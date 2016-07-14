# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = verify_user unless Nenv.skip_auth?
    end

    private

    def verify_user
      cookies[:username].presence || reject_unauthorized_connection
    end
  end
end
