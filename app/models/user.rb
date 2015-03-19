class User < ActiveRecord::Base

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  has_many :articles
  has_many :favorites
  has_many :favorite_articles, through: :favorites, source: :favorable, source_type: 'Article'

  validates :username, presence: true, uniqueness: {case_sensitive: false}

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def name
    self.fullname.present? ? self.fullname : self.username
  end

  def to_param
    username
  end

end
