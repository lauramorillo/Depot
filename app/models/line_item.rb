class LineItem < ActiveRecord::Base
  attr_accessible :cart_id, :product_id, :quantity, :price
  
  belongs_to :product
  belongs_to :cart
  belongs_to :order
  
  def total_price
    price * quantity
  end
end
