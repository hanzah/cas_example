require 'uri'
require 'net/http'

class CasClient
  class << self  
    def setup
      yield self
    end
  
    def client_id=(val)
      @client_id = val
    end

    def client_secret=(val)
      @client_secret = val
    end

    def auth_path=(val)
      @auth_path = val
    end
    
    def verify_path=(val)
      @verify_path = val
    end
  
    def auth_path
      @auth_path_with_secrets ||= generate_url(@auth_path,
                                               client_id: @client_id,
                                               client_secret: @client_secret )
    end
    
    def verify_path
      @verify_path
    end

    def user(verification_token)
      uri = URI.parse(@verify_path)
      uri.query = URI.encode_www_form(client_id: @client_id,
                                      client_secret: @client_secret,
                                      verification_token: verification_token)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      JSON.parse(http.request(request).body)
    rescue
      false
    end

    def generate_url(url, params = {})
      uri = URI(url)
      uri.query = params.to_query
      uri.to_s 
    end
  end
end