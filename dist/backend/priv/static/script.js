$(document).ready(function() {
    $("header button#account").click(function(){
        top.location.pathname = "/login"
    });

    if (top.location.pathname == "/") {
        $(".create #create, .create #join").hide();
        $(".create").on( "mouseenter",function() {
            $(".create #create, .create #join").show();
            $(".create #add").hide();
        });
        $(".create").on( "mouseleave",function() {
            $(".create #create, .create #join").hide();
            $(".create #add").show();
        });
        $(".create #create").click(function() {
            top.location.pathname = "/create/w"
        });
        $(".create #join").click(function() {
            top.location.pathname = "/join/w"
        });
        $(".workspaces:not(.create)").click(function(){
            top.location.pathname = `/w/` + $(this).attr("id")
        });
    };

    if (top.location.pathname == "/create/w") {
        $(".ws-handler #join").hide();
    };

    if (top.location.pathname == "/join/w") {
        $(".ws-handler #create").hide();
    };

    if (top.location.pathname.indexOf("/w/") == 0 ) {
        $(".create #create").hide();
        $(".create #add").click(function() {
            $(".create #create").show();
            $(".create #add").hide();
        });
        $(".create").on( "mouseleave",function() {
            $(".create #create, .create #join").hide();
            $(".create #add").show();
        });
    };
});