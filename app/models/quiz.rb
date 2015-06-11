class Quiz < Survey::Survey
  belongs_to :testable, polymorphic: true
  belongs_to :category

  counter_culture :category, :column_name => Proc.new {|model| model.active ? 'quizzes_count' : nil }
end
