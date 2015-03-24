class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :parent, class_name: "Comment"
  has_many :subcomments, class_name: "Comment", foreign_key: "parent_id"

  validates :body, presence: true

  delegate :name, :whois, to: :user, prefix: true, allow_nil: true

  scope :main_comments, -> {where(parent_id: nil)}
end
