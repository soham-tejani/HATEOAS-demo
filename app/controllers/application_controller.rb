# frozen_string_literal: true

class ApplicationController < ActionController::API
  def render_json; end

  def render_path_not_found_error; end

  def render_not_found_error; end

  def render_bad_request_error; end
end
