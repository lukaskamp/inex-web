class Country < VolantDbGateway

  set_table_name "active_countries_view"
  has_many :workcamps


  def name
    # TODO - localize
    name_cz
  end

end
