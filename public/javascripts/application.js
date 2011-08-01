// Perform the initial drag and drop loading
$(function() {
		$(".draggable").draggable();
		$(".droppable").droppable({
			drop: function(event, ui) {
				alert($(this).attr("id"));
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
