/*
 * 해당 파일은 사용자가 임의로 생성하는 함수를 작성합니다.
 * ex) 자리수 채우기, 숫자 콤마 등
 */

//이벤트 발생 방지
function fnPrevent() {
	try {
		if (event.preventDefault) {
			event.preventDefault();
			return false;
		}
	}
	catch (e) {
	}
}

// 넘겨받은 ID의 컨트롤에 시간 세팅
// [setid] 세팅할 id / [selhour] 선택값
function fnAppendHour(setid, selhour) {
	var option = "";

	for (var i = 0; i < 24; i++) {
		var selectitem = (i == parseInt(selhour)) ? "selected" : "";
		option += "<option value='" + fnNumberPad(i, 2) + "' " + selectitem + ">" + fnNumberPad(i, 2) + "</option>";
	}

	$("#" + setid).html(option);
}

// 넘겨받은 ID의 컨트롤에 분 세팅
// [setid] 세팅할 id /  / [selmin] 선택값 / [gbn] 1 : 1단위, 10 : 10단위, 30 : 30단위
function fnAppendMin(setid, selmin, gbn) {
	var option = "";

	for (var i = 0; i < 60; i += parseInt(gbn)) {
		var selectitem = (i == parseInt(selmin)) ? "selected" : "";
		option += "<option value='" + fnNumberPad(i, 2) + "' " + selectitem + ">" + fnNumberPad(i, 2) + "</option>";
	}

	$("#" + setid).html(option);
}

// 넘겨받은 ID의 컨트롤에 년도 세팅
// [setid] 세팅할 id /  / [selmin] 선택값 / [gbn] 당해년도 기준 +- 구분값 
function fnAppendYear(setid, gbn) {
	var option = "";
	//현재년도
	var today = new Date();
	var year = today.getFullYear();

	for (var i = year - parseInt(gbn); i <= year + parseInt(gbn); i++) {
		var selectitem = (i == year) ? "selected" : "";
		option += "<option value='" + i + "' " + selectitem + ">" + i + "년" + "</option>";
	}

	$("#" + setid).html(option);
}

// 넘겨받은 ID의 컨트롤에 월 세팅
// [setid] 세팅할 id /
function fnAppendMonth(setid) {
	var option = "";
	//현재년도
	var today = new Date();
	var Month = today.getMonth() + 1;
	for (var i = 1; i < 13; i++) {
		var selectitem = (i == Month) ? "selected" : "";
		option += "<option value='" + i + "' " + selectitem + ">" + i + "월" + "</option>";
	}

	$("#" + setid).html(option);
}

// 자리수만큼 0 채워서 숫자 표시
// [n] 숫자 / [width] 자리수
function fnNumberPad(n, width) {
	n = n + '';
	return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
}

