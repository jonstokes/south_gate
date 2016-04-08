class GuestTransaction
  include Virtus.model
  include ActiveModel::Model

  # Guest
  attribute :device_address
  attribute :access_point_address
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :url

  # Transaction
  attribute :cc_number
  attribute :cc_expiry_month
  attribute :cc_expiry_year
  attribute :city
  attribute :state
  attribute :zip
  attribute :security_code
  attribute :package_id

  # Validations
  validates :package_id,                presence: true, format: { with: /\A([0-9a-f]{4}-?){7}[0-9a-f]{4}\z/i, multiline: true }
  validates :device_address,            presence: true, format: { with: /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/, multiline: true }
  validates :access_point_address,      presence: true, format: { with: /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/, multiline: true }
  validates :url,                       format: { with: URI.regexp }, if: ->{ url.present? }
  validates :first_name, :last_name,    presence: true, if: ->{ package_id != Figaro.env.free_package_id }
  validates :cc_number, :security_code, presence: true, if: ->{ package_id != Figaro.env.free_package_id }
  validates :cc_expiry_month,           presence: true, if: ->{ package_id != Figaro.env.free_package_id }
  validates :cc_expiry_year,            presence: true, if: ->{ package_id != Figaro.env.free_package_id }
  validates :city, :state, :zip,        presence: true, if: ->{ package_id != Figaro.env.free_package_id }
  validates :state,                     inclusion: { in: CS.states(:us).values }, if: ->{ package_id != Figaro.env.free_package_id }

  validate :package_is_available?

  def save
    @guest = FindOrCreateGuest.call(guest_params).guest
    return false unless @guest.valid?
    @transaction_information = CreateTransactionInformation.call(transaction_params).transaction_information
    @transaction_information.valid?
  end

  def packages
    # Package selection
    @packages ||= FindPackagesForDeviceAddress.call(device_address: device_address).packages
  end

  def package_is_available?
    packages.map(&:id).include?(package_id)
  end

  def self.find(id)
    FindGuest.call(id: id).guest
  end
end