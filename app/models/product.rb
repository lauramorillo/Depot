class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title
  
  default_scope :order => 'title'
  
  validates :title, :description, :image_url, :presence => {
    :message  => 'is required'
  }
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :title, :length => {:minimum => 10}
  validates :image_url, :format => {
    :with     => %r{\.(gif|jpg|png)$}i,
    :message  => 'must be a URL fro GIF, JPG or PNG image.'
  }
end
