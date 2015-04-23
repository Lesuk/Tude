require 'babosa'
class Category < ActiveRecord::Base

  belongs_to :parent, class_name: "Category"
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  has_many :articles
  has_many :courses

  validates :slug, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :main_categories, -> { where(parent_id: nil) }
  scope :all_subcategories, -> { where.not(parent_id: nil) }

  def parent?
    self.parent_id == nil
  end

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
end
