module FilesystemHelper
  def table_rows(list, columns, &block)
    rows = list.size / columns
    rows += 1 if list.size % columns > 0
    text = ""

    rows.times do |row|
      text << "<tr>"

	columns.times do |col|
          i = row * columns + col

          td = if i < list.size
                 image_id = "image_#{i}"
                 content_tag(:td, :class => "image_list_cell", :id => image_id) { yield(list[i],i,image_id) }
               else
                 content_tag(:td)
               end
          
          text << td
        end

      text << "</tr>"
    end

    text
  end
end
