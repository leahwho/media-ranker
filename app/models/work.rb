MOVIE = :movie
ALBUM = :album
BOOK = :book

class Work < ApplicationRecord
  has_many :votes
  has_many :users, through: :votes
  
  validates :title, presence: true
  validates :category, presence: true
  validates :creator, presence: true
  validates :description, presence: true
  validates :publication_year, presence: true, numericality: { only_integer: true } 

  # @@valid_categories = [ALBUM, BOOK, MOVIE]
  
  def self.media_spotlight
    @spotlight = Work.all.sort_by { |work| work.votes.count }
    
    return @spotlight.last
  end
  
  def self.movies
    return Work.where(category: 'movie').sort_by { |movie| movie.votes.count }
    return movies.reverse
  end
  
  def self.books
    books = Work.where(category: 'book').sort_by { |book| book.votes.count }
    return books.reverse  
  end
  
  def self.albums
    albums = Work.where(category: 'album').sort_by { |album| album.votes.count } # WOULD .ORDER("WORK.VOTES") WORK?
    return albums.reverse  
  end
  
  # def self.top_ten(category)
  #   if !@@valid_categories.includes(category)
  #     return
  #   end

  #   # logic for return the top ten CATEGORY in that category
  # end
  
end
