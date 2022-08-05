/// <reference path="message.global.js" />
/// <reference path="message.api.js" />
/// <reference path="message.util.js" />

var messageContainer = [];

const msgDeptdata = {
    name: "조직",
    toggled: true,
    deptid: '',
    children: []
};

var $selectEmptyOption = $("<option></option>").attr('key', '').val('').text('선택');

const currentMsgMenuId = function () {
    var t = $($(parent.document).find('.tabs-selected > a > span')[0]).text();
    return t.split('[')[1].split(']')[0];
}

const currentStateContainer = function () {
    let container = JSON.parse(sessionStorage.getItem('messageContainer'));
    let currMenuid = currentMsgMenuId();
    let retObj = {};
    $(container).each(function (i, c) {
        if (c.menuid == currMenuid) {
            retObj = c.container;
        }
    });
    return retObj;
}

function initializeMessageContainer() {
    let state =
    {
        message: '', SysGb: '', modalReciverEl: '#modalDept', modalReviverTableEl: '#modalTblSenderList',
        userID: '', senderID: '', orgReciverSearchObject: [],
        errorMsg: '', lblByte: '',
        users: [], deptUsers: [],
        selectedUsers: [],
        pageOfItems: [],
        pageOfItemsReceiver: [],
        pageOfItemsDept: [],
        msgType: [],
        tplmessage: [],
        subject: '', body: '', messageType: '', tplType: '',
        addName: '', addPhone: '',
        selected: {},
        selectedReceivers: [],
        addCnt: 0,
        msgGroup: [],
        className: '', modal: false, groupmodal: false, deptmodal: false, sendermodal: false, IsChecked: false,
        modalHelpKaFriend: false, modalHelpKaNoti: false, modalHelp: false, variablesmodal: false,
        sender: [],
        selectedSender: '',
        kakaoTplCode: '',
        KakaoSenderKey: '',
        scheduled: '',
        scheduledDateTime: '', minTime: moment().add(10, 'm').toDate(),
        file: null,
        image: null, images: [],
        selectedImageFile: [], selectedImageBase64 : '',
        variables: ["#{이름}", "#{핸드폰번호}", "#{회사}", "#{날짜}"], variableValue: '',
        tplButtons: [], selectedTplButton: [],
        EnableSendImage: false,
        isChkSchedule: false, EnableSchedule: true, isChkAddGroup: false,
        isSelectedNoti: false, isSelectedFri: false,
        groupNM: '', groupDesc: '',
        IsSend: false, siteApiKey: '',
        newVariables: [], inputKey: '', inputImageKey: '',
        sendFee: 0, sendCnt: 0, sendTotal: 0, feePolicy: [],
        cursor: '', prevNode: '',
        menu: '', menuPID: '', menuID: '', menuNM: '', desc: '', lev: '', sort: '',
        isDepts: [],
        inputVariables: '', tmpVariables: [],
    };

    if (sessionStorage.getItem('messageContainer')) {
        messageContainer = JSON.parse(sessionStorage.getItem('messageContainer'));
    }

    let findContainer = messageContainer.find(f => f.menuid == currentMsgMenuId());
    let findContainerIndex = messageContainer.indexOf(findContainer);
    if (findContainerIndex > -1) {
        messageContainer.splice(findContainerIndex, 1);
    }

    messageContainer.push({ menuid: currentMsgMenuId(), container: state });
    sessionStorage.setItem('messageContainer', JSON.stringify(messageContainer));
}

function validateImage(width, height) {

    const stateContainer = currentStateContainer();
    const messageType = stateContainer.messageType;

    const maxWidth = isKakaoTalkType(messageType) ? 720 : 176;
    const maxHeight = isKakaoTalkType(messageType) ? 630 : 144;
    const ratio = height / width;

    if (isKakaoTalkType(messageType)) {
        if (width < 500) {
            alert("가로 500px 이상 크기의 이미지만 첨부 가능합니다.");
            return false;
        }

        if (ratio > 1.5) {
            alert('가로 세로 비율이 1:1.5 이하의 이미지만 첨부 가능합니다.');
            return false;
        }

        if (width > maxWidth || height > maxHeight) {
            alert(`가로 500px 이상, 최대 ${maxWidth}px * ${maxHeight}px 이하 크기의 이미지만 첨부 가능합니다.`);
            return false;
        }

    } else if (messageType === 'Mms') {
        if (width > maxWidth || height > maxHeight) {
            alert(`가로 500px 이상, 최대 ${maxWidth}px * ${maxHeight}px 이하 크기의 이미지만 첨부 가능합니다.`);
            return false;
        }

    }

    return true;
}

function findVariables(argBody, argGubun) {
    let stateContainer = currentStateContainer();

    let variableRegex = /#\{.+?\}/g;
    let results = [];
    let filterItem = [];
    filterItem.push("#{재학생명}");
    filterItem.push("#{대상자명}");
    filterItem.push("#{대출자명}");
    filterItem.push("#{복학대상자명}");
    filterItem.push("#{졸업생명}");
    filterItem.push("#{학번}");

    let filterSystem = [];
    filterSystem.push('student');
    filterSystem.push('hostel');
    filterSystem.push('sugang');
    filterSystem.push('scholarship');

    if (filterSystem.includes(stateContainer.SysGb)) {
        filterItem.push("#{학과명}");
    }

    results.push("#{이름}");
    results.push("#{핸드폰번호}");

    if (argBody !== null && argBody.trim().length > 0) {
        const matchResults = argBody.match(variableRegex);

        if (matchResults !== null && matchResults.length > 0) {
            for (let each of matchResults) {

                let IsExist = false;
                // 기본메세지치환유형 체크
                stateContainer.variables.forEach(vals => {
                    if (each == vals) {
                        IsExist = true;
                    }
                });

                if (argGubun == "content") {

                    // 중복 체크
                    results.forEach(vals => {
                        if (each == vals) {
                            IsExist = true;
                        }
                    });

                    if (!IsExist) {
                        if (each != '#{과목명}') {
                            results.push(each);
                        }
                    }
                }
                else {
                    if (!IsExist) {
                        if (!filterItem.includes(each)) {
                            if (stateContainer.SysGb == 'sugang' && each != '#{과목명}') {
                                results.push(each);
                            }
                            else {
                                results.push(each);
                            }
                        }
                    }
                }
            }
        }
    }

    return results;
}

