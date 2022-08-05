<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			// 시, 분 세팅
			fnAppendHour("ddlEndHour", "<%:Model.ExamDetail.EndHours%>");
			fnAppendMin("ddlEndMin", "<%:Model.ExamDetail.EndMin%>", 10);

			// 응시종료일자 세팅
			fnCalendar("txtEndDay", "<%:Model.ExamDetail.EndDayFormat%>");

			// 종료일시 변경 버튼 누를 때 종료일시 다시 세팅
			$("#btnChgEndDt").click(function () {
				$("#txtEndDay").val("<%:Model.ExamDetail.EndDayFormat%>");
				$("#ddlEndHour").val("<%:Model.ExamDetail.EndHours%>");
				$("#ddlEndMin").val("<%:Model.ExamDetail.EndMin%>");
			})

			// 종료일시 변경
			$("#chgEnddtYes").click(function () {
				var stDt = parseInt("<%:Model.ExamDetail.StartDay.ToString("yyyyMMddhhmm")%>");
				var endDt = parseInt(fnReplaceAll($("#txtEndDay").val().trim(), "-", "") + $("#ddlEndHour").val().trim() + $("#ddlEndMin").val().trim());
				
				if ($("#txtEndDay").val().trim() == "") {
					bootAlert("응시 종료일을 입력해주세요.", function () {
						$("#txtEndDay").focus();
					});

					return false;
				}

				if (stDt > endDt) {
					bootAlert("응시 종료일시는 응시 시작일시보다 빠를 수 없습니다.", function () {
						$("#txtEndDay").focus();
					});

					return false;
				}

				ajaxHelper.CallAjaxPost("/Exam/UpdateEndDay", { examno: <%:Model.ExamNo%>, endday: endDt }, "fnCompleteEndDay", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
			});

			// 출제완료
			$("#completeYes").click(function () {
				ajaxHelper.CallAjaxPost("/Exam/ExamComplete", $("#mainForm").serialize(), "fnCompleteExam", "'Y'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
			});

			// 출제완료해제
			$("#IncompleteYes").click(function () {
				ajaxHelper.CallAjaxPost("/Exam/ExamUnComplete", { examno: <%:Model.ExamNo%> }, "fnCompleteExam", "'N'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
			});

			// 시험지 초기화
			$("#btnResetExam").click(function () {
				bootConfirm("시험지 초기화를 진행하시겠습니까? \n시험지 초기화 시 이미 응시된 인원의 시험정보가 모두 삭제됩니다.", fnRetestCall, null);
			});

			// 삭제
			$("#btnDelete").click(function () {
				bootConfirm("삭제하시겠습니까?", fnChkExaminee, "D");
			});
		})

		// 응시자 체크
		function fnChkExaminee(gbn) {
			ajaxHelper.CallAjaxPost("/Exam/ChkExaminee", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo%> }, "fnChkExamineeResult", "'" + gbn + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnChkExamineeResult(gbn) {
			var result = ajaxHelper.CallAjaxResult();
		
			if (result > 0) {
				var msg = (gbn == "D") ? "삭제" : "수정";
				bootAlert("응시자가 존재하여 " + msg + " 불가능 합니다.", function () {
					location.reload();
				});
			} else {
				if (gbn == "D") fnDelete();
				else location.href = "/Exam/Write/<%:Model.ExamDetail.CourseNo %>/<%:Model.ExamDetail.ExamNo %>";
			}
		}

		function fnCompleteEndDay() {
			var result = ajaxHelper.CallAjaxResult();
		
			if (result > 0) {
				bootAlert("종료일시 변경이 완료되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
				$("#chgEnddtNo").click();
			}
		}

		// [gbn] Y : 출제완료 / N : 출제완료해제
		function fnCompleteExam(gbn) {
			var result = ajaxHelper.CallAjaxResult();
			
			if (result > 0) {
				var msg = (gbn == "Y") ? "출제완료" : "출제완료해제";
				bootAlert(msg + " 되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
				$("#completeNo").click();
			}
		}

		function fnDelete() {
			ajaxHelper.CallAjaxPost("/Exam/ExamDelete", $("#mainForm").serialize(), "fnDeleteExam", "'N'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnDeleteExam() {
			var result = ajaxHelper.CallAjaxResult();
			
			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {
					location.href = "/Exam/ListTeacher/<%:Model.ExamDetail.CourseNo %>";
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
		}

		function fnRetestCall() {
			ajaxHelper.CallAjaxPost("/Exam/UpdateExamReset", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo %>, examineeno: 0, userno: 0, adminyn: "Y" }, "fnRetestResult", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnRetestResult() {
			var result = ajaxHelper.CallAjaxResult();
			
			if (result > 0) {
				bootAlert("시험지 초기화 처리되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
		}
	</script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<%
		bool TakeTypeYn = (Model.ExamDetail.TakeType).Equals("EXST001");  // 온라인강의 여부
		string EstimationGubunSt = Model.ExamDetail.EstimationGubun;    // 시험상태
		int CandidateCnt = Model.ExamCandidate - Model.ExamNonTaker;    // 응시자수
	%>

	<form method="post" id="mainForm">
		<input type="hidden" id="hdnCourseNo"		name="ExamDetail.CourseNo"		value="<%:Model.ExamDetail.CourseNo %>" />
		<input type="hidden" id="hdnExamNo"			name="ExamDetail.ExamNo"		value="<%:Model.ExamDetail.ExamNo %>"/>
		<input type="hidden" id="hdnSubmitType"		name="ExamDetail.SubmitType"	value="<%:Model.ExamDetail.SubmitType %>" />
		<input type="hidden" id="hdnExamItem"		name="ExamDetail.ExamItem"		value="<%:Model.ExamDetail.ExamItem %>" />
		<input type="hidden" id="hdnWeek"			name="ExamDetail.Week"			value="<%:Model.ExamDetail.Week %>" />
		<input type="hidden" id="hdnInningNo"		name="ExamDetail.InningNo"		value="<%:Model.ExamDetail.InningNo %>" />
		<input type="hidden" id="hdnAddExamYesNo"	name="ExamDetail.AddExamYesNo"	value="<%:Model.ExamDetail.AddExamYesNo %>" />
		<input type="hidden" id="hdnUseMixYesNo"	name="ExamDetail.UseMixYesNo"	value="<%:Model.ExamDetail.UseMixYesNo %>" />
	</form>

	<h3 class="title04"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 정보</h3>
	<div class="card card-style01">
		<div class="card-header">
			<div class="row no-gutters align-items-center">
				<div class="col">
					<div class="row">
						<div class="col-md">
							<div class="text-primary font-size-14">
								<strong class="bar-vertical"><%:Model.ExamDetail.Week %>주차</strong>
								<strong><%:Model.ExamDetail.InningSeqNo %>차시</strong>
							</div>
						</div>
						<div class="col-md-auto text-right">												
							<dl class="row dl-style01">
								<dt class="col-auto">응시 인원</dt>
								<dd class="col-auto"><%:Model.ExamDetail.TakeStudentCount %>명</dd>
								<dt class="col-auto">평가 인원</dt>
								<dd class="col-auto"><%:Model.ExamDetail.CheckStudentCount %>/<%:Model.ExamDetail.TotalStudentCount %></dd>
							</dl>
						</div>
					</div>
				</div>	
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample2" aria-expanded="false" aria-controls="collapseExample2">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>

			<div class="row">
				<div class="col-auto">
					<a href="#" class="card-title01 text-dark"><%:Model.ExamDetail.ExamTitle %></a>
					<span class="badge badge-irregular <%:Model.ExamDetail.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">추가시험</span>
				</div>
			</div>
		</div>

		<div class="card-body collapse d-md-block" id="collapseExample2">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item text-danger"><%:Model.ExamDetail.EstimationGubunNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.OpenYesNoNm %></li>
				<li class="list-inline-item <%=(Model.ExamDetail.UseMixYesNo.Equals("Y")) ? "" : "d-none" %>"><%:Model.ExamDetail.UseMixYesNoNm %></li>
				<li class="list-inline-item <%=(Model.ExamDetail.ExampleMixYesNo.Equals("Y")) ? "" : "d-none" %>"><%:Model.ExamDetail.ExampleMixYesNoNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.LimitTime %>분</li>
			</ul>
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시방법</dt>
						<dd class="col"><%:Model.ExamDetail.LectureTypeNm %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:Model.ExamDetail.StartDayFormat + " " + Model.ExamDetail.StartHours + ":" + Model.ExamDetail.StartMin %> ~ <%:Model.ExamDetail.EndDayFormat + " " + Model.ExamDetail.EndHours + ":" + Model.ExamDetail.EndMin %></dd>
					</dl>
				</div>

				<div class="col-md-auto mt-2 mt-md-0 text-right">
					<div class="btn-group btn-group-lg">
						<button type="button" id="btnUpdate" class="btn btn-lg btn-outline-warning <%:(EstimationGubunSt.Equals("EXET001")) ? "" : "d-none" %>" onclick="fnChkExaminee('U')">수정</button>
						<button type="button" id="btnDelete" class="btn btn-lg btn-outline-danger <%:(EstimationGubunSt.Equals("EXET001") || (EstimationGubunSt.Equals("EXET002") && (DateTime.Now < Model.ExamDetail.StartDay))) ? "" : "d-none" %>">삭제</button>
					</div>
				</div>
			</div>
		</div>
	</div><!-- card -->

	<div class="row align-items-center mt-2">
		<div class="col-md">
			<p class="mb-0 font-size-14 text-danger font-weight-bold <%:(TakeTypeYn) ? "" : "d-none" %>"><i class="bi bi-info-circle-fill"></i> <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 미리보기는 출제한 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 확인용이며, 저장 후에는 수정이 불가능합니다.</p>
		</div>
		<div class="col-md-auto mt-2 mt-md-0 text-right">
			<div class="dropdown d-inline-block">
				<button type="button" class="btn btn-point dropdown-toggle" id="quiz-setting" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 설정
				</button>
				<ul class="dropdown-menu" aria-labelledby="quiz-setting">
					<li <%:(EstimationGubunSt.Equals("EXET002") && (DateTime.Now > Model.ExamDetail.StartDay) && (DateTime.Now < Model.ExamDetail.EndDay)) ? "" : "class=d-none" %>><a class="dropdown-item" role="button" href="/Exam/Write/<%:Model.CourseNo %>/<%:Model.ExamNo %>?AddExamYesNo=Y">추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 등록</a></li>
					<li><a class="dropdown-item" role="button" href="#" data-toggle="modal" data-target="#chgEndDTMsg" id="btnChgEndDt">종료일시 변경</a></li>
					<li><a class="dropdown-item <%:(Model.QuestionList.Count > 0 && EstimationGubunSt.Equals("EXET001")) ? "" : "d-none" %>" role="button" href="#" data-toggle="modal" data-target="#completeMsg">출제완료</a></li>
					<li><a class="dropdown-item <%:(EstimationGubunSt.Equals("EXET002") && CandidateCnt <= 0) ? "" : "d-none" %>" role="button" href="#" data-toggle="modal" data-target="#incompleteMsg">출제완료 해제</a></li>
					<li <%:(EstimationGubunSt.Equals("EXET002") && (DateTime.Now > Model.ExamDetail.StartDay) && (DateTime.Now < Model.ExamDetail.EndDay)) ? "" : "class=d-none" %>><button class="dropdown-item text-danger" type="button" id="btnResetExam">시험지 초기화</button></li>
				</ul>
			</div>
			<button type="button" class="btn btn-secondary <%:(TakeTypeYn) ? "" : "d-none" %>" onclick="fnOpenPopup('/Exam/Run/<%:Model.CourseNo %>/<%:Model.ExamNo %>', 'PreViewQuiz', 1500, 830, 0, 0, 'auto')" title="새창열림">미리보기</button>
		</div>
	</div>	

	<%-- 주차별 공통 --%>
	<div <%=(TakeTypeYn && Model.ExamDetail.IsGrading.Equals(1)) ? "" : "class='d-none'" %>>
		<% Html.RenderPartial("/Views/Shared/Exam/DetailQuestionScore.ascx"); %>
	</div>
	
	<%-- 문제 설정 공통 --%>
	<div>
		<% Html.RenderPartial("/Views/Shared/Exam/DetailQuestionList.ascx"); %>
	</div>

	<%-- 출제완료 --%>
	<div class="modal fade layerbox" role="dialog" aria-labelledby="completeMsgLabel" id="completeMsg">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">출제완료 확인</h4>
				</div>
				<div class="modal-body">
					<p>출제완료를 하시면 더 이상 문제를 수정하실 수 없으며, <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>들이 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %>에 응시할 수 있도록 공개로 설정됩니다. </p>
					<p>지금 출제완료를 하시겠습니까?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="completeYes">확인</button>
					<button type="button" class="btn btn-secondary confirmNo" id="completeNo" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<%-- 출제완료 해제 --%>
	<div class="modal fade layerbox" role="dialog" aria-labelledby="incompleteMsgLabel" id="incompleteMsg">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">확인</h4>
				</div>
				<div class="modal-body">
					<p>출제완료 해제를 하시면 미완료 상태로 변경되오니, 수정 완료 후 출제 완료를 다시 진행 해주십시오.</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="IncompleteYes">확인</button>
					<button type="button" class="btn btn-secondary confirmNo" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	<%-- 종료일시 변경 --%>
	<div class="modal fade layerbox" role="dialog" aria-labelledby="chgEndDTMsgLabel" id="chgEndDTMsg">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">종료일시 변경</h4>
				</div>
				<div class="modal-body">
					<p class="font-size-14 font-weight-bold text-danger"><i class="bi bi-info-circle-fill"></i> 응시기간의 종료일시만 변경가능합니다.</p>

					<div class="row align-items-end">
						<div class="col-md-4">
							<div class="form-group">
								<label class="form-label">응시 시작일시</label>
								<input class="form-control-plaintext text-secondary" readonly type="text" value="<%:Model.ExamDetail.StartDay %>">
							</div>
						</div>
						<div class="col-md-8">
							<div class="form-row align-items-end">
								<div class="form-group col-md-5">
									<label for="datepicker" class="form-label">응시종료일시 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control text-center" name="Quiz.EndDay" id="txtEndDay" title="" type="text" value="<%:Model.ExamDetail.EndDayFormat %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-md">
									<label for="ddlEndHour" class="sr-only">종료시간 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<select name="Quiz.EndHour" id="ddlEndHour" class="form-control"></select>
										<div class="input-group-append">
											<span class="input-group-text"> 시</span>
										</div>
									</div>
								</div>
								<div class="form-group col-md">
									<label for="ddlEndMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<select name="Quiz.EndMin" id="ddlEndMin" class="form-control w-auto"></select>
										<div class="input-group-append">
											<span class="input-group-text"> 분</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div><!-- row -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="chgEnddtYes">확인</button>
					<button type="button" class="btn btn-secondary confirmNo" id="chgEnddtNo" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>