class Admin::CzProjectKindsController < Admin::AdminController

  active_scaffold :cz_project_kind do |config|
    config.label = 'CZ project kinds'
    config.columns = [:title_btkey, :description_btkey, :marker_btkey]
    config.columns[:title_btkey].label = 'BuiltinText key for title'
    config.columns[:description_btkey].label = 'BuiltinText key for description'
    config.columns[:marker_btkey].label = 'Marker color (#rrggbb)'
  end
  
end
