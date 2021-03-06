class NeighbourhoodsController < ApplicationController
  before_action :set_neighbourhood, only: [:show, :update, :destroy]

  # GET /neighbourhoods
  def index
    @neighbourhoods = Neighbourhood.all

    if params[:max_home_price].present?
      @neighbourhoods = @neighbourhoods.where('home_price <= ?', params[:max_home_price])
    end

    if params[:min_home_price].present?
      @neighbourhoods = @neighbourhoods.where('home_price >= ?', params[:min_home_price])
    end

    if params[:ranked_by].present?
      # .to_sym converts a string to a symbol. For example, "a".to_sym becomes :a
      # :desc - descendant
      @neighbourhoods = @neighbourhoods.order(params[:ranked_by].to_sym => :desc)
    end

    if params[:near].present?
      # Unlike the queries we saw earlier, the line below overwrites
      # the @neighbourhoods variable. It will return only the nearest
      # neighbourhood, without combining with the other filters.
      @neighbourhoods = Location.nearest_neighbourhood(params[:near])
    end

    render json: @neighbourhoods
  end

  # GET /neighbourhoods/1
  def show
    render json: @neighbourhood
  end

  # POST /neighbourhoods
  def create
    @neighbourhood = Neighbourhood.new(neighbourhood_params)

    if @neighbourhood.save
      render json: @neighbourhood, status: :created, location: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /neighbourhoods/1
  def update
    if @neighbourhood.update(neighbourhood_params)
      render json: @neighbourhood
    else
      render json: @neighbourhood.errors, status: :unprocessable_entity
    end
  end

  # DELETE /neighbourhoods/1
  def destroy
    @neighbourhood.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighbourhood
      @neighbourhood = Neighbourhood.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def neighbourhood_params
      params.require(:neighbourhood).permit(:name, :num_businesses, :home_price)
    end
end
