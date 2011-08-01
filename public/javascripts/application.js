// Perform the initial drag and drop loading
$(function() {
		$(".draggable").draggable({
        start: function(event, ui) {
            $(this).animate({ "width": "40px", "height": "20px" });
        },

        stop: function(event, ui) {
            $(this).animate({ "width": "60px", "height": "40px" });
        }
		});
		
		$(".droppable").droppable({
			  drop: function(event, ui) {
				    alert($(this).attr("id"));
			  },

			  over: function(event, ui) {
			      $(this).animate({ width: 60 }, 300)
			  },

			  out: function(event, ui) {
			      $(this).animate({ width: 48 }, 300)
			  },
		});
});

// Create the global Bluebook namespace
Bluebook = function() {};

// Create XMLHttpRequest objects
if (window.XMLHttpRequest)                      // Chrome, Safari, Opera, FF
    Bluebook.request = new XMLHttpRequest();
else                                            // IE Handler
    Bluebook.request = new ActiveXObject("Microsoft.XMLHTTP");
