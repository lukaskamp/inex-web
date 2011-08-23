class RecentYear < Term

  def initialize(options = {})    
  end

  def from
    1.year.ago.to_date
  end
  
  def to
    Date.today
  end
  
  def needed_attributes
    []
  end
  
  def valid?
    true
  end
  
  def to_label
    "Recent year (#{from} - #{to} if viewed now)"
  end
  
end