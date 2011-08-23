class RatingChart < StatisticQuery

  # TODO - use builtin texts
  EVALUATION_RESULTS = [ 'Neohodnoceno', '1 - Výborné', '2 - Dobré', '3 - Průměrné', '4 - Nevyhovující', '5 - Naprosto nedostatečné']
  
  def initialize(options = {})
    super(options)
    self.field ||= allowed_fields[0]
    self.width ||= 600
    self.height ||= 200    
  end
  
  def allowed_fields
    Survey::EVALUATION_ATTRIBUTES  
  end
  
  def specific_form
  end

  def title
    "Evaluation statistics for '#{field}'"    
  end
  
  def refresh
    logger.info "Generating rating chart: #{self.inspect}"
    raw_data = Survey.evaluation_statistics(field, term.from , term.to )
    data = to_google_api_format( raw_data, EVALUATION_RESULTS)    

    chart = GoogleChart.pie(data)
    chart.height = self.height
    chart.width = self.width

    self.generated_at = Time.now
    self.google_chart_url = chart.to_url
  end
  
  protected
  
  # Converts SQL aggregate function output to format acceptable by Google Chart API bridge.
  def to_google_api_format(data, labels )
    result = { labels[0] => 0 }
    data.each do |grade, value|
      if grade
        result[labels[grade]] = value
      else
        zero = labels[0]
        result[zero] = result[zero] + value
      end
    end
    
    result
  end  
  
end