# Using Facebook signed request decoding code from: https://github.com/nsanta/fbgraph/blob/master/lib/fbgraph/canvas.rb

require 'digest/sha2'
require 'base64'
require 'openssl'
require 'json'

module Facebook
  class Client
    module Adapter
      class Mock < Base
        attr_writer :authorization_url, :friends

        def decode_signed_reuqest(client_secret, signed_request)
          encoded_sig, payload = signed_request.split('.', 2)
          sig = urldecode64(encoded_sig)
          data = JSON.parse(urldecode64(payload))
          if data['algorithm'].to_s.upcase != 'HMAC-SHA256'
            raise "Bad signature algorithm: %s" % data['algorithm']
          end
          expected_sig = OpenSSL::HMAC.digest('sha256', client_secret, payload)
          if expected_sig != sig
            raise Error::AuthenticationError.new("Invalid signature")
          end
          data
        end

        def authorization_url(options = {})
          raise "No authorization url set in the Facebook::Client mock adapter!" unless @authorization_url
          @authorization_url
        end

        def friends
          @friends ||= {}
        end

        def friends_of(user_id, access_token)
          friends[user_id]
        end

        protected
        def urldecode64(str)
          encoded_str = str.tr('-_', '+/')
          encoded_str += '=' while !(encoded_str.size % 4).zero?
          Base64.decode64(encoded_str)
        end
      end
    end
  end
end
