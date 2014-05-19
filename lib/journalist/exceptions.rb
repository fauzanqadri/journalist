module Journalist
  module Exceptions
    class Error < StandardError; end
    class NotYetImplemented < Error; end
    class SessionValid < Error; end
    class AlreadyLogout < Error; end
    class NeedResolution < Error; end
    class JournalAccountNil < Error; end
  end
end
