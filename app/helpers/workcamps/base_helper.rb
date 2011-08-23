module Workcamps::BaseHelper

  def detail_field( label_code, value)
      <<BLOCK
        <tr>
          <th>#{bt(label_code)}</th>
          <td>#{value}</td>
        </tr>
BLOCK
  end

  def detail_field_if(label, value)
    detail_field label, value if value
  end
end
