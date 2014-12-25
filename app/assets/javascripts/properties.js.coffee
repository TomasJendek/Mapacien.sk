# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require application
#= require gmap3.min
#= require custommap
#= require slider


$ = jQuery

$ ->
  # Code for map
  lat = 48.12; lon =17.12; zoom = 10

  #make slider
  slider = new Slider()
  slider.make_slider("area",1, 200)

  map = new Map()
  map.initialize_map(lat, lon, zoom)



  # Clearing autocomplete imput
  $('#autocomplete').click ->
    $(this).val ""


  

