class RestaurantsController < ApplicationController
  def index
    @restaurants = viewable_restaurants
  end

  def show
    @restaurant = Restaurant.find_by(slug:params[:slug])
    redirect_to categories_path(@restaurant)
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.create!(restaurant_params)
    Role.create!(restaurant: @restaurant, user: current_user, level: "admin")
    render :restaurant_confirmation
  end

  def update
    @restaurant = Restaurant.find(params[:id])

    if params[:status]
      @restaurant.status = params[:status]
    end

    if params[:display]
      @restaurant.display = params[:display]
    end

    @restaurant.save
    UserMailer.approved_confirmation("denvergschool@gmail.com").deliver
    # UserMailer.approved_confirmation(@user).deliver
    redirect_to root_path
  end

  private
    def restaurant_params
      params.require(:restaurant).permit(:name, :description, :status)
    end
end
