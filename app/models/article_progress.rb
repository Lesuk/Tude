class ArticleProgress < ActiveRecord::Base
  belongs_to :student, class_name: "User"
  belongs_to :article

  validates_presence_of [:student_id, :article_id]
  validates_uniqueness_of :student_id, scope: :article_id, message: "can only once complete article"
end
