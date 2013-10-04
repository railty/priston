#require 'gmail'
#require "google_drive"

def g_session
	$session = GoogleDrive.login(config['email_user'], config['email_password']) if $session == nil
	return $session
end

def g_upload(file, label)
	logger.info("uploading #{file} into #{label}")
	g_delete(label)
	g_session.upload_from_file(file, label, :convert => false)
end

def g_download(file, label)
	logger.info("downloading #{label} into #{file}")
	
	f = g_session.file_by_title(label)
	if f == nil then
		logger.info("#{label} not exist in gdrive")
		return false
	else
		f.download_to_file(file)
		return true
	end
end

def g_delete(label)
	logger.info("delete #{label} from gdrive")
	f = g_session.file_by_title(label)
	if f == nil then
		return false
	else
		f.delete
		return true
	end
end

def g_exist?(label)
	f = g_session.file_by_title(label)
	if f == nil then
		logger.info("#{label} not exist in gdrive")
		return false
	else
		logger.info("#{label} exists in gdrive")
		return true
	end
end

def g_rename(old_label, new_label)
	logger.info("rename #{old_label} to #{new_label} in gdrive")
	g_session.file_by_title(old_label).title = new_label
end

#in case there are more reports, use the latest one
#return a string in 2011-01-31 format
def get_report_date(folder)
	last_day = Time.parse('2011-01-01')
	Dir["#{folder}/*.pdf"].each do |pdf|
#puts pdf
		filename = File.basename(pdf).gsub('.pdf', '')
		fs = filename.split(' ')
		store_name = fs[0]
		dt = fs[-1]
		dt.gsub!('W', '')
		dt.gsub!('M', '')
#puts dt
		dt = Time.parse(dt)
		last_day = dt if last_day < dt
	end

	date = last_day.strftime('%Y-%m-%d')

	return date
end

def send_email(recipients, subject_text, body_text, attachments=[])
	logger.info("email #{recipients}: #{subject_text}")
	gmail = Gmail.connect(config['email_user'], config['email_password'])
	gmail.deliver do
		to recipients
		subject subject_text
		text_part do
			body body_text
		end

		attachments.each do |attach|
				puts "Attaching #{attach}"
				add_file attach
		end

		puts "successfully sent mail to #{recipients}"
	end
	gmail.logout
end

def send_reports(recipients, reports, folder, subject, body)
	email_date = (Time.now).strftime("%Y-%m-%d")
	host = ENV["COMPUTERNAME"]

	report_date = get_report_date(folder)

	if folder=='Monthly' then
		y, m, d = report_date.split('-')

		reports.each do |rpt|
			ofn = "#{folder}/#{host} #{rpt[:new]} M#{y}-#{m}-#{d}.pdf"
			nfn = "#{folder}/#{host} #{rpt[:new]} M#{y}-#{m}.pdf"

			if File.exist?(ofn) then
				File.rename(ofn, nfn) 
			end
		end

		report_date = "#{y}-#{m}"
	end

	subject.gsub!('%report_date%', report_date)
	subject.gsub!('%store%', host)
	subject.gsub!('%email_date%', email_date)

	body.gsub!('%report_date%', report_date)
	body.gsub!('%store%', host)
	body.gsub!('%email_date%', email_date)

	attachments = []
	reports.each do |rpt|
	        rn = "#{folder}/#{host} #{rpt[:new]} #{report_date}.pdf"
		attachments << rn if File.exist?(rn)
		rn = "#{folder}/#{host} #{rpt[:new]} W#{report_date}.pdf"
		attachments << rn if File.exist?(rn)
		rn = "#{folder}/#{host} #{rpt[:new]} M#{report_date}.pdf"
puts rn
		attachments << rn if File.exist?(rn)
	end

	puts "subject: #{subject}"
	puts "body: #{body}"
	send_email(recipients, subject, body, attachments)

	attachments.each do |att|
		arch = att.gsub("#{folder}/", 'Archive/')
		puts "Moving #{att} to #{arch}"
		File.rename(att, arch)
	end
end



