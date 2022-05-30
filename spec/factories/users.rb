# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password@123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    headline { 'Headliine' }
    gender { 'male' }
    phone { Faker::PhoneNumber.phone_number }
  end
end
