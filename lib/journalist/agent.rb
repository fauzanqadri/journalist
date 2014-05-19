require 'openssl'
require 'mechanize'
module Journalist

  class Agent < Mechanize

    def initialize
      @agent = Mechanize::HTTP::Agent.new
      @agent.context = self
      @log = Journalist.logger
      ca_f =  OpenSSL::X509::Store.new
      ca_f.add_file Journalist.certificates
      @agent.cert_store = ca_f
      @agent.cookie_jar = Journalist::CookieJar.new

      # attr_accessors
      @agent.user_agent = AGENT_ALIASES['Mac Safari']
      @watch_for_set    = nil
      @history_added    = nil

      # attr_readers
      @pluggable_parser = PluggableParser.new

      @keep_alive_time  = 0

      # Proxy
      @proxy_addr = Journalist.agent_proxy_address
      @proxy_port = Journalist.agent_proxy_port
      @proxy_user = Journalist.agent_proxy_user
      @proxy_pass = Journalist.agent_proxy_password

      @html_parser = self.class.html_parser

      @default_encoding = nil
      @force_default_encoding = false

      # defaults
      @agent.max_history = 50

      yield self if block_given?

      @agent.set_proxy @proxy_addr, @proxy_port, @proxy_user, @proxy_pass
    end
  end
end
