module Journalist
  module Driver
    module Abstract

      def session_valid?
        raise Journalist::Exceptions::NotYetImplemented.new
      end

      def login
        raise Journalist::Exceptions::NotYetImplemented.new
      end

      def logout
        raise Journalist::Exceptions::NotYetImplemented.new
      end
    end

    class Base
      include Abstract
      attr_reader :mechanize_agent

      def initialize journal_account = nil
        @journal_account ||= journal_account
        @mechanize_agent ||= Journalist::Agent.new
        raise Journalist::Exceptions::JournalAccountNil.new if journal_account.nil?
      end

      def identifier
        "#{self.class.to_s.underscore}_#{@journal_account.id}"
      end

      def execute &block
        load_session
        instance_eval &block if block_given?
      end

      def raw_cookie
        Journalist.redis.get("#{identifier}")
      end

      def get_cookie
        YAML.load(raw_cookie)
      end

      def connect!
        load_session
        if !session_valid?
          login
          save_cookie
        else
          raise Journalist::Exceptions::SessionValid.new
        end
      end

      def disconnect!
        load_session
        if session_valid?
          logout
          destroy_session
        else
          raise Journalist::Exceptions::AlreadyLogout.new
        end
      end

      private

      def save_cookie
        Journalist.redis.set("#{identifier}", YAML.dump(mechanize_agent.cookie_jar))
      end

      def destroy_session
        Journalist.redis.del("#{identifier}")
      end

      def load_session
        mechanize_agent.cookie_jar = get_cookie if raw_cookie.present?
      end
    end
  end
end
