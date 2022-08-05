<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div id="content">
		<h3 class="title04">팀프로젝트 결과 리스트</h3>
		<div class="card">
			<div class="card-body">
				<ul class="list-inline list-inline-style02 mb-0">
					<li class="list-inline-item bar-vertical">
						진행중
						<span class="ml-1 badge badge-secondary">
							<%: Model.TeamProjectList.Where(t => (DateTime.Parse(t.SubmitStartDay) < DateTime.Now && DateTime.Parse(t.SubmitEndDay) > DateTime.Now)).Count() %>
						</span>
					</li>
					<li class="list-inline-item bar-vertical">
						진행예정
						<span class="ml-1 badge badge-secondary">
							<%: Model.TeamProjectList.Where(t => DateTime.Parse(t.SubmitStartDay) > DateTime.Now).Count()%>
						</span>
					</li>
					<li class="list-inline-item bar-vertical">
						종료 
						<span class="ml-1 badge badge-secondary">
							<%: Model.TeamProjectList.Where(t => DateTime.Parse(t.SubmitEndDay).AddDays(1) < DateTime.Now).Count()%>
						</span>
					</li>
				</ul>
			</div>
		</div>
		<%
			if (Model.TeamProjectList.Count.Equals(0))
			{
		%>
				<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 팀프로젝트가 없습니다.</div>
		<%
			}
			else
			{
		%>
				<%
					foreach (var item in Model.TeamProjectList)
					{
				%>
						<div class="card card-style01">
							<div class="card-header">
								<div class="row no-gutters align-items-center">
									<div class="col">
										<div class="row">
											<div class="col-md">
												<div class="text-primary font-size-14">
													<strong class="text-<%:item.ProjectSituation == "진행예정" ? "info" : item.ProjectSituation == "종료" ? "dark" : "danger" %> bar-vertical"><%:item.ProjectSituation %></strong>			
													<strong class="text-primary"><%:item.LeaderYesNo.Equals("Y") ? "팀장제출" : "개별제출"%></strong>
												</div>
											</div>
											<div class="col-md-auto text-right">
												<dl class="row dl-style01">
													<dt class="col-auto">제출인원</dt>
													<dd class="col-auto"><%:item.SubmitCount %>명</dd>
													<dt class="col-auto">평가인원</dt>
													<dd class="col-auto"><%:item.FeedbackCount %>명/<%:item.StudentCount %>명</dd>
												</dl>
											</div>
										</div>
									</div>
									<div class="col-auto text-right d-md-none">
										<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divTeamprojectListTeacher" aria-expanded="false" aria-controls="divTeamprojectListTeacher">
											<span class="sr-only">더 보기</span>
										</button>
									</div>
								</div>
								<a href="/Report/Detail/<%:ViewBag.Course.CourseNo %>/<%:item.ProjectNo %>" class="card-title01 text-dark"> <%:item.ProjectTitle %></a>
							</div>
							<div class="card-body collapse d-md-block" id="divTeamprojectListTeacher">
								<div class="row mt-2 align-items-end">
									<div class="col-md">
										<dl class="row dl-style02">
											<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i> 제출기간</dt>
											<dd class="col-8 col-md"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
										</dl>
									</div>
									<div class="col-md-auto mt-2 mt-md-0 text-right">
										<a class="btn btn-lg btn-point w-100 w-md-auto" href="/Report/Detail/<%:ViewBag.Course.CourseNo %>/<%:item.ProjectNo %>">자세히</a>
									</div>
								</div>
							</div>
						</div>
				<%
					}
				%>
		<%
			}
		%>
		<%
			if (ViewBag.Course.IsProf == 1)
			{
		%>
				<div class="text-right">
					<a href="/Report/Write/<%:ViewBag.Course.CourseNo %>" class="btn btn-primary">팀프로젝트 등록</a>
				</div>
		<%
			}
		%>
	</div>
</asp:Content>
