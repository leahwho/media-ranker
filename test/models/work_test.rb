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
    
    it 'is invalid if publication year is not a number' do
      @work.publication_year = 'taco'
      
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :publication_year
    end
  end 
  
  describe 'custom methods' do
    
    describe 'spotlight' do
      it 'returns a single work' do
        spotlight = Work.media_spotlight
        
        expect(spotlight).must_be_kind_of Work  
      end
      
      it 'returns the correct work' do
        new_vote = Vote.create!(user_id: users(:katie).id, work_id: works(:moonstruck).id)

        expect(Work.media_spotlight.title).must_equal 'Moonstruck'

        new_vote2 = Vote.create!(user_id: users(:jared).id, work_id: works(:blackstar).id)
        new_vote3 = Vote.create!(user_id: users(:leah).id, work_id: works(:blackstar).id)
        expect(Work.media_spotlight.title).must_equal 'Blackstar'
      end     
            
    end
    
    describe 'categories' do
      it "puts work into correct category" do
        expect(Work.movies).must_include works(:brazil)
        expect(Work.albums).must_include works(:blackstar)
        expect(Work.books).must_include works(:oryx)
      end
      
      it "sorts categories by vote count" do
        # expect specific 

      end

    end
    
  end
end
  