// Create global facebook namespace
Bluebook.Facebook = function() {};

/*
 * [FACEBOOK] Prototype
 *
 * The following is a prototype for the getting the user's facebook info
 *
 * @params: none
 * @methods: updateInfo, getFriends
 */

// updateInfo(): Queue off an information update
Bluebook.Facebook.updateInfo = function() {
    // Change information in DB
    FB.api('/me', function(response) {
        if (response.name) {
            Bluebook.request.open("POST", ("/update?email=" + response.email + 
                "&name=" + response.name), true);
            Bluebook.request.send();
        }
        
        // Update the user's name
        Bluebook.User.username = response.name;
        Bluebook.User.facebook_id = response.id;
    });
}

// getFriends(): Queue off a request for the user's friends
Bluebook.Facebook.getFriends = function() {
    // Send a request to FB API
    FB.api('/me/friends', function(response) {
        friends = response.data;

        // Create a shortlist of id's of friends
        Bluebook.Facebook.friends = new Array();
        for (i in friends) {
            Bluebook.Facebook.friends.push(friends[i].id);
        }

        // Remove results from the DOM that aren't from friends
        $.each($(".friendResult"), Bluebook.Facebook.removeFromDOM);
        $.each($(".courseFlyoutFriend"), Bluebook.Facebook.removeFromDOM);
        $.each($(".comment"), Bluebook.Facebook.removeFromDOM);

        // Iterate through each set of friend renderings for flyout and check
        $.each($(".courseResult .flyout .taking"), 
            Bluebook.Facebook.showNull);
        $.each($(".courseResult .flyout .shopping"), 
            Bluebook.Facebook.showNull);
        $.each($(".courseResult .flyout .avoiding"), 
            Bluebook.Facebook.showNull);

        // Display all the friend results (if any) or a null message
        if (!$(".friendResult").length)
            $(".friendResults .noResults").show();
        else
            $(".friendResults .friendResult").show();

        // If we're on the home page show all the friends
        if (!$(".courseResults").length)
            $(".friendResults").show();
        $(".loadingResults").hide();
    });
}

// removeFromDOM(): Remove a given element from the DOM in an iterator
Bluebook.Facebook.removeFromDOM = function(index, friend) {
    if (Bluebook.Facebook.friends.indexOf($(friend).attr("data-fb-id"))
          < 0  && Bluebook.User.facebook_id != $(friend).attr("data-fb-id")) {
          $(friend).remove();
    }
}

// showNull(): Check if there are the correct flyout children and if there not
//    show a null message
Bluebook.Facebook.showNull = function(index, friend) {
    if (!$(friend).children(".courseFlyoutFriend").length)
        $(friend).children(".noResults").show();
}
