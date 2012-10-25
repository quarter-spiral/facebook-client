require 'fb_graph'

module Facebook
  class Client
    module Adapter
      class FbGraph < Base
        def initialize(*args)
          super
          @fb_auth = ::FbGraph::Auth.new(client.client_id, client.client_secret)
        end

        def decode_signed_request(client_secret, signed_request)
          facebook_info = ::FbGraph::Auth::SignedRequest.verify(@fb_auth.client, signed_request)
        rescue ::FbGraph::Auth::VerificationFailed => e
          raise Error::AuthenticationError.new(e)
        end

        def authorization_url(options)
          @fb_auth.client.redirect_uri = options[:redirect_url]
          @fb_auth.client.authorization_uri(scope: options[:scopes])
        end

        def friends_of(user_id, access_token)
          user = ::FbGraph::User.new(user_id, access_token: access_token)
          user.fetch
          user.friends
        end

        def whoami(access_token)
          data = ::FbGraph::User.me(access_token).fetch
          {
            'id' => data.identifier,
            'name' => data.name,
            'email' => data.email
          }
        end
      end
    end
  end
end
