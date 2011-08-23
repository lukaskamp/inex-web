class CzProjectKind < ActiveRecord::Base
  
  has_many :cz_projects, :foreign_key => :kind_id, :order => :title
  
  def to_s
    BuiltinText.get_text(self.title_btkey, Language.find(:first, :order => :code))
  end
  
end
