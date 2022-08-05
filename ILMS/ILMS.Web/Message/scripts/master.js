
function getNavigationMenu(menu_id) {
    var menu;
    var eobmu_menu;
    var sub_sys_menu;
    var sys_menu;

    menu = getMenuObject(menu_id);
    eobmu_menu = getParentMenuObject(menu_id)
    sub_sys_menu = getParentMenuObject(eobmu_menu ? eobmu_menu["id"] : "");
    sys_menu = getParentMenuObject(sub_sys_menu ? sub_sys_menu["id"] : "");

    var returnValue = new Object();
    returnValue.menu = menu ? menu["name"] : "";
    returnValue.eobmu_menu = eobmu_menu ? eobmu_menu["name"] : "";
    returnValue.sub_sys_menu = sub_sys_menu ? sub_sys_menu["name"] : "";
    returnValue.sys_menu = sys_menu ? sys_menu["name"] : "";

    return returnValue;
}

function getParentMenuObject(menu_id) {
    var menus = sessionStorage.getItem("menu");
    var result = $.parseJSON(menus);
    var menu = _.find(result["menu"], function (v) { return v["id"] == menu_id });
    var parent_menu_id = menu ? menu["parentId"] : "";
    var parent_menu = _.find(result["menu"], function (v) { return v["id"] == parent_menu_id });

    return parent_menu;
}

function getMenuObject(menu_id) {
    var menus = sessionStorage.getItem("menu");
    var result = $.parseJSON(menus);
    var menu = _.find(result["menu"], function (v) { return v["id"] == menu_id });

    return menu;
}

function updateSize() {
    if (window.parent && window.parent.resizeTabPanel) {

        var height_form = $(document).find('.container-fluid').height();

        window.parent.resizeTabPanel({
            'width': $(document).width() - 288,
            //'height': $(document).height()
            'height': height_form
        });
    }
}

$(document).ready(function () {
    updateSize();

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        window.frameElement.style.height = window.frameElement.contentWindow.document.body.scrollHeight + 'px'
    });

    //$(window.parent).find("div[id='0001730']").height(700);
});