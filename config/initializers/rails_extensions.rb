class ActiveRecord::Base
  include ParameterAware
  
  def self.address_mapping( prefix = '')
    [ [ "#{prefix}street",  :street   ],
      [ "#{prefix}city",    :city     ],
      [ "#{prefix}zipcode" , :zipcode ] ]
  end
end

class ActionView::Base
  include ParameterAware
end

class ActiveRecord::ConnectionAdapters::Column
  def self.string_to_date(string)
    return string unless string.is_a?(String)
    return nil if string.empty?

    # HACK HACK HACK 
    # fast_string_to_date(string) || fallback_string_to_date(string)
    fast_string_to_date(string) || fallback_string_to_date(string) || string.to_date
  end
end        