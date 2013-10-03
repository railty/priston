require 'prislib'
require 'ofcmail'

namespace :hq do
	task :test do
		send_email('zxning@gmail.com', 'hq db status', 'body')

	end
		
	desc "Watch database status"
	task :watch_status do

		sql = "Select Top 5 Date, Product_ID, Quantity, Amount From ofm.dbo.POS_Sales Order By Date Desc;"
		n = 3
		body = ""
		['alp', 'ofc', 'ofmm'].each do |store|
			sql = "Select Top #{n} Date, Product_ID, Quantity, Amount From #{store}.dbo.POS_Sales Order By Date Desc;"
			result = run_sql_cmd(sql)
			date_str = result.scan(/\d\d\d\d-\d\d-\d\d/)[0]

			today_str = (Time.now).strftime("%Y-%m-%d")
			yesterday_str = (Time.now-86400).strftime("%Y-%m-%d")

			if date_str==today_str or date_str==yesterday_str then
				body = body + "#{store} OK\n"
			else
				body = body + "#{store} fail\n"
				body = body + result
				db_7z = "d:/pris/data/pris_#{store}_#{yesterday_str}.bak.7z"
				if File.exist?(db_7z) then
					sz = File.size(db_7z)/1000/1000
					body = body + "file exist #{db_7z}, size #{sz}MB \n"
				else
					body = body + "file #{db_7z} not exist\n"
				end
			end
		end
		puts body
		send_email('shawn.ning@list4d.com', 'hq db status', body)
	end

	desc "restore pris database, use all for all stores"
	task :restore_pris_dbs, :host do |t, args|
		host = args[:host].downcase
		if host == 'all' then
			['ofmm', 'alp'].each do|host|
				restore_pris(host)
			end
		else
			restore_pris(host)
		end
	end
end

