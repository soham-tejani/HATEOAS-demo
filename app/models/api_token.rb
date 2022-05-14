# frozen_string_literal: true

class ApiToken < ApplicationRecord
  belongs_to :user
end
