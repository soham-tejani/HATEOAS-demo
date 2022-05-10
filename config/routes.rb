# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  devise_for :users
  match '*unmatched', to: 'application#render_path_not_found_error', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
