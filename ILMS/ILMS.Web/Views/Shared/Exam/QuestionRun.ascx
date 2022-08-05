<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : ConfigurationManager.AppSettings["ExamText"].ToString();
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<form action="/<%:GubunCd %>/RunSubmit" method="post" id="mainForm" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
	<div class="row no-gutters">
		<div class="col-xl-8 p-4 position-relative">
			<h2 class="title03"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 정보</h2>
			<div class="card">
				<div class="card-body">
					<ul class="list-inline-style03">
						<li class="list-inline-item">
							<strong class="pr-2"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></strong>
							<span><%:Model.ExamineeDetail.UserID %></span>
						</li>
						<li class="list-inline-item bar-vertical"></li>
						<li class="list-inline-item">
							<strong class="pr-2">이름</strong>
							<span><%:Model.ExamineeDetail.HangulName %></span>
						</li>
						<li class="list-inline-item bar-vertical <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"></li>
						<li class="list-inline-item <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>">
							<strong class="pr-2">학년</strong>
							<span><%:Model.ExamineeDetail.GradeNm %></span>
						</li>
						<li class="list-inline-item bar-vertical <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"></li>
						<li class="list-inline-item <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>">
							<strong class="pr-2">소속</strong>
							<span><%:Model.ExamineeDetail.AssignName %></span>
						</li>
					</ul>
				</div>
			</div><!-- card -->

			<h2 class="title03 mt-4"><%:GubunNm %> 정보</h2>
			<div class="card">
				<div class="card-body">
					<ul class="list-inline-style03">
						<li class="list-inline-item text-center <%:Model.ExamDetail.SEType.Equals(1) ? "" : "d-none" %>">
							<strong class="d-block"><%:Model.ExamDetail.SEType.Equals(1) ? "남은시간" : "경과시간" %></strong>
							<span class="text-primary font-size-20"><i class="bi bi-clock-history mx-2"></i> <strong id="chkTime">00분 00초</strong></span>
							<input type="hidden" id="hdnRemainTime" name="hdnRemainTime" />
							<input type="hidden" id="hdnRemainSecond" name="hdnRemainSecond" />
						</li>
						<li class="list-inline-item bar-vertical height2 <%:Model.ExamDetail.SEType.Equals(1) ? "" : "d-none" %>"></li>
						<li class="list-inline-item text-center">
							<strong class="d-block">현재문항</strong>
							<span class="text-point font-size-20"><i class="bi bi-list-check mx-2"></i> <strong id="currentPage"><%:Model.QuestionDetail.RowIndex %></strong>/<%:Model.QuestionList.Count %></span>
						</li>
					</ul>
				</div>
			</div><!-- card -->
			<p class="font-size-15 text-danger font-weight-bold mb-0">
				<i class="bi bi-info-circle-fill"></i> 남은 시간이 정확히 표시되는지 확인하고 문제를 풀어주십시오.
				<%
					if (Model.AdminYn.Equals("Y"))
					{
				%>
				<br /><i class="bi bi-info-circle-fill"></i> 미리보기의 경우 문제섞기, 보기섞기 기능이 적용되지 않으며 출제된 모든 문제가 조회됩니다.
				<%
					}
				%>
			</p>
      
			<%
				if (Model.QuestionDetail == null)
				{
			%>
			<div class="card card-style01 mt-4">
				<div class="card-header text-center">
					조회된 문제가 없습니다.
				</div>
			</div>
			<%
				}
				else
				{
			%>
			<div class="card card-style01 mt-4">
				<div class="card-header">
					<input type="hidden" id="hdnRowIndex" name="QuestionDetail.RowIndex" value="<%:Model.QuestionDetail.RowIndex %>" />
					<input type="hidden" id="hdnQuestionNo" name="QuestionDetail.QuestionNo" value="<%:Model.QuestionDetail.QuestionNo %>" />
					<input type="hidden" id="hdnQuestionBankNo" name="QuestionDetail.QuestionBankNo" value="<%:Model.QuestionDetail.QuestionBankNo %>" />
					<input type="hidden" id="hdnQuestionType" name="QuestionDetail.QuestionType" value="<%:Model.QuestionDetail.QuestionType %>" />
					<input type="hidden" id="hdnExamineeNo" name="QuestionDetail.ExamineeNo" value="<%:Model.ExamineeDetail.ExamineeNo %>" />
					<input type="hidden" id="hdnCourseNo" name="ExamDetail.CourseNo" value="<%:Model.ExamDetail.CourseNo %>" />
					<input type="hidden" id="hdnExamNo" name="ExamDetail.ExamNo" value="<%:Model.ExamDetail.ExamNo %>" />
					<input type="hidden" id="hdnIsResultYesNo" name="ExamineeDetail.IsResultYesNo" />
					
					<div class="card-title02" id="question"><strong class="badge badge-primary mr-2">문제<%:Model.QuestionDetail.RowIndex %></strong><%=Model.QuestionDetail.Question %></div>
				</div>
				
				<div class="card-body">
					<div class="row">
						<div class="form-group col-12" id="example">

						</div>
					</div>
				</div>
			</div>
			<%
				}
			%>

			<div class="text-left mt-4">
				<button type="button" class="btn btn-secondary d-none" id="btnPre">이전</button>
				<button type="button" class="btn btn-secondary <%:(Model.NextPage > 0) ? "" : "d-none" %>" id="btnNext" data-toggle="modal" data-target="#layer_next">다음</button>
			</div>
		</div>
		<div class="col-xl-4 bg-point-light p-4 position-relative">
			<h3 class="title03">답변현황 <small class="total">(미답변: 총 <strong class="text-danger" id="noAnswerCnt"><%:Model.noAnswerCnt %></strong>건)</small></h3>

			<div class="card">
				<div class="card-body">
					<div class="overflow-auto bg-white overflow-xs overflow-sm overflow-md overflow-xl">
						<div class="table-responsive">
							<table class="table table-hover sticky-header" summary="">
								<thead>
									<tr>
									<th scope="col">번호</th>
									<th scope="col">문제유형</th>
									<th scope="col">답안체크</th>
									</tr>
								</thead>
								<tbody>
									<%
										int i = 1;
										foreach (var item in Model.QuestionList)
										{
									%>
									<tr>
									<th scope="row">
										<input type="hidden" id="hdnExamineeAnswers<%:i %>" name="hdnExamineeAnswers" value="<%:(item.ExamineeAnswer == null || item.ExamineeAnswer == "") ? "" : item.ExamineeAnswer %>" />
										<input type="hidden" id="hdnOldExamineeAnswers<%:i %>" name="hdnOldExamineeAnswers" value="<%:(item.ExamineeAnswer == null || item.ExamineeAnswer == "") ? "" : item.ExamineeAnswer %>" />
										<input type="hidden" id="hdnQuestionBankNo<%:i %>" name="hdnQuestionBankNos" value="<%:item.QuestionBankNo %>" />
										<input type="hidden" id="hdnQuestionNo<%:i %>" name="hdnQuestionNos" value="<%:item.QuestionNo %>" />
										<input type="hidden" id="hdnQuestionType<%:i %>" name="hdnQuestionTypes" value="<%:item.QuestionType %>" />

										<button type="button" id="btnQuestionLink<%:i %>" name="btnQuestionLink" onclick="fnSave('0', '<%:i - 1 %>')"><%:i %></button>
									</th>
									<td><%:item.QuestionTypeNm %></td>
									<td class="text-primary"><i class="bi <%:(item.AnswerChk.Equals("Y")) ? "bi-check-circle-fill" : "bi-circle" %>" id="chkQuestion<%:i %>"><span class="sr-only">선택</span></i></td>
									</tr>
									<%
											i++;
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div><!-- card -->
  
			<div class="text-right mt-4">
				<button type="button" class="btn btn-secondary" id="btnTempSave" onclick="fnSave('0', '<%:Model.QuestionDetail.RowIndex + 1 %>')">임시저장</button>
				<button type="button" class="btn btn-primary" id="btnSave" onclick="fnSave('1', '')">최종저장(응시완료)</button>
			</div>
		</div>
	</div>
</form>

<script>
	// ajax 객체 생성
	var ajaxHelper;
	var getSetType = "<%:Model.ExamDetail.SEType %>"; // 응시방식 ( 0 : 시작/종료방식, 1 : 기간방식 )
	var remainSecond = <%:Model.initSecond %>;	      // 남은 시간(sec)
	var saveTimer = 5								  // 저장 간격
	var timer = 0;									  // 타이머

	// 키보드 동작 제어
	document.onkeydown = function () {
		e = window.event;

		// Ctrl키
		if (e.ctrlKey == true) {
			return false;
		}
		// Alt키
		else if (e.altKey == true) {
			return false;
		}

		// 브라우저기능키
		switch (e.keyCode) {
			case 122: // F11
			case 116: // F5
			case 123: // F12
			case 91:
			case 92: // WindowKey
				e.keyCode = 0;
				return false;
				break;
		}
	}

	window.addEventListener('beforeunload', function (e) {
		if ($("#hdnIsResultYesNo").val() != "1" && $("#hdnIsResultYesNo").val() != "2") {
			fnSave('0', $("#hdnRowIndex").val());
		}

		// 타임아웃 아닌 경우에만 체크
		if ($("#hdnIsResultYesNo").val() == "" || $("#hdnIsResultYesNo").val() != "2") {
			e.preventDefault();
			e.returnValue = '창을 닫으시겠습니까?';
		}
	});


	$(document).ready(function () {
		ajaxHelper = new AjaxHelper();

		// 타이머 호출
		fnSetTimer();

		// 보기
		fnCallExample();

		$("#btnPre").click(function () {
			fnSave('0', parseInt($("#hdnRowIndex").val()) - 2);
		});

		$("#btnNext").click(function () {
			if (fnChk()) {
				fnSave('0', $("#hdnRowIndex").val());
			} else {
				bootConfirm("답을 입력하지않으셨습니다. 계속 진행 하시겠습니까?", fnGetQuestion, $("#hdnRowIndex").val());
			}
		});
	})

	// 타이머(1초 간격)
	function fnSetTimer() {
		// 응시방식이 기간방식일 경우(down)
		if (<%:Model.ExamDetail.SEType%> == 1) {
			var remainMinute_ = parseInt(remainSecond / 60); // 분(min)
			var remainSecond_ = remainSecond % 60;			 // 초(sec)

			if (remainSecond > 0) {
				// 초 간격 체크
				if (remainSecond % saveTimer == 0) {
					// 관리자가 아니면 남은시간 저장
					if ("<%:Model.AdminYn%>" != "Y") {
						fnRemainTimeSave();
					}
				}

				$('#chkTime').empty();
				$('#chkTime').append(fnLpad(remainMinute_, 2) + "분 " + fnLpad(remainSecond_, 2) + "초"); // hh분 ss초
				$("#hdnRemainTime").val(remainMinute_);
				$("#hdnRemainSecond").val(remainSecond_);

				remainSecond--;
				setTimeout("fnSetTimer()", 1000); // 1초 간격으로 재귀호출
			}
			else {
				bootAlert("<%:GubunNm %> 시간이 종료되었습니다. \n<%:GubunNm %> 내용을 전송합니다.", function () {
					fnSave('2', '');
				});
			}
		// 응시방식이 시작/종료방식일 경우(up)
		} else {
			var remainMinute_ = parseInt(timer / 60); // 분(min)
			var remainSecond_ = timer % 60;			  // 초(sec)

			// 초 간격 체크
			if (timer % saveTimer == 0) {
				// 관리자가 아니면 종료여부 체크
				if ("<%:Model.AdminYn%>" != "Y") {
					fnChkSetType();
				}
			}

			$('#chkTime').empty();
			$('#chkTime').append(fnLpad(remainMinute_, 2) + "분 " + fnLpad(remainSecond_, 2) + "초"); // hh분 ss초
			$("#hdnRemainTime").val(remainMinute_);
			$("#hdnRemainSecond").val(remainSecond_);

			timer++;
			setTimeout("fnSetTimer()", 1000); // 1초 간격으로 재귀호출
		}
	}

	// 응시방식이 시작/종료방식일 경우 종료여부 체크
	function fnChkSetType() {
		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/ChkSetType", { examno: <%:Model.ExamNo%> }, "fnChkSetTypeResult", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnChkSetTypeResult() {
		var result = ajaxHelper.CallAjaxResult();
		
		if (result < 1) {
			bootAlert("<%:GubunNm %> 응시가 종료되었습니다. \n<%:GubunNm %> 내용을 전송합니다.", function () {
				fnSave('2', '');
			});
		}
	}

	// 남은시간 저장
	function fnRemainTimeSave() {
		var limitTime = <%:Model.ExamDetail.LimitTime %>;
		var remainTime = parseInt(($("#hdnRemainTime").val().trim() == "") ? "0" : $("#hdnRemainTime").val());
		var remainSecond = parseInt(($("#hdnRemainSecond").val().trim() == "") ? "0" : $("#hdnRemainSecond").val());
		var saveTime = 0;
		var saveSecond = 0;

		// 응시방식이 기간방식일 경우(down)
		if (<%:Model.ExamDetail.SEType%> == 1) {
			if (remainSecond > 0) {
				saveTime = limitTime - remainTime - 1;
				saveSecond = 60 - remainSecond;
			}
			else {
				saveTime = limitTime - remainTime;
				saveSecond = 0;
			}
		} else {
			saveTime = remainTime;
			saveSecond = remainSecond;
		}

		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/SaveTime", { examineeno: <%:Model.ExamineeDetail.ExamineeNo%>, remaintime: saveTime, remainsecond: saveSecond }, "", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnGetQuestion(QuestionIndex) {
		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetQuestion", { examno: <%:Model.ExamNo%>, examineeno: parseInt($("#hdnExamineeNo").val()), currentpage: parseInt(QuestionIndex), adminyn: "<%:Model.AdminYn%>" }, "fnQuestionItem", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	// 문항
	function fnQuestionItem() {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result != null) {
			if (result.QuestionDetail != null) {
				var seq = result.QuestionDetail.RowIndex;

				// 초기화
				$("#hdnRowIndex").val("");
				$("#hdnQuestionNo").val("");
				$("#hdnQuestionBankNo").val("");
				$("#hdnQuestionType").val("");
				$("#currentPage").html("");
				$("#question").html("");

				// 값 세팅
				$("#hdnRowIndex").val(seq);
				$("#currentPage").html(seq);
				$("#hdnQuestionNo").val(result.QuestionDetail.QuestionNo);
				$("#hdnQuestionBankNo").val(result.QuestionDetail.QuestionBankNo);
				$("#hdnQuestionType").val(result.QuestionDetail.QuestionType);
				$("#question").html("<strong class='badge badge-primary mr-2'>문제" + seq + "</strong>" + result.QuestionDetail.Question);

				// 이전 버튼
				if (parseInt(result.PrePage) > 0) $("#btnPre").removeClass("d-none");
				else $("#btnPre").addClass("d-none");

				// 다음 버튼
				if (parseInt(result.NextPage) > 0) $("#btnNext").removeClass("d-none");
				else $("#btnNext").addClass("d-none");
					
			} else {
				$("#btnPre").addClass("d-none");
				$("#btnNext").addClass("d-none");
			}
		}

		fnCallExample();
	}

	// 답안
	function fnCallExample() {
		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetExample", { examplemixyesno : "<%:Model.ExamDetail.ExampleMixYesNo %>", examno : <%:Model.ExamNo%>, questionbankno: parseInt($("#hdnQuestionBankNo").val()), examineeno: parseInt($("#hdnExamineeNo").val()) }, "fnExampleItem", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnExampleItem() {
		var result = ajaxHelper.CallAjaxResult();
		var rowIndex = $("#hdnRowIndex").val();
		var hdnExamineeAnswers = $("#hdnExamineeAnswers" + rowIndex).val().trim();
		var selected = "";
		var html = "";

		// 초기화
		$("#example").html("");

		if (result != null) {
			// 서술형
			if (result.QuestionExampleList[0].QuestionType == "MJQT001") {
				$("#btnTempSave").removeClass("d-none");
				var answers = ("<%:Model.AdminYn%>" == "Y") ? hdnExamineeAnswers : result.QuestionExampleList[0].ExamineeAnswer;

				html += "<textarea id='txtDescription' name='txtDescription' class='form-control' rows='3' onkeyup='fnChkAnswer()'>" + answers + "</textarea>";
			// 단일선택
			} else if (result.QuestionExampleList[0].QuestionType == "MJQT002") {
				$("#btnTempSave").addClass("d-none");
				for (var i = 0; i < result.QuestionExampleList.length; i++) {
					var answers = ("<%:Model.AdminYn%>" == "Y") ? hdnExamineeAnswers : result.QuestionExampleList[0].ExamineeAnswer;

					selected = (result.QuestionExampleList[i].ExampleNo == answers) ? "checked" : "";

					html += "<div class='form-check'>";
					html += "<input class='form-check-input' type='radio' name='rbtSingle' id='rbtSingle" + i + "' value='" + result.QuestionExampleList[i].ExampleNo + "' onclick='fnChkAnswer()' " + selected + " />";
					html += "<label class='form-check-label' for='rbtSingle" + i + "'>";
					html += result.QuestionExampleList[i].ExampleContents;

					// 이미지가 있는 경우
					if (result.QuestionExampleList[i].OriginFileName != null && result.QuestionExampleList[i].OriginFileName != "") {
						html += "<img src='/files" + result.QuestionExampleList[i].SaveFileName + "' class='img-fluid w-100' alt='" + result.QuestionExampleList[i].ExampleContents + "'>";
					}

					html += "</label>";
					html += "</div>";
				}
			// 다중선택
			} else if (result.QuestionExampleList[0].QuestionType == "MJQT003") {
				$("#btnTempSave").addClass("d-none");

				var chkAnswer = (result.QuestionExampleList[0].ExamineeAnswer != null && result.QuestionExampleList[0].ExamineeAnswer != "") ? result.QuestionExampleList[0].ExamineeAnswer.split(",") : "";

				// 관리자인 경우
				if ("<%:Model.AdminYn%>" == "Y") chkAnswer = (hdnExamineeAnswers != null && hdnExamineeAnswers != "") ? hdnExamineeAnswers.split(",") : "";

				for (var i = 0; i < result.QuestionExampleList.length; i++) {
					selected = (chkAnswer.indexOf(String(result.QuestionExampleList[i].ExampleNo)) > -1) ? "checked" : "";

					html += "<div class='form-check'>";
					html += "<input class='form-check-input' type='checkbox' name='chkMulti' id='chkMulti" + i + "' value='" + result.QuestionExampleList[i].ExampleNo + "' onclick='fnChkAnswer()' " + selected + " />";
					html += "<label class='form-check-label' for='chkMulti" + i + "'>";
					html += result.QuestionExampleList[i].ExampleContents;

					// 이미지가 있는 경우
					if (result.QuestionExampleList[i].OriginFileName != null && result.QuestionExampleList[i].OriginFileName != "") {
						html += "<img src='/files" + result.QuestionExampleList[i].SaveFileName + "' class='img-fluid w-100' alt='" + result.QuestionExampleList[i].ExampleContents + "'>";
					}

					html += "</label>";
					html += "</div>";
						
				}
			// 단답형
			} else if (result.QuestionExampleList[0].QuestionType == "MJQT004") {
				$("#btnTempSave").addClass("d-none");
				var answers = ("<%:Model.AdminYn%>" == "Y") ? hdnExamineeAnswers : result.QuestionExampleList[0].ExamineeAnswer;

				html += "<textarea id='txtShortAnswer' name='txtShortAnswer' class='form-control' rows='3' onkeyup='fnChkAnswer()'>" + answers + "</textarea>";
			}
		}

		$("#example").html(html);
	}

	// 답안체크
	function fnChk(rowIndex) {
		var questionType = $("#hdnQuestionType").val();
		var chk = false;

		if (questionType == "MJQT001") {
			$("#hdnExamineeAnswers" + rowIndex).val($("#txtDescription").val().trim());
			chk = ($("#txtDescription").val().trim() != "");
		} else if (questionType == "MJQT002") {
			$("#hdnExamineeAnswers" + rowIndex).val($("input:radio[name='rbtSingle']:checked").val());
			chk = ($("input:radio[name='rbtSingle']:checked").length > 0);
		} else if (questionType == "MJQT003") {
			$("#hdnExamineeAnswers" + rowIndex).val($("input:checkbox[name='chkMulti']:checked").map( function() { return this.value; }).get().join(","));
			chk = ($("input:checkbox[name='chkMulti']:checked").length > 0);
		} else if (questionType == "MJQT004") {
			$("#hdnExamineeAnswers" + rowIndex).val($("#txtShortAnswer").val().trim());
			chk = ($("#txtShortAnswer").val().trim() != "");
		}

		return chk;
	}

	// 답안현황
	function fnChkAnswer() {
		var rowIndex = $("#hdnRowIndex").val();

		if (fnChk(rowIndex)) {
			$("#chkQuestion" + rowIndex).removeClass("bi-circle");
			$("#chkQuestion" + rowIndex).addClass("bi-check-circle-fill");
		} else {
			$("#chkQuestion" + rowIndex).removeClass("bi-check-circle-fill");
			$("#chkQuestion" + rowIndex).addClass("bi-circle");
		}

		var cnt = 0;
		$("input[name=hdnExamineeAnswers]").each(function (index, item) {
			if ($(item).val().trim() == "") cnt++;
		});

		$("#noAnswerCnt").html("");
		$("#noAnswerCnt").html(cnt);
	}

	// resultYesNo = 0 : 임시저장(0), resultYesNo = 1 : 최종저장(응시완료). resultYesNo = 2 : 시간초과 저장
	function fnSave(resultYesNo, rowIndex) {
		var chk = true;
		fnRemainTimeSave();

		$("#hdnIsResultYesNo").val(resultYesNo);

		var params = [];
		params.push({ "resultYesNo": resultYesNo, "rowIndex": rowIndex });

		// 시간초과 저장
		if (resultYesNo == "2") {
			fnLastConfirm(params);
		} else {
			// 최종제출
			if (resultYesNo == "1") {
				var cnt = 0;
				$("input[name=hdnExamineeAnswers]").each(function (index, item) {
					if ($(item).val().trim() == "") cnt++;
				});

				chk = (cnt == 0);
			}

			if (chk) {
				if (resultYesNo == "1") {
					bootConfirm("<%:GubunNm %> 내용을 전송합니다.", fnLastConfirm, params);
				} else {
					fnLastConfirm(params);
				}
			} else {
				bootAlert("입력하지 않은 답안이 존재합니다.");
			}
		}
	}

	function fnLastConfirm(param) {
		// 관리자는 임시저장 안함
		if ("<%:Model.AdminYn%>" == "Y") {
			if (param[0].resultYesNo != "0") {
				bootAlert("<%:GubunNm %> 내용이 전송되었습니다.", function () {
					window.close();
				});
			} else {
				fnGetQuestion(parseInt(param[0].rowIndex));
			}
		} else {
			ajaxHelper.CallAjaxPost("/<%:GubunCd %>/RunSubmit", $("#mainForm").serialize(), "fnSaveResult", "'" + param[0].resultYesNo + "', '" + param[0].rowIndex + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}
	}

	function fnSaveResult(resultYesNo, rowIndex) {
		var result = ajaxHelper.CallAjaxResult();

		if (result > 0) {
			if (rowIndex == null || rowIndex == "") {
				if (resultYesNo != "0") {
					bootAlert("<%:GubunNm %> 내용이 전송되었습니다.", function () {
						window.close();
					});
				} else {
					window.close();
				}

				opener.location.reload();
			} else {
				fnGetQuestion(parseInt(rowIndex));
			}
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}
</script>