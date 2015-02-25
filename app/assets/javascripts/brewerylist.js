var BREWERIES = {};

BREWERIES.show = function(){
    $("#activebrewerytable tr:gt(0)").remove();
    $("#retiredbrewerytable tr:gt(0)").remove();

    var table = $("#activebrewerytable");

    $.each(BREWERIES.list, function (index, brewery) {
        if (brewery['active'] == true) {
            table = $("#activebrewerytable");
            table.append('<tr>'
            + '<td>' + brewery['name'] + '</td>'
            + '<td>' + brewery['year'] + '</td>'
            + '</tr>');
        } else {
            table = $("#retiredbrewerytable");
            table.append('<tr>'
            + '<td>' + brewery['name'] + '</td>'
            + '<td>' + brewery['year'] + '</td>'
            + '</tr>');
        }

    });

};

BREWERIES.sort_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sort_by_year = function(){
    BREWERIES.list.sort( function(a,b){
        return a.year > b.year;
    });
};

$(document).ready(function () {
    $("#active_brewery_name").click(function (e) {
        BREWERIES.sort_by_name();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#active_brewery_year").click(function (e) {
        BREWERIES.sort_by_year();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#retired_brewery_name").click(function (e) {
        BREWERIES.sort_by_name();
        BREWERIES.show();
        e.preventDefault();
    });

    $("#retired_brewery_year").click(function (e) {
        BREWERIES.sort_by_year();
        BREWERIES.show();
        e.preventDefault();
    });

    $.getJSON('breweries.json', function (breweries) {
        BREWERIES.list = breweries;
        BREWERIES.sort_by_name();
        BREWERIES.show();
    });

});