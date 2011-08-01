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
			      // TODO: PUT IN BUCKET
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
