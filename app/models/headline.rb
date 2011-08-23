require "#{RAILS_ROOT}/lib/inex_utils"
require "#{RAILS_ROOT}/lib/inex_helpers"

class Headline < ActiveRecord::Base

  include ActAsAuthored
  include InexHelpers
  
  validates_presence_of  :title, :valid_from, :language

  acts_as_indexed :fields => [:title, :annotation_explicit]

  belongs_to :article
  belongs_to :language

  def to_param
    "#{id}-#{InexUtils::string_for_url(title)}"
  end

  def fulltext_formatter_name
    "format_headline_for_fulltext"
  end
    
  def annotation
    if annotation_explicit and not annotation_explicit.empty?
      annotation_explicit
    elsif article
      help.truncate(help.strip_tags(article.body), par("headline_annotation_length"))
    end
  end
  
  def unexpired?
    today = Date.today
    today >= valid_from and today <= valid_to      
  end
  
  def self.find_unexpired( language, limit = nil )
    today = Date.today
    Headline.find(:all, 
                  :conditions => 
                  [ 'language_id = ? AND valid_from <= ? AND valid_to >= ?', 
                    language.id, today, today ],
                  :limit => limit,
                  :order => 'updated_at DESC'
                  )
  end
  
  def self.find_expired( language, limit = nil )
    today = Date.today
    Headline.find(:all, 
                  :conditions => 
                  [ 'language_id = ? AND valid_from <= ? AND valid_to < ?', 
                    language.id, today, today],
                  :limit => limit,
                  :order => 'valid_to DESC'
                  )
  end
  
  # Convenience method
  def self.find_newest( language )
    newest  = find_unexpired(language)
    newest += find_expired(language, 3 - newest.size) if newest.size<3
    newest
  end

  def to_label
    title
  end
  
end
