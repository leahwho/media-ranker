class VotesController < ApplicationController
  
  def vote_check(work)
    user = User.find_by(id: session[:user_id])
    duplicates = user.votes.select { |vote| vote.work_id == work.id}
    
    return true if duplicates.empty?
    
    return false
  end
  
  def create
    # find the user and the work
    user = User.find_by(id: session[:user_id])
    work = Work.find_by(id: params[:work_id])
    
    # if the user is logged in
    if session[:user_id] && vote_check(work)
      #create a new vote for those objects
      vote = Vote.create(user_id: user.id, work_id: work.id)
      # if the work saves
      if vote.save
        # tell the user and redirect to whoever sent them there
        flash[:success] = "Successfully upvoted!"
        redirect_to request.referrer || work_path(work.id)
        return
      else
        #otherwise, there was a problem; tell the user and redirect to whoever sent them there
        flash[:error] = 'A problem occurred and your upvote could not be recorded.'
        redirect_to request.referrer || work_path(work.id)
        return
      end
      # if there is no user logged in
    elsif !vote_check(work)
      flash[:error] = 'You already voted for this!'
      redirect_to request.referrer || work_path(work.id)
      return
    elsif !session[:user_id]
      # tell them they need to log in and redirect to who sent them there
      flash[:error] = 'A problem occurred. You must be logged in to vote.'
      redirect_to request.referrer || work_path(work.id)
      return
      # if the user or work cannot be found
    elsif user.nil? || work.nil?
      head :not_found
      return
    end
  end
  
  private
  
  def votes_params
    params.require(:votes).permit(:user_id, :work_id, :created_at)
  end
  
end
