require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "total price return the sum of all items in the cart" do
    cart = carts(:one)
    lineItem = cart.line_items.build(:product_id => products(:one).id, :quantity => 1, :price => 10.00)
    lineItem2 = cart.line_items.build(:product_id => products(:two).id, :quantity => 1, :price => 10.00)
    assert_equal lineItem.total_price + lineItem2.total_price, cart.total_price
  end
  
  def new_cart_with_one_product(product_name)
    cart = Cart.create
    cart.add_product(products(product_name).id)
    cart
  end

  test 'cart should create a new line item when adding a new product' do
    cart = new_cart_with_one_product(:one)
    assert_equal 1, cart.line_items.length

    cart.add_product(products(:ruby).id)
    assert_equal 2, cart.line_items.length
  end

  test 'cart should update an existing line item when adding an existing product' do
    cart = new_cart_with_one_product(:one)

    cart.add_product(products(:one).id)
    assert_equal 1, cart.line_items.length
  end
end
