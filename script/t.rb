require "google/api_client"
#require "google_drive"

def x
config = Rails.configuration.database_configuration[Rails.env]

# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization
auth.client_id = '309955991766-v3epsgk0rrsq1jaevcdni46kurimboim.apps.googleusercontent.com'
auth.client_secret = 'CAkdEh309oXyNViISkoeGrNH'
auth.scope = "https://www.googleapis.com/auth/drive"
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")
auth.code = $stdin.gets.chomp
#auth.code = '4/jnCMS6LCJ0OGLhpzzOf3u1rxHwq0b6ekSRKZzfETs30.Unnu3VfZzKgaXmXvfARQvthKpAp_lQI'.chomp
auth.fetch_access_token!
access_token = auth.access_token
puts access_token
# Creates a session.
puts "refresh----------------"
print auth.refresh_token
end

def y
  access_token = 'ya29.8wASkyqFbsYsiy0LdhGPGu85JlSwC2er5g0wj1RskLkGGDmiGZQZPNuIggCQ4ZnnqRTOEqTrmWqnFQ'
  access_token = 'ya29.9gBaO69hauNF-RbgmBRxi_9_dwPWF2UoKbad0L1DgRemy9d999yPYXQUf_NUf7QiwUkZz5fNtNGUJw'

  session = GoogleDrive.login_with_oauth(access_token)

  # Gets list of remote files.
  for file in session.files
    p file.title
  end
end

def z
client_id = '309955991766-v3epsgk0rrsq1jaevcdni46kurimboim.apps.googleusercontent.com'
client_secret = 'CAkdEh309oXyNViISkoeGrNH'
refresh_token = '1/j87S-rY--mU3uUre9HaHgJ1KGqGYU0-tBR_yHn-hpmQMEudVrK5jSpoR30zcRFq6'

client = Google::APIClient.new
auth = client.authorization
auth.client_id = client_id
auth.client_secret = client_secret
auth.scope = "https://www.googleapis.com/auth/drive"
auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
auth.refresh_token = refresh_token
auth.refresh! 

session = GoogleDrive.login_with_oauth(auth.access_token)
  for file in session.files
    p file.title
  end
  
end

z