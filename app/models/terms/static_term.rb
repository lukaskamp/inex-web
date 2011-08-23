class StaticTerm < Term
  
  attr_accessor :from, :to

  def initialize(options = {})
    set_dates_from_hash(options) if options
  end
  
  def needed_attributes
    [ :from, :to ]
  end
  
  # Term is valid if both 'from' and 'to' method returns non-nil and 'from' precedes 'to' in time.
  def valid?   
    return false unless (to and from)
    (from <= to)
  end  

  def to_label
    "#{from} - #{to}"
  end  
  
end