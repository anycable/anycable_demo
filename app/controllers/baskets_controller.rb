class BasketsController < ApplicationController
  before_action :set_basket, only: [:show, :destroy, :update]

  def index
    @baskets = Basket.all
  end

  def show
    gon.basket_id = @basket.id
    @products = @basket.products
  end

  def create
    @basket = Basket.create(basket_params.merge(owner: current_user))
    render_json @basket
  end

  def destroy
    @basket.destroy!
    render_json_message
  end

  private

  def basket_params
    params.require(:basket).permit(:name, :logo_path, :description)
  end

  def set_basket
    @basket = Basket.find(params[:id])
  end
end
