class Activity < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :trackable, polymorphic: true
  belongs_to :parent, polymorphic: true
  belongs_to :category

  scope :order_desc, -> {order(id: :desc)}

  def self.feed(user_id)
    all_ids = activities_ids(user_id)
    where(id: all_ids)
    # A possible second option:
    # find_by_sql("#{self.courses(user_id).to_sql} UNION #{self.comments(user_id).to_sql}")
  end

  def self.courses(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Course')).
            where(a[:category_id].in(categories_ids).
            or(a[:owner_id].in(users_ids)))
  end

  def self.articles(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    courses_ids = get_courses_ids(user_id)
    users_ids = get_users_ids(user_id)
    subscribed_courses = a[:parent_type].eq('Course').and(a[:parent_id].in(courses_ids))
    where(a[:trackable_type].eq('Article')).
            where(a[:category_id].in(categories_ids).
            or(a[:owner_id].in(users_ids)).
            or(subscribed_courses).
            and(a[:owner_id].not_eq(user_id)))
  end

  def self.comments(user_id)
    a = Activity.arel_table
    articles_ids = get_articles_ids(user_id)
    users_ids = get_users_ids(user_id)
    subscribed_articles = a[:parent_type].eq('Article').and(a[:parent_id].in(articles_ids))
    where(a[:trackable_type].eq('Comment')).
            where(a[:owner_id].in(users_ids).
            or(a[:recipient_id].eq(user_id)).
            or(subscribed_articles).
            and(a[:owner_id].not_eq(user_id)))
  end

  def self.questions(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    courses_ids = get_courses_ids(user_id)
    users_ids = get_users_ids(user_id)
    subscribed_courses = a[:parent_type].eq('Course').and(a[:parent_id].in(courses_ids))
    where(a[:trackable_type].eq('Question')).
            where(a[:category_id].in(categories_ids).
            or(a[:owner_id].in(users_ids)).
            or(subscribed_courses).
            and(a[:owner_id].not_eq(user_id)))
  end

  def self.answers(user_id)
    a = Activity.arel_table
    questions_ids = get_questions_ids(user_id)
    users_ids = get_users_ids(user_id)
    subscribed_questions = a[:parent_type].eq('Question').and(a[:parent_id].in(questions_ids))
    where(a[:trackable_type].eq('Answer')).
            where(a[:owner_id].in(users_ids).
            or(a[:recipient_id].eq(user_id)).
            or(subscribed_questions).
            and(a[:owner_id].not_eq(user_id)))
  end

  def self.users(user_id)
    a = Activity.arel_table
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('User').and(a[:trackable_id].in(users_ids)).
            or(a[:trackable_type].eq('Review').and(a[:owner_id].in(users_ids))))
  end

  def self.personal(user_id)
    a = Activity.arel_table
    where(a[:owner_id].eq(user_id).
            or(a[:trackable_type].eq('User').and(a[:trackable_id].eq(user_id))))
  end

private

  ["categories", "courses", "articles", "questions", "users"].each do |method|
    define_singleton_method("get_#{method}_ids") do |user_id|
      Subscription.where(subscribable_type: "#{method.singularize.capitalize}", subscriber_id: user_id).pluck(:subscribable_id)
    end
  end

  def self.activities_ids(user_id)
    activities_ids = []
    [:courses, :articles, :comments, :questions, :answers, :users].each do |method|
      activities_ids << self.send("#{method}", user_id).ids
    end
    activities_ids.flatten.uniq
  end
end
