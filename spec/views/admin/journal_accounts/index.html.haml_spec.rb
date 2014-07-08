require 'rails_helper'

RSpec.describe "admin/journal_accounts/index", :type => :view do
  before(:each) do
    assign(:admin_journal_accounts, [
      Admin::JournalAccount.create!(
        :username => "Username",
        :password => "Password",
        :other => "Other",
        :enable => false,
        :status => "Status",
        :journal_id => 1,
        :lock_version => 2
      ),
      Admin::JournalAccount.create!(
        :username => "Username",
        :password => "Password",
        :other => "Other",
        :enable => false,
        :status => "Status",
        :journal_id => 1,
        :lock_version => 2
      )
    ])
  end

  it "renders a list of admin/journal_accounts" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Other".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
