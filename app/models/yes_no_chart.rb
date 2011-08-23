class YesNoChart < StatisticQuery
  
  def allowed_fields
    Survey::YES_NO_ATTRIBUTES  
  end
  
  def refresh
    # TODO - implement
  end
  
end