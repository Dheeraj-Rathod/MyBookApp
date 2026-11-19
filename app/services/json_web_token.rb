class JsonWebToken
  ALGORITHM = "HS256"

  def self.encode(user_id)
    payload = {
      sub: user_id.to_s,
      iat: Time.current.to_i,
      exp: 24.hours.from_now.to_i
    }

    JWT.encode(
      payload,
      ENV.fetch("JWT_SECRET"),
      ALGORITHM
    )
  end

  def self.decode(token)
    payload, = JWT.decode(
      token,
      ENV.fetch("JWT_SECRET"),
      true,
      {
        algorithm: ALGORITHM,
        required_claims: ["sub", "exp"]
      }
    )

    payload.with_indifferent_access
  rescue JWT::DecodeError
    nil
  end
end