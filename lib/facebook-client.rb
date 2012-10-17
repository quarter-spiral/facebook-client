require "facebook-client/version"
require "facebook-client/utils"
require "facebook-client/error"
require "facebook-client/adapter"
require "facebook-client/unauthenticated"
require "facebook-client/authenticated"

module Facebook
  class Client
    attr_reader :client_id, :client_secret, :adapter

    def initialize(client_id, client_secret, options = {})
      @client_id = client_id
      @client_secret = client_secret

      options[:adapter] ||= :fb_graph
      @adapter = Adapter.get(options[:adapter], self)
    end

    def unauthenticated
      @unuathenticated_client ||= Unauthenticated.new(self)
    end

    def authenticated_by(access_token)
      @authenticated_client ||= Authenticated.new(self, access_token)
    end
  end
end
