<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="row align-items-center mt-4">
		<div class="col-md">
			<h3 class="title04">과제 리스트</h3>
		</div>
	</div>
	<div class="card">
		<div class="card-body">
			<ul class="list-inline list-inline-style02">
				<li class="list-inline-item bar-vertical">진행예정<span class="ml-1 badge badge-primary"><%= Model.HomeworkList.Where(t => DateTime.Parse(t.SubmitStartDay) > DateTime.Now).Count()%></span>
				</li>
				<li class="list-inline-item bar-vertical">종료<span class="ml-1 badge badge-secondary"><%= Model.HomeworkList.Where(t => t.AddSubmitEndDay != null ? DateTime.Parse(t.AddSubmitEndDay) < DateTime.Now : DateTime.Parse(t.SubmitEndDay) < DateTime.Now).Count()%></span>
				</li>
				<li class="list-inline-item bar-vertical">평가완료<span class="ml-1 badge badge-secondary"><%= Model.HomeworkList.Where(t => t.SubmitScoreCnt == t.StudentCnt).Count()%></span>
				</li>
			</ul>
		</div>
	</div>
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
										<strong class="text-success bar-vertical"><%:item.SubmitTypeName %></strong>
										<%: item.OpenYesNo.Equals("Y") ? Html.Raw("<strong class='text-info'>공개</strong>") : Html.Raw("<strong class='text-danger'>비공개</strong>")%>
									</div>
								</div>
								<div class="col-md-auto text-right">
									<dl class="row dl-style01">
										<dt class="col-auto">제출인원</dt>
										<dd class="col-auto"><%= item.SubmitCnt%>명</dd>
										<dt class="col-auto">평가인원</dt>
										<dd class="col-auto"><%= item.SubmitScoreCnt%>명 / <%= item.StudentCnt%>명</dd>
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
					<a href="/Homework/Detail/<%:item.CourseNo %>/<%:item.HomeworkNo %>" class="card-title01 text-dark"><%= item.HomeworkTitle %></a>
					<span class="badge badge-irregular <%:item.AddSubmitPeriodUseYesNo.Equals("Y") ? "" : "d-none" %>">추가시험</span>
				</div>
				<div class="card-body collapse d-md-block" id="colHomework">
					<div class="row mt-2 align-items-end">
						<div class="col-md">
							<dl class="row dl-style02">
								<dt class="col-4 col-md-3 col-lg-2 w-7rem">
									<i class="bi bi-dot"></i>과제유형
								</dt>
								<dd class="col-8 col-md-9 col-lg-2">
									<%:item.HomeworkTypeName %>
								</dd>
								<dt class="col-4 col-md-3 col-lg-2 w-7rem">
									<i class="bi bi-dot"></i>제출기간
								</dt>
								<dd class="col-8 col-md-9 col-lg-6">
									<%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %>
								</dd>
							</dl>
						</div>
						<div class="col-md-auto mt-2 mt-md-0 text-right">
							<a class="btn btn-lg btn-point w-100 w-md-auto" href="/Homework/Detail/<%:item.CourseNo %>/<%:item.HomeworkNo %>">자세히</a>
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
	<div class="text-right">
		<input type="button" class="btn btn-secondary <%: ViewBag.Course.ProgramNo == 2 ? "d-none" : ""%>" id="btnCopy" value="과제 가져오기" />
		<a href="/Homework/Write/<%= ViewBag.Course.CourseNo %>" class="btn btn-primary">등록</a>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$("#btnCopy").click(function () {
				fnOpenPopup("/Homework/Copy/" + <%:ViewBag.Course.CourseNo%> , "CopyHomework", 700, 600, 0, 0, "auto");
			});
		});
	</script>
</asp:Content>
