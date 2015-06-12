class Quiz < Survey::Survey
  belongs_to :testable, polymorphic: true
  belongs_to :category
  has_many :participants, -> { uniq }, through: :attempts, source_type: 'User'
  has_many :views, as: :viewable, dependent: :destroy

  counter_culture :category, :column_name => Proc.new {|model| model.active ? 'quizzes_count' : nil }

  scope :order_desc, -> {order(id: :desc)}
  scope :order_popular, -> {order(views_count: :desc)}
end
