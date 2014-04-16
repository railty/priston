module GDrive
	def g_session
		$session = GoogleDrive.login(config['email_user'], config['email_password']) if $session == nil
		return $session
	end

	def g_upload(file, label)
		logger.info("uploading #{file} into #{label}")
		#always overwrite if the lavel exists
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
		g_session.file_by_title(old_label).title = new_label if g_exist?(old_label)
	end

	def g_clear
		logger.info("delete everything in gdrive")
		for file in g_session.files
			g_delete file.title
		end
	end

	def g_list
		logger.info("list files in gdrive")
		for file in g_session.files
			puts file.title
		end
	end

end