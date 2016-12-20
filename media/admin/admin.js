$(document).ready(function() {
    
    // Get the last segment of the url and set that nav item to active
    var url = $(location).attr("href").replace(/\/$/,"").split("/");
    var page = url[url.length - 1];
    $("nav a").each(function() {
        if($(this).attr("href") == page)
            $(this).addClass("active");
    });

    // Sortable Navigation Menu row
    $(".rows").sortable({
        update: function( event, ui ) {
            resetPositionValues();
        }
    });

    // Add new Navigation Menu row
    $(".add-row").click(function(e){
        e.preventDefault();
        var newRow = '' +
            '<fieldset>' +
                '<label>Display Name<input type="text" name="name" value=""></label>' +
                '<label>Link Address<input type="text" name="href" value=""></label>' +
                '<input type="hidden" name="type" value="new">' +
                '<input type="hidden" name="position" value="">' +
                '<i class="fa fa-times-circle delete" aria-hidden="true"></i>' +
                '<i class="fa fa-arrows-v" aria-hidden="true"></i>' +
            '</fieldset>';
        $(".rows").append(newRow);
        resetPositionValues();
    });

    // Rebuild position values
    function resetPositionValues(){
        $.each($("fieldset>input[name=position]"), function(index,value) {
            $(this).val(index);
        });
    }

    // Submit Navigation Menu changes
    $(".js-submit").click(function(e){
        e.preventDefault();
        data = {};
        $.each($("input"), function(){
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
        });
    });

    // Delete something from the navigation
    $(".delete").click(function(e){
        e.preventDefault();
        data = {};
        data.id = $(this).parent().find("[name=id]").val();
        data.action="nav_items";
        data.type = [];
        data.type[0] = "delete";
        $.ajax({
            url: 'admin/ajax',
            method: "POST",
            data: data,
        });
        $(this).parent().remove();
    });
});

