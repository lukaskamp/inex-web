namespace :maintenance do
  
  task :menu_icons => :environment do
    MenuItem::create_all_icons
  end
  
end
