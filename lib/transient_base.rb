class TransientBase
    
    # Initializes all attributes from the hash, if defined.
    def initialize(hash = nil)
      if hash
        hash.each do |symbol,value|      
          method = "#{symbol.to_s}="
          
          if self.respond_to? method
            self.send(method,value) 
          else
            raise "Unknown method #{method}"
          end
        end
      end
    end    
    
    def ==(comparison_object)
      comparison_object.equal?(self) ||
       (comparison_object.instance_of?(self.class) && 
        attributes_equal?(comparison_object))        
    end
    
    private 
    
    def attributes_equal?(other)
      self.instance_variables.each do |attr|
        # TODO - this should be one-line simple command but I'm too stupid and tired
        attr = attr.to_s
        attr[0] = ''
        
        return false if self.send(attr) != other.send(attr)
      end
      
      true
    end
    
end  