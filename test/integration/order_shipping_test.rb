require 'test_helper'

class OrderShippingTest < ActionDispatch::IntegrationTest
  fixtures :orders
  
  test "the truth" do
    order = orders(:one)
    admin_login
    admin_goes_to_orders_list
    admin_ships order
    an_email_is_sent_to order.email
  end
  
  def admin_login
    password = "my_password"
    user = User.new(:name => "user", :password => password, :password_confirmation => password)
    assert user.save
    post "/login", :name => user.name, :password => password
    assert_redirected_to "/admin?locale=en"
  end
  
  def admin_goes_to_orders_list
    get "/orders"
    assert_response :success
    assert_template "index"
  end
  
  def admin_ships(order)
    post_via_redirect "/orders/#{order.id}/ship", :order => order
    assert_response :success
  end
  
  def an_email_is_sent_to(email)
    mail = ActionMailer::Base.deliveries.last
    assert_equal [email], mail.to
  end
end
