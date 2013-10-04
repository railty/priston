require 'prislib'

namespace :job do
	desc "create windows job by rake job:create[reboot, user, pass]"
	task :create, :job, :user, :password do |t, args|
		create_job(args[:job], args[:user], args[:password])
	end
	
	desc "delete windows job"
	task :delete, :job do |t, args|
		job = args[:job].downcase
		delete_job(job)
	end
	
	desc "run windows job"
	task :run, :job do |t, args|
		job = args[:job].downcase
		run_job(job)
	end
end

