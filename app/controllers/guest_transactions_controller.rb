class GuestTransactionsController < ApplicationController
  before_filter :redirect_authorized_guests

  # GET /guest
  def new
    # This just picks up the webhook, parses it, and shows
    # the actual splash page where plans are picked

    # From https://community.ubnt.com/t5/UniFi-Wireless/external-hotspot-portal/td-p/419845
    # /guest/?id=20:aa:4b:95:bc:9d&ap=00:27:22:e4:ce:79&t=1363610350&url=http://facebook.com/&ssid=Test%20SSID

    # For hidden fields
    @device_address = params[:id]
    @access_point_address = params[:ap]
    @url = params[:url]

    # Package selection
    @packages = FindPackagesForDeviceAddress.call(device_address: @device_address).packages

    # New guest transaction
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

  def redirect_authorized_guests
    if CheckGuestAuthorization.call(device_address: guest_transaction_params[:device_address]).success?
      redirect_to(guest_transaction_params[:url] || "http://www.summerfell.com/")
    end
  end

  def guest_transaction_params
    params.permit(
      :device_address,
      :access_point_address,
      :url,
      :first_name,
      :last_name,
      :cc_number,
      :cc_expiry_month,
      :cc_expiry_year,
      :city,
      :state,
      :zip,
      :security_code,
      :package_id
    )
  end
end