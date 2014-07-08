require 'rails_helper'

RSpec.describe "Journals", :type => :request do
  describe "GET /journals" do
    it "works! (now write some real specs)" do
      get journals_path
      expect(response.status).to be(200)
    end
  end
end
