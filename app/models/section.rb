class Section < ActiveRecord::Base
  belongs_to :course, touch: true
  has_many :articles,  -> {order(position: :asc)}

  after_touch :update_duration

  acts_as_list scope: :course

 private

  def update_duration
    self.duration = self.articles.sum(:video_duration)
    self.save!
  end
end
