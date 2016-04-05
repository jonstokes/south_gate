require 'spec_helper'

RSpec.describe "Guest Sign Up" do
  describe "Signing up a new guest" do
    it "shows all the packages available" do
      visit new_guest_transaction_path

    end

    it "lets a user select a package" do
    end
  end
end
