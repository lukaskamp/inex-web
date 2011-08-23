module Admin::AdminHelper
	
	def advanced_menu_button
      show_or_hide = remote_function(:url => { :action => "switch_advanced_menu" })
      roll_icon = (@current_user.show_advanced_menu?) ? 'admin_unroll' : 'admin_roll'   
    
  		button =  '<a href="#" '
      button << ' id="advanced_menu_button" '
      button << " onclick=\"#{show_or_hide}\""
      button << ">\n"
      button << "		<strong>Advanced #{icon(roll_icon)}</strong>\n"
			button << "</a>\n"
	end
  
end