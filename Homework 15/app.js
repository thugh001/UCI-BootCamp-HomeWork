var svgWidth = 1200;
var svgHeight = 600;

var margin = { top: 20, right: 40, bottom: 60, left: 100 };

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

// Create an SVG wrapper, append an SVG group that will hold our chart, and shift the latter by left and top margins.
var svg = d3.select(".chart")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var chart = svg.append("g");

// Append a div to the body to create tooltips, assign it a class
d3.select(".chart")
  .append("div")
  .attr("class", "tooltip")
  .style("opacity", 0);

// import data.csv 
d3.csv("data.csv", function(error, Data) {
  if (error) throw error;

  actualData.forEach(function(actualData) {
      data.total_HH_FS =+ data.total_HH_FS;
      data.med_income =+ data.med_income;
      data.state_abbr = data.state_abbr
      data.state = data.state
  });

    // Create scale functions
  var yLinearScale = d3.scaleLinear()
  .range([height, 0]);

  var xLinearScale = d3.scaleLinear()
  .range([0, width]);

  // Create axis functions
  var bottomAxis = d3.axisBottom(xLinearScale);
  var leftAxis = d3.axisLeft(yLinearScale);

  // Scale the domain
  xLinearScale.domain([(d3.min(actualData, function(data) {
    return + data.total_HH_FS-1;
  })), (d3.max(actualData, function(data){
      return + data.total_HH_FS+1}))]);

  yLinearScale.domain([(d3.min(actualData, function(data) {
    return +data.med_income-1;
  })), (d3.max(actualData, function(data){
      return +data.med_income+1}))]);
  
  // create the tool tip that will pop up when circle is moused over
  var toolTip = d3.tip()
      .attr("class", "tooltip")
      .offset([80, -60])
      .html(function(data) {
      var state = data.state;
      var med_income = +data.med_income;
      var foodstamp = + data.total_HH_FS;
      return ("<b>"+state +"</b>" + "<br> Median Income in 2014: " + med_income + "%<br> Receive Foodstamps: " + foodstamp +"%");
      });
  
  chart.call(toolTip);
  
  //create and append circles to graph
  chart.selectAll("circle")
    .data(actualData)
    .enter().append("circle")
      .attr("cx", function(data, index) {
        return xLinearScale(data.total_HH_FS);
      })
      .attr("cy", function(data, index) {
        return yLinearScale(data.med_income);
      })
      .attr("r", "15")
      .attr("fill", "lightblue")
      .style("opacity", .75)
      .attr("stroke", "black")
      .on("mouseover", function(data) {
        toolTip.show(data);
        toolTip.style("display", null);
      })
      // onmouseout event
      .on("mouseout", function(data, index) {
        toolTip.hide(data);
        toolTip.style("display", "none");
      })

  chart.selectAll("g")
    .data(actualData)
    .enter()
    .append("text")
    .attr("dx", function(data, index){
      return xLinearScale(data.total_HH_FS)-11.5
    })
    .attr("dy", function(data){
      return yLinearScale(data.med_income)+4
    })
    .text(function (data, index){
      return data.abbr;
    });
  // call x axis
  chart.append("g")
    .attr("transform", `translate(0, ${height})`)
    .call(bottomAxis);

  //call y axis
  chart.append("g")
      .call(leftAxis);
  
  // Append y-axis labels
  chart.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left + 40)
    .attr("x", 0 - (height / 2))
    .attr("dy", "1em")
    .attr("class", "axisText")
    .text("Median Income in 2014+");

  // Append x-axis labels
  chart.append("text")
    .attr("transform", "translate(" + (width / 2) + " ," + (height + margin.top + 30) + ")")
    .attr("class", "axisText")
    .text("Total Number of Households Receiving Foodstamps");
  
  chart.append("text")
    .attr("transform","translate(" +(width/2)+"," + (0)+")")
    .attr("class","axisText")
    .text("Foodstamps and Median Income")
    
});