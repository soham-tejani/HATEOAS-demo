# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::API
  # before_action :authenticate_user!
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error
  rescue_from ActionController::BadRequest, with: :render_bad_request_error
  rescue_from ActionController::RoutingError, with: :render_path_not_found_error

  # protect_from_forgery with: :null_session
  respond_to :json

  def pagy_meta_options(pagy)
    default_params = self.default_params.dup
    self_params = default_params.dup
    self_params[:page] = pagy.page if pagy.page > 1

    links = {
      first: url_for(default_params),
      self: url_for(self_params),
      last: url_for(default_params.merge(page: pagy.last))
    }

    links[:prev] = url_for(default_params.merge(page: pagy.page - 1)) if pagy.page > 1
    links[:next] = url_for(default_params.merge(page: pagy.page + 1)) if pagy.last > pagy.page
    include_relationships = Array.wrap(params[:include].to_s.split(','))
    {
      links: links,
      include: include_relationships,
      meta: {
        count: pagy.count
      }
    }
  end

  def render_json; end

  def render_path_not_found_error
    render_jsonapi_error({
                           title: 'Not found',
                           status: 404,
                           code: 404,
                           detail: format('No route matches [%<http_method>s] "%<path>s"', path: request.path,
                                                                                           http_method: request.method),
                           source: {
                             pointer: '/request/url'
                           }
                         })
  end

  def render_not_found_error(error)
    render_jsonapi_error({
                           title: 'Not found',
                           status: 404,
                           code: 404,
                           detail: format('We could not find the %<model>s you were looking for', model: error.model),
                           source: {
                             pointer: pointer_for(error.model, params)
                           }
                         })
  end

  def render_bad_request_error(error)
    render_jsonapi_error({
                           title: 'Bad request',
                           status: 400,
                           code: 400,
                           detail: error.message,
                           source: {
                             pointer: pointer_for(error.model, params)
                           }
                         })
  end

  private

  def render_jsonapi_error(error_or_errors, status: nil, **options)
    errors = Array.wrap(error_or_errors)
    response_status = status || errors.first[:status]

    render_jsonapi({ errors: errors }, status: response_status, **options)
  end

  def render_jsonapi(object, **options)
    render(json: object, **options)
  end

  def pointer_for(model, params)
    model_id = "#{model.underscore}_id".to_sym
    pointer_id = params.key?(model_id) ? model_id : :id
    "/request/url/:#{pointer_id}"
  end

  def default_params
    params.permit(:perPage, filter: {})
          .slice(:perPage, :filter)
  end
end
