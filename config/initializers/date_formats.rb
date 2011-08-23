require "date"

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y'
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = '%H:%M - %d.%m.%Y'

class Date
    # Override is needed due to bad date format handling in serialization
    # Originally, 'self.to_s' is called instead of 'self.to_s(:db)'.
    def to_yaml(opts)      
      YAML::quick_emit( object_id, opts ) do |out|
        out.scalar( "tag:yaml.org,2002:timestamp", self.to_s(:db), :plain )
      end
    end
  
end


class String
  
  # Rails aware parse ... TODO - is there some better way?    
  def to_date
    begin
     to_date_unsafe
    rescue => message
     puts "Failed to parse #{self}: #{message}"
     nil
    end
  end

  def to_date_unsafe
     Date.strptime self, ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]    
  end
  
  
end
