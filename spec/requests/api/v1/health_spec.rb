# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/health', type: :request do
  path '/api/v1/health' do
    get('Checks if all systems are operational') do
      tags 'Health Check'
      consumes 'application/json'
      produces 'application/json'
      security([{ Bearer: [] }])
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
