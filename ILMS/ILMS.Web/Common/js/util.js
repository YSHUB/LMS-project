/*
 * 해당 파일은 다른 언어 보통 기본으로 제공하는 기본함수 ex)string.format, string.replace
 * 또는 디자인과 관련된 함수 ex) datepicker, alert, layer
 * 와 같이 공통된 내용을 작성합니다.
 */

// $.stringFormat("제 이름은 {0} 입니다. {1} {0}","홍길동","테스트" );
//결과값 :제 이름은 홍길동 입니다. 테스트 홍길동
(function ($) {
	$.stringFormat = function () {
		if (arguments.length < 2) {
			return false;
		}
		else {
			for (var i = 0; i < arguments.length; i++) {
				var searchStr = "{" + i + "}";
				while (arguments[0].indexOf(searchStr) != -1) {
					arguments[0] = arguments[0].replace("{" + i + "}", arguments[i + 1]);
				}
			}
			return arguments[0];
		}
	}
})(jQuery);

// 기간 달력 [ yyyy-MM-dd ~ yyyy-MM-dd ] 
// [setStartDayId] 세팅할 시작일자 id / [setEndDayId] 세팅할 종료일자 id / [setDefaultType] 시작일자 default 설정(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
function fnFromToCalendar(setStartDayId, setEndDayId, setDefaultType) {
	var setDateType = (setDefaultType != "") ? setDefaultType : 'today';

	var dateFormat = "yy-mm-dd"
		, from = $("#" + setStartDayId).datepicker({
			defaultDate: "today"
			, dateFormat: 'yy-mm-dd'
			, showOtherMonths: true
			, showMonthAfterYear: true
			, changeYear: true
			, changeMonth: true
			, numberOfMonths: 1
			, yearSuffix: "년"																							//달력의 년도 부분 뒤 텍스트
			, monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']	//달력의 월 부분 텍스트
			, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']		//달력의 월 부분 Tooltip
			, dayNamesMin: ['일', '월', '화', '수', '목', '금', '토']													//달력의 요일 텍스트
			, dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일']							//달력의 요일 Tooltip
			, minDate: "-5Y"																							//최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
			, maxDate: "+5y"																							//최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)  
		})
		.on("change", function () {
			to.datepicker("option", "minDate", fnGetDate(this));
		}), to = $("#" + setEndDayId).datepicker({
			defaultDate: "today"
			, dateFormat: 'yy-mm-dd'
			, showOtherMonths: true
			, showMonthAfterYear: true
			, changeYear: true
			, changeMonth: true
			, numberOfMonths: 1
			, yearSuffix: "년"																							//달력의 년도 부분 뒤 텍스트
			, monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']	//달력의 월 부분 텍스트
			, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']		//달력의 월 부분 Tooltip
			, dayNamesMin: ['일', '월', '화', '수', '목', '금', '토']													//달력의 요일 텍스트
			, dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일']							//달력의 요일 Tooltip
			, minDate: "-5Y"																							//최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
			, maxDate: "+5y"																							//최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)
		})
		.on("change", function () {
			from.datepicker("option", "maxDate", fnGetDate(this));
		});

	//초기값 설정
	$('#' + setStartDayId).datepicker('setDate', setDateType);
	$('#' + setEndDayId).datepicker('setDate', setDateType); 
}

// 기간 달력 사용시 min, max 날짜 설정을 위해 추가
function fnGetDate(element) {
	var dateFormat = 'yy-mm-dd';
	var date;
	try {
		date = $.datepicker.parseDate(dateFormat, element.value);
	} catch (error) {
		date = null;
	}
	return date;
}

// 달력 [ yyyy-MM-dd ] 
// [setDayId] 세팅할 일자 id / [setDefaultType] 시작일자 default 설정(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
function fnCalendar(setDayId, setDefaultType) {
	var setDateType = (setDefaultType != "") ? setDefaultType : 'today';

	//날짜 선택 - input을 datepicker로 선언
	$("#" + setDayId).datepicker({
		dateFormat: 'yy-mm-dd'																						//달력 날짜 형태
		, showOtherMonths: true																						//빈 공간에 현재월의 앞뒤월의 날짜를 표시
		, showMonthAfterYear: true																					//월- 년 순서가아닌 년도 - 월 순서
		, changeYear: true																							//option값 년 선택 가능
		, changeMonth: true																							//option값  월 선택 가능
		, yearSuffix: "년"																							//달력의 년도 부분 뒤 텍스트
		, monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']	//달력의 월 부분 텍스트
		, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']		//달력의 월 부분 Tooltip
		, dayNamesMin: ['일', '월', '화', '수', '목', '금', '토']													//달력의 요일 텍스트
		, dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일']							//달력의 요일 Tooltip
		, minDate: "-5Y"																							//최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		, maxDate: "+5y"																							//최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)  
	});

	//초기값 설정
	$('#' + setDayId).datepicker('setDate', setDateType);
}

