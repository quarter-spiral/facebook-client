module Facebook
  class Client
    class Authenticated
      attr_reader :client, :access_token

      def initialize(client, access_token)
        @client = client
        @access_token = access_token
      end

      def friends_of(user_id)
        client.adapter.friends_of(user_id, access_token)
      end

      def whoami
        client.adapter.whoami(access_token)
      end
    end
  end
end
