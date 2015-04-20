class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course, counter_cache: :users_count
end
