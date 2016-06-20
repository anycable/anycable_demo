class BasketsController < ApplicationController
  def index
    @baskets = Basket.all
    @basket = Basket.new
  end

  def create
    @basket = Basket.new(basket_params.merge(owner: current_user))
    @basket.save
    render_json @basket
  end

  def destroy
    @basket = Basket.find(params[:id])
    @basket.destroy!
    render_json @basket
  end

  private

  def basket_params
    params.require(:basket).permit(:name, :logo_path, :description)
  end
end
