require 'cgi'

class StatisticQuery < ActiveRecord::Base
  
  serialize :term, Term
  serialize :field, Symbol
  
  validates_numericality_of :width
  validates_numericality_of :height
  
  def initialize(options = {})
      super(options)

      if options and options[:term]
        self.term = options[:term][:type].constantize.new(options[:term])
      else
        self.term = RecentYear.new
      end
    
      self.name ||= 'Anonymous Chart'
  end
  
  def field=(value)
    value = value.intern if String === value

    if allowed_fields.include?(value)
      write_attribute(:field, value)
    else
      write_attribute(:field, allowed_fields[0])            
    end  
  end
  
  # An ActiveRecord callback - regenerate statistics after find
  def before_save
    self.refresh
    # TODO - it is neccessary ... but why?
    self.google_chart_url = CGI.unescapeHTML(self.google_chart_url)
  end
    
  def validate
    errors.add("name","has to be set") and return unless name
    errors.add("field","has to be set") and return unless field
    errors.add("term","has to be set") and return unless term
    errors.add("term","has invalid class #{self.term.class.inspect}") unless self.term.class < Term
    errors.add("term","is invalid") and return unless term.valid?
  end
  
  # FIXME - let it be consistent with MenuItem URL handling
  # TODO - let it be an active hyperlink
  def url_for_web
    #    chart_url :id => self.id, :language_code => 'cs'
    "/cs/chart/#{self.id}" if self.id
  end
  
  # Somehow, simply defining to_label on term instance doesn't work - we have to use this 'bridge'
  def term_in_human
    term.to_label
  end
    
  private
  
  def new(options)
    super(options)
  end

end

