class EvsProjectsController < PublicController
  
  def index
    @projects = {}
    EvsProject.find(:all, :order => "eiref DESC").each do |project|
      if project.has_info?
        (@projects[project.country]||=[]).push project
      end
    end
  end
  
end
