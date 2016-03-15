class CheckGuestAuthorization
  include Troupe

  expects :device_address

  provides(:response) do
    Summerfell.get("api/v1/guests/#{device_address}/authorize")
  end

  def call
    context.fail! unless response["status"] == "success"
  end
end