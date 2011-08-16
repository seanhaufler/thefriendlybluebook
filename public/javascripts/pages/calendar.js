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

/* loadCourses(): Set the left and width for each course visible */
Bluebook.Calendar.loadCourses = function() {
    var courses = $(".course:visible");
    $.each(courses, function(index, course) { 
        // Extract relevant CSS for the current course
        var cTop = parseInt($(course).css("top"));
        var cLeft = parseInt($(course).css("left"));
        var cHeight = parseInt($(course).css("height")) + 10;
        var colCourses = $(".course[style*='left: " + cLeft + 
            "px']").filter(":visible")

        // Iterate through each of the courses in the current column
        var overlapping = 0;
        $.each(colCourses, function(overNum, overCourse) {
            overTop = parseInt($(overCourse).css("top"));
            overLeft = parseInt($(overCourse).css("left"));
            overHeight = parseInt($(overCourse).css("height")) + 10;

            // Overlap occurred, add one to the count of overlaps
            if ((cTop > overTop && cTop - overTop < overHeight) || 
                (cTop <= overTop && overTop - cTop < cHeight)) {
                overlapping++;
            }
        });

        // Change the width and left based on our calculated values
        $(course).css({
            "width": ((150 / overlapping - 15) + "px"),
//            "left": parseInt($(value).css("left")) + 
//                (index * 150 / nums) + "px", 
        });
    });
}
