class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_course

  #override devise default sign in path
  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'my_courses', :controller => '/courses', :only_path => false, :protocol => 'http')
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || sign_in_url || root_path
    end
  end

  def current_course
    session[:current_user_course]
  end
end
