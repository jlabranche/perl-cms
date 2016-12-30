$(document).ready(function() {
    
    // Get the segment of the url after "admin/" and set that nav item to active, or set Dashboard to active
    var pattern = /admin\/(\w+)/;
    var page = pattern.exec($(location).attr("href"));
    if(page != undefined) {
        $("nav a").each(function() {
            var href = pattern.exec($(this).attr("href"));
            if(href != undefined) {
                if(href[1] == page[1])
                    $(this).addClass("active");
            }
        });
    } else {
        $("nav a[href=admin]").addClass("active");
    }

    // Mobile hamburger menu
    $(".hamburger-menu").click(function(){
        $(this).siblings("nav").slideToggle();
    });

    // Submit js-submit changes
    $(".js-submit").click(function(e){
        e.preventDefault();
        var data = {};
        $.each($(this).parent().find("input, select"), function(){
            if (!$(this).hasClass("inactive")) {
                if (data[$(this).attr("name")] === undefined) {
                    data[$(this).attr("name")] = [];
                }
                data[$(this).attr("name")].push($(this).val());
            }
        });
        data.action = $(this).attr("action");
        $.ajax({
            url: 'admin/ajax',
            method: "POST",
            data: data,
        }).done(function(){
            showConfirmation();
        });
    });

});

// Show a confirmation message
function showConfirmation() {
    $(".confirmation").fadeIn(100).delay(600).fadeOut(1000);
}