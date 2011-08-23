class VolantDbGateway < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "workcamps_#{RAILS_ENV}"

  def self.test_connection
    Workcamp.find(:first)
  end

end


