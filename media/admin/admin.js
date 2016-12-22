$(document).ready(function() {
    
    // Get the last segment of the url and set that nav item to active
    var url = $(location).attr("href").replace(/\/$/,"").split("/");
    var page = url[url.length - 1];
    console.log(page);
    $("nav a").each(function() {
        var href = $(this).attr("href").split("/");
        if(href[href.length - 1] == page)
            $(this).addClass("active");
    });

});