// JavaScript Document

$(document).ready(function () {

    //	$('[data-toggle="tooltip"]').tooltip();

    $('.dropdown-toggle').dropdown();

    $(".collapse-link").click(function () {
        if ($(this).hasClass("open")) {
            $(this).parent().parent().next(".ibox-content").slideDown(500);
            $(this).html('<i class="glyphicon glyphicon-chevron-up"></i><span class="sr-only">패널 숨기기</span>');
            $(this).attr("title", "패널 숨기기");
            $(this).removeClass("open");
        } else {
            $(this).parent().parent().next(".ibox-content").slideUp(500);
            $(this).html('<i class="glyphicon glyphicon-chevron-down"></i><span class="sr-only">패널 펼치기</span>');
            $(this).attr("title", "패널 펼치기");
            $(this).addClass("open");
        }
    });
    $(".close-link").click(function () {
        $(this).parent().parent().parent().hide();
    });

    //$('table.display').removeClass('display').addClass('table table-striped').DataTable();
    $('table.display').removeClass('display').addClass('table table-striped').DataTable({
        "paginate": false,
        "ordering": false,
        "filter": false
    });

    $('.btn-group .dropdown-menu a').click(function (e) {
        var selectdata = $(this).text();
        $(this).parent('li').parent('ul').prev('button').html(selectdata + ' <span class=\"caret\"></span>');
        // $(this).parent('li').parent('ul').prev('button').attr('value', selectdata);
        e.preventDefault();
    });
    $('.input-group-btn .dropdown-menu a').click(function (e) {
        var selectdata = $(this).text();
        $(this).parent('li').parent('ul').prev('button').html(selectdata + ' <span class=\"caret\"></span>');
        // $(this).parent('li').parent('ul').prev('button').attr('value', selectdata);
        e.preventDefault();
    });

    //var mcode = document.getElementById('menucode').value.split(",");
    //if (mcode != null && mcode != undefined) {
    //	var code1 = mcode[0] - 1 ;
    //	var code2 = mcode[1] - 1 ;
    //	if (code1 < 0) {
    //		var code1 = null ;
    //	}
    //	if (code2 < 0) {
    //		var code2 = null ;
    //	}
    //}

    //$('.navbar .location div:eq(1) > .dropdown-menu > li:eq('+ code1 +')').addClass('active');
    //var mtext1 = $('.navbar .location div:eq(1) > .dropdown-menu > li:eq('+ code1 +') > a').text();
    //$('.navbar .location div:eq(1) > button').html(mtext1 +'<span class="caret"></span>');

    //$('.navbar .location div:eq(2) > .dropdown-menu > li:eq('+ code2 +')').addClass('active');
    //var mtext2 = $('.navbar .location div:eq(2) > .dropdown-menu > li:eq('+ code2 +') > a').text();
    //$('.navbar .location div:eq(2) > button').html(mtext2 +'<span class="caret"></span>');

    //$('.sidebar .nav-sidebar > li').removeClass('active');
    //$('.sidebar .nav-sidebar > li > ul > li').removeClass('active');
    //$('.sidebar .nav-sidebar > li > ul').hide();
    //$('.sidebar .nav-sidebar > li:eq('+ code1 +')').addClass('active');
    //$('.sidebar .nav-sidebar > li.active > ul > li:eq('+ code2 +')').addClass('active');	
    //$('.sidebar .nav-sidebar > li.active > ul').slideDown(200);

    $('.sidebar .nav-sidebar > li > a > .toggleicon').attr('class', 'toggleicon glyphicon glyphicon-menu-down');
    $('.sidebar .nav-sidebar > li.active > a > .toggleicon').attr('class', 'toggleicon glyphicon glyphicon-menu-up');

    $('.sidebar .nav-sidebar > li > a').click(function () {
        if ($(this).parent("li").hasClass("active")) {
            $(this).next('ul').stop().slideUp(200);
            $(this).parent("li").removeClass('active');
            $(this).children('.toggleicon').attr('class', 'toggleicon glyphicon glyphicon-menu-down');
        } else {
            $('.sidebar .nav-sidebar > li').removeClass('active');
            $('.sidebar .nav-sidebar > li > ul').stop().slideUp(200);
            $('.sidebar .nav-sidebar > li > a > .toggleicon').attr('class', 'toggleicon glyphicon glyphicon-menu-down');
            $(this).next('ul').stop().slideDown(200);
            $(this).parent('li').addClass('active');
            $(this).children('.toggleicon').attr('class', 'toggleicon glyphicon glyphicon-menu-up');
        }
    });
    $('.sidebar .nav-sidebar > li > ul > li > a').click(function () {
        if ($(this).parent('li').hasClass('active')) {
            $(this).parent('li').removeClass('active');
        } else {
            $('.sidebar .nav-sidebar > li > ul > li').removeClass('active');
            $(this).parent('li').addClass('active');
        }
    });

    //setScroll();

    // 탭 컨트롤
    $('.nav-tabs > li > a[data-toggle="tab"]').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    })

    // 달력 컨트롤
    $('.date-control').focusin(function () {
        $(this).datepicker();
    });

    $("#divProcessing").hide();

});

