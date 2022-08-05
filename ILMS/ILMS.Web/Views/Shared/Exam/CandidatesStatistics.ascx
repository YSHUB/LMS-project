<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.ExamViewModel>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
	<li class="nav-item" role="presentation"><a class="nav-link" href="/<%:GubunCd%>/EstimationList/<%:Model.CourseNo %>/<%:Model.ExamNo %>">개인별 평가현황</a></li>
	<li class="nav-item" role="presentation"><a class="nav-link active show" id="tab2-tab" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="false">문항별 통계</a></li>
</ul>

<div id="questionDiv"></div>

<script>
	// ajax 객체 생성
	var ajaxHelper;

	$(document).ready(function () {
		ajaxHelper = new AjaxHelper();

		ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetQuestionStatement", { examno: <%:Model.ExamDetail.ExamNo%> }, "fnQuestionItem", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	})

	// 문항
	function fnQuestionItem() {
		var result = ajaxHelper.CallAjaxResult();
		$("#questionDiv").html();

		if (result != null && result.QuestionList.length > 0) {
			for (var i = 0; i < result.QuestionList.length; i++) {
				var participation = parseInt(result.QuestionList[i].ParticipationCnt);
				var right = parseInt(result.QuestionList[i].RightCnt);
				var percent = (participation > 0) ? ((right / participation) * 100) : 0;

				var html = "";

				html += "<div class='card card-style01 mt-4'>";
				html += "<div class='card-header'>";
				html += "<div class='row align-items-center'>";
				html += "<div class='col-md'>";
				html += "<p class='card-title02'><strong class='badge badge-primary mr-2'>문제" + (i + 1) + "</strong>" + result.QuestionList[i].Question + "</p>";
				html += "</div>";
				html += "<div class='col-md-auto text-right'>";
				html += "<dl class='row dl-style01'>";
				html += "<dt class='col-auto text-dark'>참여</dt>";
				html += "<dd class='col-auto mb-0'>" + result.QuestionList[i].ParticipationCnt + "명</dd>";
				html += "<dt class='col-auto text-primary'>정답률</dt>";
				html += "<dd class='col-auto mb-0'>" + percent + "%</dd>";
				html += "</dl>";
				html += "</div>";
				html += "</div>";
				html += "</div>";
				html += "<div class='card-body' id='divExample" + result.QuestionList[i].QuestionNo + "'>";
				html += "</div>";
				html += "</div>";

				$("#questionDiv").append(html);

				ajaxHelper.CallAjaxPost("/<%:GubunCd %>/GetExample", { examplemixyesno : "N", examno : <%:Model.ExamDetail.ExamNo%>, questionbankno: parseInt(result.QuestionList[i].QuestionBankNo), examineeno: 0 }, "fnExampleItem", result.QuestionList[i].QuestionNo, "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
			}
		}
	}

	function fnExampleItem(questionNo) {
		var result = ajaxHelper.CallAjaxResult();
		var html = "";
		$("#divExample" + questionNo).html("");

		if (result != null) {
			// 단답형
			if (result.QuestionExampleList[0].QuestionType == "MJQT004") {
				html += "<ol class='marking'>";
				html += "<li class='text-primary'>";
				html += "<strong>모범답안</strong>";
				html += "<span class='col-sm'>" + result.QuestionExampleList[0].CorrectAnswer + "</span>";
				html += "</li>";
				html += "</ol>";

			// 단일선택 또는 다중선택
			} else {
				html += "<ol class='list-style01 marking'>";
				for (var i = 0; i < result.QuestionExampleList.length; i++) {
					var liClass = (result.QuestionExampleList[i].CorrectAnswerYesNo == "Y") ? "text-primary font-weight-bold" : "";
				
					html += "<li class='" + liClass + "'>";
					html += "<span>" + result.QuestionExampleList[i].ExampleContents + "</span>";

					// 이미지가 있는 경우
					if (result.QuestionExampleList[i].OriginFileName != null && result.QuestionExampleList[i].OriginFileName != "") {
						html += "<div><img src='/files" + result.QuestionExampleList[i].SaveFileName + "' class='img-fluid w-100 border border-" + liClass + "' alt='" + result.QuestionExampleList[i].ExampleContents + "'></div>";
					}

					html += "</li>";
				}
				html += "</ol>";
			}
		}

		$("#divExample" + questionNo).append(html);
	}
</script>
