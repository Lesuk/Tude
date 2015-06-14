class Quiz < Survey::Survey
  belongs_to :testable, polymorphic: true
  belongs_to :category
  has_many :participants, -> { uniq }, through: :attempts, source_type: 'User'
  has_many :views, as: :viewable, dependent: :destroy

  counter_culture :category, :column_name => Proc.new {|model| model.active ? 'quizzes_count' : nil }

  scope :order_desc, -> {order(id: :desc)}
  scope :order_popular, -> {order(views_count: :desc)}

  def self.in_category(cat = nil)
    if cat.present?
      category = Category.friendly.find(cat)
      if category.parent?
        ids = category.subcategories.ids
        where(category_id: ids)
      else
        where(category_id: category.id)
      end
    else
      all
    end
  end

  # a virtual attribute global_testable, with a setter and getter method
  # we use this virtual attribute to takes care of setting the right :testable_type and :testable_id
  def global_testable
    self.testable.to_global_id if self.testable.present?
  end

  def global_testable=(testable)
    self.testable = GlobalID::Locator.locate testable
  end
end
