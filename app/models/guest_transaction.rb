class GuestTransaction
  include Virtus.model
  include ActiveModel::Model

  attribute :device_address
  attribute :access_point_address
  attribute :url
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :cc_number
  attribute :cc_expiry_month
  attribute :cc_expiry_year
  attribute :city
  attribute :state
  attribute :zip
  attribute :security_code
  attribute :package_id

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
end