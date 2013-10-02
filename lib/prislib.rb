$sqldata_path = "D:\\SQLData\\"
$data_path = "D:\\Pris\\Data\\"

def logger
	Rails.logger = Logger.new("log/pris_#{hostname}_#{Time.now.strftime("%Y_%m_%d") }.log") if Rails.logger == nil
	return Rails.logger
end

def config
	return Rails.configuration.database_configuration[Rails.env]
end

def run(cmd)
	logger.info(cmd)
	result = `#{cmd} 2>&1`
	logger.info(result)
	return result
end

def run_sql(sqlfile)
	cmd = "osql -e -E -l 300 -i #{sqlfile}"
	return run(cmd)
end

def run_sql_cmd(sql)
	f = File.open('anonymous.sql', "w+")
	f.puts(sql)
	f.close
	return run_sql('anonymous.sql')
end

def hostname
	hostname = ENV["COMPUTERNAME"]
	hostname = hostname.downcase
	return hostname
end

def compress(i, o)
	run("7z a -t7z -mx9 #{o} #{i}")
end

def decompress(i)
	run("7z x #{i} -od:\\temp -y")
end


def get_latest_file(pattern)
	logger.info("getting latest #{pattern}")

	latest_time = nil
	latest_file = nil
	pattern.gsub!("\\", '/')
	Dir[pattern].each do |bak|
		if latest_time == nil then
			latest_time = File::mtime(bak)
			latest_file = bak
		else
			if latest_time < File::mtime(bak) then
				latest_time = File::mtime(bak)
				latest_file = bak
			end
		end
	end
	latest_file.gsub!('/', "\\")
	logger.info("latest file is #{latest_file}")
	return latest_file
end

def setip
	uri = URI.parse("http://tst.orientalfoods.ca")
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new("/setip?host=#{hostname}")
	response = http.request(request)
	logger.info("set ip of #{hostname}")
	logger.info(response.body)
end

def connect_hq
	cmd = "rasdial hq #{config['hq_user']} #{config['hq_password']}"
	result = `#{cmd} 2>&1`
	logger.info(result)
end

def disconnect_hq
	run("rasdial hq /disconnect")
end

def reboot
        cmd = "shutdown -r -f"
        puts cmd
        result = run(cmd)
        puts result
        return false if result =~ /ERROR/
        return true
end

def copy_backup
	lastest_backup_db_7z = get_latest_file('//192.168.1.202/d$/pris/data/pris_*_full*.7z')
	if lastest_backup_db_7z =~ /([^\\]*)\.7z$/ then
		lastest_backup_db = $1
		puts lastest_backup_db
		decompress(lastest_backup_db_7z)
		run_sql_cmd("DROP DATABASE [Pris]")
		run_sql_cmd("RESTORE DATABASE [Pris] FROM DISK = N'D:\\Temp\\#{lastest_backup_db}' WITH MOVE N'Pris' TO N'D:\\SQLDATA\\Pris.mdf', MOVE N'Pris_log' TO N'D:\\SQLDATA\\Pris_1.ldf';")
		run_sql_cmd("use pris;\r\ngo\r\nsp_change_users_login 'update_one', 'po', 'po' ;\r\ngo\r\n")
		run_sql_cmd("use pris;\r\ngo\r\nupdate pos set signature=null where datalength(signature)>10000;\r\ngo\r\n")
		run_sql_cmd("use pris;\r\ngo\r\nupdate pos set ordered_signature=null where datalength(ordered_signature)>10000;\r\ngo\r\n")
		run_sql_cmd("use pris;\r\ngo\r\nupdate pos set received_signature=null where datalength(received_signature)>10000;\r\ngo\r\n")
		run_sql_cmd("use pris;\r\ngo\r\nupdate pos set received_signature=null where datalength(received_signature)>10000;\r\ngo\r\n")
	end 
end

def copy_pos_data
	run_sql_cmd("Pris.Dbo.Refresh_POS @Full=1")
	run_sql_cmd("Pris.Dbo.Calculate_Sales")
	run_sql_cmd("Pris.Dbo.Build_Inventory")
end

def backup_pris
	t=Time.now
	dt = "#{t.year}_#{t.month}_#{t.day}"
	host = hostname

	filename = "#{$data_path}pris_#{host}_full_#{dt}.bak"
	compress_filename = "#{filename}.7z"

	#File.delete filename if File.exist? filename
	#File.delete compress_filename if File.exist? compress_filename

	sql = "BACKUP DATABASE [Pris] TO DISK = N'#{filename}' WITH INIT, NAME = N'Pris Full Database Backup at #{dt}'"
	logger.info("making full backup #{filename} on #{host}")
	#run_sql_cmd(sql)
	#compress(filename, compress_filename)
	g_upload(compress_filename, "pris_#{host}_full_#{dt}")
end

def restore_pris(host)
	today_str = (Time.now).strftime("%Y_%-m_%d")
	logger.info("restore database")
	latest_full_bak_7z = "#{$data_path}pris_#{host}_full_#{today_str}.bak.7z"

	g_download(latest_full_bak_7z, "pris_#{host}_full_#{today_str}")
	if latest_full_bak_7z =~ /(\d+)_(\d+)_(\d+)/ then
		full_dt = Time.local($1, $2, $3)
		full_name = "pris_#{host}_full_#{$1}_#{$2}_#{$3}.bak"
	end

	decompress(latest_full_bak_7z)		
	run_sql_cmd("RESTORE DATABASE [#{host}] FROM DISK = N'D:\\Temp\\#{full_name}' WITH MOVE N'Pris' TO N'D:\\SQLDATA\\#{host}.mdf', MOVE N'Pris_log' TO N'D:\\SQLDATA\\#{host}_1.ldf';")
	run_sql_cmd("use #{host};\r\ngo\r\nsp_change_users_login 'update_one', 'po', 'po' ;\r\ngo\r\n")
end

def create_job(job)
	run("schtasks /create /xml jobs\\#{job}.xml /tn #{job} /ru #{config['job_user']} /rp #{config['job_password']}")
end

def delete_job(job)
	run("schtasks /delete /tn #{job} /f")
end

def refresh_pos
	run_sql_cmd("use pris; exec refresh_pos")
end