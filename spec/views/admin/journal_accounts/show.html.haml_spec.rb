require 'rails_helper'

RSpec.describe "admin/journal_accounts/show", :type => :view do
  before(:each) do
    @admin_journal_account = assign(:admin_journal_account, Admin::JournalAccount.create!(
      :username => "Username",
      :password => "Password",
      :other => "Other",
      :enable => false,
      :status => "Status",
      :journal_id => 1,
      :lock_version => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Other/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
