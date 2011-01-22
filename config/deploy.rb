=begin

Capistrano deploy script

* deploy to linux system running apache, passenger,
* install to /var/rails
* central mysql database
* create config for virtual host

=end
default_run_options[:pty] = true

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'


set :application, "cleancity"
set :repository, "git://github.com/mgratzer/cleancity-web.git"
set :virtual_hostname, "cleancity.dyndns.org"
role :app, "cleancity.dyndns.org"
role :web, "cleancity.dyndns.org"
role :db, "cleancity.dyndns.org", :primary => true
set :db_user, "rails"

ssh_options[:keys] = %w(config/deploy.pem)
ssh_options[:user] = "root"
set :user, "root"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, :master
set :git_shallow_clone, 1
set :scm_verbose, true
set(:deploy_to){"/var/rails/#{application}/#{stage}"}


namespace :deploy do
  desc "Restart the appliaction, passenger looks for the restart.txt file and restart automatically"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end


  desc "link the the shared content to the newly deployed folder"
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end

  desc "fix runtime permissions"
  task :fix_runtime_permissions do
    run "chown -R www-data #{release_path}"
  end

  desc "build plugins"
  task :build_plugins do
    run "cd #{release_path}; bundle install --deployment --without development test"
  end

  desc "db migrate"
  task :db_migrate do
    run "cd #{release_path}; RAILS_ENV=production rake db:migrate --trace"
  end


  desc "create initial shared folder, set permissions"
  task :create_shared do
    run "mkdir -p #{shared_path}/config/"
    #run "chmod -R 775 #{shared_path}"
    #run "chown -R nobody #{shared_path}"
    #top.upload("config/database.yml", "#{shared_path}/config/database.yml")
  end

  desc "generate apache virtual host descripton, with configuration for passenger"
  task :setup_apache_virtual_host do
    require 'erb'
    html = ERB.new(File.read("config/apache_virtual_host.rhtml")).result(binding)
    put html, "#{shared_path}/config/virtual-host"
    run "ln -nfs #{shared_path}/config/virtual-host /etc/apache2/sites-available/#{application}-#{stage}"
  end

end

after 'deploy:finalize_update', 'deploy:symlink_shared'
after 'deploy:finalize_update', 'deploy:fix_runtime_permissions'
after 'deploy:finalize_update', 'deploy:build_plugins'
after 'deploy:finalize_update', 'deploy:db_migrate'

after 'deploy:setup', 'deploy:create_shared'
#after "deploy:setup", 'deploy:setup_production_database_configuration'
after "deploy:setup", 'deploy:setup_apache_virtual_host'

before 'deploy:restart', 'deploy:migrate'
