angular_app.directive('pkVisualize', ->
  restrict: 'E'
  replace: false
  scope:
    times: "=timeData"
    enableInput: "&inputToggle"
  link: (scope, element, attrs, controller) ->

    width = 500px
    height = 200px
    padding = 30px

    vis = {}
    elements_up = {}
    elements_bottom = {}
    axis = {}

    keys = []
    times = []
    pauses = []



    upper_times = {}
    bottom_times = {}


    start = 0
    stop = 0

    start_delay = stop/2

    x = []

    max_y = 0

    y = {}

    counter = 1

    waitForEnd = (t) ->
      if counter == keys.length
        scope.enableInput()
        counter := 1
      else
        counter := counter + 1;

    scope.$watch("times", (o,n)->
      return if o == n
      times := []
      pauses := []

      keys := scope.times.keys
      times := scope.times.times
      pauses := scope.times.pauses

      if keys.length == 0 or pauses.length == 0
        return


      upper_times := [time: time, idx: idx for time,idx in times when idx % 2 == 0]
      bottom_times := [time: time, idx: idx for time,idx in times when idx % 2 != 0]


      start := 0
      stop := (times ++ pauses).reduce (+)

      start_delay := stop/2

      x := d3.scale.linear().range([0,width-2*padding]).domain [start,stop]

      max_y := Math.ceil(Math.max(...times) / 10 ) * 10

      y := d3.scale.linear()
        .range([height - 2*padding,0])
        .domain [2*max_y, 0]

      counter := 1
      draw()
    ,true)

      


    calculateOffset = (idx) ->
      if idx == 0
        return 0
      s_times = times.slice(0,idx)
      s_pauses = pauses.slice(0,idx)
      (s_times ++ s_pauses).reduce (+)


    init = !->
      vis := d3.select(element[0])
        .append \svg
        .attr \width  width
        .attr \height height

      elements_bottom := vis.append \g
        .attr \class \elements_bottom

      axis := vis.append \g
        .attr \class \axis

      elements_up := vis.append \g
        .attr \class \elements_up

      vis.append \defs
        .append \marker
        .attr \id \BlockArrow
        .attr \refX 1
        .attr \refY 15
        .attr \viewBox "0 0 30 30"
        .attr \orient \auto
        .attr \markerWidth 3
        .attr \markerHeight 3
        .attr \markerUnits \strokeWidth
        .append \path
          .attr \d "M 0 20 L 10 20 L 10 30 L 30 15 L 10 0 L 10 10 L 0 10 z"



    draw = !->
      drawLine()
      drawRectangles()
      drawTexts()

    drawLine = ->

      axis.selectAll('line').data([stop])
        .enter()
        .append \line
        .attr \class "arrow"
        .attr \x1 padding - 20 
        .attr \x2 padding - 20
        .attr \y1 y(max_y) + padding
        .attr \y2 y(max_y) + padding
        .attr \transform "skewX(30), translate(-50,0)"
        .transition()
        .duration(start_delay * 0.8)
        .attr \x2 width - padding + 10

      axis.selectAll('text').data([stop])
        .transition()
        .duration(1500)
        .tween("text", ->
          i = d3.interpolate(@textContent, stop + " ms")
          return (t) -> 
            @textContent = (Math.round parseInt i(t)) + " ms"
        )
        .attr \y, ->
          if keys.length % 2
            y(max_y) + padding + 20
          else
            y(max_y) - padding + 50
      axis.selectAll('text').data([stop])
        .enter()
        .append \text
        .text ->
          0 + " ms"
        .attr \class "arrow"
        .attr \x padding
        .attr \y, ->
          if keys.length % 2
            y(max_y) + padding + 20
          else
            y(max_y) - padding + 50
        .transition()
        .duration(start_delay * 0.8)
        .attr \x width - padding + 20
        .tween("text", ->
          i = d3.interpolate(@textContent, stop + " ms")
          return (t) -> 
            @textContent = (Math.round parseInt i(t)) + " ms"
        )

    drawRectangles = ->
        elements_up.selectAll \rect
          .data upper_times
          .transition()
          .duration (1500)
          .attr \x, (d) ->
            padding + (x calculateOffset d.idx)
          .attr \width, (d) -> x times[d.idx]
          .attr(\y, (d) -> padding + y(max_y) - y times[d.idx])
          .attr \height, (d) -> y times[d.idx]
          .each("end", waitForEnd)

        elements_up.selectAll \rect
          .data upper_times
          .enter()
          .append \rect
          .attr \rx 2
          .attr \ry 2
          .attr \x, (d) ->
            padding + (x calculateOffset d.idx)
          .attr \width, (d) -> x times[d.idx]
          .attr(\y, padding + y(max_y))
          .attr \height, 0
          .transition()
          .duration (d) -> 2*times[d.idx]
          .delay (d) -> start_delay + 2*calculateOffset d.idx
          .attr(\y, (d) -> padding + y(max_y) - y times[d.idx])
          .attr \height, (d) -> y times[d.idx]
          .each("end",waitForEnd)

        elements_up.selectAll \rect
          .data upper_times
          .exit()
          .attr \opacity 1
          .transition()
          .attr \opacity 0
          .remove()

        elements_bottom.selectAll \rect
          .data bottom_times
          .transition()
          .duration (1500)
          .attr \x, (d) ->
            padding + (x calculateOffset d.idx)
          .attr \width, (d) -> x times[d.idx]
          .attr(\y, (d) -> padding + y(max_y))
          .attr \height, (d) ->  y times[d.idx]
          .each("end",waitForEnd)

        elements_bottom.selectAll \rect
          .data bottom_times
          .enter()
          .append \rect
          .attr \rx 2
          .attr \ry 2
          .attr \x, (d) ->
            padding + (x calculateOffset d.idx)
          .attr \width, (d) -> x times[d.idx]
          .attr(\y, padding + y(max_y))
          .attr \height, 0
          .transition()
          .duration (d) -> 2*times[d.idx]
          .delay (d) -> start_delay + 2*calculateOffset d.idx
          .attr(\y, (d) -> padding + y(max_y))
          .attr \height, (d) ->  y times[d.idx]
          .each("end",waitForEnd)

        elements_bottom.selectAll \rect
          .data bottom_times
          .exit()
          .attr \opacity 1
          .transition()
          .attr \opacity 0
          .remove()

          
    drawTexts = !->
      elements_up.selectAll \text
        .data times
        .transition()
        .duration(1500)
        .text (d,i) -> "#{keys[i].toUpperCase()}:#d ms"
        .attr \x, (d,i) ->
          padding + (x calculateOffset i) + 0.5 * x times[i]
        .attr \y, (d,i) ->
              if i % 2 != 0
                padding + y(max_y) + y times[i] + 20
              else
                padding + y(max_y) - y times[i] + 20
        .tween("text", (d,idx,a) ->
          key = keys[idx].toUpperCase()
          old_time = parseInt @textContent.split(":")[1]
          time = times[idx]
          i = d3.interpolateRound(old_time,  time)
          return (t) -> 
            @textContent = "#key:#{i(t)} ms"
        )

      elements_up.selectAll \text
        .data times
        .enter()
        .append \text
        .text (d,i) -> "#{keys[i].toUpperCase()}:#d ms"
        .attr \opacity 0
        .attr \class, (d,i) ->
          if i % 2 != 0
            "text_bar_even text_bar"
          else
            "text_bar_odd text_bar"
        .attr \x, (d,i) ->
          padding + (x calculateOffset i) + 0.5 * x times[i]
        .attr \y, (d,i) ->
              if i % 2 != 0
                padding + y(max_y) + y times[i] + 20
              else
                padding + y(max_y) - y times[i] + 20
        .transition()
        .duration(800)
        .delay (d,i) ->
          [start_delay, 2*calculateOffset i, 2*times[i]].reduce (+)
        .attr \opacity 1

      elements_up.selectAll \text
        .data times
        .exit()
        .attr \opacity 1
        .transition()
        .attr \opacity 0
        .remove()

    init()
)
