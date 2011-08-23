module Admin::CzProjectsHelper
  
  def gmlink_form_column(record, field_name)
    %{<input type="text" value="" size="30" name="gmlink" id="gmlink" class="gmlink-input text-input" autocomplete="off"/>} +
    button_to_function('Extract L+L', \
      "s = this.form['gmlink'].value;" +
      "var pattern = /&ll=([\\d\\.]+),([\\d\\.]+)&/;" +
      "var result = pattern.exec(s);" +
      "this.form['record_latitude_#{@record.id}'].value = result[1];"+
      "this.form['record_longitude_#{@record.id}'].value = result[2];") +
    %{<p style="max-width:300px">You can either input latitude&amp;longitude values directly, or just copy a URL from googlemaps (using the GM 'Link' button), paste it into the text field and click on the 'Extract L+L' button.</p>}
  end
  
end
