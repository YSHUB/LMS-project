<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";

	//string goUrl = "/" + GubunCd + "/" + ((Model.ExamDetail.TakeType.Equals("EXST001")) ? "EstimationList" : "EstimationOffline") + "/" + Model.CourseNo + "/" + Model.ExamNo;
	string goUrl = "/" + GubunCd + "/EstimationList/" + Model.CourseNo + "/" + Model.ExamNo;
	string styleDisplay = (!Model.ExamDetail.EstimationGubun.Equals("EXET001")) ? "" : "d-none";
%>

<div class="row align-items-center mt-4">
	<div class="col-md">
		<h3 class="title04">문제 리스트 <small>(등록된 문제: 총 <strong class="text-danger"><%:Model.QuestionList.Count %></strong>건)</small></h3>
	</div>
	<div class="col-md-auto mt-2 mt-md-0 text-right">
		<a href="<%:goUrl %>" class="btn btn-primary <%=styleDisplay %>">평가</a>
		<a href="/<%:GubunCd %>/ListTeacher/<%:Model.CourseNo %>" class="btn btn-secondary">목록</a>
	</div>
</div>
<div class="card">
	<div class="card-body py-0">
		<div class="table-responsive-lg">
			<table class="table table-hover" summary="문제 리스트">
				<caption>문제 리스트</caption>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">문제유형</th>
						<th scope="col">문제</th>
						<th scope="col">주차</th>
						<th scope="col" class="d-none">배점</th>
					</tr>
				</thead>		
				<tbody>
					<%
						if(Model.QuestionList.Count > 0)
						{
							foreach (var item in (Model.QuestionList))
							{
					%>
					<tr>
						<th scope="row"><%:item.RowIndex %></th>
						<td><%:item.QuestionTypeNm %></td>
						<td class="text-left"><p class="mb-0"><%=item.Question %></p></td>
						<td><%:item.DifficultyNm %></td>
						<td class="d-none">
							<input type="text" class="form-control" name="txtQuestionScores" value="<%:item.EachScore %>">
						</td>
					</tr>
					<%
							}
						}
						else
						{
					%>
					<tr>
						<td  colspan="5">조회된 데이터가 없습니다.</td>
					</tr>
					<%
						}
					%>				
				</tbody>
			</table>
		</div>
	</div>
</div><!-- card -->
					
<div class="mt-4 text-right">
	<a href="<%:goUrl %>" class="btn btn-primary <%=styleDisplay %>">평가</a>
	<a href="/<%:GubunCd %>/ListTeacher/<%:Model.CourseNo %>" class="btn btn-secondary">목록</a>
</div>