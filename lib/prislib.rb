require 'gdrive'
require 'ofcmail'

$sqldata_path = "D:\\SQLData\\"
$data_path = "D:\\Pris\\Data\\"

def logger
	if Rails.logger == nil then
		Rails.logger = Logger.new("log/pris_#{hostname}_#{Time.now.strftime("%Y_%m_%d") }.log") 
		logger.formatter = Logger::Formatter.new
	end
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

def setip(host=hostname)
	uri = URI.parse("http://tst.orientalfoods.ca")
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new("/setip?host=#{host}")
	response = http.request(request)
	logger.info("set ip of #{host}")
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

def backup_pris(host=hostname, db='Pris')
	t=Time.now
	dt = "#{t.year}_#{t.month}_#{t.day}"

	return if g_exist?("pris_#{host}_full_#{dt}_success")

	filename = "#{$data_path}pris_#{host}_full_#{dt}.bak"
	compress_filename = "#{filename}.7z"

	File.delete filename if File.exist? filename
	File.delete compress_filename if File.exist? compress_filename

	sql = "BACKUP DATABASE [#{db}] TO DISK = N'#{filename}' WITH INIT, NAME = N'Pris Full Database Backup at #{dt}'"
	logger.info("making full backup #{filename} on #{host}")
	run_sql_cmd(sql)
	compress(filename, compress_filename)
	g_upload(compress_filename, "pris_#{host}_full_#{dt}")
end

def restore_pris(host)
	return true if check_pris_db_status(host)
	today_str = (Time.now).strftime("%Y_%-m_%-d")
	logger.info("restore database")
	latest_full_bak_7z = "#{$data_path}pris_#{host}_full_#{today_str}.bak.7z"

	return false if !g_download(latest_full_bak_7z, "pris_#{host}_full_#{today_str}")
	if latest_full_bak_7z =~ /(\d+)_(\d+)_(\d+)/ then
		full_dt = Time.local($1, $2, $3)
		full_name = "pris_#{host}_full_#{$1}_#{$2}_#{$3}.bak"
	end

	decompress(latest_full_bak_7z)		
	run_sql_cmd("RESTORE DATABASE [#{host}] FROM DISK = N'D:\\Temp\\#{full_name}' WITH MOVE N'Pris' TO N'D:\\SQLDATA\\#{host}.mdf', MOVE N'Pris_log' TO N'D:\\SQLDATA\\#{host}_1.ldf';")
	run_sql_cmd("use #{host};\r\ngo\r\nsp_change_users_login 'update_one', 'po', 'po' ;\r\ngo\r\n")
	
	status = check_pris_db_status(host)
	if status then
		#g_rename("pris_#{host}_full_#{today_str}", "pris_#{host}_full_#{today_str}_success")
	else
		#g_rename("pris_#{host}_full_#{today_str}", "pris_#{host}_full_#{today_str}_failed")
	end
	return status
end

def create_job(job, u = nil, p = nil)
	u = config['job_user'] if u==nil
	p = config['job_password'] if p==nil
	run("schtasks /create /xml jobs\\#{job}.xml /tn #{job} /ru #{u} /rp #{p}")
end

def delete_job(job)
	run("schtasks /delete /tn #{job} /f")
end

def run_job(job)
	run("schtasks /run /tn #{job}")
end

def refresh_pos
	run_sql_cmd("use pris; exec refresh_pos")
end

def check_pris_db_status(db)
	sql = "Select Max(Date) From #{db}.dbo.POS_Sales;"
	result = run_sql_cmd(sql)
	date_str = result.scan(/\d\d\d\d-\d\d-\d\d/)[0]
	
	today_str = (Time.now).strftime("%Y-%m-%d")
	yesterday_str = (Time.now-86400).strftime("%Y-%m-%d")

	return true if date_str==today_str or date_str==yesterday_str
	return false		
end

