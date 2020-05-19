class VotesController < ApplicationController
  
  def create
    user = User.find_by(id: session[:user_id])
    work = Work.find_by(id: params[:work_id])
    
    if user.nil? || work.nil?
      head :not_found
      return
    end
    
    if session[:user_id]
      vote = Vote.create(user_id: user.id, work_id: work.id)
      if vote.save 
        flash[:success] = 'Successfully upvoted!'
      else
        flash[:error] = 'You already voted for this'
      end
    else 
      flash[:error] = 'You must be logged in to vote.'
    end
    
    redirect_to request.referrer || work_path(work.id)
    return
  end
  
  
  private
  
  def votes_params
    params.require(:votes).permit(:user_id, :work_id, :created_at)
  end
  
end
