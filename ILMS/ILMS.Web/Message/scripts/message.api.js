
const SENDER_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/sender';
const DEPT_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/department';
const USERS_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/Users';
const COMMONCODES_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/commoncodes';
const FEE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/feepolicy';
const TPLMESSAGE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/tplmessage';
const TPLKAKAO_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/tplkakao';
const KAKAOCHANNEL_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/kakaochannel';

const AUTHGROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/authgroup';
const CONTACTGROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/contactgroup';
const PERSONALINFO_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/personalinfo';
const LOG_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/log';

const GROUP_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/group';
const MESSAGE_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/message';
const SITES_API_URL = 'https://messagesvc.idino.co.kr/api/v1.0/sites';


const storageUserKey = "msgUser";
const currentMsgUser = () => { return localStorage.getItem(storageUserKey) ? JSON.parse(localStorage.getItem(storageUserKey)) : null; }

const authHeader = function (xhr) {
    let urser = currentMsgUser();
    if (urser && urser.token) {
        xhr.setRequestHeader("Authorization", `Bearer ${urser.token}`);
    }
}
const authHeaderEx = function (xhr) {
    let urser = currentMsgUser();
    if (urser && urser.token) {
        xhr.setRequestHeader("Content-Type", 'application/json');
        xhr.setRequestHeader("Authorization", `Bearer ${urser.token}`);
    }
}

const getCurrentYYYYMM = function(separator = '') {

    let newDate = new Date()
    let month = newDate.getMonth() + 1;
    let year = newDate.getFullYear();

    return `${year}${separator}${month < 10 ? `0${month}` : `${month}`}`
}

function authUser(userID, password, siteID, siteCode, callBack) {
    var reqData = {};
    reqData['userID'] = userID;
    reqData['password'] = password;
    reqData['siteID'] = siteID;
    reqData['siteCode'] = siteCode;
    
    $.ajax({
        type: "POST",
        data: JSON.stringify(reqData),
        url: `${USERS_API_URL}/authenticate`,
        dataType: "json",
        async: false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader("Content-Type", "application/json-patch+json");
        },
        success: function (data) {
            localStorage.setItem(storageUserKey, JSON.stringify(data));
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function createDefaultAuthUser(callBack) {
    if (localStorage.getItem(storageUserKey)) {
        localStorage.removeItem(storageUserKey);
    }

    authUser("dgkim", "rlaehdrbs1!", "D5811F88-011B-4407-A8FD-08D89CCE0858", "koje", callBack);
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
        url: `${USERS_API_URL}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (error == 'Unauthorized') {

            }
        },
        always: function () {
            console.log("always");
        }
    });
}

function getDeptUserInfo(siteid, menuid, callBack) {
    
    $.ajax({
        type: "GET",
        data: {},
        url: `${DEPT_API_URL}/${siteid}/${menuid}/users`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (error == 'Unauthorized') {

            }
        },
        always: function () {
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
        url: `${SENDER_API_URL}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (error == 'Unauthorized') {

            }
        },
        always: function () {
            console.log("always");
        }
    });
}

