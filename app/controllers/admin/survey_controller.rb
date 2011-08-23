class Admin::SurveyController < Admin::AdminController

  active_scaffold :survey do |config|
    config.label = "Volunteer Surveys"
    config.create.link = nil

    action_link(config, 'surveys.csv', 'Export to CSV', 'admin_csv_export')
    # action_link(config, 'index', 'Statistics', 'admin_statistics', :controller => 'admin/statistics', :action => 'index')
#    action_link(config, 'surveys.csv', 'Export to CSV', 'admin_csv_export', :url => '/cs/admin/survey.csv')
#    action_link(config, 'index', 'Statistics', 'admin_statistics', :controller => 'admin/statistics', :action => 'index', :language_code => 'cs')

    config.list.columns = [ :projectcountry, :project, :lastname, :firstname, :email ]
    list.sorting = {:updated_at => 'DESC'}
  end

  def surveys
    @lines = Survey.find(:all).to_csv

    # TODO - format date normally
    today = Date.today
    date = "#{today.day}-#{today.month}-#{today.year}"

    # TODO put into constants?
    response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
    response.headers['Content-Disposition'] = "attachment; filename=surveys-#{date}.csv"

    render :text => @lines.join("\n")
  end


end
