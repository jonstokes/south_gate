require 'rails_helper'

RSpec.describe "guest_transactions/show", type: :view do
  before(:each) do
    @guest_transaction = assign(:guest_transaction, GuestTransaction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