// Ajax
// 사용예시) 
// var ajaxHelper = new AjaxHelper(); >>> Ajax 객체생성
// ajaxHelper.CallAjaxPost("/Quiz/InningList", { courseno: <%:Model.CourseNo%>, weekno: $(this).val() }, "CompleteInningList"); >>> 호출(URL, 파라미터, 콜백함수)
// ajaxHelper.CallAjaxPost("/Quiz/InningList", { courseno: <%:Model.CourseNo%>, weekno: $(this).val() }, "CompleteInningList", 'param1'); >>> 호출(URL, 파라미터, 콜백함수, 콜백함수용 파라미터)
// ajaxHelper.CallAjaxPost("/Quiz/InningList", { courseno: <%:Model.CourseNo%>, weekno: $(this).val() }, "alert", "'저장되었습니다.'", "저장에 실패하였습니다."); >>> 호출(URL, 파라미터, 콜백함수(alert), 성공메세지, 실패메세지)
// var result = ajaxHelper.CallAjaxResult();  >>> 결과값
var AjaxHelper = function () {
	var resultAjax;			// 리턴값

	// 실행결과
	this.CallAjaxResult = function () {
		return resultAjax;
	}

	// [url] 통신할 url / [queryJsonType] 전달할 파라미터 / [callbackFunction] 콜백함수 / [strParam] 콜백함수 호출시 파라미터
	this.CallAjaxPost = function (url, queryJsonType, callbackFunction, strParam, strErMsg) {
		var path = url;
		
		$.ajax({
			type: "POST"
			, url: path
			, data: queryJsonType
			, dataType: "json"
			, async: false
			, success: function (data) {
				resultAjax = data;
				if (callbackFunction != null && callbackFunction != "") {
					if (strParam != undefined && strParam != null) {
						eval(callbackFunction + "(" + strParam + ");");
					} else {
						eval(callbackFunction + "();");
					}
				}
			}, error: function (data) {
				resultAjax = data;
				if (strErMsg != undefined && strErMsg != null) {
					bootAlert(strErMsg);
				}
				console.log(resultAjax);
			}
		});
	};

	//파일 전송용 ajax
	// [url] 통신할 url / [queryJsonType] 전달할 파라미터 / [callbackFunction] 콜백함수 / [strParam] 콜백함수 호출시 파라미터
	this.CallAjaxPostFile = function (url, queryJsonType, callbackFunction, strParam, strErMsg) {
		var path = url;
		
		$.ajax({
			type: "POST"
			, url: path
			, data: queryJsonType
			, dataType: "json"
			, processData: false
			, contentType: false
			, async: false
			, success: function (data) {
				resultAjax = data;
				if (callbackFunction != null && callbackFunction != "") {
					if (strParam != undefined && strParam != null) {
						eval(callbackFunction + "(" + strParam + ");");
					} else {
						eval(callbackFunction + "();");
					}
				}
			}, error: function (data) {
				resultAjax = data;
				if (strErMsg != undefined && strErMsg != null) {
					bootAlert(strErMsg);
				}
				console.log(resultAjax);
			}
		});
	};
}

// 안내용 레이어 표시
function fnShowInfoLayer(msg) {
	$("#divInfoLayer .msg").html("처리중입니다. <br />잠시만 기다려 주세요.");
	if ((msg || "") != "") {
		$("#divInfoLayer .msg").html(msg);
	}
	$("#divInfoLayer").show();
}

function fnHideInfoLayer() {
	$("#divInfoLayer").hide();
}

// 문자열 대체
function fnReplaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}

// 길이에 맞게 숫자 앞에 0 채우기
// [str] 문자 / [len] 길이
function fnLpad(str, len) { 
	str = str + "";
	while (str.length < len) {
		str = "0" + str;
	}
	return str;
}

function convertBootMessge(msg) {
	msg = msg.replace(/[\r\n]/g, '<br>');
	msg = msg.replace(/[\r]/g, '<br>');
	msg = msg.replace(/[\n]/g, '<br>');
	return msg;
}

function bootAlert(msg, callback) {
	msg = convertBootMessge(msg);
	if (callback) {
		bootbox.alert({
			title: '<i class="bi bi-info-circle-fill"></i> 알림',
			message: msg,
			callback: function () {
				setTimeout(function () { callback(); }, 1);
			}
		});
	}
	else {
		bootbox.alert({
			title: '<i class="bi bi-info-circle-fill"></i> 알림',
			message: msg
		});
	}
}

function bootConfirm(msg, callback, param) {
	msg = convertBootMessge(msg);
	bootbox.confirm({
		title: '<i class="bi bi-question-circle-fill"></i> 확인',
		message: msg,
		buttons: {
			cancel: {
				label: '<i class="bi bi-x"></i> 취소'
			},
			confirm: {
				label: '<i class="bi bi-check"></i> 확인'
			}
		},
		callback: function (confirmed) {
			if (confirmed) {
				setTimeout(function () { callback(param); }, 1);
			}
		}
	});
}

// 생년월일 달력 [ yyyy-MM-dd ] 
// [setDayId] 세팅할 일자 id / [setDefaultType] 시작일자 default 설정(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
function fnBirthCalendar(setDayId, setDefaultType) {
	var setDateType = (setDefaultType != "") ? setDefaultType : 'today'; 
	//날짜 선택 - input을 datepicker로 선언
	$("#" + setDayId).datepicker({
		dateFormat: 'yy-mm-dd'																						//달력 날짜 형태
		, showOtherMonths: true																						//빈 공간에 현재월의 앞뒤월의 날짜를 표시
		, showMonthAfterYear: true																					//월- 년 순서가아닌 년도 - 월 순서
		, changeYear: true																							//option값 년 선택 가능
		, changeMonth: true																							//option값  월 선택 가능
		, yearSuffix: "년"																							//달력의 년도 부분 뒤 텍스트
		, monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']	//달력의 월 부분 텍스트
		, monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']		//달력의 월 부분 Tooltip
		, dayNamesMin: ['일', '월', '화', '수', '목', '금', '토']													//달력의 요일 텍스트
		, dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일']							//달력의 요일 Tooltip
		, yearRange: 'c-100:c+10'																					// 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위
	});

	//초기값 설정
	$('#' + setDayId).datepicker('setDate', setDateType);
}