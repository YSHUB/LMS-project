<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
   <div id="content">					
		<h3 class="title04">팀프로젝트 결과 리스트</h3>
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
									<dt class="col-auto">제출여부</dt>
									<dd class="col-auto"><%:item.IsLeaderSubmit.Equals("Y") ? "제출" : "미제출" %></dd>
									<dt class="col-auto">점수</dt>
									<dd class="col-auto"> <%: item.EstimationOpenYesNo.Equals("Y") ? item.Score.ToString() : "비공개" %></dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="col-auto text-right d-md-none">
						<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divTeamprojectListStudent" aria-expanded="false" aria-controls="divTeamprojectListStudent">
							<span class="sr-only">더 보기</span>
						</button>
					</div>
				</div>
				<a href="/Report/Submit/<%:ViewBag.Course.CourseNo %>/<%:item.ProjectNo %>" class="card-title01 text-dark"><%:item.ProjectTitle %></a>
			</div>
			<div class="card-body collapse d-md-block" id="divTeamprojectListStudent">
				<div class="row mt-2 align-items-end">
					<div class="col-md">
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i> 제출기간</dt>
							<dd class="col-8 col-md"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
						</dl>
					</div>
					<div class="col-md-auto mt-2 mt-md-0 text-right">
						<a class="btn btn-lg btn-point w-100 w-md-auto" href="/Report/Submit/<%:ViewBag.Course.CourseNo %>/<%:item.ProjectNo %>">자세히</a>
					</div>
				</div>
			</div>
		</div>
		<%
			}
		%>
	</div>
</asp:Content>
