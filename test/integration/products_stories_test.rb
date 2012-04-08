require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products 
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    order_data = { :name => "Dave Thomas",
                :address => "123 The Secret",
                :email => "dave@example.com",
                :pay_type => "Check"}
                
    user_goes_to_store_index_page
    select_a_product_adding_to_the_cart ruby_book
    check_out
    fill_order_form_with order_data
    order_is_saved order_data, ruby_book
    email_is_sent_to order_data[:email]
  end
end

def user_goes_to_store_index_page
  get "/"
  assert_response :success
  assert_template "index"
end

def select_a_product_adding_to_the_cart( product )
  xml_http_request :post, 'line_items', :product_id => product.id
  assert_response :success
  cart = Cart.find(session[:cart_id])
  assert_equal 1, cart.line_items.size
  assert_equal product, cart.line_items[0].product
end

def check_out
  get "/orders/new"
  assert_response :success
  assert_template "new"
end

def fill_order_form_with(order_data)
  post_via_redirect "/orders",
                    :order => order_data
                                
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size
end

def order_is_saved(order_data, product)
  orders = Order.all
  assert_equal 1, orders.size
  order = orders[0]
  
  assert_equal order_data[:name], order.name
  assert_equal order_data[:address], order.address
  assert_equal order_data[:email], order.email
  assert_equal order_data[:pay_type], order.pay_type
  
  assert_equal 1, order.line_items.size
  line_item = order.line_items[0]
  assert_equal product, line_item.product
end

def email_is_sent_to (email)
  mail = ActionMailer::Base.deliveries.last
  assert_equal [email], mail.to
end