require 'sidekiq'
module Journalist
  module Backgrounder

    class OpenSession
      include ::Sidekiq::Worker
      sidekiq_options retry: false, queue: :high

      def perform journal_account_id = nil
        begin
          journal_account_klass = "::#{Journalist.journal_account_klass}".constantize
          journal_account = journal_account_klass.find(journal_account_id)
          driver = journal_account.send("#{Journalist.journal_account_klass_belongs_to}").driver.constantize
          journal = driver.new(journal_account)
          journal.connect!
          journal_account.update(status: "online") if journal.session_valid?
        rescue Journalist::Exceptions::SessionValid
          ::Sidekiq.logger.warn "Okey, session still opened"
        end
      end
    end

    class CloseSession
      include ::Sidekiq::Worker
      sidekiq_options retry: false, queue: :high

      def perform journal_account_id = nil
        begin
          journal_account_klass = "::#{Journalist.journal_account_klass}".constantize
          journal_account = journal_account_klass.find(journal_account_id)
          driver = journal_account.send("#{Journalist.journal_account_klass_belongs_to}").driver.constantize
          journal = driver.new(journal_account)
          journal.disconnect!
          journal_account.update(status: "offline") unless journal.session_valid?
        rescue Journalist::Execptions::AlreadyLogout
          ::Sidekiq.logger.warn "It's already logout but, it should not show too. Contact developer"
        end
      end
    end

    class ExecuteDriver
      include ::Sidekiq::Worker
      sidekiq_options retry: false

      def perform journal_account_id = nil, command = nil
        journal_account_klass = "::#{Journalist.journal_account_klass}".constantize
        journal_account = journal_account_klass.find(journal_account_id)
        driver = journal_account.send("#{Journalist.journal_account_klass_belongs_to}").driver.constantize
        journal = driver.new(journal_account)
        journal.execute do
          send(command)
        end
      end
    end
  end
end
