class GuestsController < ApplicationController
  before_filter :redirect_authorized_guests

  # GET /guest
  def guest
    # This just picks up the webhook, parses it, and shows
    # the actual splash page where plans are picked

    # From https://community.ubnt.com/t5/UniFi-Wireless/external-hotspot-portal/td-p/419845
    # /guest/?id=20:aa:4b:95:bc:9d&ap=00:27:22:e4:ce:79&t=1363610350&url=http://facebook.com/&ssid=Test%20SSID

    redirect_to new_guest_transaction_path(
      device_address: guest_params[:id],
      access_point_address: guest_params[:ap],
      url: redirect_url
    )
  end

  private

  def guest_params
    params.permit(:id, :ap, :url)
  end

  def redirect_authorized_guests
    if CheckGuestAuthorization.call(device_address: guest_params[:ap]).success?
      redirect_to redirect_url
    end
  end

  def redirect_url
    return Figaro.env.app_host unless guest_params[:url] && URI.parse(guest_params[:url]).host
    guest_params[:url]
  rescue URI::InvalidURIError
    Figaro.env.app_host
  end
end