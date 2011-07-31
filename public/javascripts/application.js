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
