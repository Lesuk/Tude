class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User", foreign_key: "subscriber_id"
  belongs_to :subscribable, polymorphic: true
end
