require 'journalist/proxy/request_instance'
require 'action_dispatch/http/request'
module Journalist
  module Proxy
    class Server
      class << self
        include ActionDispatch::Http::URL
        def call env
          @env = env
          request = ActionDispatch::Request.new(env)
          [200, {"Content-Type" => "text/html"}, ["responding"]]
        end

        def request_instance
          @request_instance ||= fetch_instance
        end

        private
        def fetch_instance
          "Hello World"
        end
      end
    end
  end
end