// 숫자 입력시 콤마 찍기
// [gbn] A : 입력시 바로 적용, B : 스크립트 합산 처리후 콤마 찍어서 넣어줄때 / [element] gbn A의 경우 이벤트 발생요소. gbn B의 경우 콤마 찍을 값
// 사용예시) onkeyup="addCommas('A', this)"
function fnAddCommas(gbn, element) {
	if (gbn == "A") {
		var result = (element.value.replace(/[^0-9]/g, "")).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		element.value = result;
	} else if (gbn == "B") {
		return element.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
}

//텍스트박스에 숫자만 입력 받기
//사용예시 oninput="fnOnlyNumber(this);"
function fnOnlyNumber(obj) {
	obj.value = obj.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
}


// 학기 값에 따른 교과목 리스트 변경
function fnChangeCourse(obj) {
	if ($(obj).val() != "") {
		$.ajax({
			type: "POST"
			, url: "/Course/CourseList"
			, data: { termNo: $(obj).val() }
			, dataType: "json"
			, async: false
			, success: function (data) {
				var innerHtml = "";

				for (var i = 0; i < data.length; i++) {
					innerHtml += "<option value='" + data[i].CourseNo + "'>";
					if (data[i].ProgramNo == "1") {
						innerHtml += "[" + data[i].ProgramName + "] " + data[i].SubjectName + "(" + fnNumberPad(data[i].ClassNo, 3) + ") - " + data[i].AssignName;
						if (data[i].TargetGradeName != "기타") {
							innerHtml += " " + data[i].TargetGradeName;
						}
					} else {
						innerHtml += "[" + data[i].ProgramName + "] " + data[i].SubjectName;
					}
					innerHtml += "</option>";
				}

				$("#ddlCourseNo").html(innerHtml);
			}
			, error: function (e) {
				console.log("학기별 강좌목록을 가져올 수 없습니다.\n다시 시도해 주세요.");
				console.log(e);
			}
		});
	}

	fnPrevent();
}

// 강의실 내 강좌 바로가기 기능(교수용)
function fnChangeLectureRoomWithPage() {

	if ($("#ddlCourseNo").val() != "") {
		var changeCourseNo = $("#ddlCourseNo").val();
		var path = window.location.pathname;
		var url = "";

		var splitPath = path.split("/");
		var splitPathCtr = splitPath[1].toUpperCase();
		var splitPathAction = splitPath[2].toUpperCase();
		var splitPathParam = splitPath[4];

		if ($("#ddlCourseNo option").size() < 1) {
			url = "/Mypage/LectureRoom";
		} else {
			if (splitPathCtr == "BOARD") {
				url = "/" + splitPathCtr + "/" + splitPathAction + "/" + changeCourseNo + "/" + splitPathParam;
			} else if (splitPathCtr == "OCW") {
				if (splitPathAction.substring(0, 4) == "WEEK") {
					url = "/" + splitPathCtr + "/WeekList/" + changeCourseNo;
				} else {
					url = "/" + splitPathCtr + "/LectureRoom/" + changeCourseNo;
				}
			} else if (splitPathCtr == "HOMEWORK" || splitPathCtr == "EXAM" || splitPathCtr == "QUIZ" || splitPathCtr == "TEAMPROJECT") {
				url = "/" + splitPathCtr + "/ListTeacher/" + changeCourseNo;
			} else if (splitPathCtr == "DISCUSSION" || splitPathCtr == "REPORT") {
				url = "/" + splitPathCtr + "/List/" + changeCourseNo;
			} else {
				url = "/" + splitPathCtr + "/" + splitPathAction + "/" + changeCourseNo;
			}

			fnShowInfoLayer("강좌 이동 중입니다.<br />잠시만 기다려 주세요.");
		}
		
		window.location = url;
	}

	fnPrevent();
}

// 강의실 내 강좌 바로가기 기능(학생)
function fnChangeLectureRoom() {
	if ($("#ddlCourseNo option").size() < 1) {
		window.location = "/Mypage/LectureRoom";
	} else {
		if ($("#ddlCourseNo").val() != "") {
			var url = "/LectureRoom/Index/" + $("#ddlCourseNo").val();

			fnShowInfoLayer("강좌 이동 중입니다.<br />잠시만 기다려 주세요.");
			window.location = url;
		}

		fnPrevent();
	}
}

// 글자수 리턴
function fnGetBytes(v, nocrtrim) {
	nocrtrim = nocrtrim == undefined || nocrtrim == null ? false : nocrtrim;
	if (v == null) {
		return 0;
	}
	v = $.trim(v);
	if (!nocrtrim) {
		v = v.replace(/[\r\n]/gi, '').replace(/[\n]/gi, '');
	}
	var stringByteLength = 0;
	stringByteLength = (function (s, b, i, c) {
		for (b = i = 0; c = s.charCodeAt(i++); b += c >> 11 ? 2 : c >> 7 ? 2 : 1);
		return b
	})(v);
	return stringByteLength;
}

// 넘겨받은 체크박스 리스트 체크여부 확인
// isChecked("chkUserType");
function fnIsChecked(chkId) {
	var isChecked = false;
	var chkList = $("input[id*=" + chkId + "]");

	for (var i = 0; i < chkList.length; i++) {
		if (chkList[i].checked) {
			isChecked = true;
			break;
		}
	}

	return isChecked;
}

// 넘겨받은 체크박스 리스트 값 연결
// fnLinkChkValue("chkUserType");
// fnLinkChkValue("chkUserType", ",");
function fnLinkChkValue(chkId, splitChar) {
	var returnStr = "";
	var chkList = $("input[id*=" + chkId + "]");

	var splitChar = splitChar == null ? "|" : splitChar;

	for (var i = 0; i < chkList.length; i++) {
		if (chkList[i].checked) {
			returnStr += splitChar + chkList[i].value;
		}
	}

	return returnStr.substr(1);
}

function fnGetCheckboxListWithSelection(chkId, splitChar){
	var returnStr = "";
	var chkList = $("input[id*=" + chkId + "]");

	var splitChar = splitChar == null ? "|" : splitChar;

	for (var i = 0; i < chkList.length; i++) {
		
		returnStr += splitChar + chkList[i].value + ":";
		returnStr += chkList[i].checked? "Y" : "N";
	}

	return returnStr.substr(1);
}

// 넘겨받은 문자 배열에 해당하는 체크박스 세팅
// setSplitValueInChk("chkUserType", data.UserTypeArray, '|');
function fnSetSplitValueInChk(chkId, strArr, splitChar) {
	var chkList = $("input[id*=" + chkId + "]");
	var splitArr = strArr.split(splitChar);

	for (var i = 0; i < splitArr.length; i++) {
		for (var j = 0; j < chkList.length; j++) {
			if (chkList[j].value == splitArr[i]) {
				chkList[j].checked = true;
			}
		}
	}
}

// 넘겨받은 체크박스 아이디 값 전체 체크
// setCheckBoxAll("chkUserType");
function fnSetCheckBoxAll(obj, chkId) {
	var chkList = $("input[id*=" + chkId + "]");

	for (var i = 0; i < chkList.length; i++) {
		chkList[i].checked = obj.checked;
	}
}

// 팀 편성 보기(그룹명 조회)
// 토론, 과제, 팀프로젝트 같은 디자인 사용으로 구분값 부여(isTeamProject 0 : 토론, 과제에서 사용 / 1 : 팀프로젝트에서 사용)
// fnGroupTeam(27215, 3251, 1);
function fnGroupTeam(courseNo, groupNo, isTeamProject) {

	$.ajax({
		type: "POST"
		, url: isTeamProject == 0 ? "/Team/GroupTeam" : "/Report/GroupTeam"
		, data: { courseNo: courseNo, groupNo: groupNo}
		, dataType: "json"
		, async: false
		, success: function (data) {

			$("#lblGroupName").html(data.GroupName);
			fnGroupTeamList(courseNo, groupNo, isTeamProject);
		}
		, error: function (e) {
			console.log("해당 그룹을 확인할 수 없습니다.\n다시 시도해 주세요.");
			console.log(e);
		}
	});

	fnPrevent();
}

// 팀 편성 보기(팀 조회)
// 토론, 과제, 팀프로젝트 같은 디자인 사용으로 구분값 부여(isTeamProject 0 : 토론, 과제에서 사용 / 1 : 팀프로젝트에서 사용)
// fnGroupTeamList(27215, 3251, 1);
function fnGroupTeamList(courseNo, groupNo, isTeamProject) {

	$.ajax({
		type: "POST"
		, url: isTeamProject == 0 ? "/Team/GroupTeamList" : "/Report/GroupTeamList"
		, data: { courseNo: courseNo, groupNo: groupNo}
		, dataType: "json"
		, async: false
		, success: function (data) {
			var innerHtml = "";

			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {

					innerHtml += '	<tr>';
					innerHtml += '		<td class="text-left">' + data[i].TeamName + '</td>';
					innerHtml += '		<td class="text-center">' + data[i].MemberCnt + '</td>';
					innerHtml += '		<td class="text-center">';
					innerHtml += '			<a class="text-primary" href="#" title="팀원보기" onclick="fnGroupTeamMemberList(' + courseNo + ',' + groupNo + ',' + data[i].TeamNo + ',' + isTeamProject + ')"><i class="bi bi-people"></i></a>'
					innerHtml += '		</td>';
					innerHtml += '	</tr>';
				}
			} else {
				innerHtml += '	<tr>';
				innerHtml += '		<td colspan="3">' + "등록된 팀이 없습니다." + '</td>';
				innerHtml += '	</tr>';
			}

			$("#tdbTeamList").html(innerHtml);
		}
		, error: function (e) {
			console.log("해당 팀을 확인할 수 없습니다.\n다시 시도해 주세요.");
			console.log(e);
		}
	});

	fnPrevent();
}

