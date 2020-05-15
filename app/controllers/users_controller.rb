class UsersController < ApplicationController
  
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
    user = User.find_by(username: params[:username])
    
    if user # existing user
      session[:user_id] = user.id
      flash[:success] = "Login successful. Welcome back, #{user.username}."

    elsif user.nil? # new user
      user = User.create!(username: params[:username])
      user.reload
      session[:user_id] = user.id
      flash[:success] = "Login successful. Welcome, #{user.username}. So glad you joined us!"

    elsif !user.save
      flash.now[:error] = 'Unable to login'
      redirect_to root_path
      return
    end
    
    redirect_to root_path
    return
  end
  
  
  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        session[:user_id] = nil
        flash[:notice] = "Bye, #{user.username}.  See you next time."
      else
        session[:user_id] = nil
        flash[:notice] = "Error: Unknown User"
      end
    else
      flash[:error] = "You must be logged in to log out!"
    end
    
    redirect_to root_path
  end
  
  private
  
  def users_params
    return params.require(:user).permit(:username, :created_at)
  end
  
end
