module NewsletterAdmin
  
  def self.subscribe(email)
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.logger = RAILS_DEFAULT_LOGGER
    
    mail = TMail::Mail.new
    mail.subject = 'subscribe'
    mail.body = 'subscribe'
    mail.to = Parameter::get_value('newsletter_subscription_email')
    mail.set_content_type("text", "plain")
    mail.sender = email
    mail.reply_to = email
    ActionMailer::Base.deliver(mail)
  end
  
end
