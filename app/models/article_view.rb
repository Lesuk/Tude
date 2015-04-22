class ArticleView < ActiveRecord::Base
  belongs_to :article, counter_cache: true

  def self.set_view(id, ip)
    self.find_or_create_by!(article_id: id, guest_ip: ip)
  end
end
