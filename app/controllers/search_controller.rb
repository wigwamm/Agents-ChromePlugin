class SearchController < ApplicationController
  def near
    @listings = FullListing.near([-0.166683, 51.473137], 100, :units => :km).limit(250)

    @count = @listings.count

  end

  def index

    filter = {}

    type = params[:search][:type]
    size = params[:search][:size]
    min_price = params[:search][:min_price]
    max_price = params[:search][:max_price]

    if type and type.length > 0
      filter[:type] = type.downcase
    end

    if size and size.length > 0
      filter[:bedrooms] = Integer(size)
    end

    if min_price and min_price.length > 0
      filter[:price] = {'$gt' => (Integer(min_price.gsub(/\D/, '')) - 1)}
    end

    if max_price and max_price.length > 0
      filter_price = filter[:price] || {}
      filter_price['$lt'] = (Integer(max_price.gsub(/\D/, '')) + 1)
      filter[:price] = filter_price
    end

    @listings = FullListing.where(filter).limit(250)

    render 'search/near'
  end
end
