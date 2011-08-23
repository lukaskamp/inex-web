class Admin::EvsProjectsController < Admin::AdminController
      
  include InexHelpers
      
  active_scaffold :evs_project do |config|
    
    config.columns = [:eiref, :title, :description, :country, :eid, :link]
    list.columns = [:eiref, :country, :title]
    
    config.columns[:eiref].label = "EI Ref #"
    config.columns[:eid].label = "EID"
    
    config.action_links.add 'retrieve', 
                            :crud_type=> nil, 
                            :label => help.icon('evs_load') + " Fill in from EU database",
                            :type => :table,
                            :inline => false

    config.action_links.add 'enter_multiple', 
                            :crud_type=> nil, 
                            :label => help.icon('evs_multiple') + "Enter multiple projects", 
                            :type => :table,
                            :inline => false

  end

  def enter_multiple
    if request.post?
      n=0
      params[:query].scan(/(\d\d\d\d\-[A-Za-z]+-\d+)/).each do |match|
        eiref = match[0].upcase
        existing = EvsProject.find(:first, :conditions => ['eiref = ?', eiref])
        unless existing
          EvsProject.create(:eiref => eiref)
          n+=1
        end
      end
      flash[:notice] = "#{n} projects added."
      redirect_to :action => :index
    end
  end
  
  def retrieve
    @evs = []
    for project in EvsProject.find(:all,:order => :eiref)
      @evs << project unless project.has_info?
    end
  end
  
  def retrieve_project
    @message = EvsProject.find(params[:id].to_i).retrieve 
    unless Symbol === @message
      @message = help.icon('evs_ok') + " " + @message
    else
      @message = help.icon('evs_error') + " retrieval failed [#{@message}]"
    end
    render :partial => "retrieve_project"
  end
  
  def retrieving_project
    @project = EvsProject.find(params[:id].to_i)
    render :partial => "retrieving_project"
  end
    
end
