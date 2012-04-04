require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "order_received" do
    order = orders(:one)
    mail = Notifier.order_received(order)
    assert_equal [order.email], mail.to
  end

  test "order_shipped" do
    order = orders(:one)
    mail = Notifier.order_shipped(order)
    assert_equal [order.email], mail.to
  end

end
