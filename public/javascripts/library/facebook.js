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
        Bluebook.request.open("POST", ("/update?email=" + response.email + 
            "&name=" + response.name), true);
        Bluebook.request.send();
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

        // Remove elements from the DOM that aren't friends
        $.each($(".friendResult"), function(index, friend) {
            if (Bluebook.Facebook.friends.indexOf($(friend).attr("data-fb-id"))
                  < 0) {
                  $(friend).remove();
            }
        });

        // Display all the friend results
        $(".friendResult").show();
    });
}
