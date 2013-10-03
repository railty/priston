require 'prislib'
require 'ofcmail'

namespace :hq do

	desc "Watch database status"
	task :test do
		session = GoogleDrive.login(config['email_user'], config['email_password'])
		for file in session.files
			p file.title
			p file
		end

g_delete('pris_alp_full_2013_10_3_failed')
	
		#backup_pris('alp', 'alp')
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

