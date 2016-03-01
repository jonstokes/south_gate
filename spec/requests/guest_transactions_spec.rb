require 'rails_helper'

RSpec.describe "GuestTransactions", type: :request do
  describe "GET /guest_transactions" do
    it "works! (now write some real specs)" do
      get guest_transactions_path
      expect(response).to have_http_status(200)
    end
  end
end
