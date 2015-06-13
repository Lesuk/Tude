class Quiz < Survey::Survey
  belongs_to :testable, polymorphic: true
  belongs_to :category
  has_many :participants, -> { uniq }, through: :attempts, source_type: 'User'
  has_many :views, as: :viewable, dependent: :destroy

  counter_culture :category, :column_name => Proc.new {|model| model.active ? 'quizzes_count' : nil }

  scope :order_desc, -> {order(id: :desc)}
  scope :order_popular, -> {order(views_count: :desc)}

  # a virtual attribute global_testable, with a setter and getter method
  # we use this virtual attribute to takes care of setting the right :testable_type and :testable_id
  def global_testable
    self.testable.to_global_id if self.testable.present?
  end

  def global_testable=(testable)
    self.testable = GlobalID::Locator.locate testable
  end
end
