# Used by ActiveScaffold driven controllers when saving any model that has 
# a language attribute. Language association is filled automatically from 
# request parameters (path).
#
# Enhances ActiveScaffold controller to update 'created_by' and 'updated_by' fields on change.
#
# Must be included after the ActiveScaffold call, otherwise the method is overriden
# by empty default.
#
# TODO - rename UserAndLanguageAware
#
module LanguageAware
  
  def self.included(mod)
    # TODO - check that before_create_save overrides ActiveScaffold action
    # $stderr.puts "#{self} included in #{mod}"
  end

  # TODO - move to public_helper
  def admin_view?
    logged_in? and session[:show_admin_view]
  end
  
  # TODO - move to public_helper
  def admin_view(flag = :default)    
    unless flag == :default
      session[:show_admin_view] = flag
    else
      session[:show_admin_view] = false
    end
  end
  
  # ActiveScaffold callback
  # Injects current user into 'updated_by' field if 'record' responds to the right setter.
  # Injects current language into 'language' field if 'record' responds to the right setter. 
  def before_create_save(record)
    if record.respond_to? 'language='
      record.language = @current_language  
    end
    if record.respond_to? 'created_by='
      record.created_by = current_user
    end
  end
  
  # ActiveScaffold callback
  # Injects current user into 'updated_by' field if 'record' responds to the right setter.
  def before_update_save(record)
    if record.respond_to? 'updated_by='
      record.updated_by = current_user
    end
  end
  
  # ActiveScaffold callback
  # Limits records shown by AS to those in current language.
  def conditions_for_collection
    ['language_id = ?', [ @current_language.id ]]
  end
  
  # Convenience method.
  # Retrieves builtin text with given name in language corresponding to current request
  def builtin_text(name)
    BuiltinText.get_text(name, @current_language)
  end

end