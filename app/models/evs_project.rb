class EvsProject < ActiveRecord::Base
  
  validates_presence_of :eiref
  
  acts_as_indexed :fields => [:title, :description, :country, :eiref]

  def fulltext_formatter_name
    "format_evs_project_for_fulltext"
  end

  def has_info?
    country and title and ((eid and not eid.empty?) or (link and not link.empty?))
  end
  
  def retrieve
    response = query_website(eiref)
    return response[:flag] unless response[:body]

    regex = Regexp.compile("<td class=\"eilist\".*?><a\\s+href=\".+?\\?EID=(\\d+)\">\\s*#{eiref}[^A-Z0-9].*?</tr", Regexp::MULTILINE)
    m0 = regex.match(response[:body])
    return :no_match unless m0

    regex = Regexp.compile("<td class=\"eilist\".*?><a\\s+href=\".+?\\?EID=(\\d+)\">\\s*#{eiref}\\s*</td>\\s*"+"<td.*?>(.*?)</td>\\s*"*5)
    m = regex.match(response[:body])
    #p "PARTIAL MATCH FOR #{eiref}", m0[0] unless m
    return :partial_match unless m
    self.eid = m[1]
    self.title = m[6]
    self.country = m[2]
    self.save
    return "OK (title = #{title}, country = #{country})"
  end  
  
private
  
  def query_website(query_eiref)
    require 'net/http'
    require 'uri'
    
    begin
      response = Net::HTTP.post_form(URI.parse('http://ec.europa.eu/youth/evs/aod/hei_list_from_query.cfm'),{'EIRef' => query_eiref})
      return {:flag => :bad_response} unless Net::HTTPSuccess === response
      return {:flag => :ok, :body => response.body}
    rescue 
      return {:flag => :exception}
    end
  end
  
end
