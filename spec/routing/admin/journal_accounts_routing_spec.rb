require "rails_helper"

RSpec.describe Admin::JournalAccountsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/journal_accounts").to route_to("admin/journal_accounts#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/journal_accounts/new").to route_to("admin/journal_accounts#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/journal_accounts/1").to route_to("admin/journal_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/journal_accounts/1/edit").to route_to("admin/journal_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/journal_accounts").to route_to("admin/journal_accounts#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/journal_accounts/1").to route_to("admin/journal_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/journal_accounts/1").to route_to("admin/journal_accounts#destroy", :id => "1")
    end

  end
end
