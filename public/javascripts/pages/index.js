Bluebook.FBLogin = function() {
    FB.login(function(response) {
        if (response.session && response.session.sig) {
            alert('Welcome!  Fetching your information.... ');
            FB.api('/me', function(response) {
                alert('Good to see you, ' + JSON.stringify(response) + '.');
            });
         } else {
           alert('User cancelled login or did not fully authorize.');
         }
     }, {scope: 'email'});
};
