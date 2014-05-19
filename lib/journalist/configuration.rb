require 'logger'
require 'redis'
module Journalist

  def self.configure &block
    instance_eval &block if block_given?
  end

  def self.config
    self
  end

  class << self

    attr_writer :log_path, :certificates, :redis_host, :redis_port, :journal_account_klass, :journal_account_klass_belongs_to
    attr_accessor :redis_db, :redis_path, :redis_username, :redis_password, :logger, :redis, :agent_proxy_address, :agent_proxy_port, :agent_proxy_user, :agent_proxy_password

    def root
      File.expand_path('../../../', __FILE__)
    end

    def logger
      @logger ||= ::Logger.new(log_path)
    end

    def redis
      @redis ||= ::Redis.new(redis_configurations)
    end

    def redis_configurations
      return {path: redis_path} if using_redis_path?
      return {url: build_redis_url} if redis_password.present?
      config = {
        host: build_redis_url,
        port: redis_port
      }
      config[:db] = redis_db(true) if redis_db.present?
      return config unless redis_password.present?
    end


    def log_path
      @log_path ||= "#{Journalist.root}/log/journalist.log"
    end

    def certificates
      @certificates ||= "#{root}/certificates/cacert.pem"
    end

    def redis_host
      @redis_host ||= 'localhost'
    end

    def redis_port
      @redis_port ||= 6379
    end

    def journal_account_klass
      @journal_account_klass ||= "JournalAccount"
    end

    def journal_account_klass_belongs_to
      @journal_account_klass_belongs_to ||= "journal"
    end

    private

    def build_redis_url
      if (!redis_username.present? || redis_username.present?) && redis_password.present?
        "redis://#{redis_username}:#{redis_password}@#{redis_host}:#{redis_port}#{build_redis_db}"
      else
        "#{redis_host}"
      end
    end

    def build_redis_db hash = false
      return redis_db if redis_db.present? && hash
      return "/#{redis_db}" if redis_db.present?
    end

    def using_redis_path?
      redis_path.present?
    end
  end
end

