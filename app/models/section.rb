class Section < ActiveRecord::Base
  belongs_to :course, touch: true
  has_many :articles

  after_touch :update_duration

 private

  def update_duration
    self.duration = self.articles.sum(:video_duration)
    self.save!
  end
end
