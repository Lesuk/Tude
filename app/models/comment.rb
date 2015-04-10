class Comment < ActiveRecord::Base

  USERNAME_REGEX = /@([A-Za-z0-9_]{3,15})/

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :parent, class_name: "Comment"
  has_many :subcomments, class_name: "Comment", foreign_key: "parent_id"
  has_many :mentions, as: :mentionable
  has_many :mentioned_users, through: :mentions, source: :user

  validates :body, presence: true

  after_save :save_mentions

  delegate :name, :username, :whois, to: :user, prefix: true, allow_nil: true

  scope :main_comments, -> {where(parent_id: nil)}

  private

  def save_mentions
    return unless mention?

    users_mentioned.each do |user|
      Mention.find_or_create_by!(mentionable: self, user_id: user.id)
    end
  end

  def mention?
    self.body.match(USERNAME_REGEX)
  end

  def users_mentioned
    users = []
    self.body.clone.gsub!(USERNAME_REGEX).each do |user_name|
      user = User.find_by_username(user_name[1..-1])
      users << user if user
    end
    users.uniq
  end
end
