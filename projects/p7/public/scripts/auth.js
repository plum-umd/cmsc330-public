var host = window.location.host;
var global_data = {}

/* ********************************** */
/*   AUTHENTICATION/COOKIE FUNCTIONS  */
/* ********************************** */

function authenticateUser(username, password) {
  credentials = {
    "username": username,
    "password": password
  };
  session_key = null;

  // send username/password to back end, requesting a session
  // key (POST method here because we're requesting that the server
  // create a new session -- and we're posting to a base URI [otherwise,
  // we'd be using PUT])
  $.ajax({
    type: 'POST',
    datatype: 'json',
    async: false,
    url: "http://" + host + "/rest/session",
    data: JSON.stringify(credentials),
    success: function(data) {
      console.log("post to /rest/session succeeded with data = \n")
      console.log(data)
      session_key = data["session_key"]
      console.log("session_key = " + session_key)
    },
    error: function(data) {
      console.log("failed with response:\n" + data)
    }
  });

  console.log("we got session_key = " + session_key)

  // if we got a session key back:
  if (session_key) {
    console.log("in here!")
    // store it in the browser's cookies ...
    console.log("setting cookie ...")
    setCookie("session-key", session_key, .5);
    console.log("cookie set: \"session-key\":" + getCookie("session-key"))

    // ... and try and navigate to the original page requested --
    // else if there was no original page requested, then go to the dashboard
    // by default ...
    if (path = getCookie("original-request")) {
      // naviage to the original requested url
      console.log("redirecting us to \"" + host + path + "\"")
      window.location.replace("http://" + host + path);
    } else {
      // navigate to the admin home page by default
      console.log("redirecting us to dashboard!")
      window.location.replace("http://" + host + "/admin/dashboard.html")
    }

    return true
  }

  return false
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');

    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }

    return null;
}
