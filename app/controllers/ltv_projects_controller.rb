class LtvProjectsController < PublicController
  
  def index
    @projects = {}
    LtvProject.find(:all, :order => "title").each do |project|
      (@projects[project.country]||=[]).push project
    end
  end
  
end
