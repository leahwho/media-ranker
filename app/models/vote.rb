class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work
  
  validates :user_id, presence: true
  validates :work_id, presence: true, uniqueness: { scope: :user_id }
  
  def self.most_recent(id)
    @user = User.find_by(id: id)
    @work = Work.find_by(id: id)

    if @user
      return @user.votes.order('created_at DESC')
    elsif @work
      return @work.votes.order('created_at DESC')
    end
  end

end
