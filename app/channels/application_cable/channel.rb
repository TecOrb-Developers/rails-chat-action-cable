module ApplicationCable
  class Channel < ActionCable::Channel::Base
    include JwtAuth
    identified_by :user
    # identified_by :authToken

    def connect
      unless subscriber_loggedin?
        # Rails.logger.info "Connection Refused and rejected due to unauthorized access"
        reject_unauthorized_connection
      else
        # self.user = @user
        # jtoken = zip_jwt(@user.jwt_payload(payload.first["sessionToken"]))
        # self.authToken = jtoken
        # p "Connection established"
      end
    end

    def disconnect
      # if subscriber_loggedin?
        # @user is disconnecting
      # end
    end

    private
    def subscriber_loggedin?
      payload = unzip_jwt(request.params[:session_token])
      if payload
        begin
          # verified token with array payload [data, algo]
          # @user = User.joins(:sessions).where("sessions.sessionToken=?", payload.first["sessionToken"]).last
          # self.authToken = payload.first["sessionToken"]
          self.user = payload.first
        rescue StandardError => e
          Sentry.capture_exception(e)
          false
        end
      else
        false
      end
    end
  end
end
