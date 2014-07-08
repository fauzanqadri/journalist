require 'rails_helper'

RSpec.describe "journals/index", :type => :view do
  before(:each) do
    assign(:journals, [
      Journal.create!(
        :name => "Name",
        :driver => "Driver",
        :lock_version => 1,
        :online_accounts_count => 2,
        :offline_account_counts => 3
      ),
      Journal.create!(
        :name => "Name",
        :driver => "Driver",
        :lock_version => 1,
        :online_accounts_count => 2,
        :offline_account_counts => 3
      )
    ])
  end

  it "renders a list of journals" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Driver".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
