require "facebook-client/adapter/base"
require "facebook-client/adapter/fb_graph"
require "facebook-client/adapter/mock"

module Facebook
  class Client
    module Adapter
      def self.get(adapter_name, client)
        const_get(Utils.camelize_string(adapter_name)).new(client)
      end
    end
  end
end
