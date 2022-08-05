<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
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

			<a href="#" class="card-title01 text-dark"><%:Model.ExamDetail.ExamTitle %></a>
		</div>

		<div class="card-body collapse d-md-block" id="collapseExample2">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item text-danger"><%:Model.ExamDetail.EstimationGubunNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.OpenYesNoNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.UseMixYesNoNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.ExampleMixYesNoNm %></li>
				<li class="list-inline-item"><%:Model.ExamDetail.LimitTime %>분</li>
			</ul>
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시방법</dt>
						<dd class="col"><%:Model.ExamDetail.RestrictionTypeNm %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:Model.ExamDetail.StartDayFormat %> ~ <%:Model.ExamDetail.EndDayFormat %></dd>
					</dl>
				</div>
			</div>
		</div>
	</div><!-- card -->

	<%-- 문항별 통계 --%>
	<% Html.RenderPartial("/Views/Shared/Exam/CandidatesStatistics.ascx"); %>
</asp:Content>