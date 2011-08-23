class BuiltinText < ActiveRecord::Base

  include ActAsAuthored
  
  validates_presence_of :name, :language
  validates_uniqueness_of :name, :scope => :language_id
  
  belongs_to :language
  
  after_save :clear_cache
  
  @@cache = {}

  def clear_cache
    @@cache = {}
  end
  
  # just a list in all lang versions
  def other_language_versions
    list=[]
    BuiltinText.find(:all,:conditions=> ["name = ? AND language_id <> ?", name, language_id ]).each do |t|
      list.push([t.language.code,t.body])
    end
    list
  end  
  
  # Convenience method returns simply the BuiltinText body and not the whole model object.
  def self.get_text(name, language)
    @@cache["#{language.id}::#{name}"] ||= begin
      btext = find_by_name(name, language)
      text = btext ? btext.body : ""
    end
  end
  
  # Returns BuiltinText instance
  def self.find_by_name(name, language)
      language = Language.default unless language
      raise 'BuiltinText name not specified' unless name
      
      text = BuiltinText.find(:first,
                              :conditions=> ["name = ? AND language_id = ?", name, language.id ])
                       
      if text.nil?                       
        logger.warn "No builtin text defined for '#{name}' and language '#{language}'"
        nil
      else
        text
      end        
  end
  
end
