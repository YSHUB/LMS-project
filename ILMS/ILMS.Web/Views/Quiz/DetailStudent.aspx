<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			// 재응시
			$("#btnReset").click(function () {
				bootConfirm("재응시하시겠습니까? \n재응시할 경우 기존에 작성된 퀴즈내용이 모두 초기화됩니다.", fnReset, null);
			});
		})

		function fnReset() {
			ajaxHelper.CallAjaxPost("/Quiz/UpdateExamReset", {courseno: $("#hdnCourseNo").val(), examno: $("#hdnExamNo").val(), examineeno: $("#hdnExamineeNo").val(), userno: 0, adminyn: "N" }, "fnResetQuiz", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnResetQuiz() {
			var result = ajaxHelper.CallAjaxResult();
			
			if (result > 0) {
				bootAlert("재응시가 가능하도록 변경되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
		}
	</script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<input type="hidden" id="hdnCourseNo" name="ExamDetail.CourseNo" value="<%:Model.ExamDetail.CourseNo %>" />
	<input type="hidden" id="hdnExamNo" name="ExamDetail.ExamNo" value="<%:Model.ExamDetail.ExamNo %>" />
	<input type="hidden" id="hdnExamineeNo" name="ExamDetail.ExamineeNo" value="<%:Model.ExamDetail.ExamineeNo %>" />
	
	<h3 class="title04">퀴즈 정보</h3>
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
					</div>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample2" aria-expanded="false" aria-controls="collapseExample2">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<span class="card-title01 text-dark"><%:Model.ExamDetail.ExamTitle %></span>
		</div>
		<div class="card-body collapse d-md-block" id="collapseExample2">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item <%:(Model.ExamDetail.UserState.Equals("A") ? "text-danger" : (Model.ExamDetail.UserState.Equals("B") ? "text-point" : "")) %>"><%:Model.ExamDetail.UserStateNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.LectureTypeNm %></li>
				<li class="list-inline-item"><span class="text-primary font-size-20"><%:Model.totalCntQuestion %></span>문항</li>
				<%
					if (Model.ExamDetail.SEType.Equals(1))
					{
				%>
				<li class="list-inline-item">제한시간 <span class="text-danger font-size-20"><%:Model.ExamDetail.LimitTime %></span>분</li>
				<%
					}
				%>
			</ul>
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시제한유형</dt>
						<dd class="col"><%:Model.ExamDetail.RestrictionTypeNm %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:(Model.ExamDetail.SEType.Equals(0) && Model.ExamDetail.SE0StateGbn.Equals(-1)) ? "응시대기" : Model.ExamDetail.StartDayFormat + " " + Model.ExamDetail.StartHours + "시 " + Model.ExamDetail.StartMin + "분 ~ " + ((Model.ExamDetail.SEType.Equals(0) && Model.ExamDetail.SE0State.Equals(1)) ? "임의종료시점까지" : Model.ExamDetail.EndDayFormat + " " + Model.ExamDetail.EndHours + "시 " + Model.ExamDetail.EndMin + "분") %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 퀴즈내용</dt>
						<dd class="col"><%:Model.ExamDetail.ExamContents %></dd>
					</dl>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-6">
			<div class="dropdown d-inline-block">
			</div>
		</div>
		<div class="col-6">
			<div class="text-right">
				<%
					if(Model.ExamDetail.ProgramNo.Equals(2) && Model.ExamDetail.EstimationGubun.Equals("EXET005") && Model.ExamDetail.IsResultYesNo.Equals("1") && (DateTime.Now > Model.ExamDetail.StartDay) && (DateTime.Now < Model.ExamDetail.EndDay))
					{
				%>
				<button type="button" class="btn btn-danger" id="btnReset">재응시</button>
				<%
					}
				%>
				
				<%
					if(!Model.ExamDetail.IsResultYesNo.Equals("1") && ((DateTime.Now > Model.ExamDetail.StartDay) && (DateTime.Now < Model.ExamDetail.EndDay)) && Model.ExamDetail.AvailabilityYesNo.Equals("Y"))
					{
				%>
				<button type="button" class="btn btn-point" onclick="fnOpenPopup('/Quiz/Run/<%:Model.CourseNo %>/<%:Model.ExamNo %>', 'PreViewQuiz', 1500, 830, 0, 0, 'auto')" title="새창열림">퀴즈응시</button>
				<%
					}
				%>
				
				<a href="/Quiz/ListStudent/<%:Model.CourseNo %>" class="btn btn-secondary">목록</a>
			</div>
		</div>
	</div>
</asp:Content>