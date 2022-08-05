<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="row align-items-center mt-4">
		<div class="col-md">
			<h3 class="title04">수업활동일지 리스트</h3>
		</div>
	</div>
	<div class="form-row mt-3">
		<div class="col-md-4 col-12">
			<div class="dropdown  <%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "inline-block d-none" : "d-inline-block"%>">
				<button type="button" class="btn btn-point dropdown-toggle" id="ddlOutputFile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					제출 양식 다운로드
				</button>
				<ul class="dropdown-menu" aria-labelledby="quiz-setting" style="will-change: transform;">
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_토의토론(개별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_토의토론(개별 제출).hwp</a></li>
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_토의토론(팀별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_토의토론(팀별 제출).hwp</a></li>
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_팀학습(개별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_팀학습(개별 제출).hwp</a></li>
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_팀학습(팀별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_팀학습(팀별 제출).hwp</a></li>
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_플립러닝(개별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_플립러닝(개별 제출).hwp</a></li>
					<li><a class="dropdown-item" role="button" href="/Content/file/학생산출물_플립러닝(팀별 제출).hwp" data-toggle="modal" data-target="#chgEndDTMsg"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>산출물_플립러닝(팀별 제출).hwp</a></li>
				</ul>
			</div>
		</div>
		<%if ((ViewBag.Course.IsProf == 1))
			{%>
		<div class="col-md-8 col-12 text-right">
			<input type="button" class="btn btn-primary" id="btnOutput" value="수업활동일지 등록(개인)" />
			<input type="button" class="btn btn-primary" id="btnTeam" value="수업활동일지 등록(팀)" />
		</div>
		<%} %>
	</div>
	<%
		if (Model.OutputList.Count.Equals(0))
		{
	%>
			<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 수업활동일지가 없습니다.</div>
	<%
		}
		else 
		{
	%>
			<%foreach (var item in Model.OutputList)
			{  
			%>
				<div class="card card-style01">
					<div class="card-header">
						<div class="row no-gutters align-items-center">
							<div class="col-auto text-right d-md-none">
								<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample2" aria-expanded="false" aria-controls="collapseExample2">
									<span class="sr-only">더 보기</span>
								</button>
							</div>
						</div>
						<a href="<%:item.SubmitTypeName.Equals("팀별제출") ? "/Report" : "/Homework" %>/Detail/<%:ViewBag.Course.CourseNo %>/<%:item.OutputNo %>" class="card-title01 text-dark"><%:item.OutputName %></a>
					</div>
					<div class="card-body collapse d-md-block" id="collapseExample2">
						<div class="row mt-2 align-items-end">
							<div class="col-md">
								<dl class="row dl-style02">
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출방식</dt>
									<dd class="col-8 col-md"><%:item.SubmitTypeName %></dd>
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출기간</dt>
									<dd class="col-8 col-md"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
								</dl>
							</div>
							<div class="col-md-auto mt-2 mt-md-0 text-right">
								<%if (ViewBag.Course.IsProf == 1)
									{ %>
									<a class="btn btn-lg btn-point w-100 w-md-auto" href="<%:item.SubmitTypeName.Equals("팀별제출") ? "/Report" : "/Homework" %>/Detail/<%:ViewBag.Course.CourseNo %>/<%:item.OutputNo %>">더보기</a>
					
								<%}
								else
								{ %>
									<a class="btn btn-lg btn-point w-100 w-md-auto" href="<%:item.SubmitTypeName.Equals("팀별제출") ? "/Report" : "/Homework" %>/Submit/<%:ViewBag.Course.CourseNo %>/<%:item.OutputNo %>">제출하기</a>
								<%} %>
							</div>
						</div>
					</div>
				</div>
			<%} %>
	<%
		}
	%>


	
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		$(document).ready(function () {

			$("#btnOutput").click(function () {
				window.location = '/Homework/Write/<%:ViewBag.Course.CourseNo%>/1';
			});

			$("#btnTeam").click(function () {
				window.location = '/Report/Write/<%:ViewBag.Course.CourseNo%>/1';
			});

		});

	</script>
</asp:Content>