// 팀 편성 보기(팀원 조회)
// 토론, 과제, 팀프로젝트 같은 디자인 사용으로 구분값 부여(isTeamProject 0 : 토론, 과제에서 사용 / 1 : 팀프로젝트에서 사용)
// fnGroupTeamMemberList(27215, 3251, 12881, 1);
function fnGroupTeamMemberList(courseNo, groupNo, teamNo, isTeamProject) {

	$.ajax({
		type: "POST"
		, url: isTeamProject == 0 ? "/Team/GroupTeamMemberList" : "/Report/GroupTeamMemberList"
		, data: { courseNo: courseNo, groupNo: groupNo, teamNo: teamNo }
		, dataType: "json"
		, async: false
		, success: function (data) {

			var innerHtml = "";

			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
				$("#lblTeamName").html(data[i].TeamName);

					innerHtml += '	<tr>';
					if (data[i].SexGubun == 'F') {
						innerHtml += '<td class="text-center"><i class="bi bi-gender-female text-danger" title="여"></i></td>';
					} else {
						innerHtml += '<td class="text-center"><i class="bi bi-gender-male text-primary" title="남"></i></td>';
					}
					innerHtml += '		<td class="text-center">' + data[i].HangulName + '</td>';
					innerHtml += '		<td class="center">' + data[i].UserID + '</td>';
					if (data[i].TeamLeaderYesNo == 'Y') {
						innerHtml += '<td><i class="bi bi-patch-check-fill text-success" title="팀장"></i></td>';
					} else {
						innerHtml += '<td></td>';
					}
					innerHtml += '	</tr>';
				}
			} else {
				innerHtml += '	<tr>';
				innerHtml += '		<td colspan="4">' + "등록된 팀원이 없습니다." + '</td>';
				innerHtml += '	</tr>';
			}

			$("#tdbTeamMemberList").html(innerHtml);
		}
		, error: function (e) {
			console.log("해당 학생을 확인할 수 없습니다.\n다시 시도해 주세요.");
			console.log(e);
		}
	});

	fnPrevent();
}

