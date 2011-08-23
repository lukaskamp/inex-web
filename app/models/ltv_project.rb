class LtvProject < ActiveRecord::Base
  
  belongs_to :language

  acts_as_indexed :fields => [:title, :description, :organization, :country, :fulltext]

  def fulltext_formatter_name
    "format_ltv_project_for_fulltext"
  end
  
end
