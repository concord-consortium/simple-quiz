class Run < ActiveRecord::Base
  attr_accessible :key, :response_id, :return_url

  belongs_to :response

  def self.key_for(domain, id)
    domain && id ? "#{domain}#{id}" : "#{SecureRandom.uuid}"
  end
end
