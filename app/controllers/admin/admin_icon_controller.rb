class Admin::AdminIconController < Admin::ParameterController

  def conditions_for_collection
    condition = "key LIKE '%_icon' AND key LIKE 'admin_%'"
  end

protected

  def key_ok?
    (params[:record][:key]) =~ /^admin_.*_icon$/
  end
  
  def why_not_like_key
    "does not have an admin icon suffix"
  end
  

end
