<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">상세 보기</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="content">
		<div class="col-12">
			<div class="card card-style02">
				<div class="card-header">
					<span class="card-title01 text-dark">개인출결관리</span>
				</div>
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>소속</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.AssignName %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>이름(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.HangulName %>(<%:Model.LectureUserDetail.UserID %>)</dd>
					</dl>
				</div>
			</div>
			<div class="tab-content" id="myTabContent">
				<ul class="nav nav-tabs mt-4" role="tablist">
					<li class="nav-item" role="presentation">
						<a href="/Lecture/ProgressUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link" role="tab">학습진도 관리</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/LogUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link active" role="tab">접속정보</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/OcwUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link" role="tab">콘텐츠 정보</a>
					</li>
				</ul>
			</div>
			<div class="card">
				<div class="card-header">
					<div class="row">
						<div class="col-6 col-md-2">
							강의실접속수
						</div>
						<div class="col-6 col-md-2">
							<%:Model.UserLogList.Where(c=>c.LectureRoomCheckDay != null).Count() %>
						</div>
						<div class="col-6 col-md-2">
							총 접속시간
						</div>
						<div class="col-6 col-md-2">
							<%:Model.GetTotalConnectedTime() %>분
						</div>
						<div class="col-6 col-md-2">
							평균 접속시간
						</div>
						<div class="col-6 col-md-2">
							<%:Model.GetAvgConnectedTime() %>분
						</div>
					</div>
				</div>
				<div class="card-body py-0">
					<%
						if (Model.UserLogList.Count > 0)
						{
					%>
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습상황관리 - 학습진도현황 - 학습상세">
							<caption>학습상황관리 - 학습진도현황 - 학습상세 리스트</caption>
							<thead>
								<tr>
									<th scope="col">접속기기</th>
									<th scope="col">로그인시간</th>
									<th scope="col">강의실입장시간</th>
									<th scope="col">로그아웃시간</th>
									<th scope="col">중간갱신시간</th>
								</tr>
							</thead>
							<tbody>
								<%
									foreach (var item in Model.UserLogList)
									{
								%>
								<tr>
									<td class="text-center"><%:item.ConnectGubun == 1 ? "PC" : "Mobile" %></td>
									<td class="text-center"><%:item.LoginDay %></td>
									<td class="text-center"><%:item.LectureRoomCheckDay %></td>
									<td class="text-center"><%:item.LogoutDay %></td>
									<td class="text-center"><%:item.MiddleCheckDay %></td>
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
						<i class="bi bi-info-circle-fill"></i>데이터가 없습니다.
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
