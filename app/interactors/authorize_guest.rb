class AuthorizeGuest
  include Troupe

  expects :params

  provides(:guest_transaction) do
    GuestTransaction.new(params)
  end

  provides(:response) do
    Summerfell.post("/api/v1/guests.json", params)
  end

  def call
    context.fail! unless guest_transaction.valid?
    return if response['status'] == 'success'

    response['errors'].each do |attribute, messages|
      guest_transaction.errors.add(attribute, messages.first)
    end
    context.fail!
  end
end