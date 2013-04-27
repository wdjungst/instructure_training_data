$ ->
  arrayOfData = []
  colors = ['#FF3300', '#FF6633', '#33FF33', '#0000CC', '#00CCCC', '#9966CC', '#FFFF00', '#FF9933', '#003300', '#3399FF', '#33CC33', '#CC0000', '#66FF66', '#3399FF', '#660066', '#99FFFF', '#99FF33', '#FF6666', '#00CC99', '#FFFF99'] 
  all_users = ''
  graphData = []
  
  graphInfo = (userInfo) ->
    graphData = []
    for el in userInfo
      number = parseInt(el)
      graphData.push(number)
    
    plot = $.jqplot("chartdiv", [graphData],
      title: "Summary"
      axesDefaults:
        labelRenderer: $.jqplot.CanvasAxisLabelRenderer
        tickRenderer: $.jqplot.CanvasAxisTickRenderer
        tickOptions:
          angle: -30
          fotSize: '10pt'
          mark: 'cross'
      axes:
        xaxis:
          renderer: $.jqplot.CategoryAxisRenderer
          ticks: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Week 7', 'Week 8']
          pad: 0
        yaxis:
          tickInterval: 1
          tickOptions:
            formatString: '%d'
          label: "Suggestions"
          min: 0
      highlighter:
        show: true
        tooltipAxes: 'y'
        sizeAdjust: 7.5)
    plot.replot()

  listItemClickHandler = ->
    $("[id^='list_item']").bind 'click', (e) ->
      name = $(@).text()
      $('#user-label').text(name)
      $.get "/user_info/" + name, (data) ->
        graphInfo(data.split(","))

  populate_data = (users, id) ->
    arrayOfData = []
    array = users.split '~'
    $userDropdown = $(id)
    $userDropdown.empty()
    for el, index in array
      a = el.split(',')
      name = a[1]
      $userDropdown.append("<li><a href='#' id='list_item_#{index}'>#{name}</a></li>") if typeof(name) != "undefined"
      number = parseFloat(a[0])
      temp = []
      temp.push(number)
      temp.push(a[1])
      temp.push(colors[index])
      arrayOfData.push(temp)
    arrayOfData.pop()
    listItemClickHandler()
    $(".graph-container").empty()
    $(".graph-container").jqBarGraph 
      data: arrayOfData
      legend: true
      legendWidth: 200
      sort: 'desc'
      width: '900px'
    
  weeks = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
  
  weekClickHandler = (week) ->
    $("#week#{week}").bind 'click', (e) ->
      $('.graph-container').empty()
      e.preventDefault()
      $.get "/week/#{week}", (data) ->
        populate_data(data, '#user_dropdown')
  
  usersClickHandler = () ->
    $('#modal-btn').bind 'click', (e) ->
      $('#users-modal').modal('show')
 
  usersClickHandler()
  weekClickHandler(week) for week in weeks
 
  $('#users-modal').on "shown", ->
    populate_data(all_users, '#modal_dropdown')
 
  $.get "/all_posts", (response) ->
    all_users = response
    populate_data(response, '#user_dropdown')


