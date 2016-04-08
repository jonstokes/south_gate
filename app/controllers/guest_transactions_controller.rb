class GuestTransactionsController < ApplicationController
  def new
    # New guest transaction
    @guest_transaction = GuestTransaction.new(guest_transaction_params)
  end

  def show
    @guest_transaction = GuestTransaction.find(guest_transaction_params[:id])
  end

  def create
    @guest_transaction = GuestTransaction.new(guest_transaction_params)

    respond_to do |format|
      if @guest_transaction.save
        format.html { redirect_to @guest_transaction }
      else
        format.html { render :new }
      end
    end
  end

  private

  def guest_transaction_params
    params.permit(
      :id,
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
    )
  end
end