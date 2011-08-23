module InexHelpers

  def help
    Helper.instance
  end

  def self.help
    Helper.instance
  end

  class Helper
    include Singleton
    include ApplicationHelper
    include Admin::MenuItemHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
  end

end