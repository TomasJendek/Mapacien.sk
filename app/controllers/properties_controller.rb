class PropertiesController < ApplicationController

  def index
    puts params

  end

  def show
    puts params

    sw_lat, sw_lon, ne_lat, ne_lon = getBounds(params)

    @result = Property.country("sk")
    @result = @result.boundaries(sw_lat, ne_lat, sw_lon, ne_lon)
    @result = @result.category(params[:property_category])
    @result = @result.type(params[:property_type])
    @result = @result.state_type(params[:state_type])             unless params[:state_type].empty?
    @result = @result.num_of_room(params[:num_of_rooms])         unless params[:num_of_rooms].empty?

    @result = PropertiesController.filter_interval(@result, :properties, :area, params[:area])  unless params[:area].empty?

    puts @result.inspect
    puts @result.count


    if @result.size > 0
      @price    = @result.average(:price).round        unless @result.nil?
      @price_m2 = @result.average(:price_m2).round     unless @result.nil?
    else
      @price = 0
      @price_m2 = 0
    end

    puts @price
    respond_to do |format|
      format.html
      format.json { render json: {
                               averagePrice:       @price,
                               averagePriceM2:     @price_m2,
                               numOfProperties:    @result.count,
                           } }
    end
  end


  #helpers

  def getBounds(params)
    bounds = params[:bounds]
    bounds_array = bounds.gsub('(', '').gsub(')', '').split(',')
    bounds_array = bounds_array.collect{|i| i.to_f}

    sw_lat = bounds_array[0]
    sw_lon = bounds_array[1]

    ne_lat = bounds_array[2]
    ne_lon = bounds_array[3]

    return sw_lat, sw_lon, ne_lat, ne_lon
  end

  def self.filter_interval(result, model, attribute, value)
    if !value.nil? && !value.empty?
      value = value.split(" - ")
      if (value[0] != model.to_s.classify.constantize.minimum(attribute.to_sym).to_s) || !(value[1] == model.to_s.classify.constantize.maximum(attribute.to_sym).to_s)
        result = result.where(model.to_sym => {attribute.to_sym => (value[0].. value[1])})
      end
    end
    result
  end
  
end