//function setScroll() {

//	$.mCustomScrollbar.defaults.scrollButtons.enable=true;
//	$.mCustomScrollbar.defaults.axis="yx";
//	$(".mCScroll").mCustomScrollbar({
//		axis:"y",
//		scrollbarPosition: 'inside',
//		theme: 'dark-3',
//		autoHideScrollbar:true,
//		scrollInertia:500,
//		mouseWheelPixels:70,
//		mouseWheel:{preventDefault:true},
//		advanced:{updateOnContentResize:true}
//	});
//	/*
//	$(".ibox-content.mCScroll").mCustomScrollbar({
//		axis:"y",
//		scrollbarPosition: 'outside',
//		theme: 'dark-3',
//		autoHideScrollbar:true,
//		scrollInertia:500,
//		mouseWheelPixels:70,
//		mouseWheel:{preventDefault:true},
//		advanced:{updateOnContentResize:true}
//	});
//	*/
//	$(".fix_row3").mCustomScrollbar({
//		axis:"y",
//		scrollbarPosition: 'outside',
//		theme: 'dark-3',
//		autoHideScrollbar:true,
//		scrollInertia:500,
//		mouseWheelPixels:70,
//		mouseWheel:{preventDefault:true},
//		advanced:{updateOnContentResize:true},
//		scrollButtons:{enable:false}
//	});

//	$(".mCScroll .mCSB_buttonUp").html("<span class='sr-only'>스크롤 위로 이동</span>");
//	$(".mCScroll .mCSB_buttonDown").html("<span class='sr-only'>스크롤 아래로 이동</span>");

//	setScrollHeight();
//}

// 스크롤 높이 변경	
function setScrollHeight() {
    //학생 홈 - 프로그램 현황 
    var listheight1 = $('#myList1').height() - 95;
    $('#myList1 .select-detail.mCScroll').height(listheight1);
}

$(window).bind('resize', function (e) {
    window.resizeEvt;
    $(window).resize(function () {
        clearTimeout(window.resizeEvt);
        window.resizeEvt = setTimeout(function () {
            setScrollHeight();
        }, 250);
    });
});

// 스킨변경
function skin(name) {
    var skinName = name;
    if (skinName == 'point') {
        $("#sidebar").removeClass('skin-white');
        $("#sidebar").addClass('skin-point');
    } else if (skinName == 'white') {
        $("#sidebar").removeClass('skin-point');
        $("#sidebar").addClass('skin-white');
    } else {
        $("#sidebar").removeClass('skin-point');
        $("#sidebar").removeClass('skin-white');
    }
}


//--------------------------------------------------------------------
function GoTo(url) {
    document.location.href = url;
    return false;
}

function ConfirmInput(rptListId, rptListIdCount) {
    var num = "";
    var result = "";
    var count = 0;

    if (rptListIdCount > 0) {
        for (var i = 0; i < rptListIdCount; i++) {
            num = i;
            chkSel = rptListId + "_chkSel_" + num;
            if (document.getElementById(chkSel) != undefined) {
                if (document.getElementById(chkSel).checked == true) {
                    count++;
                }
            }
        }
        if (count == 0) {
            alert('등록할 항목을 선택하십시오.');
            return false;
        }
    }
    else {
        alert('등록할 항목이 존재하지 않습니다.');
        return false;
    }
    return confirm('등록하시겠습니까?');
}

function ConfirmUpdate(rptListId, rptListIdCount) {
    var num = "";
    var result = "";
    var count = 0;

    if (rptListIdCount > 0) {
        for (var i = 0; i < rptListIdCount; i++) {
            num = i;
            chkSel = rptListId + "_chkSel_" + num;
            if (document.getElementById(chkSel) != undefined) {
                if (document.getElementById(chkSel).checked == true) {
                    count++;
                }
            }
        }
        if (count == 0) {
            alert('수정할 항목을 선택하십시오.');
            return false;
        }
    }
    else {
        alert('수정할 항목이 존재하지 않습니다.');
        return false;
    }
    return confirm('수정하시겠습니까?');
}

