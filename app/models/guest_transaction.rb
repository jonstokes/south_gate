class GuestTransaction
  include Virtus.model

  class Guest
    include Virtus.model
    attribute :device_address
    attribute :access_point_address
    attribute :url
  end

  class Transaction
    include Virtus.model
    attribute :first_name
    attribute :last_name
    attribute :cc_number
    attribute :city
    attribute :state
    attribute :zip
    attribute :security_code
  end

  attribute :guest, GuestTransaction::Guest
  attribute :transaction, GuestTransaction::Transaction
end