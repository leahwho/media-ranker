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
    user = User.find_by(username: params[:user][:username])

    if user.nil? #new user
      user = User.new(username: params[:user][:username])
        if !user.save
          flash.now[:error] = 'Unable to login'
          redirect_to root_path
          return
        end
        flash[:welcome] = "Welcome, #{user.username}"
    else #existing user
      flash[:welcome] = "Welcome back, #{user.username}"
    end

    session[:user_id] = user.id
  end

  
  private
  
  def users_params
    return params.require(:work).permit(:name, :created_at)
  end
  
end
