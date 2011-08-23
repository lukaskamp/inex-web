class CzProject < ActiveRecord::Base
  
  belongs_to :kind, :class_name => "CzProjectKind"

  acts_as_indexed :fields => [:title, :description_long, :description_short]

  def fulltext_formatter_name
    "format_cz_project_for_fulltext"
  end
    
end
