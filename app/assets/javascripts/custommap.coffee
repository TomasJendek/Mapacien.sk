class @Map
  constructor: ->

  $('#filter').bind('change paste keyup', (e) ->
    # if sorting is changed
    e.preventDefault()

    send_form()
  )

  $("#autocomplete").autocomplete(
    source: ->
      $(".gmap3").gmap3 getaddress:
        address: $(this).val()
        callback: (results) ->
          return  unless results
          $("#autocomplete").autocomplete "display", results, false
          return

      return

    cb:
      cast: (item) ->
        item.formatted_address

      select: (item) ->
        $(".gmap3").gmap3
          clear: "marker"
          marker:
            latLng: item.geometry.location

          map:
            options:
              center: item.geometry.location

        return
  ).focus()


  initialize_map: (lat, lon, zoom) ->
    $(".gmap3").gmap3 map:
      options:
        center: [
          lat
          lon
        ]
        zoom: zoom
        mapTypeId: google.maps.MapTypeId.ROADMAP
        mapTypeControl: true
        mapTypeControlOptions:
          style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        navigationControl: true
        scrollwheel: true
        streetViewControl: true

      events: # sets up the events of the actual map
        zoom_changed: ->
          map_bounds = getBounds $(this).gmap3("get")
          send_form($(this))
        dragend: ->
          map_bounds = getBounds $(this).gmap3("get")
          send_form($(this))

        idle: ->
          map_bounds = getBounds $(this).gmap3("get")
          send_form($(this))

          $('#area-range').slider change:(event, ui) ->
            map_bounds = getBounds $(".gmap3").gmap3("get")
            send_form($(this), map_bounds)


  getBounds = (map) ->
    map_bounds = map.getBounds()
    $('#bounds').val(map_bounds)


  send_form = ($container) ->
    valuesToSubmit = $('.filter_form').serialize()

    $.ajax({
      url: '/properties/show', # sumbits it to the given url of the form
      type: 'GET',
      data: valuesToSubmit,
      dataType: "JSON" # you want a difference between normal and ajax-calls, and json is standard
    }).success((input_data) ->
      #json_properties = JSON.parse(input_data.json_properties) # Property JSON objects

      $('.average-price').text(input_data['averagePrice']+" €")

      $('.average-price-m2').text(input_data['averagePriceM2']+" €")

      $('.num-of-properties').text(input_data['numOfProperties'])



      #$container.append(JST["filter/results"]({properties : json_properties}))

    )