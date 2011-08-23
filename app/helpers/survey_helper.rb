module SurveyHelper

  include PublicHelper
  include InexFormHelper

  MARKS = [[ 'survey_not_rated', 0],
           [ 'survey_excellent', 1],
           [ 'survey_good', 2],
           [ 'survey_average', 3],
           [ 'survey_bad', 4],
           [ 'survey_terrible', 5]]
    
  def form_eval_field( f, field, label, options = {})
      # resolve builtin text codes
      marks = MARKS.map { |item| [ bt(item[0]), item[1] ] }
      wrap_in_table_row(f, field, label, f.select(field, marks), options)
  end
    
end
