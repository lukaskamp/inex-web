class Workcamp < VolantDbGateway
  Workcamp.inheritance_column = :_type_disabled

  has_many :workcamp_assignments
  belongs_to :country
  # belongs_to :organization

  has_and_belongs_to_many :intentions,
                          :class_name => 'WorkcampIntention',
                          :join_table => 'workcamp_intentions_workcamps',
                          :readonly => true

  def self.find_all(ids)
    self.safe_find(ids).sort! do |w1,w2|
      ids.index(w1.id) <=> ids.index(w2.id)
    end
  end

  def free_places
    self.places - self.accepted_places
  end

  def free_places_for_males
    [ free_places, places_for_males - accepted_places_males ].min
  end
  
  def free_places_for_females
    [ free_places, places_for_females - accepted_places_females ].min
  end


  def from
    self.begin
  end

  def to
    self.end
  end

  def accepts_volunteers?
    (from > Date.today) and (free_places > 0)
  end

  # Returns code, name, count triples
  def self.counts_by_country
    name = Country.table_name 
    Workcamp.count(:include => :country, :group => "#{name}.code" )
  end

  protected

  def self.safe_find(ids)
    ids.map do |id|
      Workcamp.find(id) rescue nil
    end.compact
  end

end
