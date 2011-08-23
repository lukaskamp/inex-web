require 'test_helper'

class CzProjectTest < ActiveSupport::TestCase

  def test_construction
    project = CzProject.create(:title => "title", :kind => cz_project_kinds(:one) )
    assert_equal "title", project.title
    assert_equal "cz_kind_title_one", project.kind.title_btkey
  end

end
