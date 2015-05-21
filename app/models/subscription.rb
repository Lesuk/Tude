class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User", foreign_key: "subscriber_id"
  belongs_to :subscribable, polymorphic: true

  validates_presence_of [:subscriber_id, :subscribable_id, :subscribable_type]
  validates_uniqueness_of :subscriber_id, :scope => [:subscribable_id, :subscribable_type],
                            message: "can only once subscribe"
end
