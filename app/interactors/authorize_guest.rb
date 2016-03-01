class AuthorizeGuest
  include :troupe

  expects :params

  provides(:guest_transaction) do
    GuestTransaction.new(params)
  end

  provides(:response) do
    Summerfell.post("/api/vi/guests.json", params)
  end

  def call
    context.fail! unless guest_transaction.valid?
    context.succeed! and return if resonse['status'] == 'success'

    response['errors'].each do |attribute, messages|
      guest_transaction.errors.add(attribute, messages.first)
    end
    context.fail!
  end
end