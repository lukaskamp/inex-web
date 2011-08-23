class Term
  
  def needs?(attribute)
    needed_attributes.include?(attribute)  
  end
    
  protected
  
  def set_dates_from_hash(options)
    if options[:from]
      self.from = options[:from] if Date === options[:from]
      self.from = Time.zone.parse(options[:from]) if String === options[:from]
      self.from = self.from.to_date if self.from
    end

    if options[:to]
      self.to = options[:to] if Date === options[:to]
      self.to = Time.zone.parse(options[:to]) if String === options[:to]
      self.to = self.to.to_date if self.to
    end
  end
  
end