# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :load_language, :set_page_title

  include ExceptionNotifiable
  include AuthenticatedSystem
  include ParameterAware

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '271a89443a73312ac1e1644da241bcde'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  protected

  def rescue_action(exception)
    case exception
    when ::ActionController::UnknownAction then
      not_found_redirect
    else
      super
      # fatal_redirect
    end
  end

  # def fatal_redirect
  #   flash[:error] = help.bt('fatal_error', :edit_allowed => false)
  #   redirect_to_language_root
  # end

  def not_found_redirect(warn = true)
    flash[:error] = help.bt('not_found_error', :edit_allowed => false) if warn
    redirect_to_language_root
  end

  def set_page_title
    page_title_text =
      BuiltinText.find_by_name(controller_name+"_"+action_name+"_page_title",@current_language) ||
      BuiltinText.find_by_name(controller_name+"_page_title",@current_language)
    if page_title_text
      @page_title = "INEX-SDA - " + page_title_text.body
    else
      @page_title = "INEX-SDA"
    end
  end

  def load_language
    code = params[:language_code] || 'cs'
    @current_language = Language.find_by_code(code)
    @current_language ||= Language.find_by_code('cs')
  end

  def self.help
    InexHelpers::help
  end

end
