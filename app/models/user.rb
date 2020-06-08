class User < ApplicationRecord
  has_many :votes
  has_many :works, through: :votes
  
  validates :username, presence: true, uniqueness: true
  

  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]

    return user # unsaved!
  end
end
