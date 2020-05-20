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
  
end
