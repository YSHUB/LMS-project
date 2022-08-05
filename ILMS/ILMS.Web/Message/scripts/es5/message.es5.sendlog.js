function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

var currentSendLogContainer = function currentSendLogContainer() {
    return JSON.parse(sessionStorage.getItem('sendLogContainer'));
};

function initializeSendLogContainer() {
    var user = currentMsgUser();
    var sendLogContainer = {
        currentUser: user,
        logs: [],
        pageOfItems: [],
        sites: [],
        siteid: user.siteID,
        msgTypes: [],
        msgType: '', reqstartdt: '', reqenddt: '',
        userAuthGroup: '',
        sendResult: [],
        depts: [], deptcode: ''
    };

    sessionStorage.setItem('sendLogContainer', JSON.stringify(sendLogContainer));
}

function setSendLogState(prop, val) {

    var sendLogContainer = {};
    if (sessionStorage.getItem('sendLogContainer')) {
        sendLogContainer = JSON.parse(sessionStorage.getItem('sendLogContainer'));
    }

    if (sendLogContainer.hasOwnProperty(prop) == true) {
        sendLogContainer[prop] = val;
        sessionStorage.setItem('sendLogContainer', JSON.stringify(sendLogContainer));

        switch (prop) {
            case 'pageOfItems':
                renderPageOfItems();
                break;
            case 'logs':
                renderLogs();
                break;
            case 'sendResult':
                renderSendResult();
                break;
            default:
                break;
        }
    }
}

function renderPageOfItems() {

    var container = currentSendLogContainer();
    var user = currentMsgUser();
    $("#tblMsgSendLog > tbody").empty();

    if (!container.pageOfItems || container.pageOfItems.length <= 0) {
        $("#tblMsgSendLog > tbody").append($('<tr></tr>').append($('<td></td>').attr('colspan', '8').attr('class', 'text-center').append($('<b>등록된 발송내역이 없습니다.</b>'))));
    } else {
        $(container.pageOfItems).each(function (i, logs) {
            var $tr = $('<tr></tr>').attr('key', logs.seq);
            var $hidModelId = $('<input />').attr('type', 'hidden').val(logs.messageModel.id);
            var $tdSite = $('<td></td>').attr('scope', 'row').text(logs.sites != null ? logs.sites.identifierName : '');
            //let $tdDeptName = $('<td></td>').text(logs.messageModel.user.deptNM);
            $tdSite.append($hidModelId);
            var href = '/Message/SendLogDetail.aspx?';
            href += 'seq=' + logs.seq;
            href += '&siteid=' + user.siteID;
            href += '&msgtype=' + container.msgType;
            href += '&reqstartdt=' + container.reqstartdt;
            href += '&reqenddt=' + container.reqenddt;

            var $aLink = $('<a></a>').attr('href', "#").text(logs.messageModel != null ? logs.messageModel.senderNO : '');
            $aLink.on('click', function (e) {
                e.preventDefault();
                goToSendLogDetailPageTab('0001743', '메세지전송내역상세', logs.seq, container.msgType, container.reqstartdt, container.reqenddt);
            });

            var $tdLink = $('<td></td>').append($aLink);
            var $tdSenderNM = $('<td></td>').text(logs.messageModel != null ? logs.messageModel.senderNM : '');
            var $tdSendCnt = $('<td></td>').text(logs.sendCnt > 1 ? logs.recipientModel[0].phone + " 외 " + (logs.sendCnt - 1) + "건" : logs.recipientModel[0].phone);
            var $tdBody = $('<td></td>').attr('class', 'ellipsis text-center').append($('<span></span>').text(logs.messageModel.body));
            var $tdMsgType = $('<td></td>');
            var $spanMsgType = $('<span><span>');

            switch (logs.msgType) {
                case 0:
                    $spanMsgType.attr('class', 'badge badge-primary').text(getMessageTypeNameByCode(logs.msgType));
                    break;
                case 1:
                    $spanMsgType.attr('class', 'badge badge-success').text(getMessageTypeNameByCode(logs.msgType));
                    break;
                case 2:
                    $spanMsgType.attr('class', 'badge badge-secondary').text(getMessageTypeNameByCode(logs.msgType));
                    break;
                case 3:
                    $spanMsgType.attr('class', 'badge badge-warning').text(getMessageTypeNameByCode(logs.msgType));
                    break;
                case 4:
                    $spanMsgType.attr('class', 'badge badge-info').text(getMessageTypeNameByCode(logs.msgType));
                    break;
                default:
                    break;
            }
            $tdMsgType.append($spanMsgType);
            var $tdRequestDt = $('<td></td>').text(logs.requestDt.slice(0, 10));
            var $tdResult = $('<td></td>').append($('<span></span>').attr('class', 'badge badge-success').text('성공(' + getRecipients(logs.messageModel.id, 'success') + ')')).append('&nbsp;').append($('<span></span>').attr('class', 'badge badge-warning').text('실패(' + getRecipients(logs.messageModel.id, 'fail') + ')'));

            $tr.append($tdSite);
            //$tr.append($tdDeptName);
            $tr.append($tdLink);
            $tr.append($tdSenderNM);
            $tr.append($tdSendCnt);
            $tr.append($tdBody);
            $tr.append($tdMsgType);
            $tr.append($tdRequestDt);
            $tr.append($tdResult);
            $("#tblMsgSendLog > tbody").append($tr);
        });
    }
}

