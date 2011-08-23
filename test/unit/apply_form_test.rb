require 'test/test_helper'
require 'test/mock_resources'

class ApplyFormTest < ActiveSupport::TestCase

    def setup
      @valid = apply_forms(:valid)
      @w1 = Workcamp.find(:first)
      @w2 = Workcamp.find(:last)
      MockResources::mock_all
    end

    def test_validation
      assert_valid @valid
      assert_invalid apply_forms(:bender), [ :gender ]
      assert_invalid apply_forms(:not_accepted), [ :terms_of_processing, :terms_of_workcamps ]
    end

    def test_save
      assert @valid.save
      loaded = ApplyForm.find @valid.id

      [ :street, :city, :zipcode ].each do |field|
        assert_equal @valid.address.send(field), loaded.address.send(field)
        assert_equal @valid.contact_address.send(field), loaded.contact_address.send(field)
      end
    end

    def test_no_workcamps
      no_wc = apply_forms(:no_workcamps)
      assert_invalid no_wc, [ :workcamps_ids ]

      no_wc.workcamps_ids = []
      assert_invalid no_wc, [ :workcamps_ids ]
    end

    def test_save_workcamps
      @valid.add_workcamp @w1.id
      @valid.add_workcamp @w2.id
      assert_equal 2, @valid.workcamps.size

      @valid.save!
      loaded = ApplyForm.find(@valid.id)
      assert_equal @valid, loaded
      assert_equal 2, loaded.workcamps.size
    end

    def test_correct_workcamp_ids
      @valid.add_workcamp([ @w1.id, @w2.id ] )
      assert_equal [ @w1.id, @w2.id], @valid.workcamps_ids
    end

end
