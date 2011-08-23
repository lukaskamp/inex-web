class AddMaxwidth < ActiveRecord::Migration
  def self.up
      p IntegerParameter.create(:key => 'maximum_width', :value => 1200, :description => 'Maximum page width in pixels.')
    end

    def self.down
      Parameter.delete(Parameter.find_by_key('maximum_width').id)
  end
end
