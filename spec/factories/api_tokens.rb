# frozen_string_literal: true

FactoryBot.define do
  factory :api_token do
    user
    token { SecureRandom.base64(24) }

    trait :expire_after_70_mins do
      expired_at { 70.minutes.from_now }
    end

    trait :expired do
      expired_at { 1.day.ago }
    end
  end
end

# == Schema Information
#
# Table name: api_tokens
#
#  id         :bigint           not null, primary key
#  expired_at :datetime
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_api_tokens_on_token    (token) UNIQUE
#  index_api_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
