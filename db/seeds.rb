# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

journals = [
  {name: "ieee (computer.org)", driver: "ComputerDotOrg", url: "http://www.computer.org/portal/web/guest/home", host: "www.computer.org"}
]

journals.each do |journal|
  Journal.find_or_initialize_by(journal).tap do |j|
    j.save!
  end
end

journal = Journal.find_by_driver("ComputerDotOrg")

journal_accounts = [
  {username: "uinshj", password: "library", journal_id: journal.id}
]

journal_accounts.each do |account|
  JournalAccount.find_or_initialize_by(account).tap do |ja|
    ja.save!
  end
end

accounts = [
  {full_name: "Fauzan Qadri", email: "ojankill@gmail.com", username: "fauzanqadri", password: "1234rewq", password_confirmation: "1234rewq", role: "SUPERADMIN"}
]
accounts.each do |account|
  a = Account.new(account)
  a.save!
end
