require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  test "total price return the sum of all items from same type" do
    lineItemWithQuantity3 = LineItem.new(:product_id => products(:one).id, :cart_id => carts(:one).id, :quantity => 3, :price => 10.00)
    assert_equal 30, lineItemWithQuantity3.total_price
  end
end
