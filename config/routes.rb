# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end

  match '*unmatched', to: 'application#render_path_not_found_error', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
