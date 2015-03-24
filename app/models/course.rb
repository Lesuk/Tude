class Course < ActiveRecord::Base
  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :category
  has_many :articles
  # has_many :students, class: "User"
  has_many :reviews

  delegate :name, to: :category, prefix: true, allow_nil: true
  delegate :name, :whois, to: :author, prefix: true, allow_nil: true
end
