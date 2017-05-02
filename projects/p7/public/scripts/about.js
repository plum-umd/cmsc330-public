// on page init, fade in the about content
$(document).ready(function() {
  $(window).scroll(function() {
      var scroll = $(window).scrollTop();

      if (scroll >= 10) {
          $(".larger").removeClass("larger").addClass("smaller");
      } else {
          $(".smaller").removeClass("smaller").addClass("larger");
      }
  });
  // load the menus from the rest api
  setTimeout(fadein, 100)
});

function fadein() {
  // $("#contentContainer").removeClass("fadeout");
  $("#contentContainer").addClass("fadein");
}
