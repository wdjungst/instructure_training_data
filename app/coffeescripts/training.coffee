$ ->
  arrayOfData = []
  colors = ['#FF3300', '#FF6633', '#33FF33', '#0000CC', '#00CCCC', '#9966CC', '#003300', '#FF9933', '#660033', '#669900', '#33CC33', '#CC0000', '#66FF66', '#3399FF', '#660066', '#99FFFF', '#99FF33', '#FF6666', '#00CC99', '#FFFF99'] 
  
  populate_data = (users) ->
    arrayOfData = []
    array = users.split '~'
    for el, index in array
      a = el.split(',')
      number = parseFloat(a[0])
      temp = []
      temp.push(number)
      temp.push(a[1])
      temp.push(colors[index])
      arrayOfData.push(temp)
    arrayOfData.pop()
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
        populate_data(data)
  
  weekClickHandler(week) for week in weeks
  
  $.get "/all_posts", (response) ->
    populate_data(response)

  
