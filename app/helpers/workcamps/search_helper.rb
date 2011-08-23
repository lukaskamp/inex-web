module Workcamps::SearchHelper

  include InexFormHelper

  def country_select(f)
      select_tag = collection_select( :country, nil, @countries, :id, :to_label, {}, { :multiple => 'multiple' } )
      wrap_in_table_row(f, :country, bt('country'), select_tag )
  end

  def countries_input(countries)
    hidden_field_tag 'query[countries]', countries.map { |c| c.code }.join(',')
  end

  def render_intentions(intentions, detailed = false)
    intentions.map do |intent|
      detailed ? intent.to_label : intent.code
    end.join(',')
  end

  def countries_add_script
    javascript_tag do
      %{
         function call_add_country_ajax(code) {
          #{remote_function( :url => add_country_url, :with => "'code=' + code" )}
         }
       }
    end
  end

  def add_to_cart_link(workcamp)
    if workcamp.accepts_volunteers? and (not @cart.contains?(workcamp))
      link_to_remote show_icon('add.png', bt('wc_add_to_cart',:edit_allowed => false)),
      :url => { :action => :add_workcamp_to_cart,
        :controller => :cart_handling,
        :id => workcamp.id },
      :class => 'add'
    end
  end

  def remove_from_cart_link(workcamp)
    if @cart.contains?(workcamp)
      link_to_remote show_icon('delete.png', bt('wc_remove_from_cart', :edit_allowed => false)),
                           :url => { :action => :remove_workcamp_from_cart,
                                     :controller => :cart_handling,
                                     :id => workcamp.id },
                           :class => 'remove'
    end
  end

  def long_text(text)
    if text
      "<p>#{text.gsub(/\n/,'<br/>')}</p>"
    else
      '<p></p>'
    end
  end

  def detail_link ( label, action, workcamp, js_id, prefix = '')
      link_to_remote label, :url => { :action => action,
                                      :id => workcamp.id,
                                      :js_id => js_id,
                                      :prefix => prefix }
  end

end
