# typed: true
# frozen_string_literal: true

module Api
  module V1
    class HealthController < Api::V1::ApplicationController
      def index
        render json: { status: service.call ? 'ok' : 'error' }, status: service.status
      end

      private

      def service
        @service ||= HealthService.new
      end
    end
  end
end
