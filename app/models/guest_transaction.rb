class GuestTransaction
  include Virtus.model
  include ActiveModel::Model

  attribute :device_address
  attribute :access_point_address
  attribute :url
  attribute :first_name
  attribute :last_name
  attribute :cc_number
  attribute :city
  attribute :state
  attribute :zip
  attribute :security_code
  attribute :package_id

  validates :package_id,                format: { with: /\A([0-9a-f]{4}-?){7}[0-9a-f]{4}\z/i }
  validates :device_address,            format: { with: /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/ }
  validates :access_point_address,      format: { with: /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/ }
  validates :url,                       format: { with: URI.regexp }
  validates :first_name, :last_name,    presence: true
  validates :cc_number, :security_code, presence: true
  validates :city, :state, :zip,        presence: true
  validates :state,                     inclusion: { in: CS.states(:us).values }
end