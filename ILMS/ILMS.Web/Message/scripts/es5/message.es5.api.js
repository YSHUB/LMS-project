var SENDER_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/sender';
var DEPT_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/department';
var USERS_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/Users';
var COMMONCODES_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/commoncodes';
var FEE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/feepolicy';
var TPLMESSAGE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/tplmessage';
var TPLKAKAO_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/tplkakao';
var KAKAOCHANNEL_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/kakaochannel';

var AUTHGROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/authgroup';
var CONTACTGROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/contactgroup';
var PERSONALINFO_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/personalinfo';
var LOG_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/log';

var GROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/group';
var MESSAGE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/message';
var SITES_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/sites';

var storageUserKey = "msgUser";
var currentMsgUser = function currentMsgUser() {
    return localStorage.getItem(storageUserKey) ? JSON.parse(localStorage.getItem(storageUserKey)) : null;
};

var authHeader = function authHeader(xhr) {
    var urser = currentMsgUser();
    if (urser && urser.token) {
        xhr.setRequestHeader("Authorization", 'Bearer ' + urser.token);
    }
};
var authHeaderEx = function authHeaderEx(xhr) {
    var urser = currentMsgUser();
    if (urser && urser.token) {
        xhr.setRequestHeader("Content-Type", 'application/json');
        xhr.setRequestHeader("Authorization", 'Bearer ' + urser.token);
    }
};

var getCurrentYYYYMM = function getCurrentYYYYMM() {
    var separator = arguments.length <= 0 || arguments[0] === undefined ? '' : arguments[0];


    var newDate = new Date();
    var month = newDate.getMonth() + 1;
    var year = newDate.getFullYear();

    return '' + year + separator + (month < 10 ? '0' + month : '' + month);
};

