class SurveyController < PublicController

  include LanguageAware

  def index
    if request.post?
      @survey = Survey.new(params[:survey])

      if @survey.save        
        logger.debug "Survey submitted: #{@survey.inspect}"
        redirect_to :action => :successful
        
        if @survey.newsletter and not @survey.newsletter.empty?
          email = @survey.newsletter
          begin
            TMail::Address.parse(email)
            NewsletterAdmin::subscribe(email)
          rescue
            nil
          end
        end
        
      else
        logger.debug "Wrong survey: #{@survey.inspect}"
        # render the form again
      end
    else
      @show_intro = true
      @survey = Survey.new
    end
  end
    
  def successful
  end
    
end
