// Create global user namespace
Bluebook.User = function() {};

/*
 * [USER] Prototype
 *
 * The following is a prototype for storing the user's course choices
 *
 * @params: none
 * @methods: none
 */

Bluebook.User.buckets = {
    "taking": [],
    "shopping": [],
    "avoiding": []
}

// findCourseByBucket(): Find a specific course in a specific bucket
Bluebook.User.findCourseByBucket = function(bucket, id) {
    if (bucket === "taking" || bucket === "shopping" || bucket === "avoiding")
        bucket = Bluebook.User.buckets[bucket];

    for (i in bucket) {
        if (bucket[i].id === id)
            return bucket[i];
    }

    return undefined;
}

// findCourseByBucket(): Find a specific course in a specific bucket
Bluebook.User.findCourseIndexByBucket = function(bucket, id) {
    for (i in Bluebook.User.buckets[bucket]) {
        if (Bluebook.User.buckets[bucket][i].id === id)
            return i;
    }

    return undefined;
}

// addItem(): Add an item to the user's bucket
Bluebook.User.addItem = function(bucket, id) {
    Bluebook.request.open("POST", ("/add?type=" + bucket +
      "&course=" + id), true);
    Bluebook.request.send();

    // Push it into the correct bucket
    Bluebook.User.buckets[bucket].push(
        Bluebook.User.findCourseByBucket(Bluebook.Search.courses, id));
    Bluebook.User.refreshBucket(bucket);
    
    // Avoid following the link
    return false;
}

// removeItem(): Remove an item to the user's bucket
Bluebook.User.removeItem = function(bucket, id) {
    Bluebook.request.open("POST", ("/remove?type=" + bucket +
      "&course=" + id), true);
    Bluebook.request.send();

    // Remove it from the correct bucket
    Bluebook.User.buckets[bucket].splice(
        Bluebook.User.findCourseIndexByBucket(bucket, id), 1);
    Bluebook.User.refreshBucket(bucket);

    // Avoid following the link
    return false;
}

// refreshBucket(): Put the right information into the user's bucket flyout
Bluebook.User.refreshBucket = function(bucket) {
    // Check if the bucket is empty
    if (Bluebook.User.buckets[bucket].length === 0) {
        $("#tooltip" + Bluebook.capitalize(bucket) + "Empty").show();
        $("#tooltip" + Bluebook.capitalize(bucket) + "List").hide();

    // The bucket isn't empty, fill 'er up
    } else {
        $("#tooltip" + Bluebook.capitalize(bucket) + "Empty").hide();

        // Iterate through each bucket and fill it up
        $("#tooltip" + Bluebook.capitalize(bucket) + "List").empty();
        for (i in Bluebook.User.buckets[bucket]) {
            var course =  Bluebook.User.buckets[bucket][i];
            var url = "/search?utf8=%E2%9C%93&" + 
                "query=Enter+Search+Query...&course=" +
                course.department_abbr + "+" + course.number;
                
            container = document.createElement("a");
            $(container).html(
                "<div class='number black'> " +
                    "<div class='title'>" + 
                        "<span class='dept'>" + 
                            course.department_abbr + " " + course.number + 
                        "</span>: " +
                        Bluebook.truncate(course.title, 35) + 
                    "</div>" +
                    "<div class='remove'>" +
                        "<a href='' onclick=\"return Bluebook.User.removeItem('" + 
                            bucket + "', '" + course.id + 
                            "')\" class='hover_under'>Remove</a>" +
                    "</div>" +
                    "<div class='clear''></div>" +
                    "<div class='desc'>" +
                        Bluebook.truncate(course.description, 80) + 
                    "</div>" +
                    "<div class='clear'></div>" +
                "</div>"
            ).attr({
                "class": "courseItem draggable",
                "data-id": course.id,
                "href": url
            }).css({
                "text-decoration": "none",
            });
            $("#tooltip" + Bluebook.capitalize(bucket) + 
                "List").append(container);
        }
        
        $("#tooltip" + Bluebook.capitalize(bucket) + "List").show();
    }

    // Reflect the count in the little UI
    $("#count" + Bluebook.capitalize(bucket)).html(
        Bluebook.User.buckets[bucket].length);
};
