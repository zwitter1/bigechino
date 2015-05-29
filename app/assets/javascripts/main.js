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
		if (currentPos == 1000 || currentPos == 0){
			$("#buttonSet").addClass('shake animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass();
			});
			return;
		}
		
		var data = "";
		if(page == 'search')
			taxon = $("#taxonIn").val();
			description = $("#descIn").val();
			readD = $("#readIn").val();
			go = $("#goIn").val();
			if (taxon == "None"){
				taxon = ""
			}
			data = [taxon, readD, go];	
		if (currentPos > 0){	
					currentPos = currentPos - Number($("#count").val()); 
				}
		
		$.ajax({
			url: 'prev',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data, 'count': $("#count").val()},
			success: function(data){
				show = $.parseHTML(data);
				//$("#tableHolder").scrollTop(0);
				console.log($("#tableHolder").offset());
				console.log($("table").offset());
				$('#tableDisp').animate({
					scrollTop: 0//$("#tableHolder").offset().top -20
				},500);
				//$("#tableHolder").scrollTop(0);
				
				$("#tableHolder").html(show);
				
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
			taxon = $("#taxonIn").val();
			readD = $("#readIn").val();
			go = $("#goIn").val();
			
			if (taxon == "None"){
				taxon = ""
			}
			
			data = [taxon, readD, go];	
		currentPos = currentPos + Number($("#count").val()); 	
		
		$.ajax({
			url: 'next',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data, 'count': $("#count").val()},
			success: function(data){
				show = $.parseHTML(data);
				//$("#tableHolder").scrollTop(0);
				console.log($("#tableHolder").offset());
				console.log($("table").offset());
				$('#tableDisp').animate({
					scrollTop: 0//$("#tableHolder").offset().top -20
				},500);
				//$("#tableHolder").scrollTop(0);
				
				$("#tableHolder").html(show);
					
				
			}
		});
	});
	
	$("#runSearch").click(function(){
		taxon = $("#taxonIn").val();
		readD = $("#readIn").val();
		go = $("#goIn").val();	
		page = "search"
		
		if (taxon == "None"){
			taxon = ""
		}
		
		currentPos = 0;
		$(".spinner").show()
		$(".spinner").addClass('fadeInUp animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass().addClass('spinner');
			});
		
		var data= [taxon, readD, go]		
		$.ajax({
			url: 'search',
			type: 'GET',
			data: {"data": data , "count": $("#count").val()},
			success:function(retData){
				$(".spinner").hide()
				show = $.parseHTML(retData);
				$("#tableHolder").html(show);
				//currentPos = currentPos + Number($("#count").val());
			}
		});
	});
	
});
