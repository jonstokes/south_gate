class GuestTransactionsController < ApplicationController
  # GET /guest
  def new
    # This just picks up the webhook, parses it, and shows
    # the actual splash page where plans are picked

    # From https://community.ubnt.com/t5/UniFi-Wireless/external-hotspot-portal/td-p/419845
    # /guest/?id=20:aa:4b:95:bc:9d&ap=00:27:22:e4:ce:79&t=1363610350&url=http://facebook.com/&ssid=Test%20SSID

    @device_address = params[:id]
    @access_point_address = params[:ap]
    @url = params[:url]

    @packages = FindPackagesForDeviceAddress.call(device_address: @device_address)

    # Fill in billing info, guest info, etc.
    @guest_transaction = GuestTransaction.new
  end

  def create
    authorize_guest = AuthorizeGuest.call(
      params: guest_transaction_params
    )

    @guest_transaction = authorize_guest.guest_transaction

    respond_to do |format|
      format.html do
        if authorize_guest.success?
          redirect_to authorize_guest.url
        else
          render :new
        end
      end
    end
  end

  private

  def guest_transaction_params
    params.permit(
      guest: [:device_address, :access_point_address, :url],
      transaction: [:first_name, :last_name, :cc_number, :city, :state, :zip, :security_code]
    )
  end

end