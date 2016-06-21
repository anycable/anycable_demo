class ProductsController < ApplicationController
  before_action :set_basket, only: [:create]

  def create
    product = @basket.products.create(product_params)
    render_json product
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy!
    render_json_message
  end

  private

  def product_params
    params.require(:product).permit(:name, :category)
  end

  def set_basket
    @basket = Basket.find(params[:basket_id])
  end
end
