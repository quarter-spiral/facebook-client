module Facebook
  class Client
    class Utils
      def self.camelize_string(str)
        str.to_s.gsub('-', '_').sub(/^[a-z\d]*/) { $&.capitalize }.gsub(/(?:_|(\/))([a-z\d]*)/i) {$2.capitalize}
      end
    end
  end
end
