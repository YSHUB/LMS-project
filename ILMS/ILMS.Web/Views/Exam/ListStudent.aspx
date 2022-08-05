<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트</h3>
	<div class="alert alert-light bg-light">
		평가가 완료되어 점수가 공개되면 클릭해서 정답을 확인할 수 있습니다.
	</div>

	<%
		if(Model.QuizList.Count < 1)
		{
	%>
	<div class="card">
		<div class="card-body text-center">
			등록된 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트가 없습니다.
		</div>
	</div>
	<%	
		}

		int i = 0;
		foreach (var item in Model.QuizList)
		{
			i++;

			string txtClass = (item.UserState.Equals("A") ? "text-danger" : (item.UserState.Equals("B") ? "text-point" : ""));
	%>
	<div class="card card-style01">
		<div class="card-header">
			<div class="row no-gutters align-items-center">
				<div class="col">
					<div class="row">
						<div class="col-md">
							<div class="text-primary font-size-14">
								<strong class="bar-vertical"><%:item.Week %>주차</strong>
								<strong><%:item.InningSeqNo %>차시</strong>
							</div>
						</div>
						<div class="col-md-auto text-right">
							<dl class="row dl-style01 <%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && item.EstimationGubun.Equals("EXET005")) ? "" : "d-none" %>">
								<dt class="col-auto">점수</dt>
								<dd class="col-auto"><%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && item.EstimationGubun.Equals("EXET005")) ? item.ExamTotalScore.ToString() + "점" : "-" %></dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample<%:i %>" aria-expanded="false" aria-controls="collapseExample<%:i %>">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<div class="row">
				<div class="col-auto">
					<a href="/Exam/DetailStudent/<%:item.CourseNo %>/<%:item.ExamNo %>" class="card-title01 text-dark"><%:item.ExamTitle %></a>
					<span class="badge badge-irregular <%:item.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %></span>
				</div>
			</div>
		</div>
		<div class="card-body collapse d-md-block" id="collapseExample<%:i %>">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item <%:txtClass %>"><%:item.UserStateNm %></li>
				<li class="list-inline-item"><%:item.LectureTypeNm %></li>
			</ul>
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:(item.SEType.Equals(0) && item.SE0StateGbn.Equals(-1)) ? "응시대기" : item.StartDayFormat + " " + item.StartHours + "시 " + item.StartMin + "분 ~ " + ((item.SEType.Equals(0) && item.SE0State.Equals(1)) ? "임의종료시점까지" : item.EndDayFormat + " " + item.EndHours + "시 " + item.EndMin + "분") %></dd>
					</dl>
				</div>
				<div class="col-md-4 mt-2 mt-md-0 text-right">
					<div class="<%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && item.EstimationGubun.Equals("EXET005")) ? "btn-group btn-group-lg" : "" %>">
						<a class="btn btn-lg btn-point" href="/Exam/DetailStudent/<%:item.CourseNo %>/<%:item.ExamNo %>">자세히</a>
						<a class="btn btn-lg btn-dark <%:(ConfigurationManager.AppSettings["ExamGradeOpenYN"].Equals("Y") && item.EstimationGubun.Equals("EXET005")) ? "" : "d-none" %>" href="/Exam/EstimationStudent/<%:item.CourseNo %>/<%:item.ExamNo %>/<%:item.ExamineeNo %>">결과보기</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%
		}
	%>
</asp:Content>