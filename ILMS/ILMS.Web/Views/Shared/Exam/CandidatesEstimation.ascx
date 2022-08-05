<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.ExamViewModel>" %>

<%
	string GubunNm = Model.ExamineeDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamineeDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<div class="mt-4 alert bg-light rounded">
	<p class="font-size-14 text-danger font-weight-bold"><i class="bi bi-info-circle-fill"></i> 자동 채점 기능 사용 시 아래사항에 대하여 검토가 필요합니다.</p>
	<ul class="list-style03 mb-0">
		<li>
			단답형 자동 채점은 기호 또는 생각하지 못한 유사답안으로 인해 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>에게 오답으로 처리될 수 있으므로 반드시 단답형의 점수를 확인하시고 점수가 맞지 않는 경우 올바른 점수로 수정하시기 바랍니다.
		</li>
		<li>
			단답형의 자동 채점은 띄어쓰기 구분이 없으며, 영문자의 경우 대소문자 구분없이 사용자 답안과 비교됩니다.
		</li>
		<li>
			서술형의 경우, 점수를 <span class="text-danger">수동으로 입력</span>하셔야 합니다.
		</li>
		<li>
			<span class="text-danger">‘채점대기’</span>의 경우, 저장 이후 점수에 반영됩니다.
		</li>
	</ul>
</div>

<h3 class="title04 mt-4"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>정보</h3>
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
</div>

<h3 class="title04 mt-4">응시정보</h3>
<div class="card">
	<div class="card-body">
		<ul class="list-inline-style03">
			<li class="col-12 col-sm-auto px-0 mb-2 mb-sm-0 list-inline-item">
				<strong class="d-block">응시시작시간</strong>
				<span class="font-size-20 <%:(Model.ExamineeDetail.TakeDateTimeFormatView != null && Model.ExamineeDetail.TakeDateTimeFormatView != "") ? "" : "text-danger" %>"><%:(Model.ExamineeDetail.TakeDateTimeFormatView != null && Model.ExamineeDetail.TakeDateTimeFormatView != "") ? Model.ExamineeDetail.TakeDateTimeFormatView : "미응시" %></span>
			</li>
			<li class="list-inline-item bar-vertical"></li>
			<li class="list-inline-item">
				<strong class="d-block">객관식</strong>
				<strong class="font-size-20 text-primary"><%:Model.ExamineeScore.MultipleChoiceScore %></strong><span>/<%:Model.ExamineeScore.MultipleChoice %></span>
			</li>
			<li class="list-inline-item bar-vertical"></li>
			<li class="list-inline-item">
				<strong class="d-block">주관식</strong>
				<strong class="font-size-20 text-primary"><%:Model.ExamineeScore.EssayQuestionScore %></strong><span>/<%:Model.ExamineeScore.EssayQuestion %></span>
			</li>
			<li class="list-inline-item bar-vertical"></li>
			<li class="list-inline-item">
				<strong class="d-block">총점</strong>
				<strong class="font-size-20 text-primary"><%:Model.ExamineeScore.MultipleChoiceScore + Model.ExamineeScore.EssayQuestionScore %></strong><span>/<%:Model.ExamineeScore.MultipleChoice + Model.ExamineeScore.EssayQuestion %></span>
			</li>
		</ul>
	</div>
</div>

<h3 class="title04 mt-4">문항별 채점</h3>
<form action="/<%:GubunCd %>/UpdateExamineeEstimation" method="post" id="mainForm">
	<input type="hidden" id="hdnCourseNo" name="ExamineeDetail.CourseNo" value="<%:Model.ExamineeDetail.CourseNo %>" />
	<input type="hidden" id="hdnExamNo" name="ExamineeDetail.ExamNo" value="<%:Model.ExamineeDetail.ExamNo %>" />
	<input type="hidden" id="hdnExamineeNo" name="ExamineeDetail.ExamineeNo" value="<%:Model.ExamineeDetail.ExamineeNo %>" />

	<div id="questionDiv"></div>

	<div class="form" id="feedbackDiv">
		<div class="form-group">
			<label for="Exam_ExamContents" class="form-label">코멘트</label>
			<textarea id="Exam_ExamContents" name="ExamineeDetail.Feedback" rows="3" class="form-control"><%:Model.ExamineeDetail.Feedback %></textarea>
		</div>
	</div>
	<p class="font-size-14 text-danger font-weight-bold mb-0">
		<i class="bi bi-info-circle-fill"></i> 현재 진행된 평가를 저장하고 이전<%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 또는 다음<%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 평가로 바로 이동할 수 있습니다.
	</p>
	<div class="row mt-2">
		<div class="col-6">
			<button type="button" class="btn text-primary <%:Model.PrePage > 0 && Model.ExamineeList.Count > 1 ? "" : "d-none" %>" id="btnPre">
				<i class="bi bi-chevron-left"></i> <span>저장 후 이전 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 평가</span>
			</button>
		</div>
		<div class="col-6 text-right">
			<button type="button" class="btn text-primary <%:Model.NextPage > 0 && Model.ExamineeList.Count > 1 ? "" : "d-none" %>"" id="btnNext">
				<span>저장 후 다음 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 평가</span> <i class="bi bi-chevron-right"></i>
			</button>
		</div>
	</div>
	<div class="text-right mt-4">
		<button type="button" class="btn btn-primary" id="btnSave">저장</button>
		<a class="btn btn-secondary" href="/<%:GubunCd %>/EstimationList/<%:Model.ExamineeDetail.CourseNo %>/<%:Model.ExamineeDetail.ExamNo %>">목록</a>
	</div>
