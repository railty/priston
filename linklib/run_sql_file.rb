def run_sql_file(func_name)
	fname = "db/migrate/#{File.basename(func_name).gsub('.rb', '.sql')}"
	if File.exist?(fname) then
		ls = File.read(fname)
		execute ls
	else
		puts "#{fname} not exist"
		exit
	end
end

def drop_sql_object(func_name)
	if func_name =~ /^create|drop_([^_]*)_(.*)/ then
		object_type = $1
		object_name = $2
		sql = "if object_id('dbo.#{object_name}', 'U') is not null drop #{object_type} #{object_name}"
		execute sql
	end
end
