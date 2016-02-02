class FindPackagesForDeviceAddress
  include Troupe

  expects :device_address
  provides :packages
  
  provides :conn do
    Faraday.new(url: Figaro.env.app_host) do |faraday|
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  provides :response do
    raw = conn.get do |req|
      req.url "api/v1/packages/available", device_address: device_address
    end

    JSON.parse(raw.body)
  end

  def call
    package_list
  end
end