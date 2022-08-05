//***********************************************************************
// 1. 체크후 닫기버튼을 눌렀을때 쿠키를 만들고 창을 닫습니다
// 2. 미리보기상태에서 닫기 클릭 이벤트
//***********************************************************************

// 1. 체크후 닫기버튼을 눌렀을때 쿠키를 만들고 창을 닫습니다
function closePopup(value, cookie) {
    setcookie(value, "done", cookie);  // 오른쪽 숫자는 쿠키를 유지할 기간을 설정합니다
    window.close();
}
function closePopupLayer(value, cookie, divid) {
    setcookie(value, "done", cookie);  // 오른쪽 숫자는 쿠키를 유지할 기간을 설정합니다
    ShowHideDirect(value, 'hide');
}

function closePopupZone(value, cookie) {
    var obj = eval("document.forms[0]." + value + "_yn");
    if (obj.checked) {
        setcookie(value, "done", cookie);  // 오른쪽 숫자는 쿠키를 유지할 기간을 설정합니다
        ShowHideDirect(value, 'hide');
    }
    else {
        setcookie(value, "", 0);  // 쿠키 리셋
        ShowHideDirect(value, 'show');
    }
}
function ShowHideDirect() {
    var args = ShowHideDirect.arguments;
    var obj = document.getElementById(args[0]);
    var display = 'block';
    if (args[1] == 'hide') { display = 'none'; }
    obj.style.display = display;
}
function ShowHideAuto(value) {
    var obj = document.getElementById(value);
    if (obj.style.display == 'block') {
        obj.style.display = 'none';
    }
    else {
        obj.style.display = 'block';
    }
}
// 2. 미리보기상태에서 닫기 클릭 이벤트
function preView_closePopupLayer(value) {
    ShowHideDirect(value, 'hide');
}

