class Product < ActiveRecord::Base
  belongs_to :publisher
  has_many :categorizations
  has_many :categories, through: :categorizations

  validates :price, presence: true
end