function setStateRender(prop, val) {

    let stateContainer = currentStateContainer();
    let msgContainer = JSON.parse(sessionStorage.getItem('messageContainer')); 

    if (stateContainer.hasOwnProperty(prop) == true) {

        stateContainer[prop] = val;
        let currmenuid = currentMsgMenuId();
        for (var i in msgContainer) {
            if (msgContainer[i].menuid == currmenuid) {
                msgContainer[i].container = stateContainer;
            }
        }
        sessionStorage.setItem('messageContainer', JSON.stringify(msgContainer));

        switch (prop) {
            case 'msgType':
                renderCboMsgType();
                $("#cboMsgType").val(val ? val : '');
                break;
            case 'tplmessage':
                renderTemplate();
                break;
            case 'subject':
                $("#subject").val(val ? val : '');
                break;
            case 'messageType':
                $("#body").prop('disabled', stateContainer.messageType == "KakaoNotificationTalk" ? true : false)
                break;
            case 'body':
                $("#body").val(val ? val : '');
                break;
            case 'variables':
                $("#smallvariables").text(val);
                break;
            case 'EnableSendImage':
                renderEnableSendImage();
                break;
            case 'lblByte':
                $('#lblByte').text(val ? val : '');
                break;
            case 'newVariables':
                renderNewVariables();
                break;
            case 'inputVariables':
                renderInputVariables();
                break;
            case 'isSelectedNoti':
                renderIsSelectedNoti();
                break;
            case 'images':
                renderImages();
                break;
            case 'selectedTplButton':
                renderSelectedTplButton();
                break;
            case 'sender':
                renderSender();
                break;
            case 'file':
                renderFile();
                break;
            case 'isChkSchedule':
                renderIsChkSchedule();
                break;
            case 'EnableSchedule':
                renderEnableSchedule();
                break;
            case 'scheduledDateTime':
                renderScheduledDateTime();
                break;
            case 'errorMsg':
                renderlblErrorMsg();
                break;
            case 'selectedUsers':
                renderSelectedUsers();
                break;
            case 'pageOfItemsReceiver':
                renderPageOfItemsReceiver();
                break;
            case 'modalHelp':
                renderModalHelp();
                break;
            case 'pageOfItemsDept':
                renderPageOfItemsDept();
                break;
            case 'selectedImageFile':
                renderSelectedImageFile();
                break;
            case 'users':
                renderUsers();
                break;
            case 'isSelectedFri':
                renderIsSelectedFri();
                break;
            default:
                break;
        }
    }
}


function renderUsers() {

}

function renderSelectedImageFile() {
    let stateContainer = currentStateContainer();
    $('#selectedImageFileLabel')
        .text(stateContainer.selectedImageFile.length === 0 ? '파일 선택' : stateContainer.selectedImageFile.name);
}

function renderPageOfItemsDept() {
    let stateContainer = currentStateContainer();
    let $tbody = $(stateContainer.modalReviverTableEl + '> tbody');
    $tbody.empty();

    if (!stateContainer.pageOfItemsDept || stateContainer.pageOfItemsDept.length <= 0) {

        let colspan = 4;

        if (stateContainer.SysGb == 'entrmajor' || stateContainer.SysGb == 'entrindividual') {
            colspan = 5;
        }
        else if (stateContainer.SysGb == 'student') {
            colspan = 6;
        }

        $tbody.append(
            $('<tr></tr>')
                .append($('<td></td>')
                    .attr('colspan', colspan)
                    .attr('align', 'center')
                    .append('<b>조직원 정보가 없습니다.<b/>'))
        );
    }
    else {
        stateContainer.pageOfItemsDept.forEach(users => {
            let $tr = $('<tr></tr>');
            let $th = $('<th></th>');
            let $input = $('<input />').attr('type', 'hidden');
            let $checkbox = $('<input/>')
                .attr('type', 'checkbox')
                .attr('name', 'chkSender')
                .val(users.user.userID + "|" + users.user.userName + "|" + users.user.phone)
                .prop('disabled', users.isDisabled);
            $th.append($checkbox);
            $tr.append($th);
            $tr.append($('<td></td>').text(users.user.userID));
            $tr.append($('<td></td>').text(users.user.userName));
            if (users.user.MajorName) {
                $tr.append($('<td></td>').text(users.user.MajorName));
            }
            if (stateContainer.SysGb == 'student') {
                if (users.user.orgName) {
                    $tr.append($('<td></td>').text(users.user.orgName));
                }
                if (users.user.Grade) {
                    $tr.append($('<td></td>').text(users.user.Grade));
                }
            }

            $tr.append($('<td></td>').text(users.user.phone));
            $tbody.append($tr);
        });
    }
}

function renderCboMsgType() {
    let stateContainer = currentStateContainer();
    $("#cboMsgType").empty();
    $("#cboMsgType").append($selectEmptyOption);
    $(stateContainer.msgType).each(function (index, type) {
        $("#cboMsgType").append($(`<option key="${type.code}" value="${type.code}">${type.codeNM}</option>`));
    })
}

function renderTemplate() {
    let stateContainer = currentStateContainer();
    $("#template").empty();
    $("#template").append($selectEmptyOption);
    $(stateContainer.tplmessage).each(function (index, tpl) {
        let $option = $('<option></option>');
        $option.val(tpl.content + "|" + tpl.id + "|" + tpl.senderkey).text(tpl.name);
        $("#template").append($option);
    })
}

function renderEnableSendImage() {
    let stateContainer = currentStateContainer();
    if (stateContainer.EnableSendImage == true) {
        $('#divSendImage').css('display', 'block');
    }
    else {
        $('#divSendImage').css('display', 'none');
    }
    framResize();
}

function framResize() {
    if (window.parent && window.parent.resizeTabPanel) {

        var height_form = $(document).height();

        window.parent.resizeTabPanel({
            'width': $(document).width() - 288,
            'height': height_form
        });
    }
}



function renderNewVariables() {
    let stateContainer = currentStateContainer();

    $('#divNewVariablesModal').empty();
    if (stateContainer.newVariables.length > 0) {
        $('#divnewVariables').css('display', 'block');
    }
    else {
        $('#divnewVariables').css('display', 'none');
    }
    $(stateContainer.newVariables).each(function (idx, variable) {
        let $div = $('<div></div>').attr('key', idx).css('padding-bottom', '5px');
        let $label = $('<label></label>').text(variable.val);
        let $input = $('<input/>')
            .attr('key', idx)
            .attr('id', variable.id)
            .attr('name', variable.id)
            .attr('onchange', 'onChangeVariable(event)')
            .attr('class', 'form-control-sm form-control')
            .val(variable.text ? variable.text : '');
        $div.append($label).append($input);
        $('#divNewVariablesModal').append($div);
    });
    framResize();
}

function renderInputVariables() {
    let stateContainer = currentStateContainer();
    $('#btnVariablesModal').text(stateContainer.inputVariables != '' ? '재입력' : '입력');
    $('#inputVariables').val(stateContainer.inputVariables);
}

function renderIsSelectedNoti() {
    let stateContainer = currentStateContainer();
    if (stateContainer.isSelectedNoti == true) {
        $('#divNotiTalk').css('display', 'block');
    }
    else {
        $('#divNotiTalk').css('display', 'none');
    }
    framResize();
}

function renderIsSelectedFri() {
    let stateContainer = currentStateContainer();
    if (stateContainer.isSelectedFri == true) {
        $('#divFirendTalk').css('display', 'block');
    }
    else {
        $('#divFirendTalk').css('display', 'none');
    }
    framResize();
}

function renderImages() {
    let stateContainer = currentStateContainer();
    $('#divImages').empty();
    $(stateContainer.images).each(function (i, img) {
        let $div = $('<div></div>').attr('key', i);
        let $button = $('<button></button>').attr('type', 'button').attr('class', 'close').attr('aria-label', 'Close');
        let $span = $('<span><sapn>').attr('aria-hidden', 'true').html('&times;');
        let $img = $('<img />').attr('src', (img.data !== undefined && img.data !== null) ? img.data : img.url);
        $img.on('load', function (e) {
            const { naturalWidth, naturalHeight } = e.currentTarget;
            if (validateImage(naturalWidth, naturalHeight) === false) {
                setStateRender('images', []);
                setStateRender('selectedImageFile', []);
            }
        });
        $button.append($span);
        $button.on('click', function (e) {
            e.preventDefault();
            setStateRender('images', []);
            setStateRender('selectedImageFile', []);
        });
        $div.append($button);
        $div.append($img);
        $('#divImages').append($div);

        //$('#divImages').append($.parseHTML(`
        //    <div key=${i} class="text-center mb-3">
        //        <button click="handleRemovePicture(event, ${i})" type="button" class="close" aria-label="Close">
        //            <span aria-hidden="true">&times;</span>
        //        </button>
        //        <img src="${(img.data !== undefined && img.data !== null) ? img.data : img.url}" onload="handleImageLoaded(event, ${i})" class="img-fluid mr-1" />
        //    </div>
        //`));
    });
}

