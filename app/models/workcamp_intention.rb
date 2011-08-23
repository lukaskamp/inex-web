class WorkcampIntention < VolantDbGateway

  def to_s
    # TODO - localize
    "#{code} - #{description_cz}"
  end

end
