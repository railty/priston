namespace :hq do

	desc "test"
	task :test do
		backup = Db.new(nil, 'ofmn').create_backup
		#backup.backup(true)
		#backup.zip(true)
		#backup.upload
		
		if backup.download(true) and backup.unzip(true) then
			backup.restore
		end
		if backup.check_db_status then
			p "ok"
		end
		
				
		#Db.new(nil, 'alp').dump_functions
		#Db.new(nil, 'alp').dump_procedures
		#Db.new(nil, 'alp').dump_views
		
		#Db.new(nil, 'ofmm').dump_functions
		#Db.new(nil, 'ofmm').dump_procedures
		#Db.new(nil, 'ofmm').dump_views
		
		#Db.new(nil, 'ofmm').drop_functions
		#Db.new(nil, 'ofmm').drop_procedures
		#Db.new(nil, 'ofmm').drop_views
		
		#Db.new(nil, 'ofmm').run_sql_files("tmp/#{hostname}/alp/function")
		#Db.new(nil, 'ofmm').run_sql_files("tmp/#{hostname}/alp/procedure")
		#Db.new(nil, 'ofmm').run_sql_files("tmp/#{hostname}/alp/view")
		
#		Db.new(nil, 'alp').dump_tables
#		Db.new(nil, 'ofmm').dump_tables
	end
	
	desc "Watch database status"
	task :check_status do
		body = ""
		['alp',  'ofmm', 'ofc'].each do |store|
			if check_pris_db_status(store) then
				body = body + "#{store} OK\n"				
			else
				body = body + "#{store} failed\n"				
			end
		end
		body = body + " sent by #{hostname} at #{Time.now}"
		send_email('shawn.ning@list4d.com', 'hq db status', body)
	end

	desc "restore pris database, use all for all stores"
	task :restore_pris_dbs, :host do |t, args|
		host = args[:host]
		host = 'all' if host == nil
		host.downcase!
		if host == 'all' then
			hosts = ['alp', 'ofmm', 'ofc'] 
		else
			hosts = [host]
		end
		
		hosts.each do |store|
			restore_pris(store)
		end
	end
	
        desc "daily job"
	task :daily => [:restore_pris_dbs, :check_status] do
		logger.info "done daily job"
	end

        desc "job every 5 minutes"
	task :minutes_5 do
		if (hostname=='hqsvr2') then
			setip('hq')
		else
			setip
			connect_hq
		end
	end
end

