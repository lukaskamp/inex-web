class Survey < ActiveRecord::Base

  enforce_schema_rules
  acts_as_convertible_to_csv :header => true

  validates_presence_of :lastname, :firstname, :projectcountry, :project, :email

  validates_numericality_of :age,
  :allow_nil => true,
  :only_integer =>true,
  :greater_than => 0

  EVALUATION_ATTRIBUTES = [ :findinex,  :findproject,  :findapplication,
  :ratecommunication, :rateapplication, :projwork, :projstudy,
  :projgroup, :projleisure, :projleader, :projaccomodation,
  :projfood,  :projhygiene, :collcommunication, :collconflict,
  :collinfo, :rating ]

  YES_NO_ATTRIBUTES = [ :wasgood, :wouldrecommend, :goagain,
                        :recommendtofriends, :wouldhelp ]

  EVALUATION_ATTRIBUTES.each do |attribute|
    validates_numericality_of attribute,
    :allow_nil => true,
    :only_integer =>true,
    :less_than_or_equal_to => 5,
    :greater_than_or_equal_to => 0
  end

  YES_NO_ATTRIBUTES.each do |attribute|
     validates_inclusion_of attribute, :in => [ 0, 1 ], :allow_nil => true
  end

  def to_label
    "of '#{firstname} #{lastname}' on project '#{project}'"
  end

  def self.evaluation_statistics(column, from, to)
    Survey.count(:group => column,
                 :order => "#{column} ASC",
                 :conditions => [ 'created_at >= ? AND created_at <= ?', from, to])
  end


end
