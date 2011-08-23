class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
	#intro
	t.string :lastname, :null=>false
	t.string :firstname, :null=>false
	t.string :email
	t.string :age
	t.string :projectcountry, :null=>false
	t.string :project, :null=>false
	# 1
	t.string :reason
	t.string :reasonx
	# 2
	t.string :howknow
	t.string :howknowx
	# 3
	t.integer :findinex
	t.integer :findproject
	t.integer :findapplication
	t.string  :findcomment
	# 4
	t.integer :ratecommunication
	t.integer :rateapplication
	t.string  :ratecomment
	# 5
	t.integer :projwork
	t.integer :projstudy
	t.integer :projgroup
	t.integer :projleisure
	t.integer :projleader
	t.integer :projaccomodation
	t.integer :projfood
	t.integer :projhygiene
	t.string  :projcomment
	# 6
	t.integer :collcommunication
	t.integer :collconflict
	t.integer :collinfo
	t.string  :collcomment
	# 7
	t.integer :wasgood
	# 8 
	t.integer :wouldrecommend
	t.string  :whynot
	# 9
	t.integer :rating
	# 10
	t.string :visa
	# 11
	t.string :transport
	# 12
	t.integer :goagain
	# 13
	t.integer :recommendtofriends
	# 14
	t.integer :wouldhelp
	# 15
	t.string :newsletter
	# 16
	t.string :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
