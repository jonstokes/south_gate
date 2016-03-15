require 'spec_helper'

RSpec.describe "CheckGuestAuthorization" do

  let(:device_address) { "01-02-03-04-05-06" }

  describe "call" do
    it "returns true if the guest is authorized" do
      stub_request(:get, "www.summerfell.com/api/v1/guests/#{device_address}/authorize").to_return(
        body: { status: "success" }.to_json
      )

      interactor = CheckGuestAuthorization.call(device_address: device_address)
      expect(interactor.success?).to eq(true)
    end

    it "returns false if the guest is not authorized" do
      stub_request(:get, "www.summerfell.com/api/v1/guests/#{device_address}/authorize").to_return(
        body: { status: "failure" }.to_json
      )

      interactor = CheckGuestAuthorization.call(device_address: device_address)
      expect(interactor.failure?).to eq(true)
    end
  end
end