function renderSelectedTplButton() {
    let stateContainer = currentStateContainer();
    $('#divSelectedTplButtons').empty();
    $(stateContainer.selectedTplButton).each(function (i, b) {
        $('#divSelectedTplButtons').append($.parseHTML(`
             <div key=${i} className="list-group mb-1">
                <div class="list-group-item list-group-item-action">
                    <div class="d-flex w-100 justify-content-between mb-2">
                        <div><span class="badge badge-secondary">${b.type}</span> ${b.name}</div>
                            <small click="handleClickRemoveButton(${i})">X</small>
                        </div>
                        <small class="font-weight-light d-block"><span class="font-weight-bold mr-1">Link URL #1</span> ${b.linkUrl1}</small>
                        <small class="font-weight-light d-block"><span class="font-weight-bold mr-1">Link URL #2</span> ${b.linkUrl2}</small>
                </div>
             </div>
        `));
    });
}

function renderSender() {
    let stateContainer = currentStateContainer();
    $("#sender").empty();
    $("#sender").append($selectEmptyOption);
    $(stateContainer.sender).each(function (index, sender) {
        let val = sender.id + '|' + sender.senderId + '|' + sender.senderNm + '|' + sender.senderNo;
        let text = `${sender.senderNm}(${sender.senderNo})`;
        let $option = $('<option></option>').val(val).text(text);
        $("#sender").append($option);
    });
}

function renderFile() {
    let stateContainer = currentStateContainer();
    if (stateContainer.file == null) {
        $("#lblFileSelect").text('파일 선택');
    }
    else {
        $("#lblFileSelect").text(stateContainer.file.name);
    }
}

function renderIsChkSchedule() {
    let stateContainer = currentStateContainer();
    $('#chkSchedule').prop('checked', stateContainer.isChkSchedule);
}

function renderEnableSchedule() {
    let stateContainer = currentStateContainer();
    $("#txtscheduledDate").prop('disabled', stateContainer.EnableSchedule);
    $("#scheduledTime").prop('disabled', stateContainer.EnableSchedule);
    $("#scheduledMinutes").prop('disabled', stateContainer.EnableSchedule);
}

function renderScheduledDateTime() {
    let stateContainer = currentStateContainer();
    if (stateContainer.scheduledDateTime !== '') {
        $('#divResetSchedule').show();
        $("#txtscheduledDate").val(stateContainer.scheduledDateTime.split(' ')[0]);
        $("#scheduledTime").val(stateContainer.scheduledDateTime.split(' ')[1].split(':')[0]);
        $("#scheduledMinutes").val(stateContainer.scheduledDateTime.split(' ')[1].split(':')[1]);
    }
    else {
        $("#txtscheduledDate").val('');
        $("#scheduledTime").val('00');
        $("#scheduledMinutes").val('00');
        $('#divResetSchedule').hide();
    }
    framResize();
}

function renderlblErrorMsg() {
    let stateContainer = currentStateContainer();
    $('#lblErrorMsg').text(stateContainer.errorMsg);
}

function renderSelectedUsers() {
    let stateContainer = currentStateContainer();
    $('#strngTotalCount').text(stateContainer.selectedUsers.length);
}

function renderPageOfItemsReceiver() {
    let stateContainer = currentStateContainer();
    $('#tblReceiver > tbody').empty();
    if (!stateContainer.pageOfItemsReceiver || stateContainer.pageOfItemsReceiver.length <= 0) {
        let $firstRow = $('<tr></tr>');
        if (stateContainer.IsSend) {
            $firstRow.append($(`<td colspan="5" align="center" style="color:blue"><b>메세지 전송중입니다.</b></td>`));
        }
        else {
            $firstRow.append($(`<td colspan="5" align="center"><b>선택된 사용자가 없습니다.</b></td>`));
        }
        $('#tblReceiver > tbody').append($firstRow);
    }
    else {
        $(stateContainer.pageOfItemsReceiver).each(function (idx, users) {
            let key = users.userID;
            let id = users.userID;
            let name = users.userName;
            let phone = users.phone;
            let variables = users.variables;
            let selected = stateContainer.selected[users.userID];
            let ismobile = users.ismobile;

            let $row = $('<tr></tr>');
            let $tdChk = $('<td></td>');
            let $chkBox = $('<input/>')
                .attr('name', id)
                .attr('id', "chkReceiver" + id)
                .attr('type', 'checkbox')
                .attr('checked', selected)
                .val(id + "|" + name + "|" + phone + "|" + variables);
            $chkBox.on('change', handleSelect);
            $tdChk.append($chkBox);
            let $tdName = $('<td></td>').text(name);
            let $tdPhone = $('<td></td>').text(phone);
            let $tdVariables =
                $('<td></td>')
                    .attr('class', 'ellipsis')
                    .css('text-align', 'left')
                    .append($('<span></sapn>').text(variables.replace("#{-},-", "")));
            let $tdMobile = $('<td></td>').text(!ismobile ? '휴대폰번호 확인 필요!' : '');
            $row.append($tdChk);
            $row.append($tdName);
            $row.append($tdPhone);
            $row.append($tdVariables);
            //$row.append($tdMobile);
            $('#tblReceiver > tbody').append($row);
        });
    }
}

function renderModalHelp() {
    let stateContainer = currentStateContainer();
    if (stateContainer.modalHelp == true) {
        $('#modalContactHelp').modal('show');
    }
    else {
        $('#modalContactHelp').modal('hide');
    }
}

function handleSelect(event) {
    let stateContainer = currentStateContainer();
    const selected = stateContainer.selected;
    selected[event.target.name] = event.target.checked;

    if (stateContainer.selectedReceivers.find(f => f == event.target.value)) {
        let findIndex = stateContainer.selectedReceivers.indexOf(event.target.value);
        if (findIndex > -1) {
            stateContainer.selectedReceivers.splice(findIndex, 1);
        }
    }
    else {
        stateContainer.selectedReceivers.push(event.target.value);
    }
    let secUsers = stateContainer.selectedReceivers;
    setStateRender('selected', selected);
    setStateRender('selectedReceivers', secUsers);
}

function onCheckAll(e) {
    let stateContainer = currentStateContainer();
    if (e.target.checked) {
        $('[name=chkSender]').each(function () {
            if (!$(this)[0].disabled) {
                $(this)[0].checked = true;
            }
        });
    }
    else {
        $('[name=chkSender]').each(function () {
            $(this)[0].checked = false;
        });
    }
}

