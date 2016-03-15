require 'spec_helper'

RSpec.describe "AuthorizeGuest" do

  let(:device_address) { "01:02:03:04:05:06" }
  let(:params) {
    {
      package_id: Figaro.env.free_package_id!,
      device_address: device_address,
      access_point_address: device_address,
      url: "http://foo.com/"
    }
  }

  describe "call" do
    it "succeeds if the guest_transaction is valid and response status is success" do
      stub_request(:post, "www.summerfell.com/api/v1/guests.json").to_return(
        body: { status: "success" }.to_json
      )

      interactor = AuthorizeGuest.call(params: params)
      expect(interactor.success?).to eq(true)
    end

    it "fails if the guest_transaction is invalid" do
      interactor = AuthorizeGuest.call(params: params.merge(package_id: SecureRandom.uuid))
      expect(interactor.failure?).to eq(true)
    end

    it "fails if the guest_transaction is valid and response status is failure" do
      stub_request(:post, "www.summerfell.com/api/v1/guests.json").to_return(
        body: {
          status: "failure",
          errors: {
            cc_number: ["is invalid"]
          }
        }.to_json
      )

      interactor = AuthorizeGuest.call(params: params)
      expect(interactor.failure?).to eq(true)
      expect(interactor.guest_transaction.errors).to be_a(ActiveModel::Errors)
    end

  end
end
