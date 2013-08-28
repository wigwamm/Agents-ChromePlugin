class ListingsController < ApplicationController
  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing = Listing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @listing }
    end
  end

  # GET /listings/new
  # GET /listings/new.json
  def new
    @listing = Listing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @listing }
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = Listing.find(params[:id])
  end

  def create_id
    @listing = Listing.where(ids: params[:id]).first_or_create
    unless @listing.marked_unavailable_by.include? params[:user_id]
      @listing.marked_unavailable_by.push params[:user_id]
      @listing.availability_score += 1
    end

    unless @listing.ids.kind_of?(Array)
      @listing.ids = [params[:id]]
    end

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render json: @listing, status: :created, location: @listing }
      else
        format.html { render action: "new" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_id
    @listing = Listing.where(ids: params[:id])
    if @listing.count > 0
      @listing = @listing.first

      if @listing.marked_unavailable_by.include? params[:user_id]
        @listing.marked_unavailable_by.delete(params[:user_id])
      end

      unless @listing.marked_available_by.include? params[:user_id]
        @listing.marked_available_by.push(params[:user_id])
        @listing.availability_score -= 1
      end

      @listing.save
    end

    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(params[:listing])
    @listing.urls.append params[:url]

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render json: @listing, status: :created, location: @listing }
      else
        format.html { render action: "new" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /listings/1
  # PUT /listings/1.json
  def update
    @listing = Listing.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end

  def search
    @listings = Listing.where('$or' => [
      # Search for listings that are marked unavailable by more than 2 people
      {:ids.in => params[:listing_ids], :availability_score.gt => 1},
      # Search for ads that are marked unavailable by you
      {:ids.in => params[:listing_ids], :marked_unavailable_by => params[:user_id]}
    ])

    respond_to do |format|
      format.html { render 'listings/index' }
      format.json { render json: @listings }
    end
  end
end
