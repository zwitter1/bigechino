$(document).ready(function(){
	
	$("#enterBut").click(function(){
		$.ajax({
			url:'main/browse',
			type:'GET',
			success:function(data){
				$("body").html(data)
			}
			
		})
		
	});
	var halfHeight = $(window).height()/2
	$('#display').layout({south__size: halfHeight});
});