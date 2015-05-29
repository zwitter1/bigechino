$(document).ready(function(){
	
	$("#enterBut").click(function(){
		
		
		$.ajax({
			url:'landing/test',
			type:'GET',
			data: {"user": $("#loginName").val(), "pass":$("#loginPW").val() },
			success:function(data){
				$("body").html(data);
			}
			
		})
		
	});
	var halfHeight = $(window).height()/2
	//$('#display').layout({south__size: halfHeight});
});
