// Create global facebook namespace
Bluebook.Facebook = function() {};

/*
 * [FACEBOOK] Prototype
 *
 * The following is a prototype for the getting the user's facebook info
 *
 * @params: none
 * @methods: updateInfo
 */

// updateInfo(): Queue off an information update
Bluebook.Facebook.updateInfo = function() {
    // Change information in DB
    FB.api('/me', function(response) {
        Bluebook.request.open("POST", ("/update?uid=" + response.id +
            "&email=" + response.email + "&name=" + response.name), true);
        Bluebook.request.send();
    });
}
