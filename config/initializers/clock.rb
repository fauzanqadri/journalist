# class MaintainJournalSession
#   include Sidekiq::Worker
#   include Sidetiq::Schedulable
# 
#   recurrence {minutely(5)}
#   sidekiq_options queue: :high
# 
#   def perform
#     Journal.all.each do |journal|
#       journal.journal_accounts.each do |ja|
#         ja.open_session if ja.enable?
#       end
#     end
#   end
# end
# 
