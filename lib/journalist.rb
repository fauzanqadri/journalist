require 'active_support/all'
require 'nokogiri'
require 'journalist/exceptions'
require 'journalist/version'
require 'journalist/configuration'
require 'journalist/cookie_jar'
require 'journalist/agent'
require 'journalist/driver'
Dir["#{Journalist.root}/lib/journalist/driver/*.rb"].each {|f| require f}
require 'journalist/backgrounder'

module Journalist
  module JournalAccountModel
    extend ActiveSupport::Concern
    STATUS = %w{online offline resolution}
    def open_session
      Journalist::Backgrounder::OpenSession.perform_async(id)
    end

    def close_session
      Journalist::Backgrounder::CloseSession.perform_async(id)
    end

    def execute_driver command = nil
      Journalist::Backgrounder::ExecuteDriver.perform_async(id, command)
    end

    included do

      belongs_to Journalist.journal_account_klass_belongs_to.to_sym, counter_cache: :journal_accounts_count
      validates_presence_of :username, :password, :journal_id
      validates_inclusion_of :status, in: STATUS
      after_commit :make_online_offline, on: :update, if: Proc.new { |record|
        record.previous_changes.include? :enable
      }
      after_commit :recount_journal_status, on: :update, if: Proc.new {|record|
        record.previous_changes.include? :status
      }
      after_commit :alias_recount_journal_status, on: :create
      before_destroy :make_disable

      scope :online_accounts, -> {where(enable: true, status: "online")}
      scope :offline_accounts, -> {where(enable: false, status: "offline")}
      scope :resolution_accounts, ->{where(enable: true, status: "resolution")}
    end

    private
    def make_online_offline
      open_session if enable
      close_session unless enable
    end

    def recount_journal_status
      journal_model_config = Journalist.journal_account_klass_belongs_to
      journal_model = journal_model_config.classify.constantize
      model = send(journal_model_config)
      journal_model.increment_counter(:online_accounts_count, journal_id) if status == "online"
      journal_model.decrement_counter(:online_accounts_count, journal_id) if status == "offline" && model.online_accounts_count != 0
      journal_model.increment_counter(:offline_accounts_count, journal_id) if status == "offline"
      journal_model.decrement_counter(:offline_accounts_count, journal_id) if status == "online" && model.offline_accounts_count != 0
    end

    def alias_recount_journal_status
      recount_journal_status
    end

    def make_disable
      errors.add(:enable, "Cannot delete journal account when it still enable") if enable
      errors.add(:status, "Cannot delete journal account when it still online") if status == "online"
      errors.blank?
    end
  end

  module JournalModel
    extend ActiveSupport::Concern
    DRIVER = Dir.glob("#{Journalist.root}/lib/journalist/driver/*.rb").map {|path| File.basename(path, ".*").classify}

    included do
      validates_presence_of :name, :driver
      validates_inclusion_of :driver, in: DRIVER
      has_many Journalist.journal_account_klass.underscore.pluralize.to_sym, dependent: :destroy
    end

    def online_accounts
      journal_accounts = send(Journalist.journal_account_klass.underscore.pluralize.to_sym)
      journal_accounts.online_accounts
    end

    def offline_accounts
      journal_accounts = send(Journalist.journal_account_klass.underscore.pluralize.to_sym)
      journal_accounts.offline_accounts
    end

    def resolutions_accounts
      journal_accounts = send(Journalist.journal_account_klass.underscore.pluralize.to_sym)
      journal_accounts.resolution_accounts
    end

    def status
      journal_accounts_size = send(Journalist.journal_account_klass.underscore.pluralize.to_sym).size
      online_accounts_size = online_accounts.size
      "#{online_accounts_size}/#{journal_accounts_size} Online"
    end

    def get_cookie
      online = online_accounts
      if !online.blank?
        index = rand(online_accounts.size)
        journal_account_cache = online[index]
        journal_account_model = send(Journalist.journal_account_klass.underscore.pluralize.to_sym)
        journal_account = journal_account_model.find(journal_account_cache.id)
        driver = journal_account.send(Journalist.journal_account_klass_belongs_to).driver.constantize.new(journal_account)
        driver.get_cookie
      else
        nil
      end
    end
  end
end
