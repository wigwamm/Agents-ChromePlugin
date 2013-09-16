class StatisticsController < ApplicationController

  def average

    def median(array)
      len = array.length
      (array[(len - 1) / 2] + array[len / 2]) / 2.0
    end

    def find_quartiles(array)
      array = array.sort

      first_half = []
      second_half = []

      median_value = median(array)
      array.each do |val|

        first_half.push val if val <= median_value
        second_half.push val if val >= median_value

      end

      return median(first_half), median_value, median(second_half)
    end

    @average_sums = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @average_prices = [[], [], [], [], [], [], [], [], [], [], []]
    @average_counts = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @quartiles = []
    @averages = []

    Listing.where(area: params[:area]).each do |listing|
      next if not listing.price or listing.price_period == 'pa'

      i = listing.bedrooms
      price = listing.price_period == 'pcm' ? listing.price : listing.price * 52 / 12

      @average_counts[i] += 1
      @average_sums[i] += price
      @average_prices[i].push price

    end

    @average_sums.each_with_index do |sum, i|
      count = @average_counts[i]

      if count > 0
        q = find_quartiles(@average_prices[i]) if count > 0
        k = 1.2

        min = q[0] - k * (q[2] - q[0])
        max = q[2] + k * (q[2] - q[0])

        @quartiles[i] = [min, q[1], max]

        new_sum = 0
        new_count = 0
        @average_prices[i].each do |price|
          if min <= price  && price <= max
            new_sum += price
            new_count += 1
          end
        end

        @averages[i] = new_count != 0 ? new_sum / new_count : -1

      else
        @averages[i] = -1

      end

    end

    puts @averages
  end

end
