set :application, "webinex"

set :user, "inex"

set :keep_releases, 2

set :scm, "git"
set :repository,  "git@bolen.onesim.net:inex-web.git"

set :use_sudo, false

set :deploy_to, "/home/inex/app"

role :app, "bolen.onesim.net"
role :web, "bolen.onesim.net"
role :db,  "bolen.onesim.net", :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/volant_access.rb #{release_path}/config/volant_access.rb"
    run "ln -nfs #{shared_path}/data #{release_path}/public/data"
  end

#  before "deploy:update_code", "db:backup"
  after "deploy:update_code", "deploy:symlink_shared", "deploy:migrate", "tools:recreate_menu"
end



namespace :db do
  desc "seed data"
  task :seed, :roles => :app do
    run "cd #{deploy_to}/current; rake db:seed RAILS_ENV=production"
  end

  desc "make a db snapshot"
  task :backup, :roles => :app do
    run "cd #{deploy_to}/current; rake db:backup RAILS_ENV=production"
  end

  desc "demo data"
  task :demo, :roles => :app do
    run "cd #{deploy_to}/current; rake db:demo RAILS_ENV=production"
  end

  desc "basic seed data"
  task :params, :roles => :app do
    run "cd #{deploy_to}/current; rake db:params RAILS_ENV=production"
  end

  desc "recreate database throught migrations"
  task :reset_migrations, :roles => :app do
    run "cd #{deploy_to}/current; rake db:migrate VERSION=0 RAILS_ENV=production; rake db:migrate RAILS_ENV=production"
  end

  desc "recreate database throught schema"
  task :reset_schema, :roles => :app do
    run "cd #{deploy_to}/current; rake db:reset RAILS_ENV=production"
  end

end

namespace :tools do
  desc "recreate menu icons after rebuild"
  task :recreate_menu, :roles => :app do
    run "cd #{deploy_to}/current; rake maintenance:menu_icons RAILS_ENV=production"
  end

  desc "delete the fulltext index"
  task :unindex, :roles => :app do
    run "cd #{deploy_to}/current; rm -rf index"
  end
end

