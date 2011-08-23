require 'gchart'

class SummaryChart < StatisticQuery
    
  def initialize(options = {})
    super(options)
    self.field ||= allowed_fields[0]
    self.width ||= 600
    self.height ||= 300
  end
  
  def allowed_fields
    [ :age, :reason, :howknow ]
  end
  
  def title
    "Summary for '#{field}'"    
  end
  
  def refresh
    logger.info "Generating summary chart: #{self.inspect}"

    raw_data = Survey.evaluation_statistics(field, term.from , term.to )
    raw_data.reject! { |value,count| value == nil }
    
    
    labels = []
    data = []
    raw_data.each do |label, value|
      labels << label
      data << value
    end
    
    unless raw_data.empty?
      chart = GChart.bar(:data => data,
                         :extras => { 'chxt' => 'x,y',
                                      'chxl' => "0:#{labels.join(',')}",
                                      'chxp' => "1:10,50,100,500,1000",
                                    },
                         :spacing => 1,
                         :thickness => self.width/data.size,
                         :width => self.width,
                         :height => self.height,
                         :orientation => :vertical)
          
      self.generated_at = Time.now
      self.google_chart_url = chart.to_url    
    else
      self.generated_at = nil
      self.google_chart_url = ''
    end
  end
  
end