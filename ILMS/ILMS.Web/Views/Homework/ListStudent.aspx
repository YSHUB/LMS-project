<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04">과제 리스트</h3>
	<%
		if (Model.HomeworkList.Count < 1)
		{
	%>
			<div class="card">
				<div class="card-body text-center">
					등록된 과제가 없습니다.
				</div>
			</div>
	<%
		}
		else 
		{
	%>
			<%
				foreach (var item in Model.HomeworkList)
				{
			%>
			<div class="card card-style01">
				<div class="card-header">
					<div class="row no-gutters align-items-center">
						<div class="col">
							<div class="row">
								<div class="col-md">
									<div class="text-primary font-size-14">
										<strong class="text-danger bar-vertical"><%:item.Week %>주 <%:item.InningSeqNo %>차시</strong>
									</div>
								</div>
								<div class="col-md-auto text-right">
									<dl class="row dl-style01">
										<dt class="col-auto">제출여부</dt>
										<dd class="col-auto"><%: item.HomeworkType == "CHWT004" ? item.LeaderContents != null ? "제출" : "미제출" : item.SubmitContents != null || item.SubmitFilleGroupNo > 0 ? "제출" : "미제출"%></dd>
										<dt class="col-auto">점수</dt>
										<dd class="col-auto"><%= item.EstimationOpenYesNo.Equals("Y") ? item.Score.ToString() != null ? item.Score.ToString()+"점" : "-" : "비공개"%></dd>
									</dl>
								</div>
							</div>
						</div>
						<div class="col-auto text-right d-md-none">
							<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#colHomework" aria-expanded="false" aria-controls="colHomework">
								<span class="sr-only">더 보기</span>
							</button>
						</div>
					</div>
					<a href="/Homework/Submit/<%:ViewBag.Course.CourseNo %>/<%:item.HomeworkNo %>" class="card-title01 text-dark"><%:item.HomeworkTitle %></a>
				</div>
				<div class="card-body collapse d-md-block" id="colHomework">
					<div class="row mt-2 align-items-end">
						<div class="col-md">
							<dl class="row dl-style02">
								<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>과제유형</dt>
								<dd class="col-8 col-md"><%:item.HomeworkTypeName %></dd>
								<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출기간</dt>
								<dd class="col-8 col-md"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
							</dl>
						</div>
						<div class="col-md-auto mt-2 mt-md-0 text-right">
							<a class="btn btn-lg btn-point w-100 w-md-auto" href="/Homework/Submit/<%:ViewBag.Course.CourseNo %>/<%:item.HomeworkNo %>">자세히</a>
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
</asp:Content>
