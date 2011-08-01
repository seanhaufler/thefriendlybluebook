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
Bluebook.Facebook.updateInfo = function(access_token) {
    // Change information in DB
    Bluebook.request.open("GET", 'https://graph.facebook.com/me?access_token='
        + access_token, true);
    Bluebook.request.send();
    Bluebook.request.onreadystatechange = function() { alert('hi'); }
}
