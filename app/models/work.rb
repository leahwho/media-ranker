class Work < ApplicationRecord
  #has_many :votes
  validates :title, presence: true
  validates :category, presence: true
  validates :creator, presence: true
  validates :description, presence: true
  validates :publication_year, presence: true, numericality: { only_integer: true } 
  
  def self.media_spotlight 
    @spotlight = Work.all
    
    return @spotlight.sample
  end
  
  def self.movies
    return Work.where(category: 'movie')
    #TODO: figure out how to order and return by vote count
  end

  def self.books
    return Work.where(category: 'book')
    #TODO: figure out how to order and return by vote count
  end

  def self.albums
    return Work.where(category: 'album')
    #TODO: figure out how to order and return by vote count
  end
  


end