function authUser(userID, password, siteID, siteCode, callBack) {
    var reqData = {};
    reqData['userID'] = userID;
    reqData['password'] = password;
    reqData['siteID'] = siteID;
    reqData['siteCode'] = siteCode;

    $.ajax({
        type: "POST",
        data: JSON.stringify(reqData),
        url: USERS_API_URL + '/authenticate',
        dataType: "json",
        async: false,
        beforeSend: function beforeSend(xhr) {
            xhr.setRequestHeader("Content-Type", "application/json-patch+json");
        },
        success: function success(data) {
            localStorage.setItem(storageUserKey, JSON.stringify(data));
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function createDefaultAuthUser(id, pwd, hash, sitekey, callBack) {

    if (localStorage.getItem(storageUserKey)) {
        localStorage.removeItem(storageUserKey);
	}

	authUser(id, pwd, hash, sitekey, callBack);
}

function reDefaultAuthUser() {
    authUser("dgkim", "rlaehdrbs1!", "D5811F88-011B-4407-A8FD-08D89CCE0858", "koje", null);
}

function getUserAll(siteid, approvaluse, userid, deptcode, callBack) {
    var reqData = {};
    reqData['SiteID'] = siteid;
    reqData['ApprovalUse'] = approvaluse;
    reqData['UserID'] = userid;
    reqData['DeptCode'] = deptcode;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '' + USERS_API_URL,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error2) {
            console.log(xhr);
            if (_error2 == 'Unauthorized') { }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getDeptUserInfo(siteid, menuid, callBack) {

    $.ajax({
        type: "GET",
        data: {},
        url: DEPT_API_URL + '/' + siteid + '/' + menuid + '/users',
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error3) {
            console.log(xhr);
            if (_error3 == 'Unauthorized') { }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getSender(status, reqdel, siteid, useyn, deptcode, schgubun, schkeyword, callBack) {
    var reqData = {};
    reqData['Status'] = status;
    reqData['ReqDel'] = reqdel;
    reqData['SiteID'] = siteid;
    reqData['UseYN'] = useyn;
    reqData['DeptCode'] = deptcode;
    reqData['SchGubun'] = schgubun;
    reqData['SchKeyword'] = schkeyword;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '' + SENDER_API_URL,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error4) {
            console.log(xhr);
            if (_error4 == 'Unauthorized') { }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getCodeChildInfo(codepid, callBack) {

    $.ajax({
        type: "GET",
        data: {},
        url: COMMONCODES_API_URL + '/child/' + codepid,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error5) {
            console.log(xhr);
            if (_error5 == 'Unauthorized') { }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getPolicyAll(siteid, yyyymm, useyn, callBack) {

    var reqData = {};
    reqData['SiteID'] = siteid;
    reqData['YYYYMM'] = yyyymm;
    reqData['UseYN'] = useyn;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '' + FEE_API_URL,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error6) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getFeePolicy() {

    var feePolicy = [];
    var user = currentMsgUser();
    getPolicyAll(user.siteID, getCurrentYYYYMM(''), "Y", function (data) {
        $(data).each(function (index, item) {
            if (item.msgType == "0") {
                // SMS
                feePolicy.push("Sms|" + item.fee);
            } else if (item.msgType == "1") {
                // MMS
                feePolicy.push("Mms|" + item.fee);
            } else if (item.msgType == "3") {
                // KakaoNotificationTalk
                feePolicy.push("KakaoNotificationTalk|" + item.fee);
            } else if (item.msgType == "4") {
                // KakaoFriendTalk
                feePolicy.push("KakaoFriendTalk|" + item.fee);
            }
        });
    });

    return feePolicy;
}

function getKakaoChannelTemplate(siteid, msgType, callBack) {
    var reqData = {};
    reqData['MsgType'] = msgType;

    $.ajax({
        type: "GET",
        data: reqData,
        url: KAKAOCHANNEL_API_URL + '/template/' + siteid,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error7) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getTPLMessage(id, callBack) {

    $.ajax({
        type: "GET",
        data: {},
        url: TPLMESSAGE_API_URL + '/' + id,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error8) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getTPLMessages(siteid, name, msgType, callBack) {
    var reqData = {};
    reqData['SiteID'] = siteid;
    reqData['Name'] = name;
    reqData['msgType'] = msgType;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '' + TPLMESSAGE_API_URL,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error9) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function sendPost(senderid, userid, request, file, sucessCallBack, failedCallBack) {

    var currentUser = currentMsgUser();
    var formData = new FormData();
    formData.append('SenderId', request.SenderId);
    formData.append('userid', request.UserId);
    formData.append('ApiKey', request.ApiKey);
    formData.append('Message.Id', "");
    formData.append('Message.Type', request.msgType);
    formData.append('Message.Subject', request.Message.subject);
	formData.append('Message.Body', String(request.Body).split("'").join("''")); //2021-06-02 김광일 수정 '(작은따옴표) -> ''(작은따옴표2개) 치환
    formData.append('Message.SenderId', request.SenderId);
    formData.append('Message.SenderName', request.Message.SenderName);
    formData.append('Message.SenderNumber', request.Message.SenderNumber);
    formData.append('Message.KakaoTemplateCode', request.Message.kakaoTemplateCode);
    formData.append('Message.KakaoSenderKey', request.Message.KakaoSenderKey);
    formData.append('Message.SiteID', request.Message.SiteID);
	formData.append('Message.Scheduled', request.Message.Scheduled);
	formData.append('k_next_type', request.k_next_type);
	if(file.length != 0)
		formData.append('Message.file', file, file.name);
    var idx = 0;
    request.Message.Recipients.forEach(function (recipient) {
        formData.append('Message.Recipients[' + idx + '].VariablesData', recipient.variablesdata);
        formData.append('Message.Recipients[' + idx + '].Phone', recipient.Phone);
        idx++;
    });
    var idx2 = 0;
    request.Message.Buttons.forEach(function (button) {
        formData.append('Message.Buttons[' + idx2 + '].Type', button.type);
        formData.append('Message.Buttons[' + idx2 + '].Name', button.name);
        formData.append('Message.Buttons[' + idx2 + '].LinkUrl1', button.linkUrl1);
        formData.append('Message.Buttons[' + idx2 + '].LinkUrl2', button.linkUrl2);
        formData.append('Message.Buttons[' + idx2 + '].TypeName', button.typeName);
        idx2++;
    });

    $.ajax({
        type: "POST",
        data: formData,
        url: MESSAGE_API_URL + '/SendPost',
        cache: false,
        //enctype: 'multipart/form-data',
        contentType: false,
        processData: false,
        //dataType: "json",
        //async: false,
        beforeSend: function beforeSend(xhr) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + currentUser.token);
        },
        success: function success(data) {
            if (sucessCallBack) {
                sucessCallBack(data);
            }
        },
        error: function error(xhr, status, _error10) {
            console.log(xhr);
            if (failedCallBack) {
                failedCallBack(xhr, status, _error10);
            }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function FileDownLoadService(senderno, messageType, filetype, variables, sucessedCallBack, failedCallBack) {

    var reqParam = {};
    reqParam['senderno'] = senderno;
    reqParam['messageType'] = messageType;
    reqParam['filetype'] = filetype;
    reqParam['variables'] = variables;

    $.ajax({
        type: "POST",
        data: JSON.stringify(reqParam),
        url: MESSAGE_API_URL + '/download-file',
        cache: false,
        xhr: function xhr() {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 2) {
                    if (xhr.status == 200) {
                        xhr.responseType = "blob";
                    } else {
                        xhr.responseType = "text";
                    }
                }
            };
            return xhr;
        },
        beforeSend: function beforeSend(xhr) {
            authHeaderEx(xhr);
        },
        success: function success(data) {
            if (sucessedCallBack) {
                sucessedCallBack(data);
            }
        },
        error: function error(xhr, status, _error11) {
            console.log(xhr);
            if (failedCallBack) {
                failedCallBack(xhr, status, _error11);
            }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function FileParseService(file, sucessedCallBack, failedCallBack) {
    var currentUser = currentMsgUser();
    var formData = new FormData();
    formData.append('File', file);

    $.ajax({
        type: "POST",
        data: formData,
        url: MESSAGE_API_URL + '/parse',
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function beforeSend(xhr) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + currentUser.token);
        },
        success: function success(data) {
            if (sucessedCallBack) {
                sucessedCallBack(data);
            }
        },
        error: function error(xhr, status, _error12) {
            if (failedCallBack) {
                failedCallBack(xhr, status, _error12);
            }
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getGroupService(groupId, callBack) {

    $.ajax({
        type: "GET",
        data: {},
        url: GROUP_API_URL + '/' + groupId,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error13) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getGroupsService(groupNm, siteid, userid, callBack) {

    var reqData = {};
    reqData['GroupNM'] = groupNm;
    reqData['SiteID'] = siteid;
    reqData['UserID'] = userid;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '' + GROUP_API_URL,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error14) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getOrganizationService(sysgb, callBack) {
    var reqData = {};
    reqData['SysGb'] = sysgb;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageOrganization.aspx',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error15) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getStudentService(serviceOption, callBack) {

    var reqData = {};
    reqData['SysGb'] = serviceOption.SysGb;
    reqData['StayType'] = serviceOption.StayType;
	reqData['OrgCode'] = serviceOption.OrgCode;
    reqData['StudentNO'] = serviceOption.StudentNO;
    reqData['Grade'] = serviceOption.Grade;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessagePerson.aspx',
        dataType: "json",
        //async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error16) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeSugangSubjectService(year, term, staffno, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'SUBJECT';
    reqData['Year'] = year;
    reqData['Term'] = term;
    reqData['StaffNO'] = staffno;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageSugangData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error17) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeYearTerm(yearGb, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'YearTerm';
    reqData['YearGb'] = yearGb;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageSugangData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error18) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeScholarShipFundCode(callBack) {

    var reqData = {};
    reqData['DataGb'] = 'FUNDCODE';

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageSugangData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error19) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeScholarShipCode(scholarShipCode, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'SCHOLARSHIPCODE';
    reqData['ScholarShipCode'] = scholarShipCode;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageSugangData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error20) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeCurrentUser(callBack) {
    var reqData = {};
    reqData['DataGb'] = 'CURRENTUSER';

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageSugangData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error21) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeAuthGroupService(callBack) {
    var reqData = {};
    reqData['DataGb'] = 'AUTHGROUPDDL';

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEmpData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error22) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeAuthGroupUserService(authGroupId, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'AUTHGROUPUSER';
    reqData['AuthGroupId'] = authGroupId;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEmpData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error23) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getEmployeeService(userGbn, assignInfo, staffNO, callBack) {

 //   var reqData = {};
 //   reqData['DataGb'] = 'EMPLOYEE';
 //   reqData['StaffState'] = staffState;
 //   reqData['PayRankCode'] = payRankCode;
	//reqData['StaffNO'] = staffNO;
    //reqData['orgCode'] = orgCode;
    $.ajax({
        type: "GET",
        data: ({ userGbn: userGbn, assignInfo: assignInfo, staffNO: staffNO }),
        url: "/Message/GetEmployeeList",
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data); 
            }
        },
        error: function error(xhr, status, _error24) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getCommonCodeService(groupCode, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'COMMONCODE';
    reqData['GroupCode'] = groupCode;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/CommonData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error25) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEntrAppYearSeasonData(callBack) {

    var reqData = {};
    reqData['DataGb'] = 'APPYEARSEASON';

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEntrData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error26) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEntrSppoClsCode(year, callBack) {

    var reqData = {};
    reqData['DataGb'] = 'SPPOCLSCODE';
    reqData['Year'] = year;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEntrData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error27) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEntrMajorCode(year, callBack) {

    var reqData = {};
    reqData['DataGb'] = 'ENTRMAJORCODE';
    reqData['Year'] = year;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEntrData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error28) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEntrMajorPerson(year, season, pass, majorCode, sppoClsCode, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'ENTRMAJORPERSON';
    reqData['Year'] = year;
    reqData['Season'] = season;
    reqData['Pass'] = pass;
    reqData['MajorCode'] = majorCode;
    reqData['sppoClsCode'] = sppoClsCode;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEntrData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error29) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEntrIndividualPerson(year, season, pass, recpNo, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'ENTRINDIVIDUALPERSON';
    reqData['Year'] = year;
    reqData['Season'] = season;
    reqData['Pass'] = pass;
    reqData['RecpNo'] = recpNo;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEntrData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error30) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEducVclYearTerm(callBack) {
    var reqData = {};
    reqData['DataGb'] = 'EDUCYEARTERM';

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEducData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error31) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEducVclCourseCode(workdiv, year, term, coursediv, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'EDUCCOURSECODE';
    reqData['WORK_DIV'] = workdiv;
    reqData['YEAR'] = year;
    reqData['TERM'] = term;
    reqData['COURSEDIV'] = coursediv;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEducData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error32) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEducVclLecture(workdiv, year, term, coursediv, coursecode, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'EDUCLECTURE';
    reqData['WORK_DIV'] = workdiv;
    reqData['YEAR'] = year;
    reqData['TERM'] = term;
    reqData['COURSEDIV'] = coursediv;
    reqData['COURSECODE'] = coursecode;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEducData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error33) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEducVclStudent(workdiv, year, term, coursediv, coursecode, lectureno, studName, acceptanceYn, regdiv, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'VCLSTUDENT';
    reqData['WORK_DIV'] = workdiv;
    reqData['YEAR'] = year;
    reqData['TERM'] = term;
    reqData['COURSEDIV'] = coursediv;
    reqData['COURSECODE'] = coursecode;
    reqData['LECTURE_NO'] = lectureno;
    reqData['STUD_NAME'] = studName;
    reqData['ACCEPTANCE_YN'] = acceptanceYn;
    reqData['REG_DIV'] = regdiv;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEducData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error34) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getKojeEducVclBookMarkStudent(workdiv, year, term, coursediv, coursecode, lectureno, studName, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'VCLBOOKMARKSTUDENT';
    reqData['WORK_DIV'] = workdiv;
    reqData['YEAR'] = year;
    reqData['TERM'] = term;
    reqData['COURSEDIV'] = coursediv;
    reqData['COURSECODE'] = coursecode;
    reqData['LECTURE_NO'] = lectureno;
    reqData['STUD_NAME'] = studName;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEducData',
        dataType: "json",
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error35) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getSendLogs(sendername, type, siteid, reqstartdt, reqenddt, deptcode, callBack) {

    $.ajax({
        type: "GET",
        data: {},
        url: MESSAGE_API_URL + '/SendLogs?SenderName=' + sendername + '&SiteID=' + siteid + '&Type=' + type + '&ReqStartDt=' + reqstartdt + '&ReqEndDt=' + reqenddt + '&DeptCode=' + deptcode,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error36) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getSendLog(seq, callBack) {
    $.ajax({
        type: "GET",
        data: {},
        url: MESSAGE_API_URL + '/SendLog/' + seq,
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error37) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function getSendRecipient(id, callBack) {
    $.ajax({
        type: "GET",
        data: {},
        url: MESSAGE_API_URL + '/' + id + '/recipients',
        dataType: "json",
        beforeSend: function beforeSend(xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function success(data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function error(xhr, status, _error38) {
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}

function FileLogsDownload(sendername, type, siteid, reqstartdt, reqenddt, scuessCallBack, errorCallBack) {
    $.ajax({
        type: "POST",
        data: JSON.stringify({ sendername: sendername, type: type, siteid: siteid, reqstartdt: reqstartdt, reqenddt: reqenddt }),
        url: MESSAGE_API_URL + '/download-Log-file',
        cache: false,
        beforeSend: function beforeSend(xhr) {
            authHeaderEx(xhr);
        },
        xhr: function xhr() {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 2) {
                    if (xhr.status == 200) {
                        xhr.responseType = "blob";
                    } else {
                        xhr.responseType = "text";
                    }
                }
            };
            return xhr;
        },
        success: function success(data) {
            if (scuessCallBack) {
                scuessCallBack(data);
            }
        },
        error: function error(xhr, status, _error39) {
            if (errorCallBack) {
                errorCallBack(xhr);
            }
            console.log(xhr);
        },
        always: function always() {
            console.log("always");
        }
    });
}