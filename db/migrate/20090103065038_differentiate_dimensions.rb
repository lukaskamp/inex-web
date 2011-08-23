class DifferentiateDimensions < ActiveRecord::Migration
  def self.up
      delete_param('thumbnail_size')
      p IntegerParameter.create(:key => 'thumbnail_x_size', :value => 120, :description => 'X-size of the picture/video/album thumbnail in the media gallery.')
      p IntegerParameter.create(:key => 'thumbnail_y_size', :value => 85,  :description => 'Y-size of the picture/video/album thumbnail in the media gallery.')
      delete_param('photo_size')

      p IntegerParameter.create(:key => 'photo_x_size', :value => 490, :description => 'X-size of picture as shown in the gallery browser (e.g. the maximum size which the user sees).')
      p IntegerParameter.create(:key => 'photo_y_size', :value => 490,  :description => 'Y-size of picture as shown in the gallery browser (e.g. the maximum size which the user sees).')
    end

    def self.down
      p IntegerParameter.create(:key => 'thumbnail_size', :value => 120, :description => 'Size of the picture/video/album thumbnail in the media gallery.')
      Parameter.delete(Parameter.find_by_key('thumbnail_x_size').id)
      Parameter.delete(Parameter.find_by_key('thumbnail_y_size').id)
      p IntegerParameter.create(:key => 'photo_size', :value => 490, :description => 'Size of picture as shown in the gallery browser (e.g. the maximum size which the user sees).')
      Parameter.delete(Parameter.find_by_key('photo_x_size').id)
      Parameter.delete(Parameter.find_by_key('photo_y_size').id)
  end

  private

  def self.delete_param(name)
      to_delete = Parameter.find_by_key(name)
      Parameter.delete(to_delete.id) if to_delete
  end
end
