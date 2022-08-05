<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Report/Submit/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
	<h3 class="title04">팀프로젝트 정보</h3>
	<div class="card card-style01">
		<div class="card-header">
			<div class="row no-gutters align-items-center">
				<div class="col">
					<div class="row">
						<div class="col-md">
							<div class="text-primary font-size-14">
								<strong class="text-<%:Model.TeamProject.ProjectSituation == "진행예정" ? "info" : Model.TeamProject.ProjectSituation == "종료" ? "dark" : "danger" %> bar-vertical"><%:Model.TeamProject.ProjectSituation %></strong>			
								<strong class="text-primary">
									<%:Model.TeamProject.LeaderYesNo.Equals("Y") ? "팀장제출" : "개별제출"%>
								</strong>
							</div>
						</div>
					</div>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divTeamProjectSubmit" aria-expanded="false" aria-controls="divTeamProjectSubmit">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<a href="/Report/Submit/<%:ViewBag.Course.CourseNo %>/<%:Model.TeamProject.ProjectNo %>" class="card-title01 text-dark"> <%:Model.TeamProject.ProjectTitle %></a>
		</div>
		<div class="card-body collapse d-md-block" id="divTeamProjectSubmit">
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem">
							<i class="bi bi-dot"></i> 
							제출방식
						</dt>
						<dd class="col-8 col-md">
							<%: Model.TeamProject.LeaderYesNo.Equals("Y") ? "팀장 제출":"개별 제출" %>
						</dd>
						<dt class="col-4 col-md-auto w-7rem">
							<i class="bi bi-dot"></i> 
							팀편성
						</dt>
						<dd class="col-8 col-md">
							<%:Model.TeamProject.GroupName %> 
							<button type="button" id="btnGroupTeamMember" class="text-primary font-size-20" data-toggle="modal" data-target="#divGroupTeamMember" title="팀원보기" >
								<i class="bi bi bi-people-fill"></i>
							</button>
							<!-- 팀편성보기 ascx 호출 -->
							<% Html.RenderPartial("./Team/GroupTeamMemberList"); %>	
							<!-- 팀편성보기 ascx 호출 -->
						</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem">
							<i class="bi bi-dot"></i> 
							제출기간
						</dt>
						<dd class="col-8 col-md">
							<%:DateTime.Parse(Model.TeamProject.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(Model.TeamProject.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %>
						</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem">
							<i class="bi bi-dot"></i> 
							<%:Model.TeamProject.IsOutput == 0 ? "내용" : "수업내용" %>
						</dt>
						<dd class="col">
							<%:Model.TeamProject.ProjectContents %>
						</dd>
					</dl>
					<%
						if (Model.FileList != null)
						{
							foreach (var item in Model.FileList)
							{
					%>
								<dl class="row dl-style02">
									<dt class="col-auto w-7rem">
										<i class="bi bi-dot"></i> 
										첨부파일
									</dt>
									<dd class="col-8 col-md">
										<button type="button" title="다운로드" onclick="fnFileDownload(<%:item.FileNo %>)">
											<i class="bi bi-paperclip"></i>
											<span><%:item.OriginFileName%></span>
										</button>
									</dd>
								</dl>
					<%
							}
						}
					%>
				</div>
				<div class="col-md-auto mt-2 mt-md-0 text-right">
					<div class="btn-group btn-group-lg">
						<a class="btn btn-lg btn-outline-warning w-100 w-md-auto" href="/Report/Write/<%:Model.TeamProject.CourseNo %>/<%:Model.TeamProject.IsOutput %>/<%:Model.TeamProject.ProjectNo %>">수정</a>
						<a class="btn btn-lg btn-outline-danger w-100 w-md-auto" id="btnDelete">삭제</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-12">
			<%
				if (Model.TeamProject.EstimationOpenYesNo.Equals("Y")) 
				{ 
			%>
					<h3 class="title04">결과(피드백)</h3>
					<div class="card card-style01">
						<div class="card-header"><%:Model.TeamProjectSubmit != null && !Model.TeamProjectSubmit.Score.Equals(0) ? Model.TeamProjectSubmit.Score  + "점" : "미채점"%>
						</div>					
						<div class="card-body"><%:Model.TeamProjectSubmit != null && Model.TeamProjectSubmit.Feedback != null ? Model.TeamProjectSubmit.Feedback : "" %>
						</div>
					</div>
			<%
				}
			%>
			<h3 class="title04">제출정보</h3>
				<div class="card card-style01">
					<div class="card-header">
						<div class="row align-items-center">
							<div class="col-12 col-lg text-right text-danger">
								<%if (Model.TeamProject.ProjectSituation.Equals("종료")) {%>
									팀프로젝트  제출 기간이 지났습니다.
								<%} %>
							</div>
						</div>
					</div>
					<div class="card-body">
						<div class="row">
							<div class="col-12">
								<div class="form-row">
									<div class="form-group col-12">
										<label for="txtSubmitContents" class="form-label">제출 내용 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<textarea class="form-control" id="txtSubmitContents" name="TeamProjectSubmit.SubmitContents" rows="5"><%:Model.TeamProjectSubmit != null ? Model.TeamProjectSubmit.SubmitContents : "" %></textarea>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12">
								<div class="form-row">
									<div class="form-group col-12">
										<label for="file" class="form-label">첨부파일 <strong class="text-danger">*</strong></label>
										<small class="text-muted"> 파일이 2개이상일 경우 압축(zip)하여 올려주시기 바랍니다.</small>
											<% Html.RenderPartial("./Common/File"
												, Model.FileCopyList
												, new ViewDataDictionary {
												{ "name", "FileGroupNo" },
												{ "fname", "TeamProjectSubmitFile" },
												{ "value", Model.FileGroupNo },
												{ "readmode", (Model.TeamProjectSubmit != null ? 0 : 1) },
												{ "fileDirType", "TeamProjectSubmit"},
												{ "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-6">
						<div class="dropdown d-inline-block">
						</div>
					</div>
					<div class="col-6">
						<div class="text-right">
							<%
								if (Model.TeamProject.ProjectSituation.Equals("진행중") && Model.TeamProjectSubmit != null && Model.TeamProjectSubmit.TeamLeaderYesNo.Equals("Y")) 
								{ 
							%>
									<button type="button" class="btn btn-primary" id="btnSave">저장</button>
							<%
								}
							%>	
							<a href="<%:Model.TeamProject.IsOutput == 0 ? "/TeamProject/ListStudent/" + ViewBag.Course.CourseNo : "/Report/List/" + ViewBag.Course.CourseNo %>" class="btn btn-secondary">취소
							</a>
						</div>
					</div>
				</div>
		</div>
	</div>

	<input type="hidden" title="hdnCourseNo" id="hdnCourseNo" name ="TeamProjectSubmit.CourseNo" value="<%: Model.TeamProject.CourseNo %>">
	<input type="hidden" title="hdnProjectNo" id="hdnProjectNo" name ="TeamProjectSubmit.ProjectNo" value="<%: Model.TeamProject.ProjectNo %>">
	<input type="hidden" title="hdnTeamNo" id="hdnTeamNo" name ="TeamProjectSubmit.TeamNo" value="<%: Model.TeamProjectSubmit != null ? Model.TeamProjectSubmit.TeamNo : 0 %>">
	<input type="hidden" title="hdnIsOutput" id="hdnIsOutput" name ="TeamProject.IsOutput" value="<%: Model.TeamProject.IsOutput %>">
	<input type="hidden" title="hdnSubmitNo" id="hdnSubmitNo" name ="TeamProjectSubmit.SubmitNo" value="<%: Model.TeamProjectSubmit != null ? Model.TeamProjectSubmit.SubmitNo : 0 %>">
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		<%-- 팀원보기 --%>
		$("#btnGroupTeamMember").click(function () {

			var courseNo = $("#hdnCourseNo").val();
			var groupNo = <%:Model.TeamProject.GroupNo%>;
			var isTeamProject = 1;

			fnGroupTeam(courseNo, groupNo, isTeamProject);
		});

		<%-- 과제 저장 --%>
		$("#btnSave").click(function () {

			if ($("#txtSubmitContents").val() == "") {
				bootAlert("내용을 입력하세요", function () {
					$("#txtSubmitContents").focus();
				});
				return false;
			}

			if ($('.fileitembox').length == 0 && $("input[name='TeamProjectSubmitFile']").val() == "") {
				bootAlert("첨부파일을 추가해주세요.");
				return false;
			}

			document.forms["mainForm"].submit();
		});

	</script>
</asp:Content>
