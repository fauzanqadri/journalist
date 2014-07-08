require 'rails_helper'

RSpec.describe "Admin::JournalAccounts", :type => :request do
  describe "GET /admin_journal_accounts" do
    it "works! (now write some real specs)" do
      get admin_journal_accounts_path
      expect(response.status).to be(200)
    end
  end
end