function ConfirmDelete(rptListId, rptListIdCount) {
    var num = "";
    var result = "";
    var count = 0;
    if (rptListIdCount > 0) {
        for (var i = 0; i < rptListIdCount; i++) {
            num = i;
            chkSel = rptListId + "_chkSel_" + num;
            if (document.getElementById(chkSel) != undefined) {
                if (document.getElementById(chkSel).checked == true) {
                    count++;
                }
            }
        }
        if (count == 0) {
            alert('삭제할 항목을 선택하십시오.');
            return false;
        }
    }
    else {
        alert('삭제할 항목이 존재하지 않습니다.');
        return false;
    }
    return confirm('삭제하시겠습니까?');
}

function ConfirmDelete2(rptListIdCount) {
    if (rptListIdCount > 0) {
        return confirm('삭제하시겠습니까?');
    }
    else {
        alert('삭제할 항목이 존재하지 않습니다.');
        return false;
    }
}

function ConfirmDelete3(str) {
    if (str == "0") {
        alert("삭제할 데이터가 없습니다.");
        return false;
    } else {
        return confirm('삭제하시겠습니까?');
    }
}

function CallingPopUpEmp(Url, ctl1, ctl2, fHeight, fWidth) {
    //if (confirm('새창으로 표시됩니다. 새창에서 확인하시겠습니까?')) {
    if (Url.indexOf('?') > 0) {
        win = window.open(Url + "&ctlid1=" + ctl1 + "&ctlid2=" + ctl2,
                            null,
                            "height=" + fHeight + ", width=" + fWidth + ", status=no, location=no, scrollbars=yes");
        win.focus();
    }
    else {
        win = window.open(Url + "?ctlid1=" + ctl1 + "&ctlid2=" + ctl2,
                            null,
                            "height=" + fHeight + ", width=" + fWidth + ", status=no, location=no, scrollbars=yes");
        win.focus();
    }
    //}

    return false;
}

function CallingPopUpUser(Url, ctl1, ctl2, ctl3, ctl4, fHeight, fWidth) {
    //if (confirm('새창으로 표시됩니다. 새창에서 확인하시겠습니까?')) {
    if (Url.indexOf('?') > 0) {
        win = window.open(Url + "&ctlid1=" + ctl1 + "&ctlid2=" + ctl2 + "&ctlid3=" + ctl3 + "&ctlid4=" + ctl4,
                            null,
                            "height=" + fHeight + ", width=" + fWidth + ", status=no, location=no, scrollbars=yes");
        win.focus();
    }
    else {
        win = window.open(Url + "?ctlid1=" + ctl1 + "&ctlid2=" + ctl2 + "&ctlid3=" + ctl3 + "&ctlid4=" + ctl4,
                            null,
                            "height=" + fHeight + ", width=" + fWidth + ", status=no, location=no, scrollbars=yes");
        win.focus();
    }
    //}

    return false;
}

function ConfirmMessage(strMessage) {
    return confirm(strMessage);
}

//--------------------------------------------------------------------------

function CheckNum(strValue) {
    var regExp = /^[0-9]+$/;

    if (regExp.test(strValue)) {
        return true;
    }
    else {
        return false;
    }
}

function CheckDate(strValue) {
    var regExp = /^(\d{4})-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

    if (regExp.test(strValue)) {
        return true;
    }
    else {
        return false;
    }
}

//-----------------------------------------------------------------------------
// onkeyup 전용//

function Check_Num(obj) {
    var str = $(obj).val().replace(/[^0-9]/g, '');
    $(obj).val(str);
}

//최대 조건을 걸어줍니다.
function Check_Num_Max(obj, max) {
    var str = $(obj).val().replace(/[^0-9]/g, '').replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
    if (Number(str) > Number(max)) { str = max; }
    $(obj).val(String(Number(str)).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,"));
}

function Check_Money(obj) {
    var str = $(obj).val().replace(/[^0-9]/g, '').replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g,'');
    $(obj).val(str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
}

function Check_Num_Point(obj) {
    var str = $(obj).val().replace(/[^0-9.]/g, '').replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
    $(obj).val(str);
}

function Check_Num_Float(obj) {
    var str = $(obj).val().replace(/[^0-9.]/g, '').replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');
    if (str.search(/[.]/) != -1) {
        var position = str.search(/[.]/) + 1;
        var temp = str.substring(0, position) + str.substring(position).replace(/[.]/g, '');
        $(obj).val(temp);
    }
    else {
        $(obj).val(str);
    }
}

function Check_Percent_Point(obj,point) {
    var str = $(obj).val().replace(/[^0-9.]/g, '').replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '');;

    if (str.search(/[.]/) != -1) {
        var position = str.search(/[.]/) + 1;
        var temp = str.substring(0, position) + str.substring(position, position + point).replace(/[.]/g, '');
        $(obj).val(temp);
    }
    else {
        $(obj).val(str);
    }
}

