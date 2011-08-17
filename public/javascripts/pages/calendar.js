// Create global calendar namespace
Bluebook.Calendar = function() {};

/*
 * [CALENDAR] Prototype
 *
 * The following is a prototype for the calendar page (organizing the left
 * and width values for the different elements)
 *
 * @params: none
 * @methods: loadCourses
 */

Bluebook.Calendar.COLUMN_WIDTH = 150;
Bluebook.Calendar.OFFSET_BY_DAY = {
    "M": 0,
    "T": 150,
    "W": 300,
    "Th": 450,
    "F": 600,
}

/* loadCourses(): Set the left and width for each course visible */
Bluebook.Calendar.loadCourses = function() {
    // Get out all the visible courses first and create an empty JSON to store
    var courses = $(".course:visible");
    var courseInfo = {};
    
    $.each(courses, function(index, course) { 
        // Extract relevant CSS for the current course
        var cTop = parseInt($(course).css("top"));
        var cLeft = parseInt($(course).css("left"));
        var cHeight = parseInt($(course).css("height")) + 10;
        var colCourses = $(".course[data-day='" + $(course).attr("data-day") + 
            "']").filter(":visible")

        // Iterate through each of the courses in the current column
        var overlapping = 0;
        var overlappingCourses = new Array();
        var index;
        $.each(colCourses, function(overNum, overCourse) {
            overTop = parseInt($(overCourse).css("top"));
            overHeight = parseInt($(overCourse).css("height")) + 10;

            // Overlap occurred, add one to the count of overlaps
            if ((cTop > overTop && cTop - overTop < overHeight) || 
                (cTop <= overTop && overTop - cTop < cHeight)) {
                overlapping++;
                overlappingCourses.push(overCourse);
            }
        });

        // Store the total number of overlapping
        courseInfo[$(course).attr("data-uid")] = {
            "overlapping": overlapping,
            "colCourses": $(overlappingCourses)
        }

        // Change the width and left based on our calculated values
        $(course).css({
            "width": ((Bluebook.Calendar.COLUMN_WIDTH / overlapping - 15) + 
                      "px"),
        });
    });

    // Next, we go through all the courses and change their left positions
    $.each(courses, function(index, course) {
        // Do some legwork to get the overlap, interval width, and init left
        var courseInformation = courseInfo[$(course).attr("data-uid")];
        var intervals = (Bluebook.Calendar.COLUMN_WIDTH / 
            courseInformation.overlapping);
        var dayLeft = Bluebook.Calendar.OFFSET_BY_DAY[$(course).attr("data-day")];

        // Iterate through the overlapping and find an empty slot
        var left = 0;
        for (var i = 0; i < courseInformation.overlapping; i++) {
            var currentPos = i * intervals;
            var inCurrentPos = courseInformation.colCourses.filter(function(i) {
                return $(this).css("left") == (dayLeft + currentPos) + "px";
              });

            // We perform a check to see if either of the following two
            //    conditions are satisfied:
            //
            //    1) There's nothing at the current position
            //    2) Only we are at the current position
            if (!inCurrentPos[0] || 
                (inCurrentPos.length === 1 && 
                 inCurrentPos.attr("class") === $(course).attr("class") &&
                 inCurrentPos.attr("data-id") === $(course).attr("data-id"))) {
                left = currentPos;
                break;
            }
        }

        // Finally, update the position of the element
        $(course).css({
            "left": dayLeft + left,
        });
    });
}