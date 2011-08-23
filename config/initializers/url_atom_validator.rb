class ActiveRecord::Base

  def self.validates_url_atom
    validates_presence_of :url_atom
  	validates_uniqueness_of :url_atom, :scope => :language_id
  	validates_format_of :url_atom, :with => /[0-9A-Za-z\-]+/
  end
  
end