function AutoPointDate(obj) {
    var str = $(obj).val().replace(/[^0-9]/g, '');
    var tmp = '';
    if (str.length < 5) {
        $(obj).val(str);
    } else if (str.length < 6) {
        tmp += str.substr(0, 4);
        tmp += '.';
        tmp += str.substr(4);
        $(obj).val(tmp);
    } else if (str.length == 6) {
        tmp += str.substr(0, 4);
        tmp += '.';
        tmp += str.substr(4, 2);
        $(obj).val(tmp);
    } else {
        tmp += str.substr(0, 4);
        tmp += '.';
        tmp += str.substr(4, 2);
        tmp += '.';
        tmp += str.substr(6);
        $(obj).val(tmp);
    }
}

function AutoPointDate_Hyphen(obj) {
    var str = $(obj).val().replace(/[^0-9]/g, '');
    var tmp = '';
    if (str.length < 5) {
        $(obj).val(str);
    } else if (str.length < 6) {
        tmp += str.substr(0, 4);
        tmp += '-';
        tmp += str.substr(4);
        $(obj).val(tmp);
    } else if (str.length == 6) {
        tmp += str.substr(0, 4);
        tmp += '-';
        tmp += str.substr(4, 2);
        $(obj).val(tmp);
    } else {
        tmp += str.substr(0, 4);
        tmp += '-';
        tmp += str.substr(4, 2);
        tmp += '-';
        tmp += str.substr(6);
        $(obj).val(tmp);
    }
}
//-----------------------------------------------------------------------------
function chkDateControl(obj)
{

    var str = $(obj).val().replace(/[^0-9]/g, '');

    if (str.length == 8)
    {
        if (isCheckDateType($(obj).val()) == false)
        {
            $(obj).val("");
            $(obj).focus();
        }
            
    }
    else
    {
        if (str.length != 0)
        {
            alert("올바른 날짜형식이 아닙니다.");
            $(obj).val("");
            $(obj).focus();

        }
    }
}

function isCheckDateType(param) {
    try {
        
        // 자리수가 맞지않을때
        if (param.length != 10) {
            alert("날짜의 자리수가 맞지 않습니다.");
            return false;
        }

        var year = Number(param.split('-')[0]);
        var month = Number(param.split('-')[1]);
        var day = Number(param.split('-')[2]);

        var dd = day / 0;

        if (month < 1 || month > 12) {
            alert("날짜의 '월'이 맞지 않습니다.");
            return false;
        }

        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay = maxDaysInMonth[month - 1];

        // 윤년 체크
        if (month == 2 && (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)) {
            maxDay = 29;
        }

        if (day <= 0 || day > maxDay) {
            alert("날짜의 '일'이 맞지 않습니다.");
            return false;
        }
        return true;
    } catch (err) {
        return false;
    }
}

function isValidDate(param) {
    try {
        param = param.replace(/-/g, '');

        // 자리수가 맞지않을때
        if (param.length != 10) {
            alert("날짜의 자리수가 맞지 않습니다.");
            return false;
        }

        var year = Number(param.split('.')[0]);
        var month = Number(param.split('.')[1]);
        var day = Number(param.split('.')[2]);

        var dd = day / 0;

        if (month < 1 || month > 12) {
            alert("날짜의 '월'이 맞지 않습니다.");
            return false;
        }

        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay = maxDaysInMonth[month - 1];

        // 윤년 체크
        if (month == 2 && (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)) {
            maxDay = 29;
        }

        if (day <= 0 || day > maxDay) {
            alert("날짜의 '일'이 맞지 않습니다.");
            return false;
        }
        return true;
    } catch (err) {
        return false;
    }
}

function fn_returnUrlParams(pn) {
    var results = new RegExp('[\?&]' + pn + '=([^&#]*)').exec(window.location.href);
    if (results == null) return null;
    return results[1] || 0;
}

