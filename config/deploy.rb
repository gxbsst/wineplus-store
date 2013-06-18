#require "bundler/capistrano"
require 'railsless-deploy'

set :deploy_via, :remote_cache
set :application, "wineplus-store"
server "rails", :web, :app, :db, primary: true
set :repository,  "git://github.com/gxbsst/wineplus-store.git"
set :user, "rails"
set :deploy_to, "/srv/rails/wineplus-store"

set :scm, :git
set :use_sudo, false

set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do

  task :setup_config, roles: :app do
    run " mkdir -p #{shared_path}/config"
    run " mkdir -p #{shared_path}/uploads"
    put File.read("wp-config-sample.php"), "#{shared_path}/config/wp-config.php"
    puts "Now edit the config files in #{shared_path}."
  end

  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/wp-config.php #{release_path}/wp-config.php"
    run "ln -nfs #{shared_path}/uploads #{release_path}/wp-content/uploads"
    #run("chmod -R 777 #{current_path}/wp-content/uploads")
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end

