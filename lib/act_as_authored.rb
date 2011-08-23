# Adds created_by and updated_by associations.
module ActAsAuthored
  
  def self.included(base)
    base.belongs_to :created_by, :class_name => "User"
    base.belongs_to :updated_by, :class_name => "User"
  end
  
end