//사용자 검색 팝업
// type : multi(여러개), single(1개)
// paramId : 실제 서버로 전송되어야 하는 값
// displayId : 화면에 보여줄 값
//openUserPopup("multi", "hdnUserNo", "txtselectUser");
function fnOpenUserPopup(type, paramId, displayId, fId) {
	var typeUrl = type == "multi" ? "/Common/UserList" : "/Common/SearchUser";
	typeUrl += "?param=" + paramId + "&display=" + displayId;
	if (fId != null && fId != undefined && fId.length > 0) {
		typeUrl += "&f=" + fId;
	}

	var win = window.open(typeUrl, "UserPopup", "width=650, height=500, resizable=no, scrollbars=yes");
	win.focus();
}

//폼 submit
//fid(선택값) : 해당 페이지의 form 아이디
function fnSubmit(fid) {
	fid = fid || "mainForm";
	if ($("#" + fid).length > 0) {
		$("#" + fid).submit();
	}
	fnPrevent();
}

//파일 다운로드 
function fnFileDownload(fileNo) {
	location.href = '/Common/FileDownLoad/' + fileNo;
}

function fnFileUploaderChange(obj,id) {
	var files = [];
	Array.from(document.querySelector('#' + id).files).forEach(
		item => files.push(item.name)
	);

	var string = "";
	for (var i = 0; i < files.length; i++) {
		string += "<div id='fileName' name='fileName' class='form-label'>";
		string += files[i];
		string += "</div>";
	}
	document.querySelector("#div_" + id).innerHTML = string;

};

