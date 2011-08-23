class Address

  attr_reader :street, :city, :zipcode
  
  def initialize( street, city, zipcode)
    @street = street
    @city = city
    @zipcode = zipcode
  end

  def to_s
    "#{street}, #{city}, #{zipcode}"
  end
    
  def valid?    
    !@street.blank? and !@city.blank? and !@zipcode.blank?
  end
  
end
  
