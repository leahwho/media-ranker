class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work
  
  validates :user_id, presence: true
  validates :work_id, presence: true, uniqueness: { scope: :user_id }
  
  def self.recent_user_votes(id)
    @user = User.find_by(id: id)
    return @user.votes.order('created_at DESC')
  end
  
  def self.recent_work_votes(id)
    @work = Work.find_by(id: id)
    return @work.votes.order('created_at DESC')
  end
  
end
