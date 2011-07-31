Bluebook.FBLogin = function() {
    FB.login(function(response) {
        alert(JSON.stringify(response));
        if (response.session && response.session.sig) {
            alert('Welcome!  Fetching your information.... ');
            FB.api('/me', function(response) {
            alert('Good to see you, ' + response.name + '.');
            FB.logout(function(response) {
                alert('Logged out.');
            });
        });
     } else {
       alert('User cancelled login or did not fully authorize.');
     }
   }, {scope: 'email'});
};
