class CreateSeasonEndParam < ActiveRecord::Migration
  def self.up
    if p = Parameter.find_by_key('next_season_start')
      p.destroy
    end

    DateParameter.new(:key => 'season_start', :value => "1.3.#{Date.today.year}").save!
    DateParameter.new(:key => 'season_end', :value => "31.12.#{Date.today.year}").save!
  end

  def self.down
    Parameter.find_by_key('season_start').destroy
    Parameter.find_by_key('season_end').destroy
  end
end
