$(document).ready(function() {
    // Submit Navigation Menu changes
    $("[action=submit]").click(function(e){
        e.preventDefault();

        var data = {
            id:[],
            content:[],
            title:[],
            href:[],
            type:[],
            action:[],
        };
        data.id[0] = $("[name=id]").val();
        data.content[0] = $("[name=content]").val();
        data.title[0] = $("[name=title]").val();
        data.href[0] = $("[name=href]").val();
        data.type[0] = "update";
        data.action = "pages";
        console.log(data);
        $.ajax({
            url: 'admin/ajax',
            method: "POST",
            data: data,
        }).done(function(result){
            showConfirmation();
        });
    });
});