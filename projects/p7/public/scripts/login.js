$(document).ready(function() {
  // bind the modal open and close buttons
  $("#loginButton").button()

  $("#loginButton").click(function() {
    $("#modalContainer").addClass("shown").removeClass("hidden")
  });

  $(".close").click(function(e) {
    $("#modalContainer").addClass("hidden").removeClass("shown")
  });

  $("#cancelButton").click(function() {
    $("#modalContainer").addClass("hidden").removeClass("shown")
  });

  // bind the login submit button and trigger authentication
  $("[type='submit']").click(function() {
    username = $(":input[name='uname']").val()
    password = $(":input[name='psw']").val()

    console.log("username = " + username)
    console.log("password = " + password)

    // clear the input fields no matter what
    $(":input[name='uname']").val("")
    $(":input[name='psw']").val("")

    $.post("/api/authenticate", { name: username, password: password }, function(level) {
      if (level > 0) {
	      if (level == 1) {
	        window.location.href = "/admin/menu";
	      } else {
	        window.location.href = "/admin/dashboard";
	      }
      }
    });
  });
});
