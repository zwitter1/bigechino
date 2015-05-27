var currentPos = 0
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
				currentPos = currentPos + 1000; 
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
				currentPos = currentPos + 1000;
			}
		});
	});
	
	$("#previous").click(function(){
		if (currentPos == 1000 || currentPos == 0){
			$("#buttonSet").addClass('wobble animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
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
			
			data = [taxon, description, readD, go];	
		
		
		$.ajax({
			url: 'prev',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data},
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
				if (currentPos > 0){	
					currentPos = currentPos - 1000; 
				}
			}
		});
	});
	
	
	$("#next").click(function(){
		if(currentPos == 0){
			$("#buttonSet").addClass('wobble animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
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
			
			data = [taxon, description, readD, go];	
		
		
		$.ajax({
			url: 'next',
			type: 'GET',
			data: {'stTime': currentPos, 'page': page, 'data': data},
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
					
				currentPos = currentPos + 1000; 
			}
		});
	});
	
	$("#runSearch").click(function(){
		taxon = $("#taxonIn").val();
		description = $("#descIn").val();
		readD = $("#readIn").val();
		go = $("#goIn").val();	
		page = "search"
		currentPos = 0;
		$(".spinner").show()
		$(".spinner").addClass('fadeInUp animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
				$(this).removeClass().addClass('spinner');
			});
		
		var data= [taxon, description, readD, go]		
		$.ajax({
			url: 'search',
			type: 'GET',
			data: {"data": data },
			success:function(retData){
				$(".spinner").hide()
				show = $.parseHTML(retData);
				$("#tableHolder").html(show);
				currentPos = currentPos + 1000;
			}
		});
	});
	
});
