#encoding: utf-8

require 'flickraw'
class FlickrUploader
  APP_KEY = XiangSettings.flickr.app_key
  APP_SECRET = XiangSettings.flickr.app_secret
  SERIALIZED_OAUTH= "#{XiangSettings.flickr.session_path}/flickr_serialized_session.yml"

  class << self
    def authorize
      FlickRaw.api_key = APP_KEY
      FlickRaw.shared_secret = APP_SECRET

      token = flickr.get_request_token
      auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

      puts "Open this url in your process to complete the authication process : #{auth_url}"
      puts "Copy here the number given when you complete the process."
      verify = gets.strip

      begin
        flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
        login = flickr.test.login
        puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
      rescue FlickRaw::FailedResponse => e
        puts "Authentication failed : #{e.msg}"
      end
      
      File.open(SERIALIZED_OAUTH, 'w') do |f|
        f.puts [flickr.access_token, flickr.access_secret].to_yaml
      end

    end

    def authorized?
      FlickRaw.api_key = APP_KEY
      FlickRaw.shared_secret = APP_SECRET
      begin
        serialized_oauth = YAML::load(File.read(SERIALIZED_OAUTH))
        flickr.access_token = serialized_oauth.shift
        flickr.access_secret = serialized_oauth.shift
        login = flickr.test.login
      rescue
        nil        
      end
    end

    def upload(file)
      return nil unless authorized?
      # file = File.open("app/assets/images/logo.jpg")
      begin
        photo_id = flickr.upload_photo file, title: "xiang-#{Time.now.to_i}"
        info = flickr.photos.getInfo(photo_id: photo_id)
        FlickRaw.url_o(info)
      rescue
        nil
      end
    end

  end

end