$ ->
  arrayOfData = new Array([10.3, "Helice Agria", "#4876b9"], [15.2, "Kylie Edgecomb", "#9a1d1d"], [13.1, "Crystal Gasell", "#48a637"], [16.3, "Shaun Holland", "#0d82df"], [14.5, "Kar-On Lee", "#ff7300"], [22.0, "Rick Murch-Shafer", "#5a3764"], [8.6, "Gretchen Schaefer", "#3790e8"], [16.7, "Shelley Stewart", "#1a0edb"], [18, "Thomas Turano", "#33338b"], [15.8, "Deidre Tyler", "#394611"])
  $(".graph-container").jqBarGraph 
    data: arrayOfData
    legend: true
    legendWidth: 200
    sort: 'asc'
    width: '800px'
