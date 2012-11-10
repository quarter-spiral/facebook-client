require 'digest/sha2'
require 'base64'
require 'openssl'
require 'json'

module Facebook
  class Client
    class Fixtures
      def self.client_id
        '123'
      end

      def self.client_secret
        '123'
      end

      def self.signed_request_data(options = {})
        {
          "oauth_token" => options[:oauth_token] || "oauth-token",
          "algorithm" => "HMAC-SHA256",
          "expires" => 1291840400,
          "issued_at" => 1291836800,
          "registration" => {
             "name" => "Paul Tarjan",
             "email" => "fb@paulisageek.com",
             "location" => {
                "name" => "San Francisco, California",
                "id" => 114952118516947
             },
             "gender" => "male",
             "birthday" => "12/16/1985",
             "like" => true,
             "phone" => "555-123-4567",
             "anniversary" => "2/14/1998",
             "captain" => "K",
             "force" => "jedi",
             "live" => {
                "name" => "Denver, Colorado",
                "id" => 115590505119035
             }
          },
          "registration_metadata" => {
             "fields" => "[\n {'name':'name'},\n {'name':'email'},\n {'name':'location'},\n {'name':'gender'},\n {'name':'birthday'},\n {'name':'password'},\n {'name':'like',       'description':'Do you like this plugin?', 'type':'checkbox',  'default':'checked'},\n {'name':'phone',      'description':'Phone Number',             'type':'text'},\n {'name':'anniversary','description':'Anniversary',              'type':'date'},\n {'name':'captain',    'description':'Best Captain',             'type':'select',    'options':{'P':'Jean-Luc Picard','K':'James T. Kirk'}},\n {'name':'force',      'description':'Which side?',              'type':'select',    'options':{'jedi':'Jedi','sith':'Sith'}, 'default':'sith'},\n {'name':'live',       'description':'Best Place to Live',       'type':'typeahead', 'categories':['city','country','state_province']},\n {'name':'captcha'}\n]"
          },
          "user_id" => options[:user_id] || "218471"
        }
      end

      def self.signed_request(options = {})
        bogus_signature = options.delete :bogus_signature

        data = signed_request_data(options)

        payload = urlencode64(JSON.dump(data))

        sig = OpenSSL::HMAC.digest('sha256', client_secret, payload)
        sig = sig[0...10] + sig[10..-1].reverse if bogus_signature

        encoded_sig = urlencode64(sig)
        [encoded_sig, payload].join('.')
      end

      protected
      def self.urlencode64(str)
        str = Base64.encode64(str)
        str.tr('+/', '-_')
      end
    end
  end
end
