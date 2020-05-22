require "test_helper"

describe User do
  
  it 'can be instantiated' do
    expect(users(:jared).valid?).must_equal true
  end
  
  it 'has required fields' do
    expect(users(:jared)).must_respond_to :username
  end
  
  describe 'validations' do
    before do
      @user = users(:katie)
    end
    
    it 'is invalid without a username' do
      @user.username = ''
      
      expect(@user.valid?).must_equal false
      expect(@user.errors.messages).must_include :username
    end
    
    it 'is invalid if username is not unique' do
      old_user = User.create!(username: 'Voldemort')
      new_user = User.new(username: old_user.username)
      
      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :username
    end
  end

  describe 'relationships' do
    it 'a user can have many votes' do
      user = users(:jared)

      vote1 = Vote.create(user_id: user.id, work_id: works(:moonstruck).id)
      vote2 = Vote.create(user_id: user.id, work_id: works(:brazil).id)
      
      expect(vote1.valid?).must_equal true
      expect(vote2.valid?).must_equal true

      expect(user.votes.count).must_equal 2    
    end

    it 'can access works through votes' do
      work1 = works(:blackstar)
      work2 = works(:moonstruck)
      user = users(:leah)
      Vote.create(work_id: work1.id, user_id: user.id)
      Vote.create(work_id: work2.id, user_id: user.id)

      expect(user.votes[0].work.title).must_equal work1.title
      expect(user.votes[1].work.title).must_equal work2.title
    end
  end
  
end
