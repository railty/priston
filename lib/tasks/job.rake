require 'prislib'

namespace :job do
	desc "create windows job"
	task :create, :job do |t, args|
		job = args[:job].downcase
		create_job(job)
	end
	
	desc "delete windows job"
	task :delete, :job do |t, args|
		job = args[:job].downcase
		delete_job(job)
	end
end

