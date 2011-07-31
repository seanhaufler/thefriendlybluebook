// Create global search namespace
Bluebook.Search = function() {};

/*
 * [SEARCH] Prototype
 *
 * The following is a prototype for the search page (showing different views,
 * updating results, etc.)
 *
 * @params: none
 * @methods: showPeopleMap, showCourseMap, autocomplete
 */

// Set a variable for which one is highlighted
Bluebook.Search.autohighlighted = -1;

// showPeopleMap(): Update the map view to show friends results
Bluebook.Search.showPeopleMap = function() {
    // First, we switch the backgrounding on the buttons
    $(".searchRendering .mapType .activeButton").removeClass("activeButton");
    $(".searchRendering .mapType .friendButton").addClass("activeButton");

    // Avoid following link
    return false;
};

// showCourseMap(): Update the map to show course based results
Bluebook.Search.showCourseMap = function() {
    // First, we switch the backgrounding on the buttons
    $(".searchRendering .mapType .activeButton").removeClass("activeButton");
    $(".searchRendering .mapType .courseButton").addClass("activeButton");
    
    // Avoid following link
    return false;
};

// preventKeystrokes(): Take actions in autocomplete based on keystrokes
Bluebook.Search.preventKeystrokes = function() {
    // First, we capture the event and normalize for IE
    e = event || window.event;
    
    // Arrow down
    if (e.keyCode == 40) {
        highlighted = Bluebook.Search.autohighlighted;
        Bluebook.Search.dehighlightAll();
        Bluebook.Search.highlightItem(
            Math.min($(".suggestion").length - 1, highlighted + 1));
        return false;
    }

    // Arrow up
    if (e.keyCode == 38) {    
        highlighted = Bluebook.Search.autohighlighted;    
        Bluebook.Search.dehighlightAll();
        Bluebook.Search.highlightItem(
            Math.max(0, highlighted - 1));
        return false;
    }

    // Enter key
    if (e.keyCode == 13 && $("#ycpsSuggestions").display !== "none") {
        if (Bluebook.Search.autohighlighted > -1) {
            $("#ycpsSubject").val(
                $("#suggestion" + Bluebook.Search.autohighlighted).attr(
                    "data-completion"
                ));
        }
        $("#ycpsSuggestions").hide();
        return false;
    }
}

// autocomplete(): Fill in the datalist options using binary search
Bluebook.Search.autocomplete = function(Object) {
    // First, we capture the event and normalize for IE
    e = event || window.event;
    if (e.keyCode == 40 || e.keyCode == 38 || e.keyCode == 13)
        return false;

    // Empty all the results
    $("#ycpsSuggestions").empty();

    // Initialize an empty results array
    var bestResults = new Array();
    var results = new Array();

    // Reset the suggested highlight
    Bluebook.Search.autohighlighted = -1;

    // Loop through the YCPS listing and find the matches
    for (i = 0; i < ycps.length; i++) {
        // Find out where (if any) the location is
        var index = ycps[i][5].toLowerCase().indexOf(Object.value);

        // Matches beginning of string
        if (index == 0)
            bestResults.push(ycps[i][5]);

        // Matches within string somewhere
        else if (index > 0)
            results.push(ycps[i][5]);
    }

    // Find the total results and get the sub-array
    totalResults = bestResults.splice(0, 10).concat(results.splice(0, 
        10)).splice(0, 10);

    // Create a document element for each result
    for (i = 0; i < totalResults.length; i++) {
        // Mark up the result with emphasis
        index = totalResults[i].toLowerCase().indexOf(Object.value)
        var markedUpResult = totalResults[i].substring(0, index) +
            "<span>" + totalResults[i].substring(index, index + Object.value.length) + 
            "</span>" + totalResults[i].substring(index + Object.value.length);

        var result = document.createElement("div");
        $(result).attr({
            "class": "suggestion",
            "id": "suggestion" + i,
            "data-completion": totalResults[i],
            "data-id": i
        }).click(function() {
            $("#ycpsSubject").val($(this).attr("data-completion"));
            $("#ycpsSuggestions").hide();
        }).mouseover(function() {
            Bluebook.Search.dehighlightAll();
            Bluebook.Search.highlightItem($(this).attr("data-id"));
        }).mouseout(function() {
            Bluebook.Search.dehighlightAll();
        }).html(markedUpResult);
        
        // Add the result to the DOM
        $("#ycpsSuggestions").append(result);
    }

    // Show the results
    $("#ycpsSuggestions").show();
}

// highlightItem(): Puts the autosuggest item in a hoverstate
Bluebook.Search.highlightItem = function(item) {
    $("#suggestion" + item).css({
      "background" : "#213984",
      "color": "white"
    });
    Bluebook.Search.autohighlighted = parseInt(item);
}

// dehighlightItem(): Puts the autosuggest item in a non-hoverstate
Bluebook.Search.dehighlightAll = function() {
    $(".suggestion").css({
      "background" : "white",
      "color": "black"
    });
    Bluebook.Search.autohighlighted = -1;
}

// clearForm(): Clear out the form's hint
Bluebook.Search.clearForm = function(Object, token) {
    if (Object.value==token) {
        Object.value = '';
        Object.style.color = '#000';
        return true;
    }
    return false;
}

// restoreForm(): Restore the form's hint on blur
Bluebook.Search.restoreForm = function(Object, token) {
    if (Object.value == '') {
        Object.value = token;
        Object.style.color = '#808080';
        return true;
    }
    return false;
}
