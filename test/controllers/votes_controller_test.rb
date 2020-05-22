require "test_helper"

describe VotesController do
  
  describe 'create' do
    it 'responds with not_found if work is nil' do
      user = users(:leah)
      login(user.username)
      work_id = 'taco'

      vote_info = {
        vote: {
          user_id: user.id,
          work_id: work_id
        }
      }

      expect {
        post work_votes_path(work_id), params: vote_info 
      }.wont_differ "Vote.count"
      
      must_respond_with :not_found
    end

    it 'responds with not_found if user is nil' do
      user_id = 'sandwich'
      work = works(:moonstruck)

      vote_info = {
        vote: {
          user_id: user_id,
          work_id: work.id
        }
      }

      expect {
        post work_votes_path(work.id), params: vote_info 
      }.wont_differ "Vote.count"
    end
  
    
    it 'creates a new vote with valid information and redirects only if a user is logged in' do
      user = users(:katie)
      login(user.username)
      work = works(:oryx)
      
      vote_info = {
        vote: {
          user_id: user.id,
          work_id: work.id
        }
      }
      
      expect { 
        post work_votes_path(work.id), params: vote_info 
      }.must_differ "Vote.count", 1
      
      expect(flash[:success]).must_equal 'Successfully upvoted!'
      
      must_respond_with :redirect
      must_redirect_to work_path(work.id)
    end
    
    it 'does not create a vote if a user is not logged in' do
      user = users(:jared)
      work = works(:oryx)
      
      vote_info = {
        vote: {
          user_id: user.id,
          work_id: work.id
        }
      }
      
      expect {
        post work_votes_path(work.id), params: vote_info
      }.wont_differ "Vote.count"
      
      expect(flash[:error]).must_equal "Sorry, you need to be logged in to do that."

      must_respond_with :redirect
      must_redirect_to login_path
    end
    
  end
end
