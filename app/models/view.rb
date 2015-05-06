class View < ActiveRecord::Base
  belongs_to :viewable, polymorphic: true

  after_create :increment_counters
  after_destroy :decrement_counters

  def self.set_view(viewable, ip)
    self.find_or_create_by!(viewable_id: viewable.id, viewable_type: viewable.class.name, guest_ip: ip)
  end

  private

  [:increment, :decrement].each do |type|
    define_method("#{type}_counters") do
      viewable_type.classify.constantize.send("#{type}_counter", "views_count".to_sym, self.viewable_id)
    end
  end
end
