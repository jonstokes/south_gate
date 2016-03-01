json.array!(@guest_transactions) do |guest_transaction|
  json.extract! guest_transaction, :id
  json.url guest_transaction_url(guest_transaction, format: :json)
end
