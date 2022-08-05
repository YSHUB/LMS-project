var tab_col_cnt, window_width;
var tab_min4 = 1200;
var tab_min3 = 992;
var tab_min2 = 576;
var tabs_next = '.tabs-next';
var tabs_prev = '.tabs-prev';
var tabs_class = '.nav-tabs-style01';

function nav_tab_var_set() {
    tab_col_cnt = 1;
    window_width = window.innerWidth;
    if (window_width >= tab_min4) { tab_col_cnt = 4; }
    else if (window_width >= tab_min3) { tab_col_cnt = 3; }
    else if (window_width >= tab_min2) { tab_col_cnt = 2; }
}

//페이지 호출에 따른 탭 초기화
function tab_init(start, end) {
    for (var i = 0; i < $(tabs_class).length; i++) {
        var tabs_ctrl = $(tabs_class)[i];

        var start = $(tabs_ctrl).find('li').find('a.active').parent('li').index();
        start = parseInt(start / tab_col_cnt) * tab_col_cnt;
        var end = start + tab_col_cnt - 1

        nav_tabs_for(tabs_ctrl, start, end);
    }
}

function nav_tabs_click(obj, gubun) {
    nav_tab_var_set();

    var sel = $(obj);
    var sel_parent = $(obj).parent('div');
    var li_all_cnt = $(sel_parent).find('li').length;

    var start = 0;
    var end = tab_col_cnt - 1;
    if (li_all_cnt > tab_col_cnt) {
        var first_index = $(sel_parent).find('li.first').index();

        if (gubun == 'next') {
            start = first_index + tab_col_cnt;
            if (start >= li_all_cnt) {
                start = 0;
            }
        }
        else if (gubun == 'prev') {
            start = first_index - tab_col_cnt;
            if (start < 0) {
                start = parseInt((li_all_cnt - 1) / tab_col_cnt) * tab_col_cnt;
            }
        }
        end = start + tab_col_cnt - 1;
    }

    nav_tabs_for(sel_parent, start, end);
}

function nav_tabs_for(obj_parent, start, end) {
    var for_cnt = 0;
    $(obj_parent).find('li').css('display', 'none');
    $(obj_parent).find('li').removeClass('first');
    for (var i = start; i <= end; i++) {
        try {
            if (for_cnt == 0) { $(obj_parent).find('li:eq(' + i + ')').addClass('first'); }
            $(obj_parent).find('li:eq(' + i + ')').css('display', 'block');

            for_cnt++;
        } catch (e) { }
    }
}

$(document).ready(function () {
    nav_tab_var_set();
    for (var i = 0; i < $(tabs_class).length; i++) {
        var tabs_ctrl = $(tabs_class)[i];

        var start = 0;
        var end = tab_col_cnt - 1;

        tab_init(start, end);
        //nav_tabs_for(tabs_ctrl, start, end);
    }
});

$(window).resize(function () {
    nav_tab_var_set();
    for (var i = 0; i < $(tabs_class).length; i++) {
        var tabs_ctrl = $(tabs_class)[i];

        var start = $(tabs_ctrl).find('li').find('a.active').parent('li').index();
        start = parseInt(start / tab_col_cnt) * tab_col_cnt;
        var end = start + tab_col_cnt - 1

        nav_tabs_for(tabs_ctrl, start, end);
    }
});

$(tabs_next).click(function () {
    nav_tabs_click($(this), 'next');
});

$(tabs_prev).click(function () {
    nav_tabs_click($(this), 'prev');
});