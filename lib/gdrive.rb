module GDrive
	def g_create_token
    #1. login google using the approprate account
    #2. goto https://console.developers.google.com, create a project if needed.
    #3. goto project->apis and enable drive api
    #4. goto project->credentials, and create a new client id, using native application (others)
		client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = '309955991766-v3epsgk0rrsq1jaevcdni46kurimboim.apps.googleusercontent.com'
    auth.client_secret = 'CAkdEh309oXyNViISkoeGrNH'
    auth.scope = "https://www.googleapis.com/auth/drive"
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
    print("2. Enter the authorization code shown in the page: ")
    auth.code = $stdin.gets.chomp

    auth.fetch_access_token!
    access_token = auth.access_token
    puts access_token
	end

	def g_session
		if $session == nil then
			if RUBY_VERSION >= '2' then
        client = Google::APIClient.new(:application_name => 'priston', :application_version => '1.0.0')
        auth = client.authorization
        auth.client_id = config['email_client_id']
        auth.client_secret = config['email_client_secret']
        auth.scope = "https://www.googleapis.com/auth/drive"
        auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
        auth.refresh_token = config['email_refresh_token']
        auth.refresh! 
        $session = GoogleDrive.login_with_oauth(auth.access_token)
			else
				$session = GoogleDrive.login(config['email_user'], config['email_password']) 
			end
		end
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