function renderLogs() {
    var container = currentSendLogContainer();
    $("#strcnt").text(container.logs.length);
}

function renderSendResult() {
    var container = currentSendLogContainer();

    $('#tblMsgSendLog > tbody tr').each(function (i, tr) {
        var modelId = $(tr).children('td').eq(0).find('input').val();
        var findItem = container.sendResult.find(function (f) {
            return f.mid == modelId;
        });
        if (findItem && findItem.successCnt && findItem.failCnt) {
            $(tr).children('td').eq(7).find('.badge-success').text('성공(' + successCnt + ')');
            $(tr).children('td').eq(7).find('.badge-warning').text('실패(' + failCnt + ')');
        }
    });
}

function getRecipients(messageid, gubun) {
    var container = currentSendLogContainer();
    var retVal = "";
    container.sendResult.forEach(function (item) {
        if (item.mid == messageid) {
            if (gubun == "success") {
                retVal = item.successCnt;
            } else if (gubun == "fail") {
                retVal = item.failCnt;
            }
        }
    });

    return retVal;
}

function getCurrentMonthOfFirstDate() {
    var separator = arguments.length <= 0 || arguments[0] === undefined ? '' : arguments[0];

    var now = new Date();
    var firstDate = new Date(now.getFullYear(), now.getMonth(), 1);
    var date = firstDate.getDate();
    var month = firstDate.getMonth() + 1;
    var year = firstDate.getFullYear();
    return '' + year + separator + (month < 10 ? '0' + month : '' + month) + separator + (date < 10 ? '0' + date : '' + date);
}

function getCurrentDate() {
    var separator = arguments.length <= 0 || arguments[0] === undefined ? '' : arguments[0];
    var period = arguments[1];

    var newDate = new Date();
    var dayOfMonth = newDate.getDate();
    newDate.setDate(dayOfMonth - period);
    var date = newDate.getDate();
    var month = newDate.getMonth() + 1;
    var year = newDate.getFullYear();

    return '' + year + separator + (month < 10 ? '0' + month : '' + month) + separator + (date < 10 ? '0' + date : '' + date);
}

function getMessageTypeNameByCode(type) {
    var result = null;
    switch (type) {
        case 0:
            result = 'SMS';
            break;
        case 1:
            result = 'MMS';
            break;
        case 2:
            result = 'LMS';
            break;
        case 3:
            //'KakaoNotificationTalk':
            result = '카카오 알림톡';
            break;
        case 4:
            //'KakaoFriendTalk':
            result = '카카오 친구톡';
            break;
    }
    return result;
}

function onDataBindSendLog() {
    var user = currentMsgUser();

    if (user) {

        if (parent.startSpin) {
            parent.startSpin();
        }
        var tmpAuthGroup = '';
        user.authGroupMemeber.map(function (item) {
            tmpAuthGroup = tmpAuthGroup + item.groupID + "|";
        });

        var senderName = $("#schUser").val();
        var msgType = $("#ddlMsgType").val();
        var frDate = $("#txtReqstartdt").val();
        var toDate = $("#txtReqenddt").val();

        getSendLogs(senderName, msgType, user.siteID, frDate, toDate, '', function (logs) {

            //setSendLogState('pageOfItems', logs);
            setSendLogState('logs', logs);

            var logResult = [];

            $(logs).each(function (i, log) {

                getSendRecipient(log.messageModel.id, function (recipients) {
                    var successCnt = 0;
                    var failCnt = 0;
                    recipients.result.forEach(function (recipient) {
                        if (recipient.code == "100") {
                            successCnt++;
                        }
                        if (recipient.code != "100") {
                            failCnt++;
                        }
                    });

                    logResult.push({ mid: log.messageModel.id, successCnt: successCnt, failCnt: failCnt });
                    setSendLogState('sendResult', logResult);
                });
            });

            setSendLogState('pageOfItems', logs);

            //setPagerRender('#messageSendLogPagerContainer', 1, logs, 10, function (pageitem) {
            //    setSendLogState('pageOfItems', pageitem.pageOfItems);
            //});

            if (parent.stopSpin) {
                parent.stopSpin();
            }
        });
    }
}

