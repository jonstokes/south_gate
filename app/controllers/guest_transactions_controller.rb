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
    @url = redirect_url

    # Package selection
    @packages = FindPackagesForDeviceAddress.call(device_address: @device_address).packages

    # New guest transaction
    @guest_transaction = GuestTransaction.new
  end

  def show
    @guest_transaction = FindGuestTransaction.perform(id: params[:id])
  end

  def create
    authorize_guest = AuthorizeGuest.call(
      params: guest_transaction_params[:guest_transaction]
    )

    @guest_transaction = authorize_guest.guest_transaction

    respond_to do |format|
      if authorize_guest.success?
        format.html {
          redirect_to @guest_transaction
        }
      else
        format.html {
          # Package selection
          @packages = FindPackagesForDeviceAddress.call(device_address: @device_address).packages
          render :new
        }
      end
    end
  end

  private

  def redirect_authorized_guests
    if CheckGuestAuthorization.call(device_address: guest_transaction_params[:device_address]).success?
      redirect_to redirect_url
    end
  end

  def redirect_url
    return Figaro.env.app_host unless guest_transaction_params[:url] && URI.parse(guest_transaction_params[:url]).host
    guest_transaction_params[:url]
  rescue URI::InvalidURIError
    Figaro.env.app_host
  end

  def guest_transaction_params
    params.permit(
      :id,
      :ap,
      :url,
      guest_transaction: [
        :device_address,
        :access_point_address,
        :url,
        :first_name,
        :last_name,
        :email,
        :cc_number,
        :cc_expiry_month,
        :cc_expiry_year,
        :city,
        :state,
        :zip,
        :security_code,
        :package_id
      ]
    )
  end
end