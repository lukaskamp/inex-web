module CzProjectsHelper
  
  def infobox(project)
    '<div class="map_infobox_crumb">'+
    '<b>'+project.title+'</b>'+
    ((project.project_code and not project.project_code.empty?)?('['+project.project_code+']'):(''))+'<br />'+
    '<i>'+bt(project.kind.title_btkey)+'</i><br />'+
    strip_tags(project.description_short || "")+
    link_to(bt('cz_infobox_link', :edit_allowed => false), cz_projects_path(lng(:id => project.kind.id)))+
    '</div>'
  end
  
  def icon_js(color, label = "", star = false)
    %{MapIconMaker.createLabeledMarkerIcon({addStar: #{star ? "true" : "false"}, label: "#{label}", primaryColor: "#{color}"})}
  end
  
end
