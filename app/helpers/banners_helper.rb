module BannersHelper

  def render_banners
    banners = Banner.find_by_language(@current_language).group_by { |b| b.order }
    groups = banners.keys.sort

    groups.map do |group|
      banners[group].map do |banner|
        content_tag(:div, :class => 'banner') do
          # FIXME - avoid usage of magic constants!
          image = image_tag "/data/articleimages/#{banner.image_filename}", :size => '164x123', :alt => banner.name
          link_to image, banner.url, :title => banner.name
        end        
      end
    end.join("\n")
  end

end