//리피터 체크박스 체크유무 및 메세지 띄우기
function SelectCheck(type, id, cnt) {
    var rptCtrlId = id;
    var rptListIdCount = cnt;
    var num = "";
    var result = "";
    var count = 0;

    if (rptListIdCount > 0) {
        for (var i = 0; i < rptListIdCount; i++) {
            num = i;
            //chkSel = "IContents_rptList_chkSel_" + num;
            chkSel = rptCtrlId + num;
            if (document.getElementById(chkSel) != undefined) {
                if (document.getElementById(chkSel).checked == true) {
                    count++;
                }
            }
        }
        if (count == 0) {
            alert(type + '할 항목을 선택해주세요.');
            return false;
        }
    }
    else {
        alert(type + '할 항목이 없습니다.');
        return false;
    }
    return confirm(type + '하시겠습니까?');
}

//리피터 체크박스 체크유무만 파악
function SelectCheck_ConfirmNone(type, id, cnt) {
    var rptCtrlId = id;
    var rptListIdCount = cnt;
    var num = "";
    var result = "";
    var count = 0;

    if (rptListIdCount > 0) {
        for (var i = 0; i < rptListIdCount; i++) {
            num = i;
            //chkSel = "IContents_rptList_chkSel_" + num;
            chkSel = rptCtrlId + num;
            if (document.getElementById(chkSel) != undefined) {
                if (document.getElementById(chkSel).checked == true) {
                    count++;
                }
            }
        }
        if (count == 0) {
            alert(type + '할 항목을 선택해주세요.');
            return false;
        }
    }
    else {
        alert(type + '할 항목이 없습니다.');
        return false;
    }

    return true;
}

//전체체크
function ClickChkAll(chkName1, chkName2) {
    var frm = document.forms[0];
    if (eval('document.forms[0].' + chkName1).checked)
        SelectAll(frm, chkName2, true);
    else
        SelectAll(frm, chkName2, false);
}

function ClickChkAll_Post(chkName1, chkName2) {
    for (var i = 0; i < eval('document.forms').length; i++) {
        var frm = document.forms[i];
        if (eval('document.forms[' + i + '].' + chkName1) != null) {
            if (eval('document.forms[' + i + '].' + chkName1).checked) {
                SelectAll(frm, chkName2, true);
                break;
            }
            else {
                SelectAll(frm, chkName2, false);
                break;
            }
        }
    }
}

function SelectAll(frm, chkName, checked) {
    for (var i = 0; i < frm.elements.length; i++) {
        var e = frm.elements[i];
        if (e.type == "checkbox" && e.name.indexOf(chkName) >= 0 && !e.disabled) // 비활성화된 것 제외
            e.checked = checked;
    }
}

function autoResizes(doc) {
    var frame = doc.getElementById('frame');

    try {
        var iframeHeight = frame.contentWindow.document.body.scrollHeight;
        frame.height = iframeHeight;
    }
    catch (error) {
        frame.height = 1000; //예외발생시 고정
    }
}

function popSMS(rptListId, rptListIdCount, rptPhoneField, SendNo) {
    var num = "";
    var result = "";
    var count = 0;
    var TelList = "";

    if (rptListId != "") {
        if (rptListIdCount > 0) {
            ////SMS보내기 버튼 누를때 회원명부리스트 전체를 넘겨주도록 수정(별도처리필요X)
            //for (var i = 0; i < rptListIdCount; i++) {
            //    num = i;
            //    chkSel = rptListId + "_chkSel_" + num;
            //    //strPhone = rptListId + "_" + rptPhoneField + "_" + num;
            //    strPhone = rptPhoneField;
            //
            //    if (document.getElementById(chkSel) != undefined) {
            //        if (document.getElementById(chkSel).checked == true) {
            //            if (count == 0) {
            //                TelList = $(document.getElementById(strPhone)).val();
            //            }
            //            else {
            //                TelList = TelList + "|" + $(document.getElementById(strPhone)).val();
            //            }
            //            count++;
            //        }
            //    }
            //}
            //if (count == 0) { //위치가 이상해서 주석!!
            //    alert('수신자를 선택하십시오.');
            //    return false;
            //}
        }
        else {
            alert('수신자가 없습니다.');
            return false;
        }
    }

    //return confirm('등록하시겠습니까?');

    //var url = "../00_COMMON/COMM301.aspx?sRecNo=" + TelList + "&sSendNo=" + SendNo;
    var url = "../00_COMMON/COMM301.aspx?sRecNo=" + rptPhoneField + "&sSendNo=" + SendNo;

    openWin = window.open(url, "Activity", "width=500, height=640, scrollbars=yes, resizable=yes");

    openWin.focus();

    return false;
}