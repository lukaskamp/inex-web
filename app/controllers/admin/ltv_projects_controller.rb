class Admin::LtvProjectsController < Admin::AdminController
  
  active_scaffold :ltv_project do |config|

    config.columns = [ :title, :country, :organization, :filename, :description, :fulltext ]
    config.show.columns = [ :title, :country, :organization, :filename, :description ]
    list.columns  = [ :title, :country, :organization ]
    
    columns[:filename].form_ui = :select
    opts = []
    InexUtils::ltv_attachment_list.each { |fn| opts << [fn,fn] }
    columns[:filename].options = [["-- none --", nil]] + opts.sort{|x,y| x[0] <=> y[1]}
    
    columns[:fulltext].description = "<div style=\"max-width:500px;\">You can copy+paste the attachment text here (just plain select all), without any care for formatting etc. This information will be never displayed to the user, however, it will be looked-up by the fulltext search engine.</div>"
  end
  
end