function getCodeChildInfo(codepid, callBack) {
    
    $.ajax({
        type: "GET",
        data: {},
        url: `${COMMONCODES_API_URL}/child/${codepid}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (error == 'Unauthorized') {

            }
        },
        always: function () {
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
        url: `${FEE_API_URL}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeaderEx(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getFeePolicy() {

    let feePolicy = [];
    let user = currentMsgUser();
    getPolicyAll(user.siteID, getCurrentYYYYMM(''), "Y", function (data) {
        $(data).each(function (index, item) {
            if (item.msgType == "0") {        // SMS
                feePolicy.push("Sms|" + item.fee);
            }
            else if (item.msgType == "1") {  // MMS
                feePolicy.push("Mms|" + item.fee);
            }
            else if (item.msgType == "3") {  // KakaoNotificationTalk
                feePolicy.push("KakaoNotificationTalk|" + item.fee);
            }
            else if (item.msgType == "4") {  // KakaoFriendTalk
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
        url: `${KAKAOCHANNEL_API_URL}/template/${siteid}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getTPLMessage(id, callBack) {
    
    $.ajax({
        type: "GET",
        data: {},
        url: `${TPLMESSAGE_API_URL}/${id}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        url: `${TPLMESSAGE_API_URL}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function sendPost(senderid, userid, request, file, sucessCallBack, failedCallBack) {

    const currentUser = currentMsgUser();
    const formData = new FormData();
    formData.append('SenderId', request.SenderId)
    formData.append('userid', request.UserId)
    formData.append('ApiKey', request.ApiKey)
    formData.append('Message.Id', "")
    formData.append('Message.Type', request.msgType)
    formData.append('Message.Subject', request.Message.subject)
    formData.append('Message.Body', request.Body)
    formData.append('Message.SenderId', request.SenderId)
    formData.append('Message.SenderName', request.Message.SenderName)
    formData.append('Message.SenderNumber', request.Message.SenderNumber)
    formData.append('Message.KakaoTemplateCode', request.Message.kakaoTemplateCode)
    formData.append('Message.KakaoSenderKey', request.Message.KakaoSenderKey)
    formData.append('Message.SiteID', request.Message.SiteID)
    formData.append('Message.Scheduled', request.Message.Scheduled)
    formData.append('Message.file', file)
    var idx = 0;
    request.Message.Recipients.forEach(recipient => {
        formData.append('Message.Recipients[' + idx + '].VariablesData', recipient.variablesdata)
        formData.append('Message.Recipients[' + idx + '].Phone', recipient.Phone)
        idx++;
    });
    var idx2 = 0;
    request.Message.Buttons.forEach(button => {
        formData.append('Message.Buttons[' + idx2 + '].Type', button.type)
        formData.append('Message.Buttons[' + idx2 + '].Name', button.name)
        formData.append('Message.Buttons[' + idx2 + '].LinkUrl1', button.linkUrl1)
        formData.append('Message.Buttons[' + idx2 + '].LinkUrl2', button.linkUrl2)
        formData.append('Message.Buttons[' + idx2 + '].TypeName', button.typeName)
        idx2++;
    });    

    $.ajax({
        type: "POST",
        data: formData,
        url: `${MESSAGE_API_URL}/SendPost`,
        cache: false,
        //enctype: 'multipart/form-data',
        contentType: false,
        processData: false,
        //dataType: "json",
        //async: false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', `Bearer ${currentUser.token}`)
        },
        success: function (data) {
            if (sucessCallBack) {
                sucessCallBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (failedCallBack) {
                failedCallBack(xhr, status, error);
            }
        },
        always: function () {
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
        url: `${MESSAGE_API_URL}/download-file`,
        cache: false,
        xhr: function () {
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
        beforeSend: function (xhr) {
            authHeaderEx(xhr);
        },
        success: function (data) {
            if (sucessedCallBack) {
                sucessedCallBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
            if (failedCallBack) {
                failedCallBack(xhr, status, error);
            }
        },
        always: function () {
            console.log("always");
        }
    });
}

function FileParseService(file, sucessedCallBack, failedCallBack) {
    const currentUser = currentMsgUser();
    const formData = new FormData();
    formData.append('File', file)

    $.ajax({
        type: "POST",
        data: formData,
        url: `${MESSAGE_API_URL}/parse`,
        cache: false,
        contentType: false,
        processData: false,
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', `Bearer ${currentUser.token}`)
        },
        success: function (data) {
            if (sucessedCallBack) {
                sucessedCallBack(data);
            }
        },
        error: function (xhr, status, error) {
            if (failedCallBack) {
                failedCallBack(xhr, status, error);
            }
        },
        always: function () {
            console.log("always");
        }
    });

}


function getGroupService(groupId, callBack) {
    
    $.ajax({
        type: "GET",
        data: {},
        url: `${GROUP_API_URL}/${groupId}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        url: `${GROUP_API_URL}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getKojeOrganizationService(sysgb, callBack) {
    var reqData = {};
    reqData['SysGb'] = sysgb;
    
    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageOrganization',
        dataType: "json",
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getKojeStudentService(serviceOption, callBack) {

    var reqData = {};
    reqData['SysGb'] = serviceOption.SysGb;
    reqData['StayType'] = serviceOption.StayType;
    reqData['OrgID'] = serviceOption.OrgID;
    reqData['StudentNO'] = serviceOption.StudentNO;
    reqData['EnterType'] = serviceOption.EnterType;
    reqData['Gender'] = serviceOption.Gender;
    reqData['Grade'] = serviceOption.Grade;
    reqData['FromDate'] = serviceOption.FromDate;
    reqData['ToDate'] = serviceOption.ToDate;
    reqData['LectureCode'] = serviceOption.LectureCode;
    reqData['Class'] = serviceOption.Class;
    reqData['Year'] = serviceOption.Year;
    reqData['Term'] = serviceOption.Term;
    reqData['FundCode'] = serviceOption.FundCode;
    reqData['ScholarShipCode'] = serviceOption.ScholarShipCode;
    reqData['ScholarShipType'] = serviceOption.ScholarShipType;
    reqData['GraduateYear'] = serviceOption.GraduateYear;
    
    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessagePerson',
        dataType: "json",
        //async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getKojeEmployeeService(orgid, staffState, payRankCode, staffNO, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'EMPLOYEE';
    reqData['OrgID'] = orgid;
    reqData['StaffState'] = staffState;
    reqData['PayRankCode'] = payRankCode;
    reqData['StaffNO'] = staffNO;

    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/MessageEmpData',
        dataType: "json",
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getKojeCommonCodeService(groupCode, callBack) {
    var reqData = {};
    reqData['DataGb'] = 'COMMONCODE';
    reqData['GroupCode'] = groupCode;
    
    $.ajax({
        type: "GET",
        data: reqData,
        url: '/Message/CommonData',
        dataType: "json",
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
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
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getSendLogs(sendername, type, siteid, reqstartdt, reqenddt, deptcode, callBack) {
    
    $.ajax({
        type: "GET",
        data: {},
        url: `${MESSAGE_API_URL}/SendLogs?SenderName=` + sendername +
            `&SiteID=` + siteid +
            `&Type=` + type +
            `&ReqStartDt=` + reqstartdt +
            `&ReqEndDt=` + reqenddt +
            `&DeptCode=` + deptcode,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getSendLog(seq, callBack) {
    $.ajax({
        type: "GET",
        data: {},
        url: `${MESSAGE_API_URL}/SendLog/${seq}`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function getSendRecipient(id, callBack) {
    $.ajax({
        type: "GET",
        data: {},
        url: `${MESSAGE_API_URL}/${id}/recipients`,
        dataType: "json",
        beforeSend: function (xhr) {
            authHeader(xhr);
        },
        async: false,
        success: function (data) {
            if (callBack) {
                callBack(data);
            }
        },
        error: function (xhr, status, error) {
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}

function FileLogsDownload(sendername, type, siteid, reqstartdt, reqenddt, scuessCallBack, errorCallBack) {
    $.ajax({
        type: "POST",
        data: JSON.stringify({ sendername, type, siteid, reqstartdt, reqenddt }),
        url: `${MESSAGE_API_URL}/download-Log-file`,
        cache: false,
        beforeSend: function (xhr) {
            authHeaderEx(xhr);
        },
        xhr: function () {
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
        success: function (data) {
            if (scuessCallBack) {
                scuessCallBack(data);
            }
        },
        error: function (xhr, status, error) {
            if (errorCallBack) {
                errorCallBack(xhr);
            }
            console.log(xhr);
        },
        always: function () {
            console.log("always");
        }
    });
}