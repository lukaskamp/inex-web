module YamlUtils
  
  # include another dynamic fixture
  def self.eval_erb_file(path)
    require "erb"
    text = IO.read(path)
    template = ERB.new(text, 0, "%<>")
    template.result(binding)    
  end

  def self.yes_or_no
    if rand(2) == 1
      'yes'
    else
      'no'
    end
  end
  
  def self.cz_project_kind(key)
    "#{key}:\n"+
    "  title_btkey: cz_kind_title_#{key}\n"+
    "  description_btkey: cz_kind_description_#{key}\n"+
    "  marker_btkey: cz_kind_marker_#{key}\n"+
    "\n"
  end
  
  def self.special_article(key, cs_title, cs_text, en_title, en_text)
    "cs_#{key}:\n"+
    "  title: #{cs_title}\n"+
    "  url_atom: #{InexUtils::string_for_url cs_title}\n"+
    "  body: #{cs_text}\n"+
    "  language: czech\n"+
    "  meta_article: #{key}\n"+
    "  created_by: admin\n"+
    "  updated_by: admin\n"+
    "\n"+
    "en_#{key}:\n"+
    "  title: #{en_title}\n"+
    "  url_atom: #{InexUtils::string_for_url en_title}\n"+
    "  body: #{en_text}\n"+
    "  language: english\n"+
    "  meta_article: #{key}\n"+
    "  created_by: admin\n"+
    "  updated_by: admin\n"+
    "\n"
  end

  # for fixtures of parameters
  def self.str( key, value, description = '')
      render_param( 'StringParameter', key, "\"#{value}\"", description)
  end

  def self.int( key, value, description = '')
      render_param( 'IntegerParameter', key, value, description)
  end  

  def self.date( key, value, description = '')
      render_param( 'DateParameter', key, value, description)
  end  


  protected
  
  # for fixtures of parameters
  def self.render_param( type, key, value, description)
      result =  "#{key}:\n"        
      result << "  key: #{key}\n"        
      result << "  type: #{type}\n"        
      result << "  value: #{value}\n"        
      result << "  description: #{description}\n"
      result << "\n"
      result
  end
  
end