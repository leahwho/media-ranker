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
    
    it 'is invalid without a unique work id' do
      duplicate_vote = Vote.create(user_id: @user.id, work_id: @work.id)

      expect(duplicate_vote.valid?).must_equal false
      expect(duplicate_vote.errors.messages).must_include :work_id
    end
    
  end
  
  describe 'relationships' do
    before do
      @user = users(:katie)
      @work = works(:oryx)
      @vote = Vote.create(user_id: @user.id, work_id: @work.id)
    end
    
    
  end
  
end
