namespace :bak do
        desc "daily job"
	task :daily do
		logger.info "done daily job"
		Rake::Task["hq:daily"].invoke
		Rake::Task["hq:clear_backups"].invoke
	end

        desc "job every 5 minutes"
	task :minutes_5 do
		setip
		connect_hq
	end
end

