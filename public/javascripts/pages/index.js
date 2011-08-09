//FBLogin(): Log the user in through Facebook
Bluebook.FBLogin = function() {
    FB.login(function(response) {
        if (response.session && response.session.sig) {
            window.location.assign("/search");
        }
     }, {scope: 'email'});

     return false;
};
