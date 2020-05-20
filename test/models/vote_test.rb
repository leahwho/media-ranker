require "test_helper"

describe Vote do 
  before do
    @user = users(:leah)
    @work = works(:moonstruck)
    @vote = Vote.create(user_id: @user.id, work_id: @work.id)
  end
  
  it 'can be instantiated' do
    expect(@vote.valid?).must_equal true
  end
  
  it 'has required fields' do
    [:work_id, :user_id].each do |field|
      expect(votes(:vote1)).must_respond_to field
    end
  end
  
  
  describe 'validations' do
    before do
      @user = users(:jared)
      @work = works(:rising)
      @vote = Vote.create(user_id: @user.id, work_id: @work.id)
    end
    
    it 'is invalid without a work_id' do
      @vote.work_id = ''
      
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :work_id
    end
    
    it 'is invalid without a user_id' do
      @vote.user_id = ''
      
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :user_id
    end
    
    it 'allows multiple users to vote for the same work' do
      vote1 = Vote.create(user_id: users(:leah).id, work_id: works(:oryx).id)
      vote2 = Vote.create(user_id: users(:jared).id, work_id: works(:oryx).id)
      
      expect(vote1.valid?).must_equal true
      expect(vote2.valid?).must_equal true
    end
    
    it 'does not allow a user to vote for a work more than once' do
      vote1 = Vote.create(user_id: users(:katie).id, work_id: works(:oryx).id)
      vote2 = Vote.create(user_id: users(:katie).id, work_id: works(:oryx).id)
      
      expect(vote1.valid?).must_equal true
      expect(vote2.valid?).must_equal false
    end
  end
  
  describe 'relationships' do
    before do
      @vote = votes(:vote3)
      @work = works(:blackstar)
      @user = users(:katie)
    end
    
    it 'can set the work through .work' do
      @vote.work = @work
      
      expect(@vote.work_id).must_equal @work.id
    end
    
    it 'can set the work through .work_id' do
      @vote.work_id = @work.id
      
      expect(@vote.work).must_equal @work
    end
    
    it 'can set the user through .user' do
      @vote.user = @user
      
      expect(@vote.user_id).must_equal @user.id
    end
    
    it 'can set the user through .user_id' do
      @vote.user_id = @user.id
      
      expect(@vote.user).must_equal @user
    end
    
  end
  
  describe 'custom methods' do
    describe 'recent user votes' do
      
      it 'returns most recent votes by a user first' do
        vote1 = Vote.create(user_id: users(:katie).id, work_id: works(:oryx).id, created_at: Date.today - 1)
        vote2 = Vote.create(user_id: users(:katie).id, work_id: works(:blackstar).id, created_at: Date.today)
        
        user = users(:katie)
        result = user.votes.recent_user_votes(user.id)

        expect(result[0].created_at > result[1].created_at).must_equal true
      end
            
    end

    describe 'recent work votes' do
      it 'returns the most recent votes for the same work first' do
        vote1 = Vote.create(user_id: users(:katie).id, work_id: works(:oryx).id, created_at: Date.today - 1)
        vote2 = Vote.create(user_id: users(:leah).id, work_id: works(:oryx).id, created_at: Date.today)

        work = works(:oryx)
        result = work.votes.recent_work_votes(work.id)

        expect(result[0].created_at > result[1].created_at).must_equal true
      end
    end
  end
  
end
