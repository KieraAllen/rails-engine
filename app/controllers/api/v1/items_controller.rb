class Api::V1::ItemsController < ApplicationController

  def index
    render json: {data: Item.all}
  end

  def show
    render json: {data: Item.find(params[:id])}
  end

  def create
    render json: {data: Item.create(item_params)}
  end

  def update
    render json: {data: Item.update(params[:id], item_params)}
  end

  def destroy
    render json: {data: Item.delete(params[:id])}
  end

  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end
