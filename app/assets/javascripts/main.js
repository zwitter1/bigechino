var currentPos = null;
var page =''
var taxon = null;
var description = null;
var readD = null;
var go = null;	

$(document).ready(function(){
	$("#loader-wrapper").hide()
	//$("#buttonSet").hide(); 
	$(".spinner").hide()
	$("#downloader").hide();
	
	
	//var halfHeight = $(window).height()/2
	//$('#display').layout({south__size: halfHeight});
	
	$("#allDesc").click(function(){	
		currentPos = 0; 
		$.ajax({
			url:'desc',
			type:'GET',
			success:function(data){
				$("#buttonSet").show(); 
				show = $.parseHTML(data);
				$("#tableHolder").html(show);
				//currentPos = currentPos + Number($("#count").val()); 
			}
		});
	});
	
	$("#holes").click(function(){
		$(".spinner").show()
		$.ajax({
			url: 'holes',
			type:'GET',
			success:function(data){
				$(".spinner").hide() 
				show = $.parseHTML(data);
				$("#tableHolder").html(show);
			}
		});

	});
	
	
	$("#showwindow").click(function(){
		$("#hider").show();
		$("#infowindow").show()//.css({"width": "80%", "height": "80%", "top": "10%", "left":"10%"});
		
		/*$("#hider").addClass('fadeIn animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass('fadeInUp animated');
			});*/
		
		$("#infowindow").addClass('fadeIn animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass('fadeInUp animated');
			});
	});
	
	$("#closeinfo").click(function(){
		$("#hider").hide();
		$("#infowindow").hide();
	});
	
	$("#allSeq").click(function(){
		$(".spinner").show()
		currentPos = 0;
		page = "sequence"
		$.ajax({
			url: 'seq',
			type:'GET',
			success:function(data){
				$(".spinner").hide() 
				show = $.parseHTML(data);
				$("#tableHolder").html(show);
				//currentPos = currentPos + Number($("#count").val());
			}
		});
	});
	
	$("#previous").click(function(){
		if (currentPos == null){
			$("#buttonSet").addClass('shake animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass();
			});
			return;
		}
		
		var data = "";
		if(page == 'search'){
			taxclass = $("#classIn").val();
			taxon = $("#taxonIn").val();
			readSD = $("#readstartIn").val();
			readED = $("#readendIn").val();
			go = $("#goIn").val();
			desc = $("#descIn").val();	
			
			gocheck = $("#inclGo")[0].checked;
			
			if (taxon == "None"){
				taxon = ""
			}
			
			if (taxclass == "None"){
				taxclass = ""
			}
			
			data = [taxclass, taxon,readSD,readED, go, desc,desc];
			}	
			if (currentPos > 0){	
				if($("#count").val() != ""){		
					currentPos = currentPos - Number($("#count").val()); 
					}
				else{
					currentPos = currentPos - 10 
				}
			}
		
		$.ajax({
			url: 'prev',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data, 'count': $("#count").val()},
			success: function(data){
				show = $.parseHTML(data.html);
				//$("#tableHolder").scrollTop(0);
				//console.log($("#tableHolder").offset());
				//console.log($("table").offset());
				$('#tableDisp').animate({
					scrollTop: 0//$("#tableHolder").offset().top -20
				},500);
				//$("#tableHolder").scrollTop(0);
				
				$("#tableHolder").html(show);
				
				if (data.godata.length > 0){
					setupTreemap(data.godata);
				}
			}
		});
	});
	
	
	$("#next").click(function(){
		if(currentPos == null){
			$("#buttonSet").addClass('shake animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass();
			});
			return;
		}
		var data = "";
		if(page == 'search')
			taxclass = $("#classIn").val();
			taxon = $("#taxonIn").val();
			readSD = $("#readstartIn").val();
			readED = $("#readendIn").val();
			go = $("#goIn").val();
			desc = $("#descIn").val();	
			
			gocheck = $("#inclGo")[0].checked;
			
			if (taxon == "None"){
				taxon = ""
			}
			
			if (taxclass == "None"){
				taxclass = ""
			}
			
			data = [taxclass, taxon,readSD,readED, go, desc,desc];
		if($("#count").val() != ""){		
			currentPos = currentPos + Number($("#count").val()); 
		}
		else{
			currentPos = currentPos + 10 
		}	
		
		$.ajax({
			url: 'next',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data, 'count': $("#count").val(), "go":gocheck},
			success: function(data){
				show = $.parseHTML(data.html);
				//$("#tableHolder").scrollTop(0);
				//console.log($("#tableHolder").offset());
				//console.log($("table").offset());
				$('#tableDisp').animate({
					scrollTop: 0//$("#tableHolder").offset().top -20
				},500);
				//$("#tableHolder").scrollTop(0);
				
				$("#tableHolder").html(show);
					
				if (data.godata.length > 0){
					setupTreemap(data.godata);
				}
			}
		});
	});
	
	$("#runSearch").click(function(){
		taxclass = $("#classIn").val();
		taxon = $("#taxonIn").val();
		readSD = $("#readstartIn").val();
		readED = $("#readendIn").val();
		go = $("#goIn").val();
		desc = $("#descIn").val();	
		page = "search"
		
		gocheck = $("#inclGo")[0].checked;
		
		if (gocheck == false){
			go = ""	
		}	
			
		checkval = $("input[name='querytype']:checked").val();
		
		if (taxon == "None"){
			taxon = ""
		}
		if (taxclass == "None"){
			taxclass = ""
		}
		
		currentPos = 0;
		$(".spinner").show()
		$(".spinner").addClass('fadeInUp animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass().addClass('spinner');
			});
		
		var data= [taxclass, taxon,readSD,readED, go, desc,desc]		
		$.ajax({
			url: 'eval',
			type: 'GET',
			data: {"data": data , "count": $("#count").val(),"checked":checkval,"go":gocheck},
			success:function(retData){
				
				if(retData.file == 0){
					$(".spinner").hide()
					show = $.parseHTML(retData.html);
					$("#tableHolder").html(show);
					//currentPos = currentPos + Number($("#count").val());
				}
				else{
					$(".spinner").hide()
					$("#downloader")[0].click();
				}
				
				
				if (retData.godata.length > 0){
					setupTreemap(retData.godata);
				}
				
			}
		});
	});
	
	// The setupTreempa function handles all of the d3 calculations for the treemap visualization
	function setupTreemap(injson){
		$("#vizholder").empty();
		
		var margin = {top: 20, right: 0, bottom: 0, left: 0},
	    width = $("#vizholder").width(),
	    height = $("#vizholder").height() - margin.top - margin.bottom,
	    formatNumber = d3.format(",d"),
	    transitioning;

		var x = d3.scale.linear()
		    .domain([0, width])
		    .range([0, width]);
		
		var y = d3.scale.linear()
		    .domain([0, height])
		    .range([0, height]);
		
		var treemap = d3.layout.treemap()
		    .children(function(d, depth) { return depth ? null : d._children; })
		    .sort(function(a, b) { return a.value - b.value; })
		    .ratio(height / width * 0.5 * (1 + Math.sqrt(5)))
		    .round(false);
		
		var svg = d3.select("#vizholder").append("svg")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.bottom + margin.top)
		    .style("margin-left", -margin.left + "px")
		    .style("margin.right", -margin.right + "px")
		  .append("g")
		    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
		    .style("shape-rendering", "crispEdges");
		
		var grandparent = svg.append("g")
		    .attr("class", "grandparent");
		
		grandparent.append("rect")
		    .attr("y", -margin.top)
		    .attr("width", width)
		    .attr("height", margin.top);
		
		grandparent.append("text")
		    .attr("x", 6)
		    .attr("y", 6 - margin.top)
		    .attr("dy", ".75em");
		
		d3.json("go.json", function(root) {
		  initialize(root);
		  accumulate(root);
		  layout(root);
		  display(root);
		
		  function initialize(root) {
		    root.x = root.y = 0;
		    root.dx = width;
		    root.dy = height;
		    root.depth = 0;
		  }
		
		  // Aggregate the values for internal nodes. This is normally done by the
		  // treemap layout, but not here because of our custom implementation.
		  // We also take a snapshot of the original children (_children) to avoid
		  // the children being overwritten when when layout is computed.
		  function accumulate(d) {
		    return (d._children = d.children)
		        ? d.value = d.children.reduce(function(p, v) { return p + accumulate(v); }, 0)
		        : d.value;
		  }
		
		  // Compute the treemap layout recursively such that each group of siblings
		  // uses the same size (1×1) rather than the dimensions of the parent cell.
		  // This optimizes the layout for the current zoom state. Note that a wrapper
		  // object is created for the parent node for each group of siblings so that
		  // the parent’s dimensions are not discarded as we recurse. Since each group
		  // of sibling was laid out in 1×1, we must rescale to fit using absolute
		  // coordinates. This lets us use a viewport to zoom.
		  function layout(d) {
		    if (d._children) {
		      treemap.nodes({_children: d._children});
		      d._children.forEach(function(c) {
		        c.x = d.x + c.x * d.dx;
		        c.y = d.y + c.y * d.dy;
		        c.dx *= d.dx;
		        c.dy *= d.dy;
		        c.parent = d;
		        layout(c);
		      });
		    }
		  }
		
		  function display(d) {
		    grandparent
		        .datum(d.parent)
		        .on("click", transition)
		      .select("text")
		        .text(name(d));
		
		    var g1 = svg.insert("g", ".grandparent")
		        .datum(d)
		        .attr("class", "depth");
		
		    var g = g1.selectAll("g")
		        .data(d._children)
		      .enter().append("g");
		
		    g.filter(function(d) { return d._children; })
		        .classed("children", true)
		        .on("click", transition);
		
		    g.selectAll(".child")
		        .data(function(d) { return d._children || [d]; })
		      .enter().append("rect")
		        .attr("class", "child")
		        .call(rect);
		
		    g.append("rect")
		        .attr("class", "parent")
		        .call(rect)
		      .append("title")
		        .text(function(d) { return formatNumber(d.value); });
		
		    g.append("text")
		        .attr("dy", ".75em")
		        .text(function(d) { return d.name; })
		        .call(text);
		
		    function transition(d) {
		      if (transitioning || !d) return;
		      transitioning = true;
		
		      var g2 = display(d),
		          t1 = g1.transition().duration(750),
		          t2 = g2.transition().duration(750);
		
		      // Update the domain only after entering new elements.
		      x.domain([d.x, d.x + d.dx]);
		      y.domain([d.y, d.y + d.dy]);
		
		      // Enable anti-aliasing during the transition.
		      svg.style("shape-rendering", null);
		
		      // Draw child nodes on top of parent nodes.
		      svg.selectAll(".depth").sort(function(a, b) { return a.depth - b.depth; });
		
		      // Fade-in entering text.
		      g2.selectAll("text").style("fill-opacity", 0);
		
		      // Transition to the new view.
		      t1.selectAll("text").call(text).style("fill-opacity", 0);
		      t2.selectAll("text").call(text).style("fill-opacity", 1);
		      t1.selectAll("rect").call(rect);
		      t2.selectAll("rect").call(rect);
		
		      // Remove the old node when the transition is finished.
		      t1.remove().each("end", function() {
		        svg.style("shape-rendering", "crispEdges");
		        transitioning = false;
		      });
		    }
		
		    return g;
		  }
		
		  function text(text) {
		    text.attr("x", function(d) { return x(d.x) + 6; })
		        .attr("y", function(d) { return y(d.y) + 6; });
		  }
		
		  function rect(rect) {
		    rect.attr("x", function(d) { return x(d.x); })
		        .attr("y", function(d) { return y(d.y); })
		        .attr("width", function(d) { return x(d.x + d.dx) - x(d.x); })
		        .attr("height", function(d) { return y(d.y + d.dy) - y(d.y); });
		  }
		
		  function name(d) {
		    return d.parent
		        ? name(d.parent) + "." + d.name
		        : d.name;
		  }
		});
		
		
		
	}
	
});
