class UsersController < ApplicationController
  
  skip_before_action :require_login, only: [:login, :login_form]
  before_action :find_user, only: [:current, :show, :logout]
  before_action :require_login, only: [:current]
  
  def index
    @users = User.all
  end
  
  def show
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
      # check to see if the user has an ID
      # if they DO - keep going herrrre
      # but if they don't, then you can say that we cannot log you in
      @user.reload
      session[:user_id] = @user.id
      session[:username] = @user.username
      flash[:success] = "Login successful. Welcome, #{@user.username}. So glad you joined us!"
      
    elsif !@user.save # Devin says this will not ever happen - so, figure this out!
      flash.now[:error] = 'Unable to login'
      redirect_to root_path
      return
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
    else
      flash[:error] = "You must be logged in to log out!"
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
  
  private
  
  def users_params
    return params.require(:user).permit(:username, :created_at)
  end
  
  def find_user
    @user = User.find_by(id: session[:user_id])
  end
  
end
