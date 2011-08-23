namespace :db do
  
  desc "Load seed fixtures (from db/fixtures) into the current environment's database. Synchronizes galleries with database."
  task :seed => :environment do
    puts 'Creating basic(seed) data in the database.'    
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/seed/*.yml').each do |file|
      puts "Loading seed fixture #{file}"
      Fixtures.create_fixtures('db/fixtures/seed', File.basename(file, '.*'))
    end
    
    # TODO - output the log
    log = []
    MediaSynchronizer::synchronize_gallery(log,true)    
  end

  desc "Load core fixtures (parameters and BTs) into the current environment's database." 
  task :params => :environment do
    puts 'Creating basic(seed) data in the database.'    
    require 'active_record/fixtures'
    ['parameters', 'builtin_texts'].each do |fixname|
      puts "Loading seed fixture #{fixname}"
      Fixtures.create_fixtures('db/fixtures/seed', fixname)
    end
  end
  
  desc "Load demo fixtures (from db/fixtures) into the current environment's database." 
  task :demo => :environment do
    puts 'Loading demo data to database.'
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/demo/*.yml').each do |file|
      puts "Loading demo fixture #{file} / #{File.basename(file, '.*')}"
      Fixtures.create_fixtures('db/fixtures/demo', File.basename(file, '.*'))
    end
  end
  
  desc "Resets whole database and loads all demo data again."
  task :demo_rebuild => [ :reset, :seed, :demo ] do    
  end

  task :backup => ["data:dump"] do
    require 'ftools'
    File.copy(RAILS_ROOT + '/db/data.yml', "#{RAILS_ROOT}/db/data_#{Time.now.strftime "%Y%m%d-%H%M%S"}.yml")
  end

  namespace :create do
    desc "Creates testing/development 'external INEX databases' unless they exist."        
    task :inexdb => :environment do
      DUMP_FILE = 'db/inex_db/inex_dump.sql'
      
      begin
        system 'unzip -d db/inex_db db/inex_db/inex_dump.sql.zip'
      rescue
        puts 'Failed to unzip testing dump' and return
      end
  
      [ 'workcamps_test', 'workcamps_development' ].each do |name|
        config = ActiveRecord::Base.configurations[name]
        
        begin
          puts "Creating #{name}"
          create_database( config)
          
          puts "Loading dump and functions to #{name}"        
          ActiveRecord::Base.establish_connection( config)        

          scripts =  [  DUMP_FILE ]
          scripts << Dir['db/inex_db/[0-9][0-9]_*.sql'].sort      
          scripts.flatten.each { |script| execute_plsql( config,script) }
        rescue
          drop_database(config)
        end      
      end
            
      File.delete(DUMP_FILE)
    end
    
    def execute_plsql( config, file)
      command = "psql -f #{file} -d #{config['database']} -U #{config['username']} -o log/dump_load.log"
      puts "Running #{file} ..."
      unless system(command)
        puts "Failed to execute #{command}"
      else
        puts "Done."
      end
        
    end
    
  end
  
end