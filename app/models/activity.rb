class Activity < ActiveRecord::Base
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :trackable, polymorphic: true
  belongs_to :parent, polymorphic: true
  belongs_to :category

  def self.courses(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Course').
            and(a[:category_id].in(categories_ids)).
            or(a[:owner_id].in(users_ids)))
  end

  def self.articles(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    courses_ids = get_courses_ids(user_id)
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Article')).
            where(a[:category_id].in(categories_ids).
            or(a[:owner_id].in(users_ids)).
            or(a[:parent_type].eq('Course').and(a[:parent_id].in(courses_ids))))
  end

  def self.comments(user_id)
    a = Activity.arel_table
    articles_ids = get_articles_ids(user_id)
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Comment')).
            where(a[:owner_id].in(users_ids).
            or(a[:recipient_id].eq(user_id)).
            or(a[:parent_type].eq('Article').and(a[:parent_id].in(articles_ids))))
  end

  def self.questions(user_id)
    a = Activity.arel_table
    categories_ids = get_categories_ids(user_id)
    courses_ids = get_courses_ids
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Question').
            and(a[:category_id].in(categories_ids)).
            or(a[:owner_id].in(users_ids)).
            or(a[:parent_type].eq('Course').and(a[:parent_id].in(courses_ids))))
  end

  def self.answers(user_id)
    a = Activity.arel_table
    questions_ids = get_questions_ids(user_id)
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('Answer')).
            where(a[:owner_id].in(users_ids).
            or(a[:recipient_id].eq(user_id)).
            or(a[:parent_type].eq('Question').and(a[:parent_id].in(questions_ids))))
  end

  def self.users(user_id)
    a = Activity.arel_table
    users_ids = get_users_ids(user_id)
    where(a[:trackable_type].eq('User').and(a[:trackable_id].in(users_ids)).
            or(a[:trackable_type].eq('Review').and(a[:owner_id].in(users_ids))))
  end

  def self.personal_feed(user_id)
    a = Activity.arel_table
    where(a[:owner_id].eq(user_id).
            or(a[:trackable_type].eq('User').and(a[:trackable_id].eq(user_id))))
  end

private

  ["categories", "courses", "articles", "questions", "comments", "answers", "users"].each do |method|
    define_singleton_method("get_#{method}_ids") do |user_id|
      Subscription.where(subscribable_type: "#{method.singularize.capitalize}", subscriber_id: user_id).pluck(:subscribable_id)
    end
  end
end
