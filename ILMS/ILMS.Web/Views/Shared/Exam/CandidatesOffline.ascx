<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.ExamViewModel>" %>

<%
	string GubunNm = Model.ExamineeDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamineeDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<form action="/<%:GubunCd %>/OffCreate" method="post" id="mainForm" enctype="multipart/form-data">
	<input type="hidden" id="hdnCourseNo" name="ExamineeDetail.CourseNo" value="<%:Model.CourseNo %>" />
	<input type="hidden" id="hdnExamNo" name="ExamineeDetail.ExamNo" value="<%:Model.ExamNo %>" />
	<input type="hidden" id="hdnExamineeNo" name="ExamineeDetail.ExamineeNo" value="<%:Model.ExamineeDetail.ExamineeNo %>" />
	<input type="hidden" id="hdnOffFile" name="ExamineeDetail.OFFFile" value="<%:Model.ExamineeDetail.OFFFile %>" />
	<input type="hidden" id="hdnOffYesNo" name="ExamineeDetail.OFFYesNo" value="<%:Model.ExamineeDetail.OFFYesNo %>" />
	<input type="hidden" id="hdnPerfectScore" name="hdnPerfectScore" value="<%:Model.perfectScore %>" />

	<div class="p-4">
		<h3 class="title03"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>정보</h3>
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

		<h3 class="title03 mt-4">평가</h3>
		<div class="form-row align-items-end">
			<div class="form-group <%:Model.ExamDetail.IsGrading.Equals(1) ? "col-md-10" : "col-md-12" %>">
				<label for="Exam_ExamContents" class="sr-only">평가내용</label>
				<textarea id="Exam_ExamContents" name="ExamineeDetail.OFFMEMO" rows="3" class="form-control" placeholder="평가 내용을 입력해 주세요"><%:(Model.ExamineeDetail.OFFMEMO == null) ? "" : Model.ExamineeDetail.OFFMEMO %></textarea>
			</div>
			<div class="form-group <%:Model.ExamDetail.IsGrading.Equals(1) ? "col-md-2" : "d-none" %>">
				<label for="txtScore" class="form-label">점수 입력 <strong class="text-danger">*</strong></label>
				<div class="input-group">
					<input type="text" class="form-control" id="txtScore" name="ExamineeDetail.ExamTotalScore" value="<%:Model.ExamineeDetail.ExamTotalScore %>" placeholder="0" onkeyup="fnScoreCheck()">
					<div class="input-group-append">
						<span class="input-group-text">점</span>
					</div>
				</div>
			</div>
			<div class="form-group col">
				<label for="" class="form-label">첨부</label>
				<% Html.RenderPartial("./Common/File"
									, Model.FileList
									, new ViewDataDictionary {
									{ "name", "FileGroupNo" },
									{ "fname", "OffFile" },
									{ "value", Model.ExamineeDetail.OFFFile },
									{ "fileDirType", "ExamOff"},
									{ "filecount", 1 }, 
									{ "width", "100" }, 
									{ "isimage", 0 } }); %>
			</div>
		</div><!-- form-row -->
		<div class="p-4 bg-light rounded">
			<p class="font-size-14 text-danger font-weight-bold mb-2"><i class="bi bi-info-circle-fill"></i> <%:GubunNm %>용 첨부파일은 반드시 1개만 업로드할 수 있습니다.</p>
			<p class="font-size-14 font-weight-bold mb-0">첨부파일 > 파일찾기를 이용해 첨부하고자하는 파일을 선택한 후 파일업로드의 complete 상태 표시창이 사라질 때까지 기다렸다가 제출할 <%:GubunNm %> 파일 목록이 나타날 때 제출 버튼을 클릭해야지만 <%:GubunNm %>가 정상적으로 제출됩니다.</p>
		</div>

		<div class="text-right mt-4">
			<button type="button" class="btn btn-outline-primary <%:Model.ExamineeDetail.OFFYesNo.Equals("Y") ? "" : "d-none" %>" onclick="fnSave('N')">오프등록해제</button>
			<button type="button" class="btn btn-primary" onclick="fnSave('Y')">저장</button>
			<button type="button" class="btn btn-secondary" onclick="window.close()">닫기</button>
		</div>
	</div>
</form>

<script>
	// ajax 객체 생성
	var ajaxHelper;

	$(document).ready(function () {
		ajaxHelper = new AjaxHelper();
	})

	function fnSave(gbn) {
		if (fnScoreCheck()) {
			if (fnFileCheck()) {
				$("#hdnOffYesNo").val(gbn);

				var msg = (gbn == "Y") ? "저장하시겠습니까?" : "오프등록을 해제하시겠습니까?";
			
				bootConfirm(msg, fnSaveCall, gbn);
			}
		}
	}

	function fnSaveCall(gbn) {
		var formData = new FormData($("#mainForm")[0]);
		ajaxHelper.CallAjaxPostFile("/<%:GubunCd%>/OffCreate", formData, "fnSaveResult", "'" + gbn + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnSaveResult(gbn) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			var msg = (gbn == "Y") ? "저장되었습니다." : "오프등록이 해제되었습니다.";

			bootAlert(msg, function () {
				// 부모창 함수 호출
				opener.fnSearch();
				window.close();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	function fnScoreCheck() {
		var perfectScore = parseFloat(($("#hdnPerfectScore").val().trim() == "") ? "0" : $("#hdnPerfectScore").val().trim());
		var score = parseFloat(($("#txtScore").val().trim() == "") ? "0" : $("#txtScore").val().trim());

		// 성적미반영일 경우
		if ("<%:Model.ExamDetail.IsGrading%>" == "1") {
			if (score > perfectScore) {
				bootAlert(perfectScore + "점 이하로 입력해주세요.", function () {
					$("#txtScore").val("");
					$("#txtScore").focus();
				});

				return false;
			}
		}

		return true;
	}

	function fnFileCheck() {
		var obj = $("input[name=OffFile]");
		
		if (obj.val() != undefined && obj.val() != "") {
			var fileName = obj.val().split("\\")[obj.val().split("\\").length - 1];
			var extension = fileName.split(".")[fileName.split(".").length - 1];
			
			if($.inArray(extension.toLowerCase(), ['gif', 'png', 'jpg', 'jpeg', 'doc', 'docx', 'xls', 'xlsx', 'hwp', 'pdf', 'zip']) == -1) {
				bootAlert("등록할 수 없는 첨부파일입니다.");
				return false;
			}
		}

		return true;
	}
</script>
