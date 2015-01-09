namespace :bak do
  desc "daily job"
	task :daily do
		Rake::Task["hq:restore_pris_dbs"].invoke
    Rake::Task["hq:restore_payment"].invoke
    Rake::Task["hq:download_logs"].invoke
		#Rake::Task["hq:clear_backups"].invoke
		logger.info "done daily job"    
	end

  desc "job every 5 minutes"
	task :minutes_5 do
		setip
		connect_hq
	end
end

