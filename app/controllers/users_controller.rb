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
  
  def login_form
    @users = User.new
  end
  
  def login
    @user = User.find_by(username: params[:username])
    
    if @user # existing user
      session[:user_id] = @user.id
      session[:username] = @user.username
      flash[:success] = "Login successful. Welcome back, #{@user.username}."
    elsif @user.nil? # new user
      @user = User.create!(username: params[:username])
      if @user.id
        @user.reload
        session[:user_id] = @user.id
        session[:username] = @user.username
        flash[:success] = "Login successful. Welcome, #{@user.username}. So glad you joined us!"
      else
        flash.now[:error] = 'Unable to login'
        redirect_to root_path
        return
      end
    end
    
    redirect_to root_path
    return
  end
  
  def logout
    if session[:user_id]
      unless @user.nil?
        session[:user_id] = nil
        session[:username] = nil
        flash[:notice] = "Bye, #{@user.username}.  See you next time."
      else
        session[:user_id] = nil
        session[:username] = nil
        flash[:notice] = "Error: Unknown User"
      end
    end
    
    redirect_to root_path
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
        return redirect_to root_path
      end
    end
    
    session[:user_id] = user.id
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
