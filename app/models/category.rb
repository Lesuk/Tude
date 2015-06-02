require 'babosa'
class Category < ActiveRecord::Base

  belongs_to :parent, class_name: "Category"
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id"
  has_many :articles
  has_many :courses
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  validates :slug, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :main_categories, -> { where(parent_id: nil) }
  scope :all_subcategories, -> { where.not(parent_id: nil) }

  def self.with_child_ids(main_category)
    category = self.friendly.find(main_category)
    if category.present?
      ids = [category.id]
      ids << category.subcategories.ids if category.parent?
      ids.flatten
    else
      []
    end
  end

  def parent?
    self.parent_id == nil
  end

  def normalize_friendly_id(string)
    string.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
  end
end
