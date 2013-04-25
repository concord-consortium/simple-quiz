class Response < ActiveRecord::Base
  attr_accessible :answer

  has_one :run
end
