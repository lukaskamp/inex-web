module WorkcampSearch

  MALE = 'm'
  FEMALE = 'f'
  SEASON_START_PARAM = 'season_start'
  SEASON_END_PARAM = 'season_end'

  def self.total(query)
    query ||= {}
    Workcamp.count(create_conditions(query))
  end

  # TODO - rewrite by hash conditions
  def self.find_by_query(query = {}, page = 1, per_page = 15)
    query ||= {}
    offset = (page.to_i - 1) * per_page.to_i
    offset = 0 if offset < 0

    find_options = create_conditions(query).merge :limit => per_page,
                                                  :offset => offset,
                                                  :order => '"begin" ASC'
                                                  #:select => '"workcamps".*,"workcamp_intentions".*'

    workcamps = Workcamp.find(:all, find_options)
  end

  protected

  def self.create_conditions(query = {})
    params = []
    sql = ''

    # limit the search on future
    sql << '("begin" >= ?)'
    params << Date.today

    # respect publish_mode and type of the workcamps
    sql << " AND ((\"begin\" >= ? AND \"end\" <= ? AND publish_mode = 'SEASON') OR (publish_mode = 'ALWAYS')) "
    sql << " AND publish_mode != 'NEVER'"
    sql << " AND type != 'Outoging::Workcamp'"
    params << Parameter.get_value(SEASON_START_PARAM)
    params << Parameter.get_value(SEASON_END_PARAM)

    if is_set query, :countries
      # FIXME - security issue!!!
      codes = query[:countries].map { |code| "'#{code}'" }.join(',')
      sql << " AND #{Country.table_name}.code in (#{codes}) "
    end

    if query[:from]
      if date = query[:from].to_date
        sql += ' AND (workcamps."begin" >= ?) '
        params << date
      end
    end

    if query[:to]
      if date = query[:to].to_date
        sql += ' AND (workcamps."end" <= ?) '
        params << date
      end
    end

    if is_set( query, :intentions)
        sql += ' AND (workcamp_intentions.id in (?)) '
        params << query[:intentions]
    end

    if is_set( query, :sex)
      if query[:sex] == MALE
        sql += " AND workcamps.places_for_males - workcamps.accepted_places_males - workcamps.asked_for_places_males > 0 " 
      elsif query[:sex] == FEMALE
        sql += " AND workcamps.places_for_females - workcamps.accepted_places_females - workcamps.asked_for_places_females > 0 " 
      else
        Rails.logger.warn('unknown gender for search')
      end
      
    end

    if query[:free_only]
      sql += " AND (workcamps.places - workcamps.accepted_places - workcamps.asked_for_places) > 0 "
    end

    age = query[:age].to_i
    if age != 0
        sql += ' AND (workcamps.minimal_age <= ? and workcamps.maximal_age >= ?) '
        params << age << age
    end

#     join_sql =
#       'INNER JOIN "countries" ON "countries".id = "workcamps".country_id ' +
#       'LEFT OUTER JOIN "workcamp_intentions_workcamps" ON "workcamp_intentions_workcamps".workcamp_id = "workcamps".id ' +
#       'LEFT OUTER JOIN "workcamp_intentions" ON "workcamp_intentions".id = "workcamp_intentions_workcamps".workcamp_intention_id'

    # FIXME - workcamps without intentions are not found by this query
    { :conditions => [ sql ].concat(params), :joins => [ :country ], :include => :intentions  }
  end

  private

  def self.is_set( query, field)
    query[field] and (not query[field].empty?)
  end


end
