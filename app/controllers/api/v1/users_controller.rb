# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.all
        @pagy, @records = pagy(@users)
        serialized_users = UserSerializer.new(@records, pagy_meta_options(@pagy)).serializable_hash

        render_jsonapi(serialized_users)
      end

      def show
        render_jsonapi(UserSerializer.new(@user).serializable_hash)
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render json: @user, status: :created, location: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :headline, :gender, :phone)
      end
    end
  end
end
