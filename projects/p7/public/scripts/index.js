$(window).scroll(function() {
    var scroll = $(window).scrollTop();

    if (scroll >= 10) {
        $(".larger").removeClass("larger").addClass("smaller");
    } else {
        $(".smaller").removeClass("smaller").addClass("larger");
    }
});
