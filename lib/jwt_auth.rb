module JwtAuth
  # Dependency: gem 'jwt'

  def zip_jwt(payload)
    return false if payload.blank?

    JWT.encode(payload, ENV["JWT_SECRET"], "HS256")
  rescue => e
    false
  end

  def unzip_jwt(token)
    return false if token.blank?

    JWT.decode(token, ENV["JWT_SECRET"], true, {algorithm: "HS256"})
  rescue => e
    false
  end
end
