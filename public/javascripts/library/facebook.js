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
        Bluebook.Facebook.friends = response.data;
    });
}
