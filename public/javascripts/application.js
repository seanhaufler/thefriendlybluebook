// Perform the initial drag and drop loading
$(function() {
		$(".draggable").draggable({
        revert: true,
        revertDuration: 300,
      
        start: function(event, ui) {
            $(this).animate({ "width": "40px", "height": "20px" });
        },

        stop: function(event, ui) {
            $(this).animate({ "width": "60px", "height": "40px" });
        }
		});
		
		$(".droppable").droppable({
			  
        /* Dropping Function */
        drop: function(event, ui) {
			      // First, we make sure it's not in the bucket
			      type = $(this).attr("data-type");
			      bucket = Bluebook.User.buckets[type];
			      if (bucket.indexOf($(ui.draggable).attr("data-id")) < 0) {
                // Push in the new element and update the count
                bucket.push(ui.draggable.attr("data-id"));
                count = $("#count" + type).html();
                $("#count" + type).html(parseInt(count) + 1);
			      
      			      // Finally, we queue off a POST request to the server
      			      Bluebook.request.open("POST", ("/add?type=" + type +
                    "&course=" + ui.draggable.attr("data-id")), true);
                Bluebook.request.send();

                // Make a flash for the count
                $("#count" + type).switchClass("count", "countHighlight");
                setTimeout(function() {
                    $("#count" + type).switchClass("countHighlight", "count");
                  }, 1000);
            }
            
			      // Hide the tooltips and revert the sizes
  		        $(".droppable").animate({ 
			          "width": "48px", 
			          "margin-right": "30px",
    		          "margin-bottom": "12px" 
	            }, 200)
			      $(".count").animate({
			          "top": "27px"
		          }, 200);
            $(".tooltip").hide();
			  },

        /* Mouseover Function */
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

        /* Mouseout Function */
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
