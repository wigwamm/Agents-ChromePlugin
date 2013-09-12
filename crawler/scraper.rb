require 'bunny'
require 'open-uri'
require 'nokogiri'
require 'mongoid'
require './thread-pool'

class Scraper

  # Use this flag to disable multi-threading and process 1 item at a time
  @debug = false

  attr_accessor :debug

  def initialize(queue_name)
    init_mongoid

    # Setup RabbitMQ queue
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    @channel.prefetch(10)
    @queue = @channel.queue(queue_name)

    # Initialize thread pool, may want to experiment with count
    @pool = Pool.new(10)

    @crawled_counter = 0
  end

  def run
    puts 'Subscribed to queue...'
    @queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, url|

      # If we're debugging, only run once and don't use thread pool
      if @debug
        self.scrape_url(url)
        delivery_info.consumer.cancel
      else
        @pool.schedule do
          begin
            self.scrape_url(url)

          rescue e
            puts 'Exception'
            puts e
          end
          @channel.ack(delivery_info.delivery_tag)
        end
      end

    end
  end

  def scrape_url(url)
    puts "Trying to scrape #{url}"
    scrape(url, Nokogiri::HTML(open(url)))
  end

  def scrape(url, document)
    # Implement your scraping logic here
    puts 'Scraping document'
  end

  def init_mongoid
    require File.expand_path(File.dirname(__FILE__) + '/../app/models/listing')
    require File.expand_path(File.dirname(__FILE__) + '/../app/models/agent')
    Mongoid.load!('../config/mongoid.yml', :crawl)
  end

  def finish
    @pool.shutdown
    @connection.close
  end

end