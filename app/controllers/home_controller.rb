class HomeController < ApplicationController
  def index
    @product_categories = Product.all_categories
  end
end
