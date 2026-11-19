class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  def authenticate_user!
    scheme, token = request.headers["Authorization"].to_s.split(" ", 2)

    if scheme != "Bearer" || token.blank?
      return unauthorized_response
    end

    payload = JsonWebToken.decode(token)
    @current_user = User.find_by(id: payload[:sub]) if payload

    unauthorized_response unless @current_user
  end

  def unauthorized_response
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end