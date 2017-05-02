$(document).ready(function() {
  $("#top").hide()
  $("#bottom").hide()

  $("span.vertical-text").click(function() {
    openNav();
  });
});

/* Set the width of the side navigation to 250px */
function openNav() {
  $(".unexpanded-sidenav").hide()
  $("#mySidenav").css("position", "relative").width(250)
  setTimeout(
  function() {
    $("#top").show()
    $("#bottom").show()
  }, 500);
}

/* Set the width of the side navigation to 0 */
function closeNav() {
  $("#top").hide()
  $("#bottom").hide()
  $("#mySidenav").width(50).css("position", "fixed")
  $(".unexpanded-sidenav").show()
}
