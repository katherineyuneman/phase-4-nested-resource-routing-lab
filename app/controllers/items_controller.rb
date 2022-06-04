class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user, status: 201
  end

  def show
    user = User.find(params[:user_id])
    item = user.items.find(params[:id])
    render json: item, include: :user
  end

  def create
    user = User.find(params[:user_id])
    new_item = user.items.create!(item_params)
    render json: new_item, include: :user, status: :created
  end

  private
  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "#{self} not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

end
