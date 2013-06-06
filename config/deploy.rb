require 'bundler/capistrano'
require 'rvm/capistrano'

default_run_options[:pty] = true

set :use_sudo, false
set :repository,  "git@github.com:vinsol/spreedemo.git"
set :scm, :git

set :git_enable_submodules, 1
set :ssh_options,     { :forward_agent => true }
set :normalize_asset_timestamps, false


task :production do
  set :application, "spreedemo"
  set :deploy_to, "/var/www/spreedemo.vinsol.com"
  set :branch, "master"
  set :rvm_type, :user
  set :rails_env, 'production'
  set :my_site, 'spreedemo.konga.com'
  set :user, "deploy"
  role :web, "176.58.124.63"                          # Your HTTP server, Apache/etc
  role :app, "176.58.124.63"                          # This may be the same as your `Web` server
  role :db,  "176.58.124.63", :primary => true # This is where Rails migrations will run
end

ssh_options[:forward_agent] = true

  namespace :deploy do

    desc "copy database.yml and s3.yml to config"
    task :after_symlink, :except => { :no_release => true } do
      run <<-CMD
        ln -sf #{shared_path}/database.yml #{latest_release}/config/database.yml 
      CMD
    end

    desc "Zero-downtime restart of Unicorn"
    task :restart, :except => { :no_release => true } do
      web.disable
      stop
      start
      web.enable
    end

    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
    
    desc "assets precompile"
    task :assets_precompile, :except => { :no_release => true } do
      run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
    end
    
    task :after_symlink, :roles => :app do
      run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
    end
    
  end

  def run_rake(cmd)
    run "cd #{current_path}; #{rake} #{cmd}"
  end
  
#after 'deploy:create_symlink', 'deploy:finalize_update'
#after 'deploy:create_symlink', 'deploy:delayed_job:restart'
after "deploy:create_symlink", "deploy:after_symlink"
after "deploy:after_symlink", "deploy:assets_precompile"
require './config/boot'
