module Facebook
  class Client
    module Adapter
      class Base
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def decode_signed_reuqest(client_secret, signed_request)
          raise "Unimplemented"
        end

        def authorization_url(options = {redirect_url: nil, scopes: nil})
          raise "Unimplemented"
        end

        def friends_of(user_id, access_token)
          raise "Unimplemented"
        end

        def app_url
          "https://www.facebook.com/apps/application.php?id=#{client.client_id}"
        end
      end
    end
  end
end
