class FindPackagesForDeviceAddress
  include Troupe

  expects :device_address
  provides :packages

  provides(:response) do
    Summerfell.get("api/v1/packages/available.json", device_address: device_address)
  end

  def call
    context.fail! unless response['status'] == 'success'
    self.packages = response['packages'].map do |data|
      Package.new(data)
    end
  end
end