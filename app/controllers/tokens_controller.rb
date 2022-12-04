class TokensController < Doorkeeper::TokensController
  def create
    headers.merge!(authorize_response.headers)
    response_body = authorize_response.body
    code = if response_body.keys.include?(:error)
            401
          else
            200
          end
    render json: { code: code }.merge!(authorize_response.body),
           status: authorize_response.status
  rescue Errors::DoorkeeperError => e
    handle_token_exception(e)
  end
end
