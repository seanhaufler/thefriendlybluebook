// Perform the initial drag and drop loading
$(function() {
    var course;

		$(".draggable").draggable({
        revert: true,
        revertDuration: 300,
        cursorAt: { 
            top: 18,
            left: 55 
        },
        appendTo: 'body',
        helper: function(event) {
            // Make the item smaller and capture it's contents
            course = $(this).children(".number").html();
            layover = document.createElement("div");
            $(layover).html(
                course.substring(0, course.indexOf(":"))
            ).css({
                "font-weight": "bold",
                "background": "#0E4C92",
                "color": "white",
                "text-align": "center",
                "position": "absolute",
                "width": "110px",
                "height": "15px",
                "padding": "10px",
                "z-index": "30"
            }).attr({
                "class": "round drop_shadow",
                "data-id": $(this).attr("data-id")
            });

            return layover;
        },
      
        start: function(event, ui) {
            // Hide all the extraneous things
            $(".flyout").hide();
            $(".flyout").css("opacity", "0");
        },

        stop: function(event, ui) {
            // Show all the extraneous information
            $(".flyout").css("opacity", "1");
            $(".flyout").hide();
        }
		});
		
		$(".droppable").droppable({
        /* Dropping Function */
        drop: function(event, ui) {
            var img = $(this).children(".bucketImage");
        
			      // First, we make sure it's not in the bucket
			      type = $(img).attr("data-type");
			      id = ui.draggable.attr("data-id");
			      if (!Bluebook.User.findCourseByBucket(type, id)) {
                // Add the single item to the user's bucket and hide the helper
                Bluebook.User.addItem(type, id);
                ui.helper.hide();

                // Make a flash for the count
                $("#count" + Bluebook.capitalize(type)).switchClass("count", 
                    "countHighlight");
                setTimeout(function() {
                    $("#count" + Bluebook.capitalize(type)).switchClass(
                        "countHighlight", "count");
                  }, 1000);
            }
            
			      // Hide the tooltips and revert the sizes
  		        $(".droppable").children(".bucketImage").animate({ 
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
            var img = $(this).children(".bucketImage");
            
			      type = Bluebook.capitalize($(img).attr("data-type"));
			      $(img).animate({ 
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
            var img = $(this).children(".bucketImage");
            
			      type = Bluebook.capitalize($(img).attr("data-type"));
			      $(img).animate({ 
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
