class SearchController < ApplicationController
  def near
    @listings = Listing.near([-0.166683, 51.473137], 100, :units => :km).limit(500)

    @count = @listings.count
    @location = [-0.167, 51.474]

  end

  def index

    unless params[:search]
      @search_params = {}
      @location = [-0.167, 51.474]
      @listings = Listing.where(:area.in => ['Battersea'])
      @agents = Agent.where(:area.in => ['Battersea'])

      render 'search/near'
      return
    end

    @search_params = params[:search]

    filter = {}

    type = params[:search][:type]
    size = params[:search][:size]
    min_price = params[:search][:min_price]
    max_price = params[:search][:max_price]
    lat = params[:search][:lat]
    lng = params[:search][:lng]
    radius = params[:search][:radius]
    created_at = params[:search][:created_at]

    if type and type.length > 0
      filter[:type] = type.downcase
    end

    if size and size.length > 0
      filter[:bedrooms] = Integer(size)
    end

    if min_price and min_price.length > 0
      filter[:price] = {'$gt' => (Integer(min_price.gsub(/\D/, '')) - 1)}
      filter[:price_period] = 'pw'
    end

    if max_price and max_price.length > 0
      filter_price = filter[:price] || {}
      filter_price['$lt'] = (Integer(max_price.gsub(/\D/, '')) + 1)
      filter[:price] = filter_price
      filter[:price_period] = 'pw'
    end

    if lat and lng and lat.length > 0 and lng.length > 0
      @location = [Float(lng), Float(lat)]
    else
      @location = [-0.167, 51.474]
    end

    if created_at and created_at.length > 0 and created_at != '0'
      filter[:created_at] = {'$gte' => Date.strptime(created_at, '%Y-%m-%d')}
    end

    query_radius = 4
    query_radius = Float(radius) * 0.25 if radius and radius.length > 0

    @listings = Listing.near(@location, query_radius, units: :km).where(filter).limit(500)

    render 'search/near'
  end
end
