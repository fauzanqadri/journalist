require 'rails_helper'

RSpec.describe "journals/show", :type => :view do
  before(:each) do
    @journal = assign(:journal, Journal.create!(
      :name => "Name",
      :driver => "Driver",
      :lock_version => 1,
      :online_accounts_count => 2,
      :offline_account_counts => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Driver/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
