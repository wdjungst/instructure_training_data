$ ->
  arrayOfData = []
  colors = ['#FF3300', '#FF6633', '#33FF33', '#0000CC', '#00CCCC', '#9966CC', '#003300', '#FF9933', '#660033', '#669900', '#33CC33', '#CC0000', '#66FF66', '#3399FF', '#660066', '#99FFFF', '#99FF33', '#FF6666', '#00CC99', '#FFFF99'] 
  all_users = ''

  getName = (name) ->
    alert name

  populate_data = (users, id) ->
    arrayOfData = []
    array = users.split '~'
    $userDropdown = $(id)
    $userDropdown.empty()
    for el, index in array
      a = el.split(',')
      name = a[1]
      $userDropdown.append("<li><a onclick='getName(this.value)' value='#{name}' href='#'>#{name}</a></li>") if typeof(name) != "undefined"
      number = parseFloat(a[0])
      temp = []
      temp.push(number)
      temp.push(a[1])
      temp.push(colors[index])
      arrayOfData.push(temp)
    arrayOfData.pop()
    $(".graph-container").empty()
    $(".graph-container").jqBarGraph 
      data: arrayOfData
      legend: true
      legendWidth: 200
      sort: 'asc'
      width: '900px'

  weeks = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
  
  weekClickHandler = (week) ->
    $("#week#{week}").bind 'click', (e) ->
      $('.graph-container').empty()
      e.preventDefault()
      $.get "/week/#{week}", (data) ->
        populate_data(data, '#user_dropdown')

   listItems = ['0', '1']
   listItemClickHandler = (listItem) ->
     $("#listItem#{listItem}").bind 'click', (e) ->
       alert('click')
  
  plot = $.jqplot("chartdiv", [[1,0,3,9,4,6,6,8]],
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
        label: "Posts"
        min: 0
    
    highlighter:
      show: true
      tooltipAxes: 'y'
      sizeAdjust: 7.5
  )
  usersClickHandler = () ->
    $('#modal-btn').bind 'click', (e) ->
      $('#users-modal').modal('show')
 
  usersClickHandler()
  weekClickHandler(week) for week in weeks

  getEventTarget = (e) ->
    e = e or window.event
    e.target or e.srcElement

  ul = document.getElementById("user_dropdown")
  ul.onClick = (event) ->
    target = getEventTarget(event)
    alert target.innerHTML

  $('#users-modal').on "shown", ->
    plot.replot()
    populate_data(all_users, '#modal_dropdown')

  $.get "/all_posts", (response) ->
    all_users = response
    populate_data(response, '#user_dropdown')