function onCheckAllReceiver(e) {
    let stateContainer = currentStateContainer();

    var checkedSender = [];
    if (e.target.checked) {
        $('[id^=chkReceiver]').each(function () {
            $(this)[0].checked = true;
            checkedSender.push($(this).val());
        });
    }
    else {
        $('[id^=chkReceiver]').each(function () {
            $(this)[0].checked = false;
        });
    }

    //$(checkedSender).each(function (idx, item) {
    //    var selectedUser = item.split('|');
    //    //console.log(selectedUser)
    //    InitReceiver(selectedUser[0] + "|" + selectedUser[1] + "|" + selectedUser[2] + "|" + selectedUser[3]);
    //});

    let addedCount = stateContainer.addCnt;
    let selUser = stateContainer.selectedReceivers;
    let selected = stateContainer.selected;
    let selectedUsers = [];

    for (var i = 0; i < checkedSender.length; i++) {
        if (!selUser[checkedSender[i]]) {
            selUser.push(checkedSender[i]);
            addedCount++;
        }
    }

    setStateRender('addCnt', addedCount);
    setStateRender('selectedReceivers', checkedSender);

    if (checkedSender.length == 0) {
        setStateRender('selectedReceivers', []);
    }
}

// 전송할 사용자 리스트
function InitReceiver(val) {
    let stateContainer = currentStateContainer();

    if (stateContainer.selectedReceivers.length > 0) {
        let findObj = stateContainer.selectedReceivers.find(f => {
            if (f.split('|')[1] == val.split('|')[1] && f.split('|')[2] == val.split('|')[2]) {
                return val;
            }
            else {
                return null;
            }
        });

        if (findObj) {
            let findIndex = stateContainer.selectedReceivers.indexOf(findObj);
            if (findIndex > -1) {
                stateContainer.selectedReceivers.splice(findIndex, 1);
            }

            //alert(findObj.split('|')[1] + '-' + findObj.split('|')[2] + ' (은)는 이미 추가 되었습니다.');
            //return;
        }
        else {
            stateContainer.selectedReceivers.push(val);
            let recuser = stateContainer.selectedReceivers;
            setStateRender('addCnt', stateContainer.addCnt + 1);
            setStateRender('selectedReceivers', recuser);
        }
    }
    else {
        stateContainer.selectedReceivers.push(val);
        let recuser = stateContainer.selectedReceivers;
        setStateRender('addCnt', stateContainer.addCnt + 1);
        setStateRender('selectedReceivers', recuser);
    }
}

function onInitContents() {
    setStateRender('body', '');
    setStateRender('lblByte', '');
    setStateRender('KakaoSenderKey', '');
    setStateRender('kakaoTplCode', '');
    setStateRender('tplButtons', []);
    setStateRender('selectedTplButton', []);
    setStateRender('newVariables', []);
    setStateRender('inputVariables', []);
    setStateRender('sendFee', 0);
    setStateRender('isSelectedFri', false);
    setStateRender('isSelectedNoti', false);
    setStateRender('tplmessage', []);
}

function onSelectStatus(e) {
    let stateContainer = currentStateContainer();
    let user = currentMsgUser();

    setStateRender('messageType', e.target.value);

    // 초기화
    onInitContents();

    var messageType = e.target.value;

    if (messageType == "") return;

    // 도움말 띄우기
    if (messageType == "KakaoFriendTalk") {
        // this.toggleHelpModalKaFriend() 
        setStateRender('isSelectedFri', true);
    }
    if (messageType == "KakaoNotificationTalk") {
        // this.toggleHelpModalKaNoti() 
        setStateRender('isSelectedNoti', true);
    }

    setStateRender('EnableSendImage', false);

    if (messageType == "Mms" || messageType == "KakaoFriendTalk") {
        setStateRender('EnableSendImage', true);
    }
    setStateRender('KakaoSenderKey', user.site.kakaosenderKey);

    // 총 발송 비용
    //onSendFee(messageType);

    // 내용 템플릿
    onSetTemplate(messageType);
}

function onSetTemplate(messageType) {
    let stateContainer = currentStateContainer();
    let user = currentMsgUser();
    setStateRender('subject', "[" + messageType + "] 메세지전송");

    var tmpTpl = [];

    if (isKakaoTalkType(messageType)) {

        getKakaoChannelTemplate(user.siteID, messageType, function (tpl) {
            var tmpTplButtons = [];
            $(tpl).each(function (index, item) {
                if (messageType == "KakaoNotificationTalk") {

                    // 승인처리된 카카오 알림톡
                    if (item.status == "Y") {
                        tmpTpl.push({ id: item.templateId, content: item.content + "|" + item.code, name: item.name, senderkey: item.kakaoChannelModel.kakaoSenderKey });
                    }
                }
                else {
                    tmpTpl.push({ id: item.templateId, content: item.content, name: item.name, senderkey: item.kakaoChannelModel.kakaoSenderKey });

                    if (stateContainer.messageType == "KakaoFriendTalk") {
                        // this.setState({tplButtons: item.buttons});
                        tmpTplButtons.push(item.buttons)
                    }
                }
            });

            setStateRender('tplButtons', tmpTplButtons);

            if (tpl.length == 0) {
                setStateRender('tplmessage', tpl);
            }
            else {
                setStateRender('tplmessage', tmpTpl);
            }
        });
    }
    else {
        getTPLMessages(user.siteID, '', messageType, function (tpl) {
            setStateRender('tplmessage', tpl);
        });
    }
}

function onSelectSender(e) {
    setStateRender('selectedSender', e.target.value);
}

function onSelectTpl(e) {
    let stateContainer = currentStateContainer();
    var selectVal = e.target.value;
    var tplCode = "";
    setStateRender('selectedTplButton', []);

    if (selectVal != "") {

        if (stateContainer.messageType == "KakaoNotificationTalk") {
            tplCode = selectVal.split('|')[1];
            setStateRender('KakaoSenderKey', selectVal.split('|')[3]);
        }

        var selectedTplBun = [];
        if (stateContainer.messageType == "KakaoFriendTalk") {

            $(stateContainer.tplButtons).each(function (index, button) {
                if (button.length > 0) {
                    $(button).each(function (index, item) {
                        if (item.templateId == selectVal.split('|')[1]) {
                            selectedTplBun.push(item);
                        }
                    });
                }
            });

            setStateRender('selectedTplButton', selectedTplBun);
            setStateRender('KakaoSenderKey', selectVal.split('|')[2]);
        }

        setStateRender('body', selectVal.split('|')[0]);
        setStateRender('tplType', selectVal.split('|')[0]);
        setStateRender('kakaoTplCode', tplCode);

        // 신규 메세지치환유형 체크
        setNewVariable(selectVal.split('|')[0]);
    }
    else {
        setStateRender('KakaoSenderKey', '');
        setStateRender('selectedTplButton', []);
        setStateRender('body', '');
        setStateRender('tplType', '');
        setStateRender('kakaoTplCode', tplCode);
        setStateRender('newVariables', []);
        setStateRender('inputVariables', '');
    }

    if (stateContainer.messageType == "Sms") {
        fnChkByte(e, '80');
    }
}

function onHelpClick(e) {
    e.preventDefault();
    toggleHelpModal();
}

function toggleHelpModal() {
    let stateContainer = currentStateContainer();
    setStateRender('modalHelp', !stateContainer.modalHelp)
}

function fnChkByte(e, maxByte) {
    let stateContainer = currentStateContainer();
    var obj = e.target;
    var str = obj.value.split('|')[0];
    var str_len = str.length;
    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";

    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
        if (escape(one_char).length > 4) {
            rbyte += 2;   // 한글2Byte
        }
        else {
            rbyte++;     // 영문 등 나머지 1Byte
        }
        if (rbyte <= maxByte) {
            rlen = i + 1; // return할 문자열 갯수
        }
    }

    if (stateContainer.messageType == "Sms") {

        if (rbyte > maxByte) {
            // alert("메세지는 최대 " + maxByte + "byte를 초과할 수 없습니다.")
            // str2 = str.substr(0, rlen);
            // obj.value = str2;
            // this.setState({body: str2});
            // this.fnChkByte(e, maxByte);                

            // 80byte 초과시, 자동으로 MMS로 전환. 2020-11-26

            setStateRender('messageType', 'Mms');

            onSetTemplate('Mms');
            setStateRender('EnableSendImage', true);

            setStateRender('lblByte', 'MMS로 자동전환되었습니다. (80byte초과)');
        }
        else {
            setStateRender('lblByte', rbyte + " / " + maxByte + "byte");
        }
    }

    setNewVariable(str);
}

