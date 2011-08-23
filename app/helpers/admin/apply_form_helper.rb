module Admin::ApplyFormHelper

  def submitted_column(record)
    if record.submitted
      icon('admin_submitted') + ' OK'
    else
      icon('admin_submitted_error') + ' Submission failed'
    end
  end

end