class Backup
	include GDrive
	def initialize(db, date=Date.today)
		@db = db
		@date = date
	end

	#filename definitions
	def filename_base
		return "#{@db.host}_#{@db.name}_full_#{@date}"
	end

	def filename_g
		return "#{filename_base}"
	end
	
	def filename_g_ready
		return "#{filename_g}_ready"
	end
	
	def filename_g_success
		return "#{filename_g}_success"
	end

	def filename_local
		return "#{$data_path}#{filename_base}.bak"
	end
	
	def filename_7z
		return "#{filename_local}.7z"
	end

	#backup and upload
	def backup(overwrite=false)
		return if !check_overwrite(filename_local, overwrite)

		sql = "BACKUP DATABASE [#{@db.name}] TO DISK = N'#{filename_local}' WITH INIT, NAME = N'Pris Full Database Backup at #{@date}'"
		logger.info("making full backup #{filename_local} on #{@db.host}")
		run_sql_cmd(sql)
	end
	
	def zip(overwrite=false)
		return if !check_overwrite(filename_7z, overwrite)
		run("7z a -t7z -mx9 #{filename_7z} #{filename_local}")
	end

	def upload
		return if g_exist?(filename_g_success) or g_exist?(filename_g_ready)
		g_upload(filename_7z, filename_g)
		g_rename(filename_g, filename_g_ready)
	end
	
	#download and restore	
	def download(overwrite=false)
		return false if !check_overwrite(filename_7z, overwrite)
		return true if g_download(filename_7z, filename_g_success)
		return true if g_download(filename_7z, filename_g_ready)
	end

	def unzip(overwrite=false)
		return if !check_overwrite(filename_local, overwrite)
		run("7z x #{filename_7z} -o#{$data_path} -y")
	end

	def restore
		run_sql_cmd("RESTORE DATABASE [#{@db.name}] FROM DISK = N'#{filename_local}' WITH MOVE N'Pris' TO N'D:\\SQLDATA\\#{@db.name}.mdf', MOVE N'Pris_log' TO N'D:\\SQLDATA\\#{@db.name}_1.ldf';")
		run_sql_cmd("use #{@db.name};\r\ngo\r\nsp_change_users_login 'update_one', 'po', 'po' ;\r\ngo\r\n")
		if check_db_status then
			g_rename(filename_g_ready, filename_g_success)
		else
			g_delete(filename_g_ready)
		end
	end

	#overwrite control
	def check_overwrite(fname, overwrite=false)
		return true if !File.exist? fname
		if (overwrite) then
			File.delete fname 
			return true
		else
			logger.error "#{fname} already exists, exit"
			return false
		end
	end
	
	def check_db_status
		sql = "Select Max(Date) From #{@db.name}.dbo.POS_Sales;"
		result = run_sql_cmd(sql)
		date_str = result.scan(/\d\d\d\d-\d\d-\d\d/)[0]
		
		today_str = (Time.now).strftime("%Y-%m-%d")
		yesterday_str = (Time.now-86400).strftime("%Y-%m-%d")

		return true if date_str==today_str or date_str==yesterday_str
		return false		
	end
end

class Db
	@@obj_types = {'P '=>'Procedure', 'FN'=> 'Function', 'V '=> 'View', 'U '=>'Table'}
	attr_reader :host, :name
	def initialize(host=nil, name='pris')
		host ||= hostname
		@host = host
		@name = name
	end

	def run_sql_files(sql_folder)
		Dir["#{sql_folder}/*.sql"].each do |sql_file|
			run_sql_file(sql_file)
		end
	end

	def run_sql_file(sql_file)
		logger.info("running #{sql_file}")
		sql = File.read(sql_file)
		run_sql(sql)
	end

	def run_sql(sql)
		logger.info(sql)
		
		if @conn == nil
			@conn = TinyTds::Client.new(:username => config['username'], :password => config['password'], :host => @host, :database => @name)
			@conn.execute("set textsize 65536")
		end

		result = @conn.execute(sql)
		yield result if block_given?
		result.do
	end

	def objs
		if @objs == nil then
			@objs = []
			run_sql("select name, object_id, type from sys.objects where type in ('#{@@obj_types.keys.join("', '")}') and name not like 'sp_%' and name not like 'fn_%' and name not like 'sys%'") do |result|
				result.each do |row|
					@objs << {name:row['name'], id:row['object_id'], type: @@obj_types[row['type']]}
				end
			end
		end
		return @objs
	end

	def drop_objs(obj_type)
		if obj_type == 'Table' then
			puts "not implemented"
		else
			objs.each do |obj|
				run_sql("drop #{obj_type} #{obj[:name]}") if obj[:type] == obj_type
			end
		end
	end

	def dump_result(result)
		header = true
		strs = []
		result.each do |r|
			str_k = ''
			str_v = ''
			r.keys.each do |k|
				str_k = str_k + "#{k}\t"
				str_v = str_v + "#{r[k]}\t"
			end
			if header then
				strs << str_k 
				header = false
			end
			strs << str_v
		end
		return strs
	end
	
	def dump_objs(obj_type)
		folder = "tmp/#{@host}/#{@name}/#{obj_type}"
		FileUtils.mkdir_p folder
		objs.each do |obj|
			if obj[:type] == obj_type then
				f = File.open("#{folder}/#{obj[:name]}.sql", "w")
				sql = ''
				if obj_type == 'Table' then
					sql = "SELECT COLUMN_NAME, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH, NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, DATETIME_PRECISION FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='#{obj[:name]}' ORDER BY COLUMN_NAME"
					run_sql(sql) do |result|
						f.puts dump_result(result)
					end
					f.puts "-------------------------------"
					sql = "SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where TABLE_NAME = '#{obj[:name]}' ORDER BY CONSTRAINT_NAME"
					run_sql(sql) do |result|
						f.puts dump_result(result)
					end
				else
					sql = "select object_definition(object_id('#{obj[:name]}')) as definition"
					run_sql(sql) do |result|
						result.each do |r|
							f.puts r['definition']
						end
					end
				end
				f.close
			end
		end
	end

	def method_missing(m, *args, &block)
		method = m.to_s
		@@obj_types.each do |obj_type_short, obj_type|
			if method.capitalize.chop == obj_type then
				return objs.select{|o| o[:type]==obj_type}.collect{|o| o[:name]}
			end
			
			if method == "drop_#{obj_type.downcase.pluralize}" then
				return drop_objs(obj_type)
			end
			
			if method == "dump_#{obj_type.downcase.pluralize}" then
				return dump_objs(obj_type)
			end
		end
					
		super
	end

	def create_backup
		backup = Backup.new(self)
		return backup
	end
	
	def to_s
		str = "#{@name} at #{@host}"
	end
end