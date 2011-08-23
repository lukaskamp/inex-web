require 'test_helper'

class Admin::LtvProjectsControllerTest < ActionController::TestCase

  include Admin::ActiveScaffoldCRUDTester

  protected

    def item
      ltv_projects(:burkina_faso)
    end

end
