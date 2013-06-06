require "bundler/capistrano"

set :application, "spreedemo.vinsol.com"
set :repository,  "git@github.com:nishant-cyro/spreedemo.git"
set :stages, %w(production)
set :default_stage, "production"
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to ,"/var/www/#{application}"
set :keep_releases, 5
set :user, 'deploy'
set :use_sudo, true
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, "176.58.124.63"                          # Your HTTP server, Apache/etc
role :app, "176.58.124.63"                          # This may be the same as your `Web` server
role :db,  "176.58.124.63", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Deploy with migrations"
  task :long do
    transaction do
      update_code
      web.disable
      create_symlink
      after_symlink
      precompile_assets
      migrate
    end

    restart
    web.enable
    cleanup
  end

  task :after_symlink, :roles => :app do
    run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
  end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

  task :precompile_assets do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

end
        require './config/boot'

