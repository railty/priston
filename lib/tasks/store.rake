require 'prislib'

namespace :store do
        desc "reboot"
        task :reboot do
                reboot
        end

	desc "copy pos database"
	task :copy_pos_data do
		copy_pos_data
	end

	desc "backup pris data"
	task :backup_pris do
		backup_pris
	end

        desc "daily job"
	task :daily_job => [:copy_pos_data, :backup_pris] do
		puts "done daily job"
	end

        desc "job every 5 minutes"
	task :minutes_5_job do
		refresh_pos
		setip
		connect_hq
	end

        desc "copy backup from old server"
        task :copy_backup do
                copy_backup
        end
end
