require 'rails_helper'

RSpec.describe "guest_transactions/edit", type: :view do
  before(:each) do
    @guest_transaction = assign(:guest_transaction, GuestTransaction.create!())
  end

  it "renders the edit guest_transaction form" do
    render

    assert_select "form[action=?][method=?]", guest_transaction_path(@guest_transaction), "post" do
    end
  end
end