function setNewVariable(msgbody) {
    let stateContainer = currentStateContainer();
    // variables
    let newVariables = []
    let cnt = 0;
    let msgBodyVariables = findVariables(msgbody, '');

    $(msgBodyVariables).each(function (index, variable) {
        let IsExist = false;
        $(stateContainer.variables).each(function (index, item) {
            if (item == variable) {
                IsExist = true;
            }
        });

        if (!IsExist) {
            newVariables.push({ id: "val_" + cnt, val: variable, text: '' });
            cnt++;
        }
    });

    setStateRender('newVariables', newVariables)

    return newVariables;
}

function onChange(e) {
    setStateRender(e.target.name, e.target.value);
}

function onChangeVariable(e) {
    e.preventDefault();
    setStateRender(e.target.name, e.target.value);
}

function variablesCheck(e) {

    let stateContainer = currentStateContainer();
    let strMessage = "";
    let InputCheck = true;
    stateContainer.newVariables.forEach(item => {
        if ($("#" + item.id).val() == "") {
            strMessage += ((strMessage == "") ? "" : ", ") + item.val;
            //alert(item.val + " 를 입력해주세요.");
            if (InputCheck) {
                $("#" + item.id).focus();
            }
            InputCheck = false;
        }
    });

    if (!InputCheck) {
        alert(strMessage + " 를 입력해주세요.");
        return;
    }

    if (InputCheck) {
        let variablesName = "";
        let tmpVariables = [];
        stateContainer.newVariables.forEach(item => {
            variablesName = variablesName + item.val + "," + $("#" + item.id).val() + ";";
            tmpVariables.push({ id: item.id, val: item.val, text: $("#" + item.id).val() });
        });
        variablesName = variablesName.substring(0, variablesName.length - 1);

        setStateRender('inputVariables', variablesName);
        setStateRender('tmpVariables', tmpVariables);

        $('#variablesmodal').modal('hide');
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
    }
}

function onDeptUserBind(deptcode) {
    //let stateContainer = currentStateContainer();
    //let curruser = currentMsgUser();
    //let siteid = curruser.siteID;

    //if (!deptcode || deptcode == "") {

    //    var approvaluse = "Y";
    //    getUserAll(siteid, approvaluse, '', '', function (users) {
    //        let tmpUser = []
    //        users.forEach(user => {
    //            let isChecked = false;
    //            var receivers = Array.from(stateContainer.selectedReceivers);
    //            receivers.forEach((receiver, idx) => {
    //                if (receiver.split('|')[0] == user.userID) {
    //                    isChecked = true;
    //                }
    //            });

    //            tmpUser.push({ user: user, isDisabled: isChecked });
    //        });

    //        setStateRender('deptUsers', tmpUser);
    //        setStateRender('pageOfItemsDept', tmpUser);

    //    });
    //}
    //else {
    //    getDeptUserInfo(siteid, deptcode, function (users) {
    //        let tmpUser = []
    //        users.forEach(user => {
    //            let isChecked = false;
    //            var receivers = Array.from(stateContainer.selectedReceivers);
    //            receivers.forEach((receiver, idx) => {
    //                if (receiver.split('|')[0] == user.userID) {
    //                    isChecked = true;
    //                }
    //            });

    //            tmpUser.push({ user: user, isDisabled: isChecked });
    //        });

    //        setStateRender('deptUsers', tmpUser);
    //        setStateRender('pageOfItemsDept', tmpUser);
    //    });
    //}
}

function showDeptModal(e) {
    e.preventDefault();
    let stateContainer = currentStateContainer();

    if (stateContainer.messageType == '') {
        alert("메세지 유형을 선택하시기 바랍니다.");
        return false;
    }

    if (stateContainer.messageType == 'KakaoNotificationTalk' && $('#template').val().length == 0) {
        alert("내용 템플릿을 선택하시기 바랍니다.");
        return false;
    }

    // 메세지치환유형 확인
    if (stateContainer.inputVariables == "" && stateContainer.newVariables != '') {
        alert("메세지치환 정보가 필요합니다.");
        //hideModal(stateContainer.modalReciverEl);
        $('#variablesmodal').modal('show');
        return false;
    }

    $(stateContainer.modalReciverEl).modal('show');
}

function hideModal(modal) {
    $(modal).modal('hide');
    $('body').removeClass('modal-open');
    $('.modal-backdrop').remove();
}

function onSelectDeptUser(obj) {

    const findUserIndex = function (container, userID) {
        return container.pageOfItemsDept.findIndex(f => f.user.userID === userID);
    }

    let stateContainer = currentStateContainer();

    // 메세지치환유형 확인
    if (stateContainer.inputVariables == "" && stateContainer.newVariables != '') {
        alert("메세지치환 정보가 필요합니다.");
        hideModal(stateContainer.modalReciverEl);
        $('#variablesmodal').modal('show');
        return;
    }

    let variables = "#{-},-";
    if (stateContainer.newVariables != '') {
        variables = stateContainer.inputVariables;
    }
    var checkedSender = [];
    $('[name=chkSender]:checked').each(function () {
        checkedSender.push($(this).val() + '|' + variables);
    });

    if (checkedSender.length == 0) {
        alert("항목을 선택하세요.");
        return;
    }

    if (parent.startSpin) {
        parent.startSpin();
    }

    let addedCount = stateContainer.addCnt;
    let selUser = stateContainer.selectedReceivers;
    let selected = stateContainer.selected;
    let selectedUsers = [];

    for (var i = 0; i < checkedSender.length; i++) {
        if (!selUser[checkedSender[i]]) {

            selUser.push(checkedSender[i]);
        }
    }

    for (var i = 0; i < selUser.length; i++) {

        selectedUsers.push({
            userID: selUser[i].split('|')[0],
            userName: selUser[i].split('|')[1],
            phone: selUser[i].split('|')[2],
            ismobile: fnIsMobile(selUser[i].split('|')[2]),
            orgName: stateContainer.pageOfItemsDept[findUserIndex(stateContainer, selUser[i].split('|')[0])].user.hasOwnProperty('orgName') ?
                stateContainer.pageOfItemsDept[findUserIndex(stateContainer, selUser[i].split('|')[0])].user.orgName : '',
            lectureName: stateContainer.pageOfItemsDept[findUserIndex(stateContainer, selUser[i].split('|')[0])].user.hasOwnProperty('lectureName') ?
                stateContainer.pageOfItemsDept[findUserIndex(stateContainer, selUser[i].split('|')[0])].user.lectureName : '',
            variables: selUser[i].split('|')[3]
        });
        selected[selUser[i].split('|')[0]] = true;
        addedCount++;
    }

    setStateRender('selected', selected);
    setStateRender('selectedUsers', selectedUsers);
    setStateRender('pageOfItemsReceiver', selectedUsers);

    setStateRender('addCnt', addedCount);
    setStateRender('selectedReceivers', selUser);

    ////SetReceiverList();

    $('[name=chkSender]:checked').each(function () {
        $(this)[0].disabled = true;
        $(this)[0].checked = false;
    });

    if (parent.stopSpin) {
        parent.stopSpin();
    }

    hideModal(stateContainer.modalReciverEl);
}


