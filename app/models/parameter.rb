class Parameter < ActiveRecord::Base

  include ActAsAuthored
  
  after_save :clear_cache
  
  @@cache = {}

  def clear_cache
    @@cache = {}
  end
  
  def self.find_by_key(the_key)
    Parameter.find(:first, :conditions => ["key = ?", the_key])
  end
  
  def self.get_value(the_key)
    @@cache[the_key] ||= begin
      parameter = Parameter.find_by_key(the_key)
      raise "Parameter #{the_key} not found!" unless parameter
      parameter.get_value
    end
  end
  
  def to_label
    key
  end
  
  def get_value
    nil
  end
  
end
