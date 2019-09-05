function UpdateTableHeaders() {
    $("div.divTableWithFloatingHeader").each(function() {
        offset = $(this).offset();
        scrollTop = $(window).scrollTop();
        if ((scrollTop > offset.top) && (scrollTop < offset.top + $(this).height())) {
            $(".tableFloatingHeader", this).css("visibility", "visible");
            $(".tableFloatingHeader", this).css("top", Math.min(scrollTop - offset.top, $(this).height() - $(".tableFloatingHeader", this).height()) + "px");
        } else {
            $(".tableFloatingHeader", this).css("visibility", "hidden");
            $(".tableFloatingHeader", this).css("top", "0px");
        }
    })
}

$(document).ready(function() {
    $("table.tableWithFloatingHeader").each(function() {
        $(this).wrap("<div class="
            divTableWithFloatingHeader " style="
            position: relative "></div>");
        $("tr:first", this).before($("tr:first", this).clone());
        clonedHeaderRow = $("tr:first", this)
        clonedHeaderRow.addClass("tableFloatingHeader");
        clonedHeaderRow.css("position", "absolute");
        clonedHeaderRow.css("top", "0px");
        clonedHeaderRow.css("left", "0px");
        clonedHeaderRow.css("visibility", "hidden");
    });
    UpdateTableHeaders();
    $(window).scroll(UpdateTableHeaders);
});