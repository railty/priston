require 'prislib'

namespace :job do
	desc "create windows job by rake job:create[reboot, user, pass]"
	task :recreate_all, :user, :password do |t, args|
		u = args[:user]
		p = args[:password]
		if u== nil and p == nil then
			if hostname=='hqsvr2' then
				puts "username:"
				u = STDIN.gets.chop
				puts "password:"
				p = STDIN.gets.chop
			else
				u = config['job_user']
				p = config['job_password']
			end
		end
		
		['reboot', 'minutes_5', 'daily'].each do |job|
			delete_job(job)
			t = config['daily_job_time'] if job == 'daily'
			create_job(job, u, p, t)	
		end
	end
	
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

	desc "run windows job"
	task :list do
		list_job
	end

        desc "update code"
        task :update_code do
                run("git pull origin master")
        end
	
        desc "update code"
        task :upload_log do
		upload_log
        end

        desc "reboot"
        task :reboot => [:update_code, :upload_log] do
		if hostname=='alp' or hostname == 'ofc' or hostname == 'ofmm' then
			Rake::Task["job:recreate_all"].invoke
		end
		
                reboot
        end
	
        desc "daily job"
	task :daily do
		Rake::Task["#{host_type}:daily"].invoke
	end

        desc "job every 5 minutes"
	task :minutes_5 do
		Rake::Task["#{host_type}:minutes_5"].invoke
	end
	
end

