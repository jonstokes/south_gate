require 'rails_helper'

RSpec.describe "guest_transactions/new", type: :view do
  before(:each) do
    assign(:guest_transaction, GuestTransaction.new())
  end

  it "renders new guest_transaction form" do
    render

    assert_select "form[action=?][method=?]", guest_transactions_path, "post" do
    end
  end
end
