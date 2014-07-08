module Journalist
  module Proxy
    class RequestInstance
      class << self
        def resources
          @resources ||= []
        end
      end
    end
  end
end
