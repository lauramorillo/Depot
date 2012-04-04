class Order < ActiveRecord::Base
  attr_accessible :address, :email, :name, :pay_type, :ship_date
  
  has_many :line_items, :dependent => :destroy
  
  PAYMENT_TYPES = ["Check", "Credit Card", "Purchase order"]
  
  validates :address, :email, :name, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
