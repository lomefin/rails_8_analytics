module API
  class BaseController < ActionController::Base

    include Authentication
    skip_before_action :require_authentication
    before_action :authenticate_with_api_key!

    def authenticate_with_api_key!
      api_key = request.headers['X-API-KEY'] || params[:api_key]
      user = User.find_by(api_key: api_key)
      return not_allowed unless user


      start_new_session_for user
    end

    def current_company
      Current.user.company
    end

    def not_allowed
      render :forbidden, json: { errors: [{ title: 'not allowed ' }] }
      false
    end

  end
end
