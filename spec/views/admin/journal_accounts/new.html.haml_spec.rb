require 'rails_helper'

RSpec.describe "admin/journal_accounts/new", :type => :view do
  before(:each) do
    assign(:admin_journal_account, Admin::JournalAccount.new(
      :username => "MyString",
      :password => "MyString",
      :other => "MyString",
      :enable => false,
      :status => "MyString",
      :journal_id => 1,
      :lock_version => 1
    ))
  end

  it "renders new admin_journal_account form" do
    render

    assert_select "form[action=?][method=?]", admin_journal_accounts_path, "post" do

      assert_select "input#admin_journal_account_username[name=?]", "admin_journal_account[username]"

      assert_select "input#admin_journal_account_password[name=?]", "admin_journal_account[password]"

      assert_select "input#admin_journal_account_other[name=?]", "admin_journal_account[other]"

      assert_select "input#admin_journal_account_enable[name=?]", "admin_journal_account[enable]"

      assert_select "input#admin_journal_account_status[name=?]", "admin_journal_account[status]"

      assert_select "input#admin_journal_account_journal_id[name=?]", "admin_journal_account[journal_id]"

      assert_select "input#admin_journal_account_lock_version[name=?]", "admin_journal_account[lock_version]"
    end
  end
end