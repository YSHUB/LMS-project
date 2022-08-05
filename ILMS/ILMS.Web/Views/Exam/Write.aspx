<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			$("#AllCheck").click(function () {
                fnSetCheckBoxAll(this, "chkSel");
			});

			$("#AllAddCheck").click(function () {
                fnSetCheckBoxAll(this, "chkAddSel");
			});

			// 응시시작일자, 응시종료일자 세팅
			fnFromToCalendar("txtStartDay", "txtEndDay", "today");

			// 시, 분 세팅
			fnAppendHour("ddlStartHour", "<%:Model.ExamDetail.StartHours%>");
			fnAppendMin("ddlStartMin", "<%:Model.ExamDetail.StartMin%>", 10);
			fnAppendHour("ddlEndHour", "<%:Model.ExamDetail.EndHours%>");
			fnAppendMin("ddlEndMin", "<%:Model.ExamDetail.EndMin%>", 10);

			// 신규가 아닐 경우
			if (<%:Model.ExamNo%> != 0) {
				fnRestrictionTypeChange();
				fnWeekChange();
				fnInningChange();
				fnScoreSum("1");

				//초기값 설정
				$('#txtStartDay').datepicker('setDate', "<%:Model.ExamDetail.StartDayFormat %>");
				$('#txtEndDay').datepicker('setDate', "<%:Model.ExamDetail.EndDayFormat %>"); 
			}

			$("#completeYes").click(function () {
				$("#chkCntPerson").html("");
				$("#chkCntPerson").html($("input[name='chkUserNos']:checked").length);
				$("#completeNo").click();
			});
		})

		// 온라인/오프라인 변경시
		function fnChgTakeType() {
			$(".online").addClass("d-none");
            if ($("#hdnTakeType").val() == "EXST001" || $("#hdnTakeType").val() == "CINN001") {
				$(".online").removeClass("d-none");
            }
		}

		// 시험유형
		function fnRestrictionTypeChange() {
			ajaxHelper.CallAjaxPost("/Exam/WeekList", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo%>, lessonform: $("#ddlRestrictionType").val() }, "fnRestrictionTypeList", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");	
		}

		function fnRestrictionTypeList() {
			var result = ajaxHelper.CallAjaxResult();
			var option = "<option value=''>선택</option>";
			$("#ddlInning").html(option);
			$("#hdnTakeType").val("");
			$("#hdnExamItem").val("");

			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					var selected = (<%:Model.ExamDetail.Week %> == result[i].Week) ? "selected" : "";
					var value = "<option value='" + result[i].Week + "' " + selected + ">" + result[i].Week + "주차</option>";
					option += value;
				}
			} else {
				if ($("#ddlRestrictionType").val().trim() != "")
					bootAlert("해당 유형으로 등록하시려면 강의계획설정을 확인하세요.");
			}

			$("#ddlWeek").html(option);
		}

		// 주차 변경시
		function fnWeekChange() {
			if ($("#ddlWeek").val().trim() == "") {
				var option = "<option value=''>선택</option>";
				$("#ddlInning").html(option);
			} else {
				ajaxHelper.CallAjaxPost("/Exam/InningList", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo%>, lessonform: $("#ddlRestrictionType").val(), weekno: $("#ddlWeek").val() }, "fnInningList", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
			}
		}

		// 차시 세팅
		function fnInningList() {
			var result = ajaxHelper.CallAjaxResult();
			var option = "<option value=''>선택</option>";
			$("#hdnTakeType").val("");
			$("#hdnExamItem").val("");

            if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					var selected = (<%:Model.ExamDetail.InningNo %> == result[i].InningNo) ? "selected" : "";
                    var value = "<option value='" + result[i].InningNo + "' " + selected + ">" + result[i].InningSeqNo + "차시</option>";
                    option += value;
                }
			}

            $("#ddlInning").html(option);
		}

		// 차시 변경시
		function fnInningChange() {
			ajaxHelper.CallAjaxPost("/Exam/InningInfo", { courseno: <%:Model.CourseNo%>, inningno: $("#ddlInning").val() }, "fnInningInfo", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
		}

		function fnInningInfo() {
			var result = ajaxHelper.CallAjaxResult();
			$("#hdnTakeType").val("");
			$("#hdnExamItem").val("");
			
			if (result != null) {
				$("#hdnTakeType").val(result.LectureType);
				$("#hdnExamItem").val(result.LessonForm);
			}

			fnChgTakeType();
		}

		// 저장
		var saveFlag = false;
		function fnSave() {
			if (saveFlag) {
				bootAlert("처리중입니다. <br /> 잠시만 기다려 주세요.");
				return false;
			}

			if ($("#txtExamTitle").val().trim() == "") {
				bootAlert("<%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 제목을 입력하세요.", function () {
					$("#txtExamTitle").focus();
				});

				return false;
			}

			if ($("#ddlRestrictionType").val().trim() == "") {
				bootAlert("<%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 유형을 선택하세요.", function () {
					$("#ddlRestrictionType").focus();
				});
				
				return false;
			}

			// 온라인, 응시방식이 기간방식 일 때 검사
			if ($("#txtLimitTime").val().trim() == "" || parseInt($("#txtLimitTime").val().trim()) < 1) {
				bootAlert("제한시간은 1분 이상 입력하세요.", function () {
					$("#txtLimitTime").focus();
				});
				
				return false;
			}

			if ($("#ddlWeek").val().trim() == "") {
				bootAlert("주차를 선택하세요.", function () {
					$("#ddlWeek").focus();
				});
				
				return false;
			}

			if ($("#ddlInning").val().trim() == "") {
				bootAlert("차시를 선택하세요.", function () {
					$("#ddlInning").focus();
				});
				
				return false;
			}

			// 추가시험 등록일 경우
			if ("<%:Model.ExamDetail.AddExamYesNo%>" == "Y") {
				if ($("input[name='chkUserNos']:checked").length < 1) {
					bootAlert("추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 대상인원을 선택해주세요.");
					return false;
				}

				$("input[name=chkUserNos]:checked").each(function (index, item) {
					var userno = $(item).val();
					$("#hdnUserYesNos" + userno).val("Y");
				});
			}

			// 응시일시 체크
			var startDt = fnReplaceAll($("#txtStartDay").val().trim(), "-", "");
			var endDt = fnReplaceAll($("#txtEndDay").val().trim(), "-", "");
			var startTime = $("#ddlStartHour").val().trim() + $("#ddlStartMin").val().trim();
			var endTime = $("#ddlEndHour").val().trim() + $("#ddlEndMin").val().trim();

			if (startDt.trim() == "") {
				bootAlert("응시시작일시를 입력하세요.", function () {
					$("#txtStartDay").focus();
				});
					
				return false;
			}

			if (endDt.trim() == "") {
				bootAlert("응시종료일시를 입력하세요.", function () {
					$("#txtEndDay").focus();
				});
					
				return false;
			}

			if (parseInt(startDt + startTime) >= parseInt(endDt + endTime)) {
				bootAlert("응시종료일시가 응시시작일시보다 같거나 빠를 수 없습니다.", function () {
					$("#txtEndDay").focus();
				});
					
				return false;
			}

			// 문제 등록 필수
			if (($("#questionList > tbody > tr").length - $("#zeroTr").length) < 1) {
				bootAlert("문제를 등록해주세요.", function () {
					$("#questionList").focus();
				});
				
				return false;
			}

			// 주차별 문항수 검사
			var questionChk = 0;
			var scoreChk = 0;
			var weekScoreChk = 0;
			var nonlistChk = 0;
			$("input[name=txtRandomDiffCount]").each(function (index, item) {
				var getWeek = parseInt($(item).attr("id").replace("txtRandomDiffCount", ""));	// 주차
				var getWeekCode = $("#hdnRandomDiffCodes"+ getWeek).val(); // 주차 코드
				var getQuestion = parseInt(($(item).val() != "") ? $(item).val() : "0");	// 출제 문항수
				var getCandidate = parseInt(($("#spanWeek" + getWeek).html() != "") ? $("#spanWeek" + getWeek).html() : "0");	// 후보 문항수
				var getScore = parseInt(($("#txtWeekPoint" + getWeek).val() != "") ? $("#txtWeekPoint" + getWeek).val() : "0");	// 주차별 문항당 배점

				// 출제 문항수가 후보 문항수보다 큰 경우
				if (getQuestion > getCandidate) scoreChk++;

				// 후보 문항수가 있는데 출제 문항수를 입력하지 않은 경우
				if ((getQuestion < 1) && (getCandidate > 0)) questionChk++;

				// 후보 문항수가 있는데 문항당 배점을 입력하지 않은 경우
				if ((getScore < 1) && (getCandidate > 0)) weekScoreChk++;

				// 출제 문항수가 입력된 경우
				if (getQuestion > 0) {
					var listChk = 0;
					$("input[name=hdnDifficulty]").each(function (hdnindex, hdnitem) {
						if (getWeekCode == $(hdnitem).val()) {
							listChk++;
						}
					});

					// 출제 문항수가 입력되었지만 해당 주차에 문제가 등록되지 않은 경우
					if (listChk < 1) {
						nonlistChk++;
					}
				}

				// 문제 설정에 배점 설정(후보 문항수가 등록된 경우)
				if (getCandidate > 0) {
					$("." + getWeekCode).val(getScore);
				}
			});

			if (questionChk > 0) {
				bootAlert("출제 문항수를 입력해주세요.", function () {
					$("#scoreList").focus();
				});
					
				return false;
			}

			if (weekScoreChk > 0) {
				bootAlert("문항당 배점을 입력해주세요.", function () {
					$("#scoreList").focus();
				});
					
				return false;
			}

			if (scoreChk > 0) {
				bootAlert("출제 문항수가 후보 문항수보다 클 수 없습니다.", function () {
					$("#scoreList").focus();
				});

				return false;
			}

			if (nonlistChk > 0) {
				bootAlert("출제 문항수가 입력된 주차에 문제를 등록해주세요.", function () {
					$("#questionList").focus();
				});
					
				return false;
			}

			$("#hdnWeek").val($("#ddlWeek").val());
			$("#hdnInningNo").val($("#ddlInning").val());

			saveFlag = true;

			ajaxHelper.CallAjaxPost("/Exam/ExamCreate", $("#mainForm").serialize(), "fnCompleteSave", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteSave() {
			var result = ajaxHelper.CallAjaxResult();
			
			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					location.href = "/Exam/DetailTeacher/<%:Model.CourseNo%>/" + result;
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
				saveFlag = false;
			}
		}

		// 선택삭제
		function fnQuestionDelete() {
			$("input[name=chkQuestionNos]:checked").each(function (index, item) {
				$(item).parent().parent().remove();
			});

			// 주차별 문항수 다시 세팅
			fnDifficultySet();

			if (($("#questionList > tbody > tr").length - $("#zeroTr").length) < 1) {
				$("#zeroTr").removeClass("d-none");
			}	
		}

		// 주차별 문항수 세팅
		function fnDifficultySet() {
			// 초기화
			$("input[name=hdnQuestionCnt]").each(function (index, item) {
				var getWeek = parseInt($(item).attr("id").replace("hdnQuestionCnt", "")); // 주차
				$(item).val("");
				$("#spanWeek" + getWeek).html("");
				$("#txtRandomDiffCount" + getWeek).val("");
				$("#txtRandomDiffCount" + getWeek).keyup();
				$("#txtWeekPoint" + getWeek).val("");
				$("#txtRandomDiffCount" + getWeek).attr("readonly", true);
				$("#txtWeekPoint" + getWeek).attr("readonly", true);
			});

			// 세팅
			if ($("input[name=hdnDifficultySeq]").length > 0) {
				$("input[name=hdnDifficultySeq]").each(function (index, item) {
					var itemVal = $(item).val();
					var cnt = parseInt(($("#hdnQuestionCnt" + itemVal).val().trim() == "") ? "0" : $("#hdnQuestionCnt" + itemVal).val().trim());
					cnt++;

					$("#spanWeek" + itemVal).html(cnt);
					$("#hdnQuestionCnt" + itemVal).val(cnt);
					$("#txtRandomDiffCount" + itemVal).attr("readonly", false);
					$("#txtWeekPoint" + itemVal).attr("readonly", false);

					// 성적 미반영인 경우(후보문항수 = 출제문항수)
					if ($("#chkIsGrading").is(":checked") == false) {
						$("#txtRandomDiffCount" + itemVal).val(cnt);
						$("#txtRandomDiffCount" + itemVal).keyup();
					}
				});
			}
		}

		// 문제추가
		function fnAddQuestion(questionBankNos) {
			ajaxHelper.CallAjaxPost("/Exam/AddQuestionList", {questionBankNos : questionBankNos}, "fnCompleteQuestion", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteQuestion() {
			var result = ajaxHelper.CallAjaxResult();
			var html = "";
			var maxIndex = ($(".spanRowIndex").length < 1) ? 0 : parseInt($(".spanRowIndex").last().html());
			
			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					maxIndex++;

					html += "<tr>";
					html += "<td class='text-center'>";
					html += "<input type='checkbox' name='chkQuestionNos' id='chkSel' value=''>";
					html += "<input type='hidden' name='hdnQuestionBankNos' value='" + result[i].QuestionBankNo + "'>";
					html += "<input type='hidden' name='hdnDifficulty' value='" + result[i].Difficulty + "'>";
					html += "<input type='hidden' name='hdnDifficultySeq' value='" + result[i].DifficultySeq + "'>";
					html += "<input type='hidden' class=" + result[i].Difficulty + " name='hdnQuestionScores' value=''>";
					html += "</td>";
					html += "<td><span id='span" + result[i].Week + "RowIndex' class='spanRowIndex'>" + maxIndex + "</span></td>";
					html += "<td>" + result[i].QuestionTypeName + "</td>";
					html += "<td class='text-left'>" + result[i].Question + "</td>";
					html += "<td>" + result[i].QuestionDifficultyName + "</td>";
					html += "</tr>";
				}

				$("#questionList > tbody").append(html);
				$("#zeroTr").addClass("d-none");

				// 주차별 문항수 다시 세팅
				fnDifficultySet();
			}
		}
	</script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Exam/ExamCreate" method="post" id="mainForm">
		<input type="hidden" id="hdnCourseNo" name="ExamDetail.CourseNo" value="<%:Model.CourseNo %>" />
		<input type="hidden" id="hdnExamNo" name="ExamDetail.ExamNo" value="<%:Model.ExamDetail.ExamNo %>" />
		<input type="hidden" id="hdnTakeType" name="ExamDetail.TakeType" value="<%:Model.ExamDetail.TakeType %>" />
		<input type="hidden" id="hdnExamItem" name="ExamDetail.ExamItem" value="<%:Model.ExamDetail.ExamItem %>" />
		<input type="hidden" id="hdnAddExamRowstate" name="ExamDetail.AddExamRowstate" value="<%:Model.AddExamRowstate %>" />
		<input type="hidden" id="hdnAddExamYesNo" name="ExamDetail.AddExamYesNo" value="<%:Model.ExamDetail.AddExamYesNo %>" />

		<h3 class="title04"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 정보</h3>
		<div class="card d-md-block">
			<div class="card-header <%:Model.ExamDetail.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">
				<div class="row">
					<div class="col text-right">
						<span class="badge badge-irregular <%:Model.ExamDetail.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %></span>
					</div>
				</div>
			</div>
			<div class="card-body">
				<div class="form-row">
					<div class="form-group col-md-12">
						<label for="txtExamTitle" class="form-label"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 제목 <strong class="text-danger">*</strong></label>
						<input type="text" id="txtExamTitle" name="ExamDetail.ExamTitle" class="form-control" value="<%:Model.ExamDetail.ExamTitle %>">
					</div>
					<div class="form-group col-6 col-md-3">
						<label for="ddlRestrictionType" class="form-label"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 유형 <strong class="text-danger">*</strong></label>
						<select class="form-control" id="ddlRestrictionType" name="ExamDetail.RestrictionType" onchange="fnRestrictionTypeChange()" <%:Model.ExamNo > 0 ? "disabled='disabled'" : "" %>>
							<option value="">선택</option>
							<% 
								foreach (var item in Model.baseCodes.Where(x => x.ClassCode.Equals("CINM")).ToList())
								{ 
							%>
								<option value="<%:item.CodeValue %>" <%:(!string.IsNullOrEmpty(Model.ExamDetail.LessonForm) && Model.ExamDetail.LessonForm.Equals(item.CodeValue)) ? "selected" : "" %>><%:item.CodeName%></option>
							<%
								} 
							%>
						</select>
					</div>
					<div class="form-group col-6 col-md-3">
						<label for="txtLimitTime" class="form-label">제한시간 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<input type="number" class="form-control text-right" id="txtLimitTime" name="ExamDetail.LimitTime" value="<%:Model.ExamDetail.LimitTime %>" />
							<div class="input-group-append">
								<span class="input-group-text">분</span>
							</div>
						</div>
					</div>
					<div class="form-group col-6 col-md-3">
						<label for="ddlWeek" class="form-label">주차 <strong class="text-danger">*</strong></label>
						<input type="hidden" id="hdnWeek" name="ExamDetail.Week" />
						<select class="form-control" id="ddlWeek" name="ddlWeek" onchange="fnWeekChange()" <%:Model.ExamNo > 0 ? "disabled='disabled'" : "" %>>
							<option value="">선택</option>
						</select>
					</div>
					<div class="form-group col-6 col-md-3">
						<label for="ddlInning" class="form-label">차시 <strong class="text-danger">*</strong></label>
						<input type="hidden" id="hdnInningNo" name="ExamDetail.InningNo" />
						<select class="form-control" id="ddlInning" name="ddlInning" onchange="fnInningChange()" <%:Model.ExamNo > 0 ? "disabled='disabled'" : "" %>>
							<option value="">선택</option>
						</select>
					</div>
					<div class="form-group col-md-12">
						<label for="txtExamContents" class="form-label"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 안내(<%:ConfigurationManager.AppSettings["StudentText"].ToString() %>용)</label>
						<textarea id="txtExamContents" name="ExamDetail.ExamContents" rows="3" class="form-control" title=""><%:Model.ExamDetail.ExamContents %></textarea>
					</div>
					<div class="form-group col-md-12 <%:Model.ExamDetail.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">
						<label for="txtExamTitle" class="form-label mr-2">추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 대상인원 <strong class="text-danger">*</strong></label>
						<span id="chkCntPerson"><%:Model.ExamineeList.Where(c => c.ChkAddExaminee.Equals("Y")).Count() %></span>명
						<a class="btn btn-sm btn-primary ml-1" role="button" href="#" data-toggle="modal" data-target="#examineeChg" id="btnChgexaminee">대상자 선택</a>
					</div>
					<div class="form-group col-12 col-md-6 SetypeCtrl">
						<label for="txtStartDay" class="form-label">응시시작일시 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<input class="form-control text-center" name="ExamDetail.StartDayFormat" id="txtStartDay" type="text" value="<%:Model.ExamDetail.StartDayFormat %>">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
							<select class="form-control" id="ddlStartHour" name="ExamDetail.StartHours"></select>
							<div class="input-group-append input-group-prepend">
								<span class="input-group-text">시</span>
							</div>
							<select class="form-control" id="ddlStartMin" name="ExamDetail.StartMin"></select>
							<div class="input-group-append">
								<span class="input-group-text">분</span>
							</div>
						</div>
					</div>
					<div class="form-group col-12 col-md-6 SetypeCtrl">
						<label for="txtEndDay" class="form-label">응시종료일시 <strong class="text-danger">*</strong></label>
						<div class="input-group">			
							<input class="form-control text-center" name="ExamDetail.EndDayFormat" id="txtEndDay" type="text" value="<%:Model.ExamDetail.EndDayFormat %>">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
							<select class="form-control" id="ddlEndHour" name="ExamDetail.EndHours"></select>
							<div class="input-group-append input-group-prepend">
								<span class="input-group-text">시</span>
							</div>
							<select class="form-control" id="ddlEndMin" name="ExamDetail.EndMin"></select>
							<div class="input-group-append">
								<span class="input-group-text">분</span>
							</div>
						</div>
					</div>
					<div class="form-group col-6 col-md-2 mb-0 online d-none">
						<label for="chkUseMixYesNo" class="form-label">문제섞기 사용여부 <strong class="text-danger">*</strong></label>
						<!-- Rounded switch -->
						<label class="switch">
							<input type="checkbox" id="chkUseMixYesNo" name="ExamDetail.UseMixYesNo" <%:(Model.ExamNo == 0 || Model.ExamDetail.UseMixYesNo.Equals("Y")) ? "checked='checked'" : "" %> value="Y">
							<span class="slider round"></span>
						</label>
					</div>
					<div class="form-group col-6 col-md-2 mb-0 online d-none">
						<label for="chkExampleMixYesNo" class="form-label">보기섞기 사용여부 <strong class="text-danger">*</strong></label>
						<!-- Rounded switch -->
						<label class="switch">
							<input type="checkbox" id="chkExampleMixYesNo" name="ExamDetail.ExampleMixYesNo" <%:(Model.ExamNo == 0 || Model.ExamDetail.ExampleMixYesNo.Equals("Y")) ? "checked='checked'" : "" %> value="Y">
							<span class="slider round"></span>
						</label>
					</div>
					<div class="form-group col-6 mb-0 online d-none">
						<label for="chkOpenYesNo" class="form-label">공개여부 <strong class="text-danger">*</strong></label>
						<!-- Rounded switch -->
						<label class="switch">
							<input type="checkbox" id="chkOpenYesNo" name="ExamDetail.OpenYesNo" <%:(Model.ExamNo == 0 || Model.ExamDetail.OpenYesNo.Equals("Y")) ? "checked='checked'" : "" %> value="Y">
							<span class="slider round"></span>
						</label>
						<small class="text-secondary">※ 비공개를 선택하면 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 목록에 표시되지 않습니다. </small>
					</div>
				</div><!-- form-row -->
			</div>
			<div class="card-footer">
				<div class="row align-items-center">
					<div class="col-6">
						<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
					</div>
					<div class="col-6 text-right">
						<button type="button" class="btn btn-primary" onclick="fnSave()">저장</button>
						<a href="<%:Model.ExamNo.Equals(0) ? "/Exam/ListTeacher/" + Model.CourseNo : "/Exam/DetailTeacher/" + Model.CourseNo + "/" + Model.ExamNo %>" class="btn btn-secondary">취소</a>
					</div>
				</div>
			</div>
		</div>

		<%-- 주차별 공통 --%>
		<div id="QuestionScore">
			<% Html.RenderPartial("/Views/Shared/Exam/QuestionScore.ascx"); %>
		</div>
	
		<%-- 문제 설정 공통 --%>
		<div>
			<% Html.RenderPartial("/Views/Shared/Exam/QuestionList.ascx"); %>
		</div>

		<%-- 대상자 선택 --%>
		<div class="modal fade layerbox" role="dialog" aria-labelledby="examineeChgLabel" id="examineeChg">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">대상자 선택</h4>
					</div>
					<div class="modal-body">
						<div class="overflow-auto overflow-xs overflow-sm overflow-md overflow-xl">
							<table class="table table-hover sticky-header" summary="대상자 선택">
								<caption>대상자 선택</caption>
								<thead>
									<tr>
										<th scope="col"><input type="checkbox" class="checkbox" id="AllAddCheck" onclick="fnSetCheckBoxAll(this, 'chkAddSel');"></th>
										<th scope="col" <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "class=d-none" %>>소속</th>
										<th scope="col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
										<th scope="col">이름</th>
										<th scope="col" <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "class=d-none" %>>학적</th>
									</tr>
								</thead>
								<tbody>
									<%
										if(Model.ExamineeList.Count > 0)
										{
											foreach (var item in (Model.ExamineeList))
											{
									%>
									<tr>
										<td class="text-center">
											<input type="checkbox" name="chkUserNos" id="chkAddSel" value="<%:item.UserNo %>" <%:item.ChkAddExaminee.Equals("Y") ? "checked" : "" %>>
											<input type="hidden" name="hdnUserYesNos" id="hdnUserYesNos<%:item.UserNo %>" />
										</td>
										<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><%:item.AssignName %></td>
										<td><%:item.UserID %></td>
										<td class="text-left"><%=item.HangulName %></td>
										<td <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "class=d-none" %>><%:(item.HakjeokGubunName ?? "") %></td>
									</tr>
									<%
											}
										}
										else
										{
									%>
									<tr>
										<td colspan="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? 5 : 3 %>">조회된 데이터가 없습니다.</td>
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" id="completeYes">확인</button>
						<button type="button" class="btn btn-secondary confirmNo" id="completeNo" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>