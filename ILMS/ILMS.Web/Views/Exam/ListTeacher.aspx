<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트</h3>
	<div class="card">
		<div class="card-body">
			<ul class="list-inline list-inline-style02">
				<li class="list-inline-item bar-vertical">미완료<span class="ml-1 badge badge-secondary"><%:Model.QuizList.Count(c => c.EstimationGubun.Equals("EXET001")) %></span>
				</li>
				<li class="list-inline-item bar-vertical">출제완료<span class="ml-1 badge badge-primary"><%:Model.QuizList.Count(c => c.EstimationGubun.Equals("EXET002")) %></span>
				</li>
				<li class="list-inline-item bar-vertical">평가완료<span class="ml-1 badge badge-secondary"><%:Model.QuizList.Count(c => c.EstimationGubun.Equals("EXET003")) %></span>
				</li>
				<li class="list-inline-item">평가공개<span class="ml-1 badge badge-secondary"><%:Model.QuizList.Count(c => c.EstimationGubun.Equals("EXET005")) %></span>
				</li>
			</ul>
		</div>
	</div>
	
	<%
		if(Model.QuizList.Count < 1)
		{
	%>
	<div class="card">
		<div class="card-body text-center">
			등록된 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %>이 없습니다.
		</div>
	</div>
	<%	
		}

		foreach (var item in Model.QuizList)
		{
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
							<dl class="row dl-style01">
								<dt class="col-auto">응시 인원</dt>
								<dd class="col-auto"><%:item.TakeStudentCount %>명</dd>
								<dt class="col-auto">평가 인원</dt>
								<dd class="col-auto"><%:item.CheckStudentCount %>/<%:item.TotalStudentCount %></dd>
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
					<a href="/Exam/DetailTeacher/<%:Model.CourseNo %>/<%:item.ExamNo %>" class="card-title01 text-dark"><%:item.ExamTitle %></a>
					<span class="badge badge-irregular <%:item.AddExamYesNo.Equals("Y") ? "" : "d-none" %>">추가 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %></span>
				</div>
			</div>
		</div>

		<div class="card-body collapse d-md-block" id="collapseExample2">
			<ul class="list-inline list-inline-style01">
				<li class="list-inline-item text-danger"><%:item.EstimationGubunNm %></li>
				<li class="list-inline-item"><%:item.OpenYesNoNm %> </li>
				<li class="list-inline-item <%=(item.UseMixYesNo.Equals("Y")) ? "" : "d-none" %>"><%:item.UseMixYesNoNm %></li>
				<li class="list-inline-item <%=(item.ExampleMixYesNo.Equals("Y")) ? "" : "d-none" %>"><%:item.ExampleMixYesNoNm %></li>
				<li class="list-inline-item"><%:item.LimitTime %>분</li>
			</ul>

			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시방법</dt>
						<dd class="col"><%:item.LectureTypeNm %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 응시기간</dt>
						<dd class="col"><%:item.StartDayFormat + " " + item.StartHours + ":" + item.StartMin %> ~ <%:item.EndDayFormat + " " + item.EndHours + ":" + item.EndMin %></dd>
					</dl>
				</div>

				<div class="col-md-4 mt-2 mt-md-0 text-right">
					<div class="btn-group btn-group-lg">
						<a class="btn btn-lg btn-point" href="/Exam/DetailTeacher/<%:Model.CourseNo %>/<%:item.ExamNo %>">자세히</a>
						<%
							if (!item.EstimationGubun.Equals("EXET001"))
							{
						%>
						<a class="btn btn-lg btn-primary" href="/Exam/EstimationList/<%:Model.CourseNo %>/<%:item.ExamNo %>">평가하기</a>
						<%
							}
						%>
					</div>
				</div>
			</div>
		</div>
	</div><!-- card -->
	<%
		}
	%>
	<div class="row">
		<div class="col-md"></div>
		<div class="col-md-auto mt-2 mt-md-0 text-right">
			<a href="/Exam/Write/<%:Model.CourseNo %>" class="btn btn-primary">등록</a>
		</div>
	</div>
</asp:Content>