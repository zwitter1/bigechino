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
			}
		});
	});
	
});
