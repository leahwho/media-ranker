class UsersController < ApplicationController
  
  before_action :require_login, only: [:current]
  before_action :find_user, only: [:current, :logout, :home]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    
    if @user.nil?
      head :not_found
      return
    end
  end
  
  def current
    if @user.nil?
      flash[:error] = "You must be logged in to view this page."
      redirect_to root_path
      return
    end
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        redirect_to root_path
        return 
      end
    end
    
    session[:user_id] = user.id
    session[:username] = user.username
    redirect_to root_path
    return
  end

  def destroy
    session[:user_id] = nil
    session[:username] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end
  
  
  private
  
  def users_params
    return params.require(:user).permit(:username, :created_at)
  end
  
  def find_user
    @user = User.find_by(id: session[:user_id])
  end
  
end
