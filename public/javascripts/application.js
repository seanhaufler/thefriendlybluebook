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
			      id = ui.draggable.attr("data-id");
			      if (!Bluebook.User.findCourseByBucket(type, id)) {
                // Add the single item to the user's bucket
                Bluebook.User.addItem(type, id);

                // Make a flash for the count
                $("#count" + Bluebook.capitalize(type)).switchClass("count", 
                    "countHighlight");
                setTimeout(function() {
                    $("#count" + Bluebook.capitalize(type)).switchClass(
                        "countHighlight", "count");
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
            $(".tooltipArrow").hide();
			  },

        /* Mouseover Function */
			  over: function(event, ui) {
			      type = Bluebook.capitalize($(this).attr("data-type"));
			      $(this).animate({ 
			          "width": "60px", 
    		          "margin-right": "18px",
    		          "margin-bottom": "0px" 
  		          }, 200)
			      $("#count" + type).animate({
			          "top": "39px"
		          }, 200);

		        // Show the tooltips for the event
            $("#tooltip" + type).show();
            $("#tooltip" + type + "Arrow").show();
			  },

        /* Mouseout Function */
			  out: function(event, ui) {
			      type = Bluebook.capitalize($(this).attr("data-type"));
			      $(this).animate({ 
			          "width": "48px", 
			          "margin-right": "30px",
    		          "margin-bottom": "12px" 
	            }, 200)
			      $("#count" + type).animate({
			          "top": "27px"
		          }, 200);

  		        // Hide the tooltips for the event
            $("#tooltip" + type).hide();
            $("#tooltip" + type + "Arrow").hide();

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

// Standard capitalization function
Bluebook.capitalize = function(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

// Standard truncate function
Bluebook.truncate = function(string, length) {
    if (string.length > length)
        return string.substring(0, length) + "...";
    return string;
}
