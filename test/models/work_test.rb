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
  

  describe 'relationships' do
    it 'a work can have many votes' do
      work = works(:overstory)
      
      vote1 = Vote.create(work_id: work.id, user_id: users(:katie).id)
      vote2 = Vote.create(work_id: work.id, user_id: users(:leah).id)
      vote3 = Vote.create(work_id: work.id, user_id: users(:jared).id)
      
      [vote1, vote2, vote3].each do |vote|
        expect(vote.valid?).must_equal true
      end
      
      expect(work.votes.count).must_equal 3      
    end
    
    it 'can access user through votes' do
      user1 = users(:katie)
      user2 = users(:leah)
      work = works(:blackstar)
      Vote.create(work_id: work.id, user_id: user1.id)
      Vote.create(work_id: work.id, user_id: user2.id)
      
      expect(work.votes[0].user.username).must_equal user1.username
      expect(work.votes[1].user.username).must_equal user2.username
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
      
      it 'returns nil if there are no works' do
        works = [works(:brazil), works(:moonstruck), works(:overstory), works(:oryx), works(:blackstar), works(:rising)]
        
        works.each do |work|
          work.destroy
        end
        
        spotlight = Work.media_spotlight
        
        expect(spotlight).must_be_nil
      end
      
    end
    
    
    describe 'categories' do
      it "puts work into correct category" do
        expect(Work.movies).must_include works(:brazil)
        expect(Work.albums).must_include works(:blackstar)
        expect(Work.books).must_include works(:oryx)
      end
      
      it "returns movies sorted by high to low vote count" do
        Vote.create(work_id: works(:moonstruck), user_id: users(:katie))
        Vote.create(work_id: works(:moonstruck), user_id: users(:jared))
        Vote.create(work_id: works(:brazil), user_id: users(:katie))
        Vote.create(work_id: works(:moonstruck), user_id: users(:leah))
        
        expect(Work.movies[0].title).must_equal 'Moonstruck'
        expect(Work.movies[1].title).must_equal 'Brazil'
      end
      
      it "returns books sorted by high to low vote count" do
        Vote.create(work_id: works(:oryx), user_id: users(:katie))
        Vote.create(work_id: works(:oryx), user_id: users(:jared))
        Vote.create(work_id: works(:overstory), user_id: users(:katie))
        Vote.create(work_id: works(:oryx), user_id: users(:leah))
        
        expect(Work.books[0].title).must_equal 'Oryx & Crake'
        expect(Work.books[1].title).must_equal 'The Overstory'
      end
      
      it "returns albums sorted by high to low vote count" do
        Vote.create(work_id: works(:rising), user_id: users(:katie))
        Vote.create(work_id: works(:rising), user_id: users(:jared))
        Vote.create(work_id: works(:blackstar), user_id: users(:katie))
        Vote.create(work_id: works(:rising), user_id: users(:leah))
        
        expect(Work.albums[0].title).must_equal 'Titanic Rising'
        expect(Work.albums[1].title).must_equal 'Blackstar'
      end
      
      it 'returns an empty array if there are no movies in the database' do
        works = [works(:brazil), works(:moonstruck)]
        
        works.each do |work|
          work.destroy
        end
        
        expect(Work.movies).must_be_empty
      end
      
      it 'returns an empty array if there are no albums in the database' do
        works = [works(:blackstar), works(:rising)]
        
        works.each do |work|
          work.destroy
        end
        
        expect(Work.albums).must_be_empty
      end
      
      it 'returns an empty array if there are no books in the database' do
        works = [works(:overstory), works(:oryx)]
        
        works.each do |work|
          work.destroy
        end
        
        expect(Work.books).must_be_empty
      end
      
    end
    
  end
end
