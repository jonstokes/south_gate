require 'spec_helper'

RSpec.describe "Guest Sign Up" do

  let(:initial_guest_params) {{
    id: Forgery(:internet).mac_address,
    ap: Forgery(:internet).mac_address,
    url: "http://example.com/"
  }}

  let(:free_package) {{
    id: Figaro.env.free_package_id,
    name: "Free Package",
    description: "A package",
    charged_as: "SUMMERFELL LLC",
    price_cents: 0,
    duration_minutes: 100,
    limit_up: 100,
    limit_down: 100,
    limit_quota: 100,
    currency: "USD"
  }}

  let(:paid_package) {{
    id: SecureRandom.uuid,
    name: "Paid Package",
    description: "A package",
    charged_as: "SUMMERFELL LLC",
    price_cents: 100,
    duration_minutes: 200,
    limit_up: 200,
    limit_down: 200,
    limit_quota: 200,
    currency: "USD"
  }}

  let(:packages) { [free_package, paid_package] }

  let(:summerfell_response) {{
    status: "success",
    packages: packages
  }}

  describe "Admitting an existing guest" do
    before do
      stub_request(:get, "http://www.summerfell.com/api/v1/guests/authorize").
         to_return(status: 200, body: { status: "success" }.to_json, headers: {})
    end

    it "redirects to a given url" do
    end

    it "redirects to APP_HOST if no url is given" do
    end
  end

  describe "Signing up a new guest" do
    before do
      stub_request(:get, "http://www.summerfell.com/api/v1/guests/authorize").
        to_return(status: 200, body: { status: "failure" }.to_json, headers: {})

      stub_request(:get, "http://www.summerfell.com/api/v1/packages/available.json?device_address=#{initial_guest_params[:id]}").
        to_return(:status => 200, :body => summerfell_response.to_json, :headers => {})
    end

    it "shows all the packages available" do
      visit new_guest_transaction_path(initial_guest_params)

      expect(page.body).to include(free_package[:id])
      expect(page.body).to include(free_package[:name])

      expect(page.body).to include(paid_package[:id])
      expect(page.body).to include(paid_package[:name])
    end

    it "lets a user sign up for the free package" do
      visit new_guest_transaction_path(initial_guest_params)

      choose free_package.name
      click_on "Submit"

      # Expect to show thank you page
    end

    it "lets a user sign up for the paid package" do
      visit new_guest_transaction_path(initial_guest_params)

      choose paid_package.name
      click_on "Submit"

      # Expect to show thank you page
    end

    it "redirects to a url if one was given" do
    end

    it "redirects to APP_HOST if none was given" do
    end

    describe "errors" do
      it "shows credit card authorization errors" do
      end

      it "shows missing field errors" do
      end

      it "shows a generic 'call support' error" do
      end
    end
  end

  describe "trial package" do
    it "shows the trial package option to a user that has never signed up" do
      # Brand new user
    end

    it "shows the trial package option to an existing user that has never used a freebie" do
      # User's paid package has timed out, but they've never used a freebie.
    end

    it "does not show the trial package to a user who has used their entire trial package" do
    end

    it "shows the user the trial package again if that user's time is not up" do
      # Existing user has signed up for the trial package, but their time isn't up
    end

    it "does not show the trial package to a user who has used all their free time" do
    end

    it "does not let a user that has timed out a trial package sign up for the trial package again by manipulating the url" do
      # Redirect to GuestTransactions#new and
      # show an error message saying what time you signed up for the trial package,
      # and what time it is now, and that you're over the limit.
    end
  end
end
