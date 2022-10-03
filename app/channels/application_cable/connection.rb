module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # Mark a key as being a connection identifier index that can then be used to find the 
    # specific connection again later. Common identifiers are current_user and current_account, 
    # but could be anything, really.
    # Note that anything marked as an identifier will automatically create a delegate 
    # by the same name on any channel instances created off the connection.
    identified_by :current_user

    def connect
      # When any user will connect to the action cable, request will come here
      # We have to authenticate user who is trying to make connection via action cable
      # When user is successfully authenticated pass user object to current_user identifier.
      # This will automatically create a delegate by the same name on any channel instances 
      # created off the connection.
      self.current_user = find_verified_user
    end

    def disconnect
      # When user will disconnect action cable, this method call will be executed.
    end

    private

    def find_verified_user 
      user = User.find_by_id(access_token.resource_owner_id) if access_token
      if user
        user
      else
        # Reject connection request when user is not authorized.
        reject_unauthorized_connection
      end
    end

    def access_token
      # Check provided token is valid or not
      params = request.query_parameters()
      @access_token ||= Doorkeeper::AccessToken.by_token(params[:access_token])
    end
  end
end
