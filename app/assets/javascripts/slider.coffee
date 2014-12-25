class Slider
  make_slider: (div_id, min_value, max_value, lvalue = min_value, rvalue = max_value) ->
    me = @
    min_value = parseFloat(min_value)
    max_value = parseFloat(max_value)
    step
    min
    max

    if (div_id == "area")
      step = 1
      rounder = 1
      min = Math.round((me.propose_min(min_value,max_value)/8)*rounder)/rounder
      max = Math.round((max_value + (max_value - min_value)/8)*rounder)/rounder
    else if (div_id == "totalValue")
      step = 1
      rounder = 1
      min = Math.round((me.propose_min(min_value,max_value)/8)/rounder)*rounder
      max = Math.round((max_value + (max_value - min_value)/8)/rounder)*rounder

    $("#"+div_id+"-range").slider({
      range: true,
    #min: 1 * min_value,
      min: min,
    #max: 1 * max_value,
      max: max,
      step: step,
      values: [lvalue, rvalue],
      slide: (event, ui) ->
        $("#"+div_id).val(ui.values[ 0 ] + " - " + ui.values[ 1 ])
        if (div_id == "area")
          $("#"+div_id+"-out").html("rozloha od "+me.addCommas(me.zeroIfMin(ui.values[ 0 ], min)) + " m<sup>2</sup> do: " + me.addCommas(me.infinityIfMax(ui.values[ 1 ], max))+" m<sup>2</sup>")
        else if (div_id == "totalValue")
          $("#"+div_id+"-out").text("Cena od "+me.addCommas(me.zeroIfMin(ui.values[ 0 ], min)) + " € do: " + me.addCommas(me.infinityIfMax(ui.values[ 1 ], max))+" €")
    })
    if (div_id == "area")
      $("#"+div_id+"-out").html("rozloha od "+me.addCommas($("#"+div_id+"-range").slider("values", 0)) + " m<sup>2</sup> do: " + me.addCommas($("#"+div_id+"-range").slider("values", 1))+" m<sup>2</sup>")
    else if (div_id == "totalValue")
      $("#"+div_id+"-out").text("Cena od "+me.addCommas($("#"+div_id+"-range").slider("values", 0)) + " € do: " + me.addCommas($("#"+div_id+"-range").slider("values", 1))+" €")

    $("#"+div_id).val($("#"+div_id+"-range").slider("values", 0) + " - " + $("#"+div_id+"-range").slider("values", 1))

  addCommas: (str) ->
    amount = str.toString().split(".")
    after_point = amount[1]
    amount = amount[0].split("").reverse()
    output = ""
    for i in [0...amount.length]
      output = amount[i] + output
      if ((i+1) % 3 == 0 && amount.length-1 > i)
        output = ',' + output

    if (after_point != undefined)
      output = output+"."+ after_point

    output

  propose_min: (min_value, max_value)->
    if (min_value - (max_value - min_value)) > 0 then (min_value - (max_value - min_value)) else 0

  zeroIfMin: (str,min) ->
    if str == min
      0
    else
      str

  infinityIfMax: (str,max) ->
    if str == max
      "∞" # ♥ ♦ ♣ ♠ len sa mi pacili tieto znaky :)
    else
      str

#    #override for filter save state of interval
#    make_slider_save_state: (div_id, min_value, max_value, lvalue = min_value, rvalue = max_value) ->
#        me = @
#        min_value = parseFloat(min_value)
#        max_value = parseFloat(max_value)
#        step
#        min
#        max
#
#        if (div_id == "area")
#          step = 1
#          rounder = 1
#          min = Math.round((me.propose_min(min_value,max_value)/8)*rounder)/rounder
#          max = Math.round((max_value + (max_value - min_value)/8)*rounder)/rounder
#        else if (div_id == "totalValue")
#          step = 100
#          rounder = 100
#          min = Math.round((me.propose_min(min_value,max_value)/8)/rounder)*rounder
#          max = Math.round((max_value + (max_value - min_value)/8)/rounder)*rounder
#
#        $("#"+div_id+"-range").slider({
#            range: true,
#            #min: 1 * min_value,
#            min: min,
#            #max: 1 * max_value,
#            max: max,
#            step: stepx,
#            values: [lvalue, rvalue],
#            slide: (event, ui) ->
#                $("#"+div_id).val(ui.values[ 0 ] + " - " + ui.values[ 1 ])
#                if (div_id == "area")
#                    $("#"+div_id+"-out").text("rozloha od "+ui.values[ 0 ] + " m2 do: " + ui.values[ 1 ]+" m2")
#                else if (div_id == "totalValue")
#                    $("#"+div_id+"-out").text("cena od "+me.addCommas(ui.values[ 0 ]) + " € do: " + me.addCommas(ui.values[ 1 ])+" €")
#        })
#        if (div_id == "area")
#            $("#"+div_id+"-out").text("rozloha od "+$("#"+div_id+"-range").slider("values", 0) + " m2 do: " + $("#"+div_id+"-range").slider("values", 1)+"m2")
#        else if (div_id == "totalValue")
#            $("#"+div_id+"-out").text("cena od "+me.addCommas($("#"+div_id+"-range").slider("values", 0)) + " € do: " + me.addCommas($("#"+div_id+"-range").slider("values", 1))+" €")
#
#        $("#"+div_id).val($("#"+div_id+"-range").slider("values", 0) + " - " + $("#"+div_id+"-range").slider("values", 1))


window.Slider = Slider