function onSelectMsgType(e) {
    setSendLogState('msgType', e.target.value);
    onDataBindSendLog();
}

function onChange(e) {
    setSendLogState(e.target.name, e.target.value);
}

function goToSendLogDetailPageTab(menuid, menuname, seq, msgtype, reqstartdt, reqenddt) {
    if (parent.useEasyUITabs()) {
        var pageUrl = '/Message/SendLogDetail.aspx?';
        pageUrl += 'programID=5467';
        pageUrl += '&seq=' + seq;
        pageUrl += '&msgtype=' + msgtype;
        pageUrl += '&reqstartdt=' + reqstartdt;
        pageUrl += '&reqenddt=' + reqenddt;
        pageUrl += '&refresh_yn=Y';
        var menu = parent.createMenu(menuid, menuname, pageUrl, true, false);
        var $contentTab = $(window.parent.document).find("#contentTab");
        parent.createTab($contentTab, menu);
    }
}

function goToSendLogListPageTab(menuid, menuname, msgtype, reqstartdt, reqenddt) {
    if (parent.useEasyUITabs()) {
        var pageUrl = '/Message/MessageSendingLog.aspx?';
        pageUrl += 'programID=5466';
        pageUrl += '&msgtype=' + msgtype;
        pageUrl += '&reqstartdt=' + reqstartdt;
        pageUrl += '&reqenddt=' + reqenddt;
        pageUrl += '&refresh_yn=Y';
        var menu = parent.createMenu(menuid, menuname, pageUrl, true, false);
        var $contentTab = $(window.parent.document).find("#contentTab");
        parent.createTab($contentTab, menu);
    }
}

function onDataBindSendLogDetail(seq) {

    getSendLog(seq, function (log) {

        renderSendLogDetailBody(log);

        getSendRecipient(log.messageModel.id, function (recipients) {
            renderTblSendLogDetail(recipients);
        });
    });
}

function renderSendLogDetailBody(log) {
    $("#hSendLogDtlSubject").text(log.messageModel.subject);
    $('#txtSendLogDtlBody').text(log.messageModel.body == null ? '' : log.messageModel.body);
}

function renderTblSendLogDetail(pageOfItems) {

    $('#tblSendLogDtlList > tbody').empty();
    if (!pageOfItems || pageOfItems.length <= 0) {
        var $emptyRow = $('<tr></tr>').append($('<td></td>').attr('colsapn', '5').attr('class', 'text-center').text('No Receiver yet'));
        $('#tblSendLogDtlList > tbody').append($emptyRow);
    } else {

        $(pageOfItems.result).each(function (i, receiver) {
            var $tr = $('<tr></tr>').attr('key', receiver.seq);
            var $tdPhone = $('<td></td>').attr('class', 'text-center').text(receiver.phone);
            var $tdText = $('<td></td>').attr('class', 'text-left').append($('<span></span>').text(receiver.text));
            var $tdResult = $('<td></td>').attr('class', 'text-center').text(receiver.sendingResultCode);
            $tr.append($tdPhone);
            $tr.append($tdText);
            $tr.append($tdResult);
            $('#tblSendLogDtlList > tbody').append($tr);
        });
    }
}

function onMessageLogExcelDownLoad(sendername, type, siteid, reqstartdt, reqenddt) {

    FileLogsDownload(sendername, type, siteid, reqstartdt, reqenddt, function (data) {
        downLoadFileBlob(data, 'SendLogs.xlsx');
    }, function (xhr) {
        alert('파일을 다운로드 할 수 없습니다. 문제가 계속되면 관리자에게 문의하시기 바랍니다.');
    });
}

function setPageItems(page, items, pageSize) {

    var pager = getPager(items.length, page, pageSize);

    var pageOfItems = items.slice(pager.startIndex, pager.endIndex + 1);

    return { pager: pager, pageOfItems: pageOfItems };
}

