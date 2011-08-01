// Perform the initial drag and drop loading
$(function() {
		$(".draggable").draggable();
		$(".droppable").droppable({
			  drop: function(event, ui) {
				    alert($(this).attr("id"));
			  } 

			  over: function(event, ui) {
			      animate({ width: 60 }, 300)
			  }

			  out: function(event, ui) {
			      animate({ width: 48 }, 300)
			  }
		});
});

// Create the global Bluebook namespace
Bluebook = function() {};

// Create XMLHttpRequest objects
if (window.XMLHttpRequest)                      // Chrome, Safari, Opera, FF
    Bluebook.request = new XMLHttpRequest();
else                                            // IE Handler
    Bluebook.request = new ActiveXObject("Microsoft.XMLHTTP");
