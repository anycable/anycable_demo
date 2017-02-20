class ProductsController < ApplicationController
  before_action :set_basket, only: [:create]

  def create
    @product = @basket.products.create(product_params)
    render_json @product
    broadcast_products_update(@basket)
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy!
    render_json_message
    broadcast_products_update(@product.basket)
  end

  private

  def channel_name
    "baskets/#{@product.basket_id}"
  end

  def product_params
    params.require(:product).permit(:name, :category)
  end

  def set_basket
    @basket = Basket.find(params[:basket_id])
  end

  def broadcast_products_update(basket)
    ActionCable.server.broadcast 'baskets', {
      type: 'products-update',
      data: {
        basket_id: basket.id,
        count: basket.products.count
      }
    }
  end
end
