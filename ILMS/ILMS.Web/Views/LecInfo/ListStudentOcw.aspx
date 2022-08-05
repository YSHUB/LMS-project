<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="content">
		<div class="col-12 p-0">
			<div class="card card-style02">
				<div class="card-header">
					<span class="card-title01 text-dark">개인출결관리</span>
				</div>
				<div class="card-body">
				<%
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				{
				%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>소속</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.AssignName %></dd>
					</dl>
				<%	
				}
				%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>이름(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.HangulName %>(<%:Model.LectureUserDetail.UserID %>)</dd>
					</dl>
				</div>
			</div>
			<div class="tab-content" id="myTabContent">
				<ul class="nav nav-tabs mt-4" role="tablist">
					<li class="nav-item" role="presentation">
						<a href="/LecInfo/ListStudent/<%:Model.LectureUserDetail.CourseNo %>" class="nav-link" role="tab">학습진도 관리</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/LecInfo/ListStudentOcw/<%:Model.LectureUserDetail.CourseNo %>" class="nav-link active" role="tab">콘텐츠 정보</a>
					</li>
				</ul>
			</div>
			<div class="card">
				<div class="card-body py-0">
					<%
						if (Model.OcwCourseList.Count > 0)
						{
					%>
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습상황관리 - 학습진도현황 - 학습상세">
							<caption>학습상황관리 - 학습진도현황 - 학습상세 리스트</caption>
							<thead>
								<tr>
									<th scope="col">주차</th>
									<th scope="col">순서</th>
									<th scope="col">콘텐츠명</th>
									<th scope="col">조회</th>
									<th scope="col">댓글</th>
								</tr>
							</thead>
							<tbody>
								<%
									foreach (var item in Model.OcwCourseList)
									{
								%>
								<tr>
									<td class="text-center"><%:item.Week %></td>
									<td class="text-center"><%:item.SeqNo %></td>
									<td class="text-center"><%:item.OcwName %></td>
									<td class="text-center"><%:item.UsingYesNo %></td>
									<td class="text-center"><%:item.OcwOpinionCount %></td>
								</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
					<%
						}
						else
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2">
						<i class="bi bi-info-circle-fill"></i> 데이터가 없습니다.
					</div>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>