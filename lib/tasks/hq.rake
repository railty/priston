require 'prislib'
require 'ofcmail'

namespace :hq do

	desc "test"
	task :test do
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
		
		Db.new(nil, 'alp').dump_tables
		Db.new(nil, 'ofmm').dump_tables
		
	end
	
	desc "Watch database status"
	task :watch_status do
		body = ""
		['alp',  'ofmm'].each do |store|
			if check_pris_db_status(store) then
				body = body + "#{store} OK\n"				
			else
				body = body + "#{store} failed\n"				
			end
		end
		puts body
		send_email('shawn.ning@list4d.com', 'hq db status', body)
	end

	desc "restore pris database, use all for all stores"
	task :restore_pris_dbs, :host do |t, args|
		host = args[:host]
		host = 'all' if host == nil
		host.downcase!
		if host == 'all' then
			hosts = ['alp', 'ofmm'] 
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
		puts body
		send_email('shawn.ning@list4d.com', 'hq db status', body)
	end
end

