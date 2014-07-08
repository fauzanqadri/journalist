require 'rails_helper'

RSpec.describe "journals/new", :type => :view do
  before(:each) do
    assign(:journal, Journal.new(
      :name => "MyString",
      :driver => "MyString",
      :lock_version => 1,
      :online_accounts_count => 1,
      :offline_account_counts => 1
    ))
  end

  it "renders new journal form" do
    render

    assert_select "form[action=?][method=?]", journals_path, "post" do

      assert_select "input#journal_name[name=?]", "journal[name]"

      assert_select "input#journal_driver[name=?]", "journal[driver]"

      assert_select "input#journal_lock_version[name=?]", "journal[lock_version]"

      assert_select "input#journal_online_accounts_count[name=?]", "journal[online_accounts_count]"

      assert_select "input#journal_offline_account_counts[name=?]", "journal[offline_account_counts]"
    end
  end
end
