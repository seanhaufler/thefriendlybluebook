// Perform the initial drag and drop loading
$(function() {
		$(".draggable").draggable({
        start: function(event, ui) {
            // TODO: CAPTURE ORIGINAL POSITION
        
            $(this).animate({ "width": "40px", "height": "20px" });
        },

        stop: function(event, ui) {
            $(this).animate({ "width": "60px", "height": "40px" });
        }
		});
		
		$(".droppable").droppable({
			  drop: function(event, ui) {
			      // TODO: CHECK IF IN BUCKET

			      // TODO: UPDATE COUNT

			      // TODO: SEND A POST REQUEST
			  },

			  over: function(event, ui) {
			      $(this).animate({ 
			          "width": "60px", 
    		          "margin-right": "18px",
    		          "margin-bottom": "0px" 
  		          }, 200)
			      $("#count" + $(this).attr("data-type")).animate({
			          "top": "39px"
		          }, 200);

		        // Show the tooltips for the event
            $("#tooltip" + $(this).attr("data-type")).show();
			  },

			  out: function(event, ui) {
			      $(this).animate({ 
			          "width": "48px", 
			          "margin-right": "30px",
    		          "margin-bottom": "12px" 
	            }, 200)
			      $("#count" + $(this).attr("data-type")).animate({
			          "top": "27px"
		          }, 200);

  		        // Hide the tooltips for the event
            $("#tooltip" + $(this).attr("data-type")).hide();

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