function fn_validation_add() {
    let stateContainer = currentStateContainer();

    if (stateContainer.addName == "") {
        alert("성명을 입력하세요.");
        document.getElementById("addName").focus();
        return false;
    }
    if (stateContainer.addPhone == "") {
        alert("휴대폰 번호를 입력하세요.");
        document.getElementById("addPhone").focus();
        return false;
    }

    if (!fnIsMobile(stateContainer.addPhone)) {
        alert("휴대폰 번호가 유효하지 않습니다.");
        document.getElementById("addPhone").focus();
        return false;
    }

    return true;
}

function showModalContactAdd(e) {
    e.preventDefault();
    $('#modalContactAdd').modal('show');
}

function onAddReceiver(e) {
    e.preventDefault();

    let stateContainer = currentStateContainer();

    // 메세지치환유형 확인
    if (stateContainer.inputVariables == "" && stateContainer.newVariables != '') {
        alert("메세지치환 정보가 필요합니다.");
        $('#variablesmodal').modal('show');
        return;
    }

    if (!fn_validation_add()) return;

    var addID = "anonymousid_" + stateContainer.addCnt;

    const selected = stateContainer.selected;
    selected[addID] = true;
    setStateRender('selected', selected);

    let variables = "#{-},-";
    if (stateContainer.newVariables != '') {
        variables = stateContainer.inputVariables;
    }

    InitReceiver(addID + "|" + stateContainer.addName + "|" + stateContainer.addPhone + "|" + variables);
    SetReceiverList();

    setStateRender('addName', '');
    setStateRender('addPhone', '');
}

function SetReceiverList() {

    let stateContainer = currentStateContainer();

    const selected = stateContainer.selected;
    var selectedUsers = [];

    var receivers = Array.from(stateContainer.selectedReceivers);

    // if(receivers.length > 20){
    //     alert("연락처 20명 초과시, [대량 전송] 메뉴에서 전송바랍니다.");
    //     return;
    // }

    receivers.forEach((receiver, idx) => {

        let IsMobile = true;
        if (!fnIsMobile(receiver.split('|')[2])) {
            IsMobile = false;
        }

        selectedUsers.push({
            userID: receiver.split('|')[0], userName: receiver.split('|')[1], phone: receiver.split('|')[2], ismobile: IsMobile
            , variables: receiver.split('|')[3]
        });
        selected[receiver.split('|')[0]] = true;
        setStateRender('selected', selected);

    });

    setStateRender('selectedUsers', selectedUsers);
    setStateRender('pageOfItemsReceiver', selectedUsers);
    setStateRender('sendCnt', selectedUsers.length);

    // 총 발송 비용
    setStateRender('sendTotal', (stateContainer.sendFee * selectedUsers.length));
}

// 양식 다운로드
function handleClickDownloadFile(e, fileType) {

    e.preventDefault();

    let stateContainer = currentStateContainer();

    if (stateContainer.selectedSender == "") {
        alert("발신자를 선택해주세요.");
        document.getElementById("sender").focus();
        return;
    }

    let senderNo = stateContainer.selectedSender.split('|')[3];

    let variables = findVariables(stateContainer.body, '');
    let fileName = 'recipients.xlsx';

    FileDownLoadService(senderNo, 'Sms', fileType, variables
        , function (data) {
            //Convert the Byte Data to BLOB object.
            var blob = new Blob([data], { type: "application/octetstream" });

            //Check the Browser type and download the File.
            var isIE = false || !!document.documentMode;
            if (isIE) {
                window.navigator.msSaveBlob(blob, fileName);
            } else {
                var url = window.URL || window.webkitURL;
                link = url.createObjectURL(blob);
                var a = $("<a />");
                a.attr("download", fileName);
                a.attr("href", link);
                $("body").append(a);
                a[0].click();
                $("body").remove(a);
            }
        }
        , function (xhr, status, error) {
            alert('파일을 다운로드 할 수 없습니다. 문제가 계속되면 관리자에게 문의하시기 바랍니다.');
            console.error(error);
        });
}

// 양식 업로드
function handleClickSelectFile(e) {

    let stateContainer = currentStateContainer();

    const { files } = e.target;

    if (files !== null && files.length > 0) {
        setStateRender('file', files[0]);
        setStateRender('inputKey', Date.now());
    }

    if (files[0] === null) {
        alert("선택된 파일 정보가 존재하지 않습니다.");
        return;
    }

    setStateRender('selectedReceivers', []);

    FileParseService(files[0]
        , function (data) {
            let IRecipient = data.result;

            const selected = stateContainer.selected;
            var selectedUsers = [];

            IRecipient.forEach((recipient, idx) => {

                var addID = "recipientid_" + idx;

                let IsMobile = true;
                if (!fnIsMobile(recipient.variables[1].value)) {
                    IsMobile = false;
                }

                let variables = "";
                if (recipient.variables.length > 2) {
                    // 기본메세지치환유형 외 처리
                    recipient.variables.forEach((item, idx) => {
                        if (idx > 1) {
                            variables = variables + item.name + "," + item.value + ";";
                        }
                    });

                    variables = variables.substring(0, variables.length - 1);
                }
                else {
                    variables = "#{-},-";
                }

                selectedUsers.push({
                    userID: addID, userName: recipient.variables[0].value, phone: recipient.variables[1].value, ismobile: IsMobile
                    , variables: variables
                });
                selected[addID] = true;

                InitReceiver(addID + "|" + recipient.variables[0].value + "|" + recipient.variables[1].value + "|" + variables);
                setStateRender('selected', selected);

            });

            SetReceiverList();
            setStateRender('selectedUsers', selectedUsers);
            setStateRender('file', '');
        }
        , function (xhr, status, error) {
            console.error(error);
            alert('수신자 파일을 해석할 수 없습니다. 문제가 계속 될 경우 관리자에게 문의하세요.');
        });

}

function handleClickDeleteScheduled() {
    setStateRender('scheduledDateTime', '');
}

function scheduleChecked(e) {

    let stateContainer = currentStateContainer();

    const target = e.target;

    if (target.checked) {
        setStateRender('EnableSchedule', false);
    }
    else {
        setStateRender('EnableSchedule', true);
    }
    setStateRender('isChkSchedule', target.checked);
}

function onScheduledDateChange(e) {
    let date = $("#txtscheduledDate").val();
    let time = $("#scheduledTime").val();
    let mm = $("#scheduledMinutes").val();

    if (date.length == 10 && time.length == 2 && mm.length == 2) {
        if (time != '00') {
            let datetimeval = `${date} ${time}:${mm}`;
            setStateRender('scheduledDateTime', datetimeval);
        }
    }
}

function onScheduledTimeChange(e) {
    let date = $("#txtscheduledDate").val();
    let time = $("#scheduledTime").val();
    let mm = $("#scheduledMinutes").val();

    if (date.length == 10 && time.length == 2 && mm.length == 2) {
        if (time != '00') {
            let datetimeval = `${date} ${time}:${mm}`;
            setStateRender('scheduledDateTime', datetimeval);
        }
    }
}

