class Admin::CzProjectsController < Admin::AdminController

  active_scaffold :cz_project do |config|
    config.columns = [:title, :description_short, :description_long, :kind, :gmlink, :longitude, :latitude]
    config.show.columns = [:title, :description_short, :description_long, :kind, :longitude, :latitude]
    config.columns[:kind].form_ui = :select
    list.columns = [:title, :description_short, :kind]
  end

end
