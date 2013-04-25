class ApplicationController < ActionController::Base
  protect_from_forgery

  # override devise's built in method so we can go back to the path
  # from which authentication was initiated
  def after_sign_in_path_for(resource)
    session.delete(:auth_return_url) || request.env['omniauth.origin'] || stored_location_for(resource) || signed_in_root_path(resource)
  end
end
