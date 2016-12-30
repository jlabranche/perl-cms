$(document).ready(function() {

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
                '<input type="hidden" name="id" value="0">' +
                '<input type="hidden" name="type" value="new">' +
                '<input type="hidden" name="position" value="">' +
                '<i class="fa fa-times-circle delete" aria-hidden="true"></i>' +
                '<i class="fa fa-arrows-v" aria-hidden="true"></i>' +
            '</fieldset>';
        $(".rows").append(newRow);
        $("fieldset").last().find(".delete").click(function(){
            $(this).parent().remove();
        });
        resetPositionValues();
    });

    // Rebuild position values
    function resetPositionValues(){
        $.each($("fieldset>input[name=position]"), function(index,value) {
            $(this).val(index);
        });
    }

    // Delete something from the navigation
    $(".delete").click(function(e){
        e.preventDefault();
        var $parent = $(this).parent();
        var previousState = $parent.find("[name=type]").val();
        $parent.find("[name=type]").data("previous-state", previousState);
        $parent.find("[name=type]").val("delete");
        $parent.addClass("deleted");
    });

    // Undo delete from the navigation
    $(".glass").click(function(e){
        e.preventDefault();
        var $parent = $(this).parent();
        var previousState = $parent.find("[name=type]").data("previous-state");
        $parent.find("[name=type]").val(previousState); 
        $parent.removeClass("deleted");
    });
});
