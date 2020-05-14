require "test_helper"

describe Work do
  
  it "can be instantiated" do
    expect(works(:brazil).valid?).must_equal true
  end
  
  it 'has required fields' do
    [:title, :category, :creator, :description, :publication_year].each do |field|
      
      expect(works(:moonstruck)).must_respond_to field
    end
  end
  
  
  describe 'validations' do 
    before do
      @work = works(:overstory)
    end
    
    it 'is invalid without a title' do
      @work.title = ''
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title
    end
    
    it 'is invalid without a category' do
      @work.category = ''
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :category
    end
    
    it 'is invalid without a creator' do
      @work.creator = ''
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :creator
    end
    
    it 'is invalid without a description' do
      @work.description = ''
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :description
    end
    
    it 'is invalid without a publication year' do
      @work.publication_year = ''
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :publication_year
    end
  end
  
  
  describe 'relationships' do 
    # TODO: What relationships will Works have with Votes and/or Users?
    # TODO: Works can have many votes, but only one user through votes
  end
  
  
  describe 'custom methods' do
    
    describe 'spotlight' do
      # TODO it returns an instance of Work
      # it returns a single item
      # if there are no votes, it returns nil?
      # When you have the method set for vote counts, test that it returns the right one (the one with the most votes)
    end
    
    describe 'movies' do
      # TODO it returns an array
      # it returns an array of Work objects
      # all categories are 'movie'
      # expect the count to be correct
      # expect order to be correct
      # expect empty array if nothing is listed
    end
    
    describe 'books' do
      # TODO it returns an array
      # it returns an array of Work objects
      # all categories are 'book'
      # expect the count to be correct
      # expect order to be correct
      # expect empty array if nothing is listed
    end
    
    describe 'albums' do
      # TODO it returns an array
      # it returns an array of Work objects
      # all categories are 'album'
      # expect the count to be correct
      # expect order to be correct
      # expect empty array if nothing is listed
    end
    
  end
  
end

