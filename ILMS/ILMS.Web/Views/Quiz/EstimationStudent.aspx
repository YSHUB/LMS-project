<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
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
						<div class="col-md-auto text-right">
							<dl class="row dl-style01 <%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && Model.ExamDetail.EstimationGubun.Equals("EXET005")) ? "" : "d-none" %>">
								<dt class="col-auto">점수</dt>
								<dd class="col-auto"><%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && Model.ExamDetail.EstimationGubun.Equals("EXET005")) ? Model.ExamDetail.ExamTotalScore.ToString() + "점" : "-" %></dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample1" aria-expanded="false" aria-controls="collapseExample1">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<a href="#" class="card-title01 text-dark"><%:Model.ExamDetail.ExamTitle %></a>
		</div>
		<div class="card-body collapse d-md-block" id="collapseExample1">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item <%:(Model.ExamDetail.UserState.Equals("A") ? "text-danger" : (Model.ExamDetail.UserState.Equals("B") ? "text-point" : "")) %>"><%:Model.ExamDetail.UserStateNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.LectureTypeNm %></li>
			</ul>
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:(Model.ExamDetail.SEType.Equals(0) && Model.ExamDetail.SE0StateGbn.Equals(-1)) ? "응시대기" : Model.ExamDetail.StartDayFormat + " " + Model.ExamDetail.StartHours + "시 " + Model.ExamDetail.StartMin + "분 ~ " + ((Model.ExamDetail.SEType.Equals(0) && Model.ExamDetail.SE0State.Equals(1)) ? "임의종료시점까지" : Model.ExamDetail.EndDayFormat + " " + Model.ExamDetail.EndHours + "시 " + Model.ExamDetail.EndMin + "분") %></dd>
					</dl>
				</div>
			</div>
		</div>
	</div>

	<%-- 응시자 리스트 --%>
	<% Html.RenderPartial("/Views/Shared/Exam/CandidatesEstimationStudent.ascx"); %>
</asp:Content>