// SMS발송
function fnLayerPopup(Type, chkId) {

	//msgtype이 IDINO 일 때, 메세지 센터 사용
	var msgType = 'IDINO';
	var Users = "";
	var Userstxt = "";
	var chkList = $("input[id*=" + chkId + "]:checked");

	if (chkList.length <= 0) {
		bootAlert("선택된 항목이 없습니다.");
		return false;
	}

	if (msgType == 'IDINO' && Type == 'LayerSMS') {

		var form = document.createElement("form");

		form.setAttribute("method", "post");
		form.setAttribute("target", "message");

		for (var i = 0; i < chkList.length; i++) {
			if (i == 0) {
				Users = chkList.eq(i).val();
			}
			else {
				Users += "|" + chkList.eq(i).val();
			}
		}

		form.setAttribute("action", "/Message/Write");
		window.open("", "message", "width=1200, height=750, scrollbars=yes, resizable=no");

		document.body.appendChild(form);

		var input_id = document.createElement("input");

		input_id.setAttribute("type", "hidden");
		input_id.setAttribute("name", "stno");
		input_id.setAttribute("value", Users);

		form.appendChild(input_id);

		form.submit();

	}
	else if (msgType == 'UNIV' && Type == 'LayerSMS') {

		var form2 = document.createElement("form");

		form2.setAttribute("method", "post");
		form2.setAttribute("target", "message2");

		for (var i = 0; i < chkList.length; i++) {
			if (i == 0) {
				Users = chkList.eq(i).next().val();
				Userstxt = chkList.eq(i).next().next().val();
			}
			else {
				Users += "," + chkList.eq(i).next().val();
				Userstxt += "," + chkList.eq(i).next().next().val();
			}
		}

		document.body.appendChild(form2);

		var userstxt = document.createElement("input");

		userstxt.setAttribute("type", "text");
		userstxt.setAttribute("name", "txtselectUser");
		userstxt.setAttribute("value", Userstxt);

		var users = document.createElement("input");

		users.setAttribute("type", "hidden");
		users.setAttribute("name", "hdnUserNo");
		users.setAttribute("value", Users);

		form2.appendChild(userstxt);
		form2.appendChild(users);

		form2.setAttribute("action", "/Message/SMSWrite");
		window.open("", "message2", "width=1200, height=750, scrollbars=yes, resizable=no");

		form2.submit();

	} else if (Type == 'LayerNote') {
		var form3 = document.createElement("form");

		form3.setAttribute("method", "post");
		form3.setAttribute("target", "message3");

		for (var i = 0; i < chkList.length; i++) {
			if (i == 0) {
				Users = chkList.eq(i).next().val();
				Userstxt = chkList.eq(i).next().next().val();
			}
			else {
				Users += "," + chkList.eq(i).next().val();
				Userstxt += "," + chkList.eq(i).next().next().val();
			}
		}

		document.body.appendChild(form3);

		var userstxt = document.createElement("input");

		userstxt.setAttribute("type", "text");
		userstxt.setAttribute("name", "txtselectUser");
		userstxt.setAttribute("value", Userstxt);

		var users = document.createElement("input");

		users.setAttribute("type", "hidden");
		users.setAttribute("name", "hdnUserNo");
		users.setAttribute("value", Users);

		form3.appendChild(userstxt);
		form3.appendChild(users);

		form3.setAttribute("action", "/Note/LayerNoteWrite");
		window.open("", "message3", "width=800, height=650, scrollbars=yes, resizable=no");

		form3.submit();
	}

}

//팝업
//fnOpenPopup("/Homework/MemberList/27215/16/7607, "ExamStudent", 700, 600, 0, 0, "auto");
function fnOpenPopup(URL, popupName, width, height, top, left, scroll, fullscreenYn) {
	var objWin;

	if (fullscreenYn == "Y") {
		objWin = window.open(URL, popupName, "width=" + screen.width + ", height=" + screen.height + ", fullscreen=yes, left=" + left + ",top=" + top + ", scrollbars=" + (scroll == undefined || scroll == "auto" ? "yes" : scroll));
	} else {
		objWin = window.open(URL, popupName, "width=" + width + ", height=" + height + " resizable=yes, left=" + left + ",top=" + top + ", scrollbars=" + (scroll == undefined || scroll == "auto" ? "yes" : scroll));
	}

	if (objWin != null)
		objWin.focus();
	return objWin;
}

//OCW용 팝업
function fnOcwViewPopup(URL, popId, width, height, fId, fullscreenYn) {
	fullscreenYn = fullscreenYn == undefined || fullscreenYn == null ? "" : fullscreenYn ? ",fullscreen=yes" : "";
	var win = window.open("", popId, "width=" + width + ", height=" + height + ", scrollbars=yes, resizable=yes" + fullscreenYn);

	if (win == null) {
		bootAlert("팝업차단을 해제해 주세요.");
	}
	else {
		var frm = document.getElementById(fId == undefined || fId == null ? "frmpop" : fId)
		var windNm = window.name || "LMS_parent";
		var action = $(frm).attr("action");

		frm.action = URL;
		frm.target = popId;
		frm.method = "post";
		frm.submit();
		frm.action = action;
		frm.target = windNm;

		if (windNm == "LMS_parent") {
			$(frm).removeAttr("target");
		}
		win.focus();
		setTimeout(function () {
			if (win.document.location.href == "about:blank") {
				win.close();
			}
		}, 5000);
	}
}


function fnOcwView(ocwNo, ocwType, ocwSourceType, ocwData, OcwFileNo, ocwWidth, ocwHeight, fid, inningNo) {
	console.log(ocwNo, "|", ocwType, "|", ocwSourceType, "|", ocwData, "|", OcwFileNo, "|", ocwWidth, "|", ocwHeight, "|", fid, "|", inningNo);
	inningNo = inningNo || 0;
	fid = fid || "frmpop";
	ocwData = decodeURIComponent(ocwData);

	if (inningNo > 0 && ocwNo == 0) {
		bootAlert("강의컨텐츠가 없습니다.");
		return false;
	}
	else if (inningNo > 0 && ocwType != 0) {
		bootAlert("출석인정용 콘텐츠가 아닙니다. 관리자에게 문의바랍니다.");
	} else {
		if (ocwType == 0) {
			$("#OcwViewOcwNo").val(ocwNo);

			if ($("#OcwViewInningNo").length > 0) {
				$("#OcwViewInningNo").val(inningNo);
			}

			if (ocwSourceType == 0) {

				//HISTORY 내역 함수
				ajaxHelper.CallAjaxPost("/Ocw/OcwViewHistory", { OcwNo: ocwNo }, "fnCbEmpty");

				if ($("#txtOcwData").length < 1 || ($("#txtOcwData").text() || "") == "") {
					//window.open(ocwData);
					fnOcwViewPopup("/Ocw/OcwView", "ocwView", ocwWidth + 50, ocwHeight + 70, fid);
				}
				else {
					//window.open($("#textOcwData").text());
					fnOcwViewPopup("/Ocw/OcwView", "ocwView", ocwWidth + 50, ocwHeight + 70, fid);
				}
			}
			else {
				fnOcwViewPopup("/Ocw/OcwView", "ocwView", ocwWidth + 50, ocwHeight + 70, fid);
			}
		}
		else {
			if (ocwSourceType == 0) {
				window.open(ocwData);
			}
			else if (ocwSourceType == 5 || ocwSourceType == 4) {
				fnFileDownload(OcwFileNo);
			}

			//HISTORY 내역 함수
			ajaxHelper.CallAjaxPost("/Ocw/OcwViewHistory", { OcwNo: ocwNo }, "fnCbEmpty");
		}

	}

	fnPrevent();
}

function fnCbEmpty() {
			
}