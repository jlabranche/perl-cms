$(document).ready(function() {
    // Submit Navigation Menu changes
    $("[action=submit]").click(function(e){
        e.preventDefault();

        var data = {
            id:[],
            content:[],
            type:[],
            action:[],
        };
        data.id[0] = $("[name=id]").val();
        data.content[0] = $("[name=content]").val();
        data.type[0] = "update";
        data.action = "pages";

        $.ajax({
            url: 'admin/ajax',
            method: "POST",
            data: data,
        }).done(function(){
            showConfirmation();
        });
    });
});