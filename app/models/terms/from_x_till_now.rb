class FromXTillNow < Term

  attr_accessor :from

  def initialize(options = {})
    set_dates_from_hash( :from => options[:from] )
  end
  
  def to
    Date.today
  end
  
  def needed_attributes
    [ :from ]
  end
  
  def valid?
    return false unless self.from
    (from <= self.to)
  end
  
  def to_label
    "From #{self.from} until now"
  end
  
end