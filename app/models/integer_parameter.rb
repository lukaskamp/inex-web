class IntegerParameter < Parameter

  validates_numericality_of :value
  
  def get_value
    value.to_i
  end
  
end