function setPagerRender(elContainer, page, items, pageSize, renderCallBack) {

    $(elContainer).empty();
    var container = currentSendLogContainer();
    var pageitem = setPageItems(page, items, pageSize);

    if (pageitem.pager.pages.length <= 1) return;

    var $ul = $('<ul></ul>').attr('class', 'pagination');

    var firstClass = pageitem.pager.currentPage === 1 ? 'disabled' : 'page-item';
    var beforeClass = pageitem.pager.currentPage === 1 ? 'disabled' : '';
    var nextClass = pageitem.pager.currentPage === pageitem.pager.totalPages ? 'disabled' : '';
    var lastClass = pageitem.pager.currentPage === pageitem.pager.totalPages ? 'disabled' : '';

    var $liFirst = $('<li></li>').attr('class', firstClass).css('display', firstClass == 'disabled' ? 'hidden' : 'block');
    var $liBefore = $('<li></li>').attr('class', beforeClass).css('display', beforeClass == 'disabled' ? 'hidden' : 'block');
    var $liNext = $('<li></li>').attr('class', nextClass).css('display', nextClass == 'disabled' ? 'hidden' : 'block');
    var $liLast = $('<li></li>').attr('class', lastClass).css('display', lastClass == 'disabled' ? 'hidden' : 'block');

    var $aFirst = $('<a></a>').attr('class', 'page-link').text('처음으로');
    var $aBefore = $('<a></a>').attr('class', 'page-link').text('이전');
    var $aNext = $('<a></a>').attr('class', 'page-link').text('다음');
    var $aLast = $('<a></a>').attr('class', 'page-link').text('끝으로');

    $aFirst.on('click', function (e) {
        e.preventDefault();
        setPagerRender(elContainer, 1, container.logs, pageSize, function (p) {
            setSendLogState('pageOfItems', p.pageOfItems);
        });
    });
    $aBefore.on('click', function (e) {
        e.preventDefault();
        setPagerRender(elContainer, pageitem.pager.currentPage - 1, container.logs, pageSize, function (p) {
            setSendLogState('pageOfItems', p.pageOfItems);
        });
    });
    $aNext.on('click', function (e) {
        e.preventDefault();
        setPagerRender(elContainer, pageitem.pager.currentPage + 1, container.logs, pageSize, function (p) {
            setSendLogState('pageOfItems', p.pageOfItems);
        });
    });
    $aLast.on('click', function (e) {
        e.preventDefault();
        setPagerRender(elContainer, pageitem.pager.totalPages, container.logs, pageSize, function (p) {
            setSendLogState('pageOfItems', p.pageOfItems);
        });
    });

    $liFirst.append($aFirst);
    $liBefore.append($aBefore);
    $liNext.append($aNext);
    $liLast.append($aLast);

    $ul.append($liFirst);
    $ul.append($liBefore);

    $(pageitem.pager.pages).each(function (i, page) {
        var $li = $('<li></li>').attr('key', i).attr('class', pageitem.pager.currentPage === page ? 'page-item active' : '');
        var $aLink = $('<a></a>').attr('class', 'page-link').text(page);
        $aLink.on('click', function (e) {
            e.preventDefault();
            setPagerRender(elContainer, page, container.logs, pageSize, function (p) {
                setSendLogState('pageOfItems', p.pageOfItems);
            });
        });
        $li.append($aLink);
        $ul.append($li);
    });

    $ul.append($liNext);
    $ul.append($liLast);
    $(elContainer).append($ul);

    if (renderCallBack) {
        renderCallBack(pageitem);
    }
}

function getPager(totalItems, currentPage, pageSize) {
    // default to first page
    currentPage = currentPage || 1;

    // default page size is 10
    pageSize = pageSize || 10;

    // calculate total pages
    var totalPages = Math.ceil(totalItems / pageSize);

    var startPage, endPage;
    if (totalPages <= 10) {
        // less than 10 total pages so show all
        startPage = 1;
        endPage = totalPages;
    } else {
        // more than 10 total pages so calculate start and end pages
        if (currentPage <= 6) {
            startPage = 1;
            endPage = 10;
        } else if (currentPage + 4 >= totalPages) {
            startPage = totalPages - 9;
            endPage = totalPages;
        } else {
            startPage = currentPage - 5;
            endPage = currentPage + 4;
        }
    }

    // calculate start and end item indexes
    var startIndex = (currentPage - 1) * pageSize;
    var endIndex = Math.min(startIndex + pageSize - 1, totalItems - 1);

    // create an array of pages to ng-repeat in the pager control
    var pages = [].concat(_toConsumableArray(Array(endPage + 1 - startPage).keys())).map(function (i) {
        return startPage + i;
    });

    // return object with all pager properties required by the view
    return {
        totalItems: totalItems,
        currentPage: currentPage,
        pageSize: pageSize,
        totalPages: totalPages,
        startPage: startPage,
        endPage: endPage,
        startIndex: startIndex,
        endIndex: endIndex,
        pages: pages
    };
}