namespace :deploy do
	desc "Restarts the mitbot process."
	task :restart do
		on roles(:app) do
			execute "/opt/mitbot/current/mitbotd restart"
		end
	end

	desc "Starts the mitbot process."
	task :start do
		on roles(:app) do
			execute "/opt/mitbot/current/mitbotd start"
		end
	end

	desc "Stops the mitbot process."
	task :stop do
		on roles(:app) do
			execute "/opt/mitbot/current/mitbotd stop"
		end
	end

	desc "Make symlink for super-secret IRC password" 
	task :symlink do
  		run "ln -nfs #{shared_path}/config/credfile #{release_path}/config/credfile" 
	end
end