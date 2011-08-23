class ApplyFormRecreation < ActiveRecord::Migration
  def self.up
    drop_table :apply_forms rescue say('ApplyForms already down.')

    create_table :apply_forms do |t|
      t.string   "firstname", :null => false
      t.string   "lastname", :null => false
      t.string   "gender",:null => false
      t.string   "email", :null => false

      t.string   "fax"
      t.string   "phone", :null => false
      t.date     "birthdate", :null => false
      t.date     "birthplace"
      t.string   "birthnumber", :null => false
      t.string   "nationality", :null => false
      t.string   "occupation", :null => false
      t.string   "account"

      t.string   "emergency_name", :null => false
      t.string   "emergency_day", :null => false
      t.string   "emergency_night", :null => false

      t.string   "speak_well"
      t.string   "speak_some"

      t.text     "motivation", :null => false
      t.text     "special_needs"
      t.text     "past_experience"
      t.text     "general_remarks"
      t.text     "comments"

      t.string   "street"
      t.string   "city"
      t.string   "zipcode"

      t.string   "contact_street", :null => false
      t.string   "contact_city", :null => false
      t.string   "contact_zipcode", :null => false

      # oncly client side
      t.datetime :submitted
      t.string   :submission_status

      t.boolean  :terms_of_processing
      t.boolean  :terms_of_workcamps
      t.string   :workcamps_ids

      t.timestamps
    end

  end

  def self.down
    #raise ActiveRecord::IrreversibleMigration
    drop_table :apply_forms
  end
end
