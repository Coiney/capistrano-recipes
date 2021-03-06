namespace :deploy do 

  desc <<-DESC

Change ownership of the created directories to user '#{user}'.

Execute at the setup stage to the application deployment user. Run
this after deploy:setup task.

Source: #{path_to __FILE__}
  DESC
  task :chown_dirs, :except => { :no_release => true } do 
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    sudo "chown -R #{user} #{dirs.join(' ')}" if user
  end

end

after "deploy:setup", "deploy:chown_dirs"
before "database:setup", "deploy:chown_dirs"
before "unicorn:setup", "deploy:chown_dirs"