function onScheduledMMChange(e) {
    let date = $("#txtscheduledDate").val();
    let time = $("#scheduledTime").val();
    let mm = $("#scheduledMinutes").val();

    if (date.length == 10 && time.length == 2 && mm.length == 2) {
        if (time != '00') {
            let datetimeval = `${date} ${time}:${mm}`;
            setStateRender('scheduledDateTime', datetimeval);
        }
    }
}

function handleClickImageUploadFile(e) {

    let stateContainer = currentStateContainer();

    const { files } = e.target;
    setStateRender('inputImageKey', Date.now());

    if (files === null || files.length === 0) {
        alert("선택된 파일 정보가 존재하지 않습니다.");
        return;
    }

    if (files[0].name.indexOf('.jpg') === -1 && files[0].name.indexOf('.JPG') === -1
        && files[0].name.indexOf('.jpeg') === -1 && files[0].name.indexOf('.JPEG') === -1) {
        alert('JPG/JPEG 이미지 파일만 전송가능합니다.');
        return;
    }

    let image = {
        name: files[0].name,
        file: files[0],
        url: null,
        data: null
    };

    const maxFileSize = isKakaoTalkType(stateContainer.messageType) ? (500 * 1024) : (1024 * 1024);
    if (files[0].size > maxFileSize) {
        alert(getMessageTypeName(stateContainer.messageType) + ' 첨부 이미지의 최대 크기는 ' + maxFileSize / 1024 + 'KB 입니다.')
        setStateRender('selectedImageFile', []);

        return;
    }

    let fileData = {
        lastModified: files[0].lastModified,
        lastModifiedDate: files[0].lastModifiedDate,
        name: files[0].name,
        size: files[0].size,
        type: files[0].type,
        webkitRelativePath: files[0].webkitRelativePath
    }
        
    setStateRender('selectedImageFile', fileData);
       
    const reader = new FileReader();
    reader.onloadend = () => {
        image.data = reader.result;
        setStateRender('images', [image]);
        setStateRender('selectedImageBase64', reader.result);
    };
    reader.readAsDataURL(image.file);
}

function handleRemovePicture() {
    setStateRender('images', []);
    setStateRender('selectedImageFile', []);
}

function handleImageLoaded(e) {

    const { naturalWidth, naturalHeight } = e.currentTarget;

    if (validateImage(naturalWidth, naturalHeight) === false) {
        setStateRender('images', []);
        setStateRender('selectedImageFile', []);
    }
}

function containValues(str, arr) {
    let cnt = 0;
    arr.forEach(function (a) {
        if (str.toUpperCase() == a.toUpperCase()) {
            cnt++;
        }
    });

    return cnt > 0;
}

