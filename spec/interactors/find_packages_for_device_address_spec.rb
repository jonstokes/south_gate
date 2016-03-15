require 'spec_helper'

RSpec.describe "FindPackagesForDeviceAddress" do

  let(:device_address) { "01:02:03:04:05:06" }
  let(:package) {
    Package.new(
      name: "Package",
      description: "Desc",
      charged_as: "summerfell.com",
      price_cents: 1000,
      duration_minutes: 1000,
      limit_up: 10,
      limit_down: 10,
      limit_quota: nil,
      currency: "USD"
    )
  }


  describe "call" do
    it "returns a list of the packages available for a device address" do
      stub_request(:get, "www.summerfell.com/api/v1/packages/available.json?device_address=#{device_address}").to_return(
        body: {
          status: "success",
          packages: [package.to_hash]
        }.to_json
      )

      interactor = FindPackagesForDeviceAddress.call(device_address: device_address)
      expect(interactor.success?).to eq(true)

      pkg = interactor.packages.first
      expect(pkg).to be_a(Package)
      expect(pkg.to_hash).to eq(package.to_hash)
    end
  end
end
