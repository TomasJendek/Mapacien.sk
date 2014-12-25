# encoding: utf-8

require 'nokogiri'
require 'open-uri'

#todo mestska cast
#todo address_number

# rails runner 'TrhParser.parseProperty("","")'
# rails runner 'TrhParser.parseList'

class TrhParser

  # Parse basic filter for house / flat
  def self.parse(start, stop)
    #number of pages to parse
    starting_page = start.to_i
    pages_to_parse = stop.to_i

    for page in starting_page..starting_page+pages_to_parse

      advertising_type = 1 # predaj =1 , prenajom = 2
      category = 1  # flat = 1, house = 2
     for cat in 1..2
       for ad in 1..2
         for room in 1..5
           for state in 1..5
             puts state.to_s+room.to_s
             parsePage(page.to_s, state, room, ad, cat)
           end
         end
       end
     end



    end
  end


  def self.parsePage(page, state, rooms, advertising_type, category)
    if state != 4
      advertising_type = advertising_type.to_s
      # Parse pages for flat type or house type
      "typeId=2&advertisingTypeId=1&order=1&priceType=3&categories%5B0%5D=2&state=1&page=1"
      base_url = "http://www.trh.sk/vyhladavanie.html?"
      state_params = "&state="+state.to_s
      order = "&order=1"

      if rooms == 1
        rooms_params = "&categories%5B0%5D=1"
      else
        rooms_params = "&categories%5B0%5D="+(rooms+1).to_s
      end


      category_params = "typeId="+category.to_s
      type_params = "&advertisingTypeId="+advertising_type.to_s

      general_params = "&fromTitle=1&countries=0"
      page_params = "&page="+page.to_s

      #puts base_url+category_params+type_params+order+rooms_params+state_params+page_params

      dom = initParser(base_url+category_params+type_params+order+rooms_params+state_params+page_params)


      #if type == "flat"
      #  dom = initParser("http://www.trh.sk/vyhladavanie.html?typeId=1&advertisingTypeId=1&order=1&priceType=3&page="+page)
      #elsif type == "house"
      #  dom = initParser("http://www.trh.sk/vyhladavanie.html?typeId=2&advertisingTypeId=1&order=1&priceType=3&page="+page)
      #else
      #  puts "mame aj dalsie typy, dorob elsif :) (tato kategoria sa volala: '#{category}')"
      #  padni!
      #end

      # All adverts from page
      adverts = dom.css('.advert')
      adverts.each do |advert|
        link = advert.css('.description').css('h2').css('a')[0]['href']
        parseAdvert("http://www.trh.sk" + link, '', category, state, rooms, advertising_type)

      end
    end
  end


  def self.parseAdvert( url, id, category, state, rooms, advertising_type )
    dom = initParser(url)

    prop = Property.where(:original_url => url)
    #puts prop.inspect+"======================="
    if prop.size > 0
      puts "exist"
      return
    end


    right_column = dom.css('.right') # details

    @attr_name = right_column.css('h1').text.to_s.strip # property name

    main_description = right_column.css('.mainDescription.clearfix')

    main_description_left = main_description.css('.left') # price, area
    span_price = main_description_left.css('span.price')
    @attr_price = span_price.css('.number').text.gsub(/\s/,"").delete(" ") # price
    @attr_area = main_description_left.css('dl dd.area').text.to_s.split('m')[0].gsub(/\s/,"").delete(" ") # area

    main_description_right = main_description.css('.right') # locality, actualized
    location = main_description_right.css('.location')
                                    #@attr_region = location.css('.township').text.strip if !location.css('.township').nil?

    @attr_city = location.css('.city').text.strip  if !location.css('.city').nil?
    @attr_street = location.css('.street').text.strip if !location.css('.street').nil?


    # ====================================== Property save =================================


    # 0 predaj
    # 1 prenajom

    adv_type = advertising_type.to_i-1
    prop_category = category.to_i-1

    if state == 5
      state = 0
    end

    if state == 2 || state == 3
      state = 2
    end

    @attr_price = @attr_price.tr('^0-9', '').to_i
    @attr_area  = @attr_area.tr('^0-9', '').to_i

    if @attr_price.to_i != 0
      # GPS coordinates getter
      coord = getLatLong(1, (!@attr_street.nil? ? @attr_street : ""), nil, @attr_city, "Slovakia")

      if !coord.nil? && coord[0] != 'error'
        @latitude = coord[0]
        @longitude = coord[1]
      end

      if !@attr_street.nil? && !@latitude.nil?
        price_m2 = @attr_price.to_i / @attr_area.to_i
        puts url
        puts @attr_price

        puts @attr_price
        puts "==="
        p = Property.new(:country=> 0 ,:price_m2 => price_m2, :original_url => url, :area => @attr_area, :state_type => state, :num_of_room => rooms-1, :latitude => @latitude, :longitude => @longitude, :property_type => adv_type, :price => @attr_price, :property_category => prop_category)
        puts p.inspect
        p.save
        puts "property saved"
      else
        puts "locality not found"
      end
    end


  end

  # Loads dom object for exact property
  def self.initParser(url)
    begin
      doc = Nokogiri::HTML(open(url))
      doc.encoding = 'utf-8'

      #puts 'URL: '+url.to_s+'>>> was opened succesfully!'
      return doc
    rescue
      puts "It's unable to parse ."+url.to_s
      return
    end
  end

  def self.getLatLong(numb, street, city_part, city, state)
    city = "Bratislava" if city.include? 'Bratislava'
    city = "Košice" if city.include? 'Košice'

    query = ''
    query << "#{street}+" if !street.nil?
    query << "#{numb}+" if !numb.nil?
    query << "#{city_part}+" if !city_part.nil?
    query << "#{city}+" if !city.nil?
    query << "#{state}" if !state.nil?

    url = "http://maps.google.com/maps/api/geocode/json?address=#{query}&sensor=false"
    puts url
    Rails.logger.info "urlka #{url}"
    escaped=URI.escape(url)
    resp = Net::HTTP.get_response(URI.parse(escaped))
    data = resp.body
    result = ActiveSupport::JSON.decode(data)
    out = Array.new
    result['results'].each do |doc|
      if !doc['geometry'].nil?
        doc['geometry'].each do |geo|
          out.push(geo[1]['lat']) if !geo[1]['lat'].nil?
          out.push(geo[1]['lng']) if !geo[1]['lng'].nil?
        end
      else
        out.push('error')
      end
    end

    if result.has_key? 'Error'
      raise "web service error"
    end
    #puts out
    return out
  end
end