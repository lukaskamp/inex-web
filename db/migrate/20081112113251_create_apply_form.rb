class CreateApplyForm < ActiveRecord::Migration
  def self.up
    create_table :apply_forms do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.string :sex, :null => false     

      t.string :street, :null => false
      t.string :city, :null => false
      t.string :zipcode, :null => false
      
      t.string :contact_street, :null => false
      t.string :contact_city, :null => false
      t.string :contact_zipcode, :null => false
      
      t.string :email
      t.string :cellphone
      t.string :phone
      
      t.date :birthdate
      t.date :birthplace
      
      t.string :nationality
      t.string :occupation
      
      t.string :passport_number
      t.string :passport_expiry
      
      # Visa related field
      t.boolean :visa_required
      t.string :emergency_name
      t.string :emergency_phone_day
      t.string :emergency_phone_night
      
      # Lanugages
      t.string :speak_well
      t.string :speak_some
      
      # Agreement
      t.boolean :terms_of_workcamps
      t.boolean :terms_of_processing
      
      # Other
      t.text :motivation
      t.text :general_remarks
      t.text :health_remarks
      t.text :general_skills
      t.text :howknow

      t.timestamps
    end
  end

  def self.down
    drop_table :apply_forms
  end
end
