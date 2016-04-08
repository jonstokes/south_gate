class Package
  include Virtus.model

  attribute :id, String
  attribute :name, String
  attribute :description, String
  attribute :charged_as, String
  attribute :price_cents, Integer
  attribute :duration_minutes, Integer
  attribute :limit_up, Integer
  attribute :limit_down, Integer
  attribute :limit_quota, Integer
  attribute :currency, String
end