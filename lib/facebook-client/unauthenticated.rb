module Facebook
  class Client
    class Unauthenticated
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def decode_signed_request(signed_request)
        client.adapter.decode_signed_request(@client.client_secret, signed_request)
      end

      def authorization_url(options = {})
        raise Error::Base.new("Must provide redirect url") unless options[:redirect_url]
        options[:scopes] ||= []
        client.adapter.authorization_url(options)
      end

      def app_url
        client.adapter.app_url
      end
    end
  end
end
