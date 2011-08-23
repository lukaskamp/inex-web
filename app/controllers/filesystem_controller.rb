class FilesystemController < ApplicationController

  def images
    @list = InexUtils::article_image_list
    respond_to do |format|
      format.js
    end
  end
    
  def attachments
    @list = InexUtils::attachment_list
    respond_to do |format|
      format.js
    end
  end

  def ltv_attachments
    @list = InexUtils::ltv_attachment_list
    respond_to do |format|
      format.js
    end
  end

end
