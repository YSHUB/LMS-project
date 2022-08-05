/// <reference path="message.es5.global.js" />

function isKakaoTalkType(messageTypes) {
    if (messageTypes == "KakaoNotificationTalk" || messageTypes == "KakaoFriendTalk") {
        return true;
    }
    return false;
}

function dataURLtoFile(dataurl, filename) {

    var arr = dataurl.split(','),
        mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]),
        n = bstr.length,
        buffer = new ArrayBuffer(bstr.length),
        u8arr = new Uint8Array(buffer);

    for (var i = 0; i < bstr.length; i++) {
        u8arr[i] = bstr.charCodeAt(i);
    }

    var blob = new Blob([u8arr], { type: mime });
    blob['name'] = filename;
    return blob;
    //return new File([blob], filename, { type: mime });

}

function fnIsMobile(phoneNum) {
    phoneNum = phoneNum.replace(/ /gi, "").replace(/-/gi, ""); // 공백,하이픈(-) 제거
    var regExp = /(01[016789])([1-9]{1}[0-9]{2,3})([0-9]{4})$/;
    var myArray;
    if (regExp.test(phoneNum)) {
        myArray = regExp.exec(phoneNum);
        return true;
    } else {
        return false;
    }
}

function fnGetCurrentDate() {
    var today = new Date();
    var year = today.getFullYear(); // 년도
    var month = today.getMonth() + 1; // 월
    var date = today.getDate(); // 날짜
    var day = today.getDay(); // 요일

    return year + "-" + month + "-" + date;
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getMessageTypeName(messageTypes) {

    var result = null;

    switch (messageTypes) {
        case 'Sms':
            result = 'SMS';
            break;
        case 'Mms':
            result = 'MMS';
            break;
        case 'KakaoFriendTalk':
            result = '카카오 친구톡';
            break;
        case 'KakaoNotificationTalk':
            result = '카카오 알림톡';
            break;
        case 'Email':
            result = '이메일';
            break;
    }

    return result;
}

function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (var i = 0; i < digits - n.length; i++) {
            zero += '0';
        }
    }
    return zero + n;
}

function getFormatDate(date) {

    if (date == "") return "";

    date = new Date(date);

    var year = date.getFullYear(); //yyyy
    var month = leadingZeros(1 + date.getMonth(), 2); //month 두자리로 저장
    var day = leadingZeros(date.getDate(), 2); //day 두자리로 저장

    var hh = leadingZeros(date.getHours(), 2);
    var mm = leadingZeros(date.getMinutes(), 2);
    var ss = leadingZeros(date.getSeconds(), 2);

    return year + '-' + month + '-' + day + ' ' + hh + ':' + mm + ':' + ss; //'-' 추가하여 yyyy-mm-dd 형태 생성 가능
}

function downLoadFileBlob(data, fileName) {
    //Convert the Byte Data to BLOB object.
    var blob = new Blob([data], { type: "application/octetstream" });

    //Check the Browser type and download the File.
    var isIE = false || !!document.documentMode;
    if (isIE) {
        window.navigator.msSaveBlob(blob, fileName);
    } else {
        try {
            var url = window.URL || window.webkitURL;
            link = url.createObjectURL(blob);
            var a = $("<a />");
            a.attr("download", fileName);
            a.attr("href", link);
            $("body").append(a);
            a[0].click();
            $("body").remove(a);
        } catch (e) { }
    }
}