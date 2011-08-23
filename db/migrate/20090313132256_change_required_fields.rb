class ChangeRequiredFields < ActiveRecord::Migration
  def self.up
    unset_required :street
    unset_required :city
    unset_required :zipcode

    set_required :emergency_name
    set_required :emergency_phone_day
    set_required :emergency_phone_night

    set_required :birthdate
    set_required :occupation
    set_required :motivation

    remove_column :apply_forms, :passport_number
    remove_column :apply_forms, :passport_expiry
  end

  def self.down
    set_required :street
    set_required :city
    set_required :zipcode

    unset_required :emergency_name
    unset_required :emergency_phone_day
    unset_required :emergency_phone_night
    unset_required :birthdate
    unset_required :occupation
    unset_required :motivation

    add_column :apply_forms, :passport_number, :string
    add_column :apply_forms, :passport_expiry, :string
  end

  private

  def self.set_required(field, type = :string, null = false)
    change_column :apply_forms, field, type, :null => null
  end

  def self.unset_required(field, type = :string)
    set_required(field, type, true)
  end
end