</form>

<script>
	// ajax 객체 생성
	var ajaxHelper;

	$(document).ready(function () {
		ajaxHelper = new AjaxHelper();

		$("#btnPre").click(function () {
			fnSave('pre');
		})

		$("#btnNext").click(function () {
			fnSave('next');
		})

		$("#btnSave").click(function () {
			bootConfirm("저장하시겠습니까?", fnSave, 'curr');
		})

		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetQuestion", { examno: <%:Model.ExamDetail.ExamNo%>, examineeno: parseInt($("#hdnExamineeNo").val()), currentpage: -1, adminyn: "N" }, "fnQuestionItem", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	})

	// 문항
	function fnQuestionItem() {
		var result = ajaxHelper.CallAjaxResult();
		$("#questionDiv").html();

		if (result != null && result.QuestionList.length > 0) {
			for (var i = 0; i < result.QuestionList.length; i++) {
				var seq = result.QuestionList[i].RowIndex;

				var html = "";

				html += "<div class='card card-style03 prtQuestion'>";
				html += "<div class='card-header'>";
				html += "<div class='row align-items-center'>";
				html += "<div class='col-lg mb-2 mb-lg-0'>";
				html += "<p class='card-title02'><strong class='badge badge-primary mr-2'>문제" + seq + "</strong>" + result.QuestionList[i].Question + "</p>";
				html += "</div>";
				html += "<div class='col-md-auto text-right'>";
				html += "<dl class='row dl-style01'>";
				html += "<dt class='col-auto text-dark'>" + result.QuestionList[i].QuestionCategory + "</dt>";
				html += "<dd class='col-auto mb-0'>" + result.QuestionList[i].QuestionTypeNm + "</dd>";
				html += "</dl>";
				html += "</div>";
				html += "<div class='col-md-auto text-right'>";
				html += "<dl class='row dl-style01'>";
				html += "<dt class='col-auto text-primary'>저장시간</dt>";
				html += "<dd class='col-auto mb-0'>" + ((result.QuestionList[i].SaveDateTimeFormatView != null && result.QuestionList[i].SaveDateTimeFormatView != "") ? result.QuestionList[i].SaveDateTimeFormatView : "-") + "</dd>";
				html += "</dl>";
				html += "</div>";
				html += "</div>";
				html += "</div>";

				html += "<div class='card-body' id='divExample" + result.QuestionList[i].QuestionNo + "'>";
				
				html += "</div>";

				html += "<div class='card-footer'>";
				html += "<div class='card-item01 form-inline justify-content-md-end'>";
				html += "<label for='txtScore" + result.QuestionList[i].QuestionNo + "' class='col-form-label mr-2'>점수입력 <strong class='pl-1 text-danger'>*</strong></label>";
				html += "<div class='input-group'>";
				html += "<input type='hidden' id='hdnReplyNos" + result.QuestionList[i].QuestionNo + "' name='hdnReplyNos' value='" + result.QuestionList[i].ReplyNo + "' />";
				html += "<input type='text' class='form-control text-right' id='txtScore" + result.QuestionList[i].QuestionNo + "' name='hdnScores' value='" + result.QuestionList[i].ScoreDec + "' onkeyup='fnScoreCheck(" + result.QuestionList[i].QuestionNo + ")' />";
				html += "<div class='input-group-append'>";
				html += "<input type='hidden' id='hdnPerfectScore" + result.QuestionList[i].QuestionNo + "' name='hdnPerfectScore' value='" + result.QuestionList[i].EachPointDec + "' />";
				html += "<span class='input-group-text'>" + result.QuestionList[i].EachPointDec + " 점</span>";
				html += "</div>";
				html += "</div>";
				html += "</div>";
				html += "<div class='card-item01'>";
				html += "<strong class='font-size-14'>답안설명</strong>";
				html += "<span class='col-sm'>" + result.QuestionList[i].AnswerExplain + "</span>";
				html += "</div>";
				html += "</div>";
				html += "</div>";

				$("#questionDiv").append(html);

				ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetExample", { examplemixyesno : "N", examno : <%:Model.ExamineeDetail.ExamNo%>, questionbankno: parseInt(result.QuestionList[i].QuestionBankNo), examineeno: <%:Model.ExamineeDetail.ExamineeNo%> }, "fnExampleItem", result.QuestionList[i].QuestionNo, "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
			}
		}
	}

	function fnExampleItem(questionNo) {
		var result = ajaxHelper.CallAjaxResult();
		var html = "";
		$("#divExample" + questionNo).html("");

		if (result != null) {
			// 서술형
			if (result.QuestionExampleList[0].QuestionType == "MJQT001") {
				html += "<ul class='pl-0'>";
				html += "<li>";
				html += "<strong class='font-size-14'><%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 답안</strong>";
				html += "<span class='col-sm'>" + result.QuestionExampleList[0].ExamineeAnswer + "</span>";
				html += "</li>";
				html += "</ul>";

			// 단답형
			} else if (result.QuestionExampleList[0].QuestionType == "MJQT004") {
				html += "<ul class='pl-0'>";
				html += "<li class='text-danger'>";
				html += "<strong class='font-size-14'><%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 답안</strong>";
				html += "<span class='col-sm'>" + result.QuestionExampleList[0].ExamineeAnswer + " <i class='bi bi-x-circle-fill d-md-inline d-none'></i></span>";
				html += "</li>";
				html += "<li class='text-primary'>";
				html += "<strong class='font-size-14'>모범답안</strong>";
				html += "<span class='col-sm'>" + result.QuestionExampleList[0].CorrectAnswer + " <i class='bi bi-check-circle-fill d-md-inline d-none'></i></span>";
				html += "</li>";
				html += "</ul>";

			// 단일선택 또는 다중선택
			} else {
				var chkAnswer = (result.QuestionExampleList[0].ExamineeAnswer != null && result.QuestionExampleList[0].ExamineeAnswer != "") ? result.QuestionExampleList[0].ExamineeAnswer.split(",") : "";

				html += "<ul class='pl-0'>";
				for (var i = 0; i < result.QuestionExampleList.length; i++) {
					var liClass = "secondary";
					var iconClass = "";
				
					if (result.QuestionExampleList[i].CorrectAnswerYesNo == "Y") {
						liClass = "primary";
						iconClass = "<i class='bi bi-check-circle-fill d-md-inline d-none'></i>";
					} else {
						if (chkAnswer.indexOf(String(result.QuestionExampleList[i].ExampleNo)) > -1) {
							liClass = "danger";
							iconClass = "<i class='bi bi-x-circle-fill d-md-inline d-none'></i>";
						}
					}

					html += "<li class='text-" + liClass + "'>";
					html += "<span>" + (i + 1) + ". " + result.QuestionExampleList[i].ExampleContents + " " + iconClass + "</span>";

					// 이미지가 있는 경우
					if (result.QuestionExampleList[i].OriginFileName != null && result.QuestionExampleList[i].OriginFileName != "") {
						html += "<div><img src='/files" + result.QuestionExampleList[i].SaveFileName + "' class='img-fluid w-100 border border-" + liClass + "' alt='" + result.QuestionExampleList[i].ExampleContents + "'></div>";
					}

					html += "</li>";
				}
				html += "</ul>";
			}
		}

		$("#divExample" + questionNo).append(html);
	}

	function fnScoreCheck(questionNo) {
		var perfectScore = parseFloat(($("#hdnPerfectScore" + questionNo).val().trim() == "") ? "0" : $("#hdnPerfectScore" + questionNo).val().trim());
		var inputScore = parseFloat(($("#txtScore" + questionNo).val().trim() == "") ? "0" : $("#txtScore" + questionNo).val().trim());

		if (inputScore > perfectScore) {
			bootAlert(perfectScore + "점 이하로 입력해주세요.", function () {
				$("#txtScore" + questionNo).val("0");
				$("#txtScore" + questionNo).focus();
			});
		}
	}

	function fnSave(gbn) {
		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/UpdateExamineeEstimation", $("#mainForm").serialize(), "fnSaveResult", "'" + gbn + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnSaveResult(gbn) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			if (gbn != 'curr') {
				var examineeno = (gbn == 'pre') ? <%:Model.PrePage%> : <%:Model.NextPage%>;
				location.href = "/<%:GubunCd %>/EstimationWrite/<%:Model.ExamineeDetail.CourseNo %>/<%:Model.ExamineeDetail.ExamNo %>/" + examineeno;
			} else {
				bootAlert("저장되었습니다.", function () {
					location.reload();
				});
			}
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}
</script>
