class DateParameter < Parameter
  
  def get_value
    value.to_date
  end
  
  protected
  
  def validate
    begin
      value.to_date_unsafe
    rescue => message
      errors.add("value", message)
      # unless value =~ /\A[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{4}\Z/
    end
  end
  
end
