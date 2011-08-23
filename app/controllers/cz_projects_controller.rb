class CzProjectsController < PublicController
  
  include InexHelpers

  layout "public", :except => [:map_loader]
  
  def index
    js_url = "/#{@current_language.code}/fn/cz_projects/map_loader#{params[:id] ? "/#{params[:id]}.js" : ""}"
    @google_maps_info = GoogleMapsInfo.new(js_url, 'load()')
    
    @kinds = CzProjectKind.find(:all, :order => :id)
    @projects = {}
    for k in @kinds
      @projects[k] = k.cz_projects
    end
  end
  
  def show
    redirect_to :index unless params[:id]
    @kind = CzProjectKind.find(params[:id])
    @projects = @kind.cz_projects
  end
  
  def map_loader
    @kinds = CzProjectKind.find(:all, :order => :id)
    @projects = CzProject.find(:all, :conditions => "(NOT(latitude IS NULL)) AND (NOT(longitude IS NULL))")

    @marker_types = @kinds.map { |kind| { :id => kind.id, :color => kind.marker_btkey } }
    
    @projects_hidden = []
    
    @multi_markers = []    
    for project in @projects
      found = nil
      for m in @multi_markers do
        foo = m[:projects].select{|p| p.latitude == project.latitude and p.longitude == project.longitude}
        found = m and break if foo.size > 0
      end
      if found
        found[:projects] << project
        found[:type] = 0
      else
        @multi_markers << {   :latitude => project.latitude, 
                              :longitude => project.longitude, 
                              :projects => [project] }
      end
    end
    
    @multi_markers.reject!{|m| m[:projects].size <= 1}
    @multi_markers.each_with_index{|m,i| m[:id] = i + 1}
    
    @multi_markers.each do |m|
      @projects_hidden += m[:projects]
    end
    
    respond_to do |format|
      format.js
    end
  end
  
end