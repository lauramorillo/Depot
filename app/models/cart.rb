class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  
  def add_product(product_id)
    logger.info "Adding #{product_id} to cart"
    current_item = line_items.where(:product_id => product_id).first
    logger.info "current_item with value #{current_item}"
    if current_item
      current_item.quantity += 1
    else
      product = Product.find(product_id)
      current_item=line_items.build(:product_id => product_id,:price => product.price)
      current_item.save
    end
    current_item
  end
  
  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end
end
