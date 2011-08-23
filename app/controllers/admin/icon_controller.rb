class Admin::IconController < Admin::ParameterController

  def conditions_for_collection
    "key LIKE '%_icon' AND key NOT LIKE 'admin_%'"
  end

protected

  def key_ok?
    (params[:record][:key]) =~ /_icon$/
  end
  
  def why_not_like_key
    "does not have an icon suffix"
  end

end
