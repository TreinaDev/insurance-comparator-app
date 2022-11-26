class ProductsController < ApplicationController
  def show
    id = params[:id]
    @products = Product.product_by_category(id)
    redirect_to root_path, alert: t(:unable_to_load_category_information) if @products.nil?
  end

  def search
    @query = params[:query]
    @products = Product.search(@query)
  end
end
