require 'rails_helper'

RSpec.describe "guest_transactions/index", type: :view do
  before(:each) do
    assign(:guest_transactions, [
      GuestTransaction.create!(),
      GuestTransaction.create!()
    ])
  end

  it "renders a list of guest_transactions" do
    render
  end
end
