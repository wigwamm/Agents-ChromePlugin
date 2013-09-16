class FiltersController < ApplicationController
  # GET /filters
  # GET /filters.json
  def index
    @filters = Filter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @filters }
    end
  end

  # GET /filters/1
  # GET /filters/1.json
  def show
    @filter = Filter.find(params[:id])

    @area = @filter.polygon

    if @filter.edited && (@filter.include_markers_for == 0 || @filter.include_markers_for == 1)
      #@listings = []
      #@listings = Listing.where(:area.in => @filter.areas)
      @listings = Listing.where(location: {
          '$geoWithin' => {
            '$geometry' => {
                type: 'Polygon',
                coordinates: [
                    @filter.polygon
                ]
            }
        }
      })
      @listings_agent_ids = []
      @listings.each do |listing|
        @listings_agent_ids.push listing.agent_id
      end
      @all_agents = Agent.where(:id.in => @listings_agent_ids)
    else
      @listings = []
    end

    if @filter.edited && (@filter.include_markers_for == 0 || @filter.include_markers_for == 2)
      @agents = Agent.where(location: {
          '$geoWithin' => {
              '$geometry' => {
                  type: 'Polygon',
                  coordinates: [
                      @filter.polygon
                  ]
              }
          }
      })
    else
      @agents = []
    end

    @location = [-0.167, 51.474]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @filter }
    end
  end

  # GET /filters/new
  # GET /filters/new.json
  def new
    @filter = Filter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @filter }
    end
  end

  # GET /filters/1/edit
  def edit
    @filter = Filter.find(params[:id])
  end

  def clone
    @filter = Filter.find(params[:id])
    @filter = @filter.clone
    @filter.save

    respond_to do |format|
      format.html { redirect_to edit_filter_url(@filter), notice: 'Filter was successfully cloned.' }
      format.json { render json: @filter }
    end
  end

  # POST /filters
  # POST /filters.json
  def create
    @filter = Filter.new(params[:filter])
    @area = Area.where(name: @filter.area).first
    @filter.polygon = @area.points

    @filter.name = "#{@area.name} Listings"

    respond_to do |format|
      if @filter.save
        format.html { redirect_to @filter, notice: 'Filter was successfully created.' }
        format.json { render json: @filter, status: :created, location: @filter }
      else
        format.html { render action: "new" }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /filters/1
  # PUT /filters/1.json
  def update
    @filter = Filter.find(params[:id])

    respond_to do |format|
      if @filter.update_attributes(params[:filter])
        format.html { redirect_to filters_url, notice: 'Filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  def polygon
    @filter = Filter.find(params[:id])
    polygon = []
    params[:polygon].each do |key, point|
      polygon.push point.map { |coordinate| Float(coordinate) }
    end
    @filter.polygon = polygon
    @filter.edited = true
    @filter.save

    respond_to do |format|
      if @filter.update_attributes(params[:filter])
        format.html { redirect_to filters_url, notice: 'Filter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.json
  def destroy
    @filter = Filter.find(params[:id])
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to filters_url }
      format.json { head :no_content }
    end
  end
end
