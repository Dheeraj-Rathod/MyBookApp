module Api
  module V1
    class AuthController < ApplicationController
      before_action :authenticate_user!, only: :me

      def register
        user = User.new(user_params)

        if user.save
          render json: auth_response(user), status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def login
        email = params.dig(:user, :email).to_s.strip.downcase
        password = params.dig(:user, :password).to_s

        user = User.find_by(email: email)

        if user&.authenticate(password)
          render json: auth_response(user)
        else
          render json: { error: "Invalid email or password" },
                 status: :unauthorized
        end
      end

      def me
        render json: user_response(current_user)
      end

      private

      def user_params
        params.require(:user).permit(
          :email,
          :password,
          :password_confirmation
        )
      end

      def auth_response(user)
        {
          token: JsonWebToken.encode(user.id),
          user: user_response(user)
        }
      end

      def user_response(user)
        {
          id: user.id,
          email: user.email
        }
      end
    end
  end
end