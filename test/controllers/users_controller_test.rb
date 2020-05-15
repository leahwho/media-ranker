require "test_helper"

describe UsersController do
  
  it 'can get the login form' do
    get login_path
    
    must_respond_with :success
  end
  
  describe 'logging in' do
    
    it 'can login a new user' do
      user = nil
      
      expect{
      user = login()
      }.must_differ "User.count", 1
    
      must_respond_with :redirect
    
      expect(user).wont_be_nil
      expect(session[:user_id]).must_equal user.id
      expect(user.username).must_equal "Grace Hopper"
    end
  

    it 'can login an existing user' do
      user = User.create!(username: 'Katie Vandervoot')

      expect {
      login(user.username)
      }.wont_change "User.count"
    end

    it 'can logouot an existing user' do
      login()
      expect(session[:user_id]).wont_be_nil

      post logout_path

      expect(session[:user_id]).must_be_nil
    end
  end

end
