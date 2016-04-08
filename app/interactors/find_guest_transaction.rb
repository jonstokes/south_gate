class FindGuestTransaction
  include Troupe

  expects :id

  provides(:response) do
    Summerfell.get("api/v1/transactions/show.json", id: self.id)
  end

  provides :guest_transaction

  def perform
    context.fail! unless response['status'] == 'success'
    self.guest_transaction = GuestTransaction.new(response['guest_transaction'])
  end
end