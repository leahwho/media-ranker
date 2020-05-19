class ApplicationController < ActionController::Base

  def current_user
    return User.find_by(id: session[:user_id])
  end

  def require_login
    current_user
    if current_user.nil?
      flash[:error] = "Sorry, you need to be logged in to do that."
      redirect_to login_path
      return
    end
  end

end
