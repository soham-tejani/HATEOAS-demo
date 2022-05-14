# typed: true
# frozen_string_literal: true

module ApiTokens
  #  < BaseService
  class Create
    include ActiveModel::Validations
    validates :user, presence: true
    attr_reader :api_token

    def initialize(user)
      @user = user
    end

    def call
      return false unless valid?

      token = SecureRandom.base64(24)
      @api_token = ApiToken.new(token: Digest::SHA256.hexdigest(token), user: user)

      return false unless @api_token.save

      token
    end

    def errors
      @api_token ? @api_token.errors : super
    end

    private

    attr_reader :user
  end
end