function onSubmitSend(e) {

    const findUserIndex = function (stateContainer, userNo) {
        return stateContainer.selectedUsers.findIndex(f => f.userID === userNo);
    }

    e.preventDefault();

    let stateContainer = currentStateContainer();

    if (stateContainer.messageType == "") {
        alert("메세지 유형을 선택하세요.");
        document.getElementById("cboMsgType").focus();
        return;
    }

    if (stateContainer.body == "") {
        alert("내용을 입력하세요.");
        document.getElementById("body").focus();
        return;
    }

    if (stateContainer.selectedSender == "") {
        alert("발신자를 선택해주세요.");
        document.getElementById("sender").focus();
        return;
    }

    var receivers = Array.from(stateContainer.selectedReceivers);
    if (receivers.length == 0) {
        alert("전송할 연락처를 선택하세요.");
        return;
    }

    // selectedSender : id|senderid|sendername|senderphone

    let user = currentMsgUser();

    var apiKey = user.site.apiKey;            // 'Eyfsv52yQAxbXIKERNOTCYmXzgXXiGi1aaDWJO24';
    var senderID = stateContainer.selectedSender.split('|')[0];
    var userID = stateContainer.selectedSender.split('|')[1];       //"0904271";//this.state.selectedSender.split('|')[1];
    var senderNM = stateContainer.selectedSender.split('|')[2]
    var senderNO = stateContainer.selectedSender.split('|')[3];

    const request = {
        SenderId: senderID,
        UserId: userID,
        Body: stateContainer.body,
        senderNO: senderNO,
        senderNM: senderNM,
        msgType: stateContainer.messageType,
        ApiKey: apiKey,
        Message: {
            ID: "guid",
            SiteID: user.siteID,
            SenderID: senderID,
            SenderNumber: senderNO,
            SenderName: senderNM,
            // MsgType: this.state.messageType,
            Type: stateContainer.messageType,
            status: "1",
            subject: stateContainer.subject,
            Body: stateContainer.body,
            kakaoTemplateCode: stateContainer.kakaoTplCode,
            KakaoSenderKey: stateContainer.KakaoSenderKey,  // "5b0f7c1da0718da7cc81bdc58bafcec4e9e96c12", 
            Recipients: [],
            Buttons: [],
            Scheduled: getFormatDate(stateContainer.scheduledDateTime)
        }
    };

    let filterSystem = [];
    filterSystem.push('student');
    filterSystem.push('hostel');
    filterSystem.push('sugang');
    filterSystem.push('scholarship');

    var msgBodyVariables = findVariables(stateContainer.body, "content");
    receivers.forEach(receiver => {
        var variablesName = "";
        // if (this.state.messageType == "Sms" || this.state.messageType == "Mms" || this.state.messageType == "Lms") {

        msgBodyVariables.forEach(variable => {
            if (variable == "#{회사}") {
                variablesName = variablesName + variable + "," + this.state.currentUser.site.identifierName + ";";
            }
            else if (variable == "#{날짜}") {
                let currDate = commonService.fnGetCurrentDate();
                variablesName = variablesName + variable + "," + currDate + ";";
            }

            else if (variable == "#{학번}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[0] + ";";
            }
            else if (variable == "#{학과명}") {

                if (filterSystem.includes(stateContainer.SysGb)) {
                    if (stateContainer.selectedUsers[findUserIndex(stateContainer, receiver.split('|')[0])].hasOwnProperty('orgName') == true) {
                        variablesName = variablesName + variable + "," +
                            stateContainer.selectedUsers[findUserIndex(stateContainer, receiver.split('|')[0])].orgName + ";";
                    }
                }
            }
            else if (variable == "#{과목명}") {

                if (filterSystem.includes(stateContainer.SysGb)) {
                    if (stateContainer.selectedUsers[findUserIndex(stateContainer, receiver.split('|')[0])].hasOwnProperty('lectureName') == true) {
                        variablesName = variablesName + variable + "," +
                            stateContainer.selectedUsers[findUserIndex(stateContainer, receiver.split('|')[0])].lectureName + ";";
                    }
                }
            }

            else if (variable == "#{이름}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }
            else if (variable == "#{핸드폰번호}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[2] + ";";
            }
            else if (variable == "#{재학생명}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }
            else if (variable == "#{대상자명}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }
            else if (variable == "#{대출자명}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }
            else if (variable == "#{복학대상자명}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }
            else if (variable == "#{졸업생명}") {
                variablesName = variablesName + variable + "," + receiver.split('|')[1] + ";";
            }

        });

        // 기본메세지치환유형 외 처리
        // this.state.newVariables.forEach(item => {
        //     variablesName = variablesName + item.val + "," + $("#"+item.id).val() + ";";
        // });
        // variablesName = variablesName.substring(0, variablesName.length - 1);

        variablesName = variablesName + receiver.split('|')[3];

        request.Message.Recipients.push({
            "Phone": receiver.split('|')[2],
            "variablesdata": variablesName
        });

        // }

    });

    if (stateContainer.selectedTplButton.length > 0) {

        stateContainer.selectedTplButton.forEach(btn => {

            request.Message.Buttons.push({
                "type": btn.type,
                "name": btn.name,
                "linkUrl1": btn.linkUrl1,
                "linkUrl2": btn.linkUrl2,
                "typeName": "웹 링크"
            });

        });
    }


    let selectedFile = stateContainer.selectedImageBase64.length > 0 ? dataURLtoFile(stateContainer.selectedImageBase64, stateContainer.selectedImageFile.name) : stateContainer.selectedImageFile;

    sendPost(senderID
        , userID
        , request
        , selectedFile
        //, stateContainer.selectedImageFile
        , function (ret) {

            if (ret.item == "error") {
                setStateRender("errorMsg", "오류 : " + ret.message)
            }
            else {

                setStateRender('IsSend', true);
                setStateRender('errorMsg', '');

                setStateRender('selectedUsers', []);
                setStateRender('pageOfItemsReceiver', []);
                setStateRender('selectedReceivers', []);
                setStateRender('sendCnt', 0);

                // 총 발송 비용
                setStateRender('sendTotal', numberWithCommas((stateContainer.sendFee * 0)));

                // 첨부 이미지 초기화
                setStateRender('images', []);
                setStateRender('selectedImageFile', []);
                setStateRender('selectedImageBase64', '');

                setStateRender('addName', '');
                setStateRender('addPhone', '');

                stateContainer.newVariables.forEach(item => {
                    $("#" + item.id).val("");
                });
                setStateRender('inputVariables', '');
            }
        },
        function (xhr, status, error) {
            console.log(error);
            setStateRender('errorMsg', error);
        });
}

function onSendPost(e) {
    e.preventDefault();
    $(document.forms[0]).attr('method', 'POST').attr('enctype', 'multipart/form-data');
    $(document.forms[0]).submit();
}

function onExcept(e) {
    e.preventDefault();
    SetReceiverList();
}

function onModalAddressBookShow(e) {
    e.preventDefault();

    let stateContainer = currentStateContainer();

    setStateRender('users', []);
    setStateRender('pageOfItems', []);

    if (stateContainer.msgGroup.length > 0) {
        getGroupService(stateContainer.msgGroup[0].groupID, function (group) {
            setStateRender('users', group.groupMem);
        });
    }

    $('#modalAddressBook').modal('show');
}

function dataBindGroupsData(selector, user) {
    let stateContainer = currentStateContainer();
    let $select = $(selector);
    $select.empty();
    $select.append($('<option></option>').attr('key', '').val('').text('선택'));

    getGroupsService('', user.siteID, user.userID, function (data) {

        setStateRender('msgGroup', data);

        $(data).each(function (index, grp) {
            let val = grp.groupID;
            let text = grp.groupNM;
            let key = grp.groupID;
            let $option = $('<option></option>').attr('key', key).val(val).text(text);
            $select.append($option);
        });
    });
}

function onSelectGrp(e) {
    var groupid = e.target.value
    if (groupid == "") return;

    getGroupService(groupid, function (group) {
        setStateRender('users', group.groupMem);
    });

    onUnCheckAll();
}

function onUnCheckAll() {
    $('[name=chkAll]').each(function () {
        $(this)[0].checked = false;
    });

    $('[name=chkSender]').each(function () {
        $(this)[0].checked = false;
    });
}



function dataBindKojeDept() {
    let stateContainer = currentStateContainer();
    let $tbody = $('#modalTblDeptList > tbody');
    $tbody.empty();
    getKojeOrganizationService(stateContainer.SysGb, function (data) {

        if ($(data).length == 0) {
            $tbody.append($('<tr><tr>').append($('<td></td>').attr('colspan', '2').text('조회된 조직이 없습니다.')));
        }
        else {
            $(data).each(function (i, item) {
                let $tr = $('<tr></tr>');
                $tr.on('click', function (e) {
                    $(this).addClass('active').siblings().removeClass('active');
                    let orgid = $(this).children('td').eq(0).text();
                    dataBindKojeStudent(orgid);
                });
                let $hidOrgSeq = $('<input />').attr('type', 'hidden').val(item.OrgSeq1);
                let $td_cd = $('<td></td>').text(item.OrgID).append($hidOrgSeq);
                let $td_nm = $('<td></td>').text(item.OrgName).attr('class', 'text-left');
                $tr.append($td_cd).append($td_nm);
                $tbody.append($tr);
            });
        }
    });
}

function onUnSelectKojeDept(e) {
    e.preventDefault();
    let stateContainer = currentStateContainer();
    let $tbody = $('#modalTblDeptList > tbody');
    dataBindKojeStudent('%');
    $('#modalTblDeptList > tbody > tr.active').removeClass('active');
}

function dataBindKojeStudent(orgid) {

    let stateContainer = currentStateContainer();
    let serviceParams = {};
    let searchObject = stateContainer.orgReciverSearchObject;
    let iserror = false;

    $(searchObject).each(function (i, param) {
        if (param.required == true && $(param.selector).val().length == 0) {
            alert(param.title + '(은)는 필수 입력 항목입니다.');
            iserror = true;
            //break;
            return false;
        }
        serviceParams[param.name] = $(param.selector).val();
    });

    if (iserror == true) return;

    serviceParams['SysGb'] = stateContainer.SysGb;
    if (stateContainer.SysGb != 'sugang') {
        serviceParams['OrgID'] = orgid;
    }

    getKojeStudentService(serviceParams, function (data) {

        let tmpUser = [];
        let receivers = Array.from(stateContainer.selectedReceivers);

        $(data.Items).each(function (i, item) {
            let exists = receivers.find(f => f.split('|')[0] == item.UserNo) ? true : false;
            let validMobile = fnIsMobile(item.MobileNo.replace(/-/g, ''));
            let stud = {};
            let user = {};

            stud['userID'] = item.UserNo;
            stud['userName'] = item.UserNm;
            stud['phone'] = item.MobileNo.replace(/-/g, '');
            stud['deptNM'] = '';
            user['user'] = stud;
            user['isDisabled'] = (exists == true || validMobile == false);
            tmpUser.push(user);
        });

        setStateRender('deptUsers', tmpUser);
        setStateRender('pageOfItemsDept', tmpUser);
    });

    return iserror;
}


$.fn.dataBindSender = function (user) {
    let $select = $(this);
    getSender(
        'Y',
        '',
        user.siteID,
        'Y',
        user.deptCode,
        undefined,
        undefined,
        function (data) {

            if ($select.is("select") && data) {
                $select.empty();
                $select.append($('<option></option>').attr('key', '').val('').text('선택'));
                $(data).each(function (index, item) {
                    let val = item.id + '|' + item.senderId + '|' + item.senderNm + '|' + item.senderNo;
                    let text = `${item.senderNm}(${item.senderNo})`;
                    let $option = $('<option></option>').val(val).text(text);
                    $select.append($option);
                });
            }
        });

    return $select;
}

$.fn.dataBindCodeChild = function (codepid) {
    let $select = $(this);
    getCodeChildInfo(codepid, function (data) {
        if ($select.is("select") && data) {
            $select.empty();
            $select.append($('<option></option>').attr('key', '').val('').text('선택'));
            $(data).each(function (index, item) {
                let $option = $('<option></option>').attr('key', item.code).val(item.code).text(item.codeNM);
                $select.append($option);
            });
        }
    });
}


$(document).ready(function () {

});