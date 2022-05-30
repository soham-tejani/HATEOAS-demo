# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api//v1/users', type: :request do
  let(:user) { create(:user) }
  it '' do
    p ":::::::::#{user.inspect}"
  end
end
