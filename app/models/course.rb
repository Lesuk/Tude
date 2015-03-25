class Course < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :category
  has_many :sections
  has_many :articles
  #has_many :reviews

  after_touch :update_duration

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :whois, to: :author, prefix: true, allow_nil: true

 private

  def update_duration
    self.duration = self.sections.sum(:duration)
    self.save!
  end
end
