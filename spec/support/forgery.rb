class Forgery::Internet < Forgery
  def self.mac_address
    (1..6).map{"%0.2X"%rand(256)}.join(":")
  end
end