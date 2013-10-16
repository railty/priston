namespace :hq do

	desc "test"
	task :test do
		include GDrive
		g_list
		#backup = Db.new(nil, 'ofmn').create_backup
		#puts backup.filename_local
		#backup.backup(true)
		#backup.zip(true)
		#backup.upload
		
		#if backup.download(true) and backup.unzip(true) then
		#	backup.restore
		#end
		#if backup.check_db_status then
		#	p "ok"
		#end
		
				
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
		
		body = ""
		hosts.each do |store|
			if restore_pris(store) then
				body = body + "#{store} OK\n"				
			else
				body = body + "#{store} failed\n"				
			end
		end
		body = body + " sent by #{hostname} at #{Time.now}"
		send_email('shawn.ning@list4d.com', 'hq db status', body)
	end

	task :download_logs do
		include GDrive
		['alp', 'ofmm', 'ofc', 'bak'].each do |host|
			g_download(logfile_name(host), logfile_basename(host))
		end
	end

	task :list_backups do
		include GDrive
		g_list
	end
	
	task :clear_backups do
		include GDrive
		g_clear
	end
	
        desc "daily job"
	task :daily => [:restore_pris_dbs, :download_logs] do
		logger.info "done daily job"
	end

        desc "job every 5 minutes"
	task :minutes_5 do
		setip('hq')
	end
end

