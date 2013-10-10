function showResponse(responseText, statusText)  { 
	if (statusText == 'success') {
		$('.signup').html('<h4>Email address sent</h4>'); 
		$('.signup-2').html('<h4>Email address sent</h4>'); 
		$('.output').html('<p>' + $('someText', responseText).html()  + '</p>'); 
	} else {
		alert('status: ' + statusText + '\n\nSomething is wrong here');
	}
}

function showRequest(formData, jqForm, options) { 
	var form = jqForm[0];
	var validRegExp = /^[^@]+@[^@]+.[a-z]{2,}$/i;
	// or use 
	// if (!$('input[@name=email]').fieldValue()) { 
	if (!form.email.value) {
		$('.output').html('<div class="output2">Please fill the field!</div>'); 
		return false; 
	} else if (form.email.value.search(validRegExp) == -1) {
		$('.output').html('<div class="output2">Please provide a valid Email address!</div>'); 
		return false; 
	}
	else {	   
	 $('.output').html('Sending email address...!');  		
		return true;
	}
}

$(document).ready(function() { 
    var options = { success: showResponse, beforeSubmit: showRequest}; 
    $('.my-form').submit(function() { 
        $(this).ajaxSubmit(options); 
        return false; 
    });
}); 