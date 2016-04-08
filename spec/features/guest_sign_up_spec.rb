require 'spec_helper'

RSpec.describe "Guest Sign Up" do

  let(:initial_guest_params) {{
    id: Forgery(:internet).mac_address,
    ap: Forgery(:internet).mac_address,
    url: "http://example.com/"
  }}

  let(:packages) {{
    status: "success",
    packages: [
      {
        id: SecureRandom.uuid,
        name: "Package 1",
        description: "A package",
        charged_as: "SUMMERFELL LLC",
        duration_minutes: 100,
        limit_up: 100,
        limit_down: 100,
        limit_quota: 100,
        currency: "USD"
      }
    ]
  }}

  describe "Signing up a new guest" do
    before do
      stub_request(:get, "http://www.summerfell.com/api/v1/guests/authorize").
        to_return(status: 200, body: { status: "failure" }.to_json, headers: {})

      stub_request(:get, "http://www.summerfell.com/api/v1/packages/available.json?device_address=#{initial_guest_params[:id]}").
        to_return(:status => 200, :body => packages.to_json, :headers => {})
    end

    it "shows all the packages available" do
      visit new_guest_transaction_path(initial_guest_params)

    end

    it "lets a user select a package" do
    end
  end

  describe "Admitting an existing guest" do
    before do
      stub_request(:get, "http://www.summerfell.com/api/v1/guests/authorize").
         to_return(status: 200, body: { status: "success" }.to_json, headers: {})
    end

    it "redirects to a given url" do
    end

    it "redirects to summerfell.com if no url is given" do
    end
  end
end
