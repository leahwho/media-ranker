class Work < ApplicationRecord

  def self.media_spotlight 
    @works = Work.all

    return @works.sample
  end

  
end
