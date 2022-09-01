# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET /v1/users' do
    path '/v1/users' do
      get("Returns the list of registrations for user's event") do
        subject(:request) do
          get(request_path, headers: request_headers)
        end

        let(:token) { ApiTokens::Create.new(user).call }
        let(:request_headers) { { Authorization: "Bearer #{token}" } }
        let(:params) { {} }

        let(:request_path) { '/api/v1/users' }
        let(:user) { create(:user) }
        let(:users) do
          create_list(:user, 10)
        end

        tags 'Users'
        parameter '$ref' => '#/components/parameters/page'
        parameter '$ref' => '#/components/parameters/perPage'
        # parameter '$ref' => '#/components/parameters/registrationsFilter'

        # parameter name: :eventId, in: :path, type: :string

        consumes 'application/json'
        produces 'application/json'
        security([{ Bearer: [] }, { OAuth: [] }])

        before do
          users
        end

        response(200, 'returns registrations list') do
          list_schema(items: { '$ref': '#/components/schemas/user' })

          it 'returns a valid 200 response and proper data' do |example|
            request
            assert_response_matches_metadata(example.metadata)
            json_body = JSON.parse(response.body)
            expect(json_body['data'].size).to eq(10)
            expect(json_body.dig('meta', 'count')).to eq(11)
            expect(json_body.dig('links', 'next')).to include("#{request_path}?page=2")
            expect(json_body.dig('links', 'self')).to include(request_path)
            expect(json_body.dig('links', 'first')).to include(request_path)
            expect(json_body.dig('links', 'prev')).to be_nil
          end
        end
      end
    end
  end
end
