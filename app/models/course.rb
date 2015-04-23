require 'babosa'
class Course < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :category
  has_many :sections
  has_many :articles
  #has_many :reviews
  has_many :enrollments
  has_many :users, through: :enrollments

  #validates :slug, presence: true

  after_touch :update_duration

  extend FriendlyId
  friendly_id :title, use: :slugged

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :whois, to: :author, prefix: true, allow_nil: true

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end

 private

  def update_duration
    self.duration = self.sections.sum(:duration)
    self.save!
  end
end
