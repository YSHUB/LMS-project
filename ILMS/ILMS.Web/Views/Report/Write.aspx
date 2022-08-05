<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Report/Write/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
		<div id="content">
			<h3 class="title04">팀프로젝트 정보</h3>
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-md-12">
							<label for="txtTeamProjectTitle" class="form-label"><%:Model.IsOutput == 0 ? "팀프로젝트 제목" : "팀프로젝트 주제" %> <strong class="text-danger">*</strong></label>
							<input type="text" id="txtTeamProjectTitle" name="TeamProject.ProjectTitle" class="form-control" value="<%:Model.TeamProject != null ? Model.TeamProject.ProjectTitle : "" %>">
						</div>
						<div class="form-group col-4 col-md-3 <%:Model.IsOutput == 0 ? "" : "d-none" %>">
							<label for="ddlTeamProjectSubmitType" class="form-label">제출구분 <strong class="text-danger">*</strong></label>
							<select class="form-control" id="ddlTeamProjectSubmitType" name="TeamProject.SubmitType">
								<option value="">선택</option>
									<%
										foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("SMTP")).ToList())
										{
											var index = Model.BaseCode.Where(x => x.ClassCode.Equals("SMTP")).ToList().IndexOf(item);
									%>
											<option value="<%:item.CodeValue.Equals("SMTP00" + (index + 1)) ? index : -1 %>" <%if (item.CodeName.Equals(Model.TeamProject == null ? "" : Model.TeamProject.SubmitTypeName)) {%> selected="selected" <%} %>><%:item.CodeName %></option>
									<%
										}
									%>
							</select>
						</div>
						<div class="form-group col-4 col-md-3">
							<label for="divTeamProjectLeaderYesNo" class="form-label">제출방식 </label>
							<div class="form-control" id="divTeamProjectLeaderYesNo" name="TeamProject.LeaderYesNo">
								팀장제출
							</div>
						</div>

						<%
							if (Model.TeamProject == null || Model.TeamProject != null && Model.TeamProject.SubmitCount == 0) 
							{
						%>
								<div class="form-group col-8 col-md-6" id="divTeamProjectGroup">
									<label for="ddlTeamProjectGroup" class="form-label">팀 편성 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<select class="form-control" id="ddlTeamProjectGroup" name="TeamProject.CourseGroupNo" onchange="fnGroupNoSelect()">
											<option value="">그룹선택</option>
											<%
												foreach (var item in Model.GroupList)
												{
											%>
													<option value="<%:item.GroupNo %>" <%if (item.GroupName.Equals(Model.TeamProject == null ? "" : Model.TeamProject.GroupName)){ %> selected="selected"<%} %>><%:item.GroupName %></option>
											<%
												}
											%>
										</select>
										<span class="input-group-append">
											<button type="button" class="btn btn-primary" id="btnGroupTeamMember" data-toggle="modal" data-target="#divGroupTeamMember">
												팀 편성 보기
											</button>
											<!-- 팀편성보기 ascx 호출 -->
											<% Html.RenderPartial("./Team/GroupTeamMemberList"); %>	
											<!-- 팀편성보기 ascx 호출 -->
										</span>
									</div>
								</div>
						<%
							}
						%>
						<div class="form-group col-md-12">
							<label for="txtTeamProjectContents" class="form-label"><%:Model.IsOutput == 0 ? "내용" : "수업내용" %> <strong class="text-danger">*</strong></label>
							<textarea id="txtTeamProjectContents" name="TeamProject.ProjectContents" rows="3" class="form-control" title="ProjectContents"><%:Model.TeamProject != null ? Model.TeamProject.ProjectContents : "" %></textarea>
						</div>
						<div class="form-group col-12 col-md-6">
							<label for="txtTeamProjectSubmitStartDay" class="form-label">제출시작일시 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="TeamProject.SubmitStartDay" id="txtTeamProjectSubmitStartDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text">
										<i class="bi bi-calendar4-event"></i>
									</span>
								</div>
								<label for="ddlStartHour" class="form-label"></label>
								<select class="form-control" id="ddlStartHour" name="TeamProject.SubmitStartHour"></select>
								<div class="input-group-append input-group-prepend">
									<span class="input-group-text">시</span>
								</div>
								<label for="ddlStartMin" class="form-label"></label>
								<select class="form-control" id="ddlStartMin" name="TeamProject.SubmitStartMin"></select>
								<div class="input-group-append">
									<span class="input-group-text">분</span>
								</div>
							</div>
						</div>
						<div class="form-group col-12 col-md-6">
							<label for="txtTeamProjectSubmitEndDay" class="form-label">제출종료일시 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="TeamProject.SubmitEndDay" id="txtTeamProjectSubmitEndDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text">
										<i class="bi bi-calendar4-event"></i>
									</span>
								</div>
								<label for="ddlEndHour" class="form-label"></label>
								<select class="form-control" id="ddlEndHour" name="TeamProject.SubmitEndHour"></select>
								<div class="input-group-append input-group-prepend">
									<span class="input-group-text">시</span>
								</div>
								<label for="ddlEndMin" class="form-label"></label>
								<select class="form-control" id="ddlEndMin" name="TeamProject.SubmitEndMin"></select>
								<div class="input-group-append">
									<span class="input-group-text">분</span>
								</div>
							</div>
						</div>
						<div class="form-group col-12 col-md-6">
							<label for="TeamProjectFileUpload" class="form-label">첨부파일</label>
								<% Html.RenderPartial("./Common/File"
									, Model.FileList
									, new ViewDataDictionary {
									{ "name", "FileGroupNo" },
									{ "fname", "TeamProjectFile" },
									{ "value", Model.FileGroupNo },
									{ "readmode", (Model.TeamProject != null ? 0 : 1) },
									{ "fileDirType", "TeamProject"},
									{ "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
						</div>
					</div><!-- form-row -->
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
						</div>
						<div class="col-6 text-right">
							<button type="button" class="btn btn-primary" id="btnSave">저장</button>
							<button type="button" class="btn btn-secondary" id="btnCancel">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	
		<input type="hidden" title="hdnCourseNo" id="hdnCourseNo" name ="TeamProject.CourseNo" value="<%:ViewBag.Course.CourseNo%>">
		<input type="hidden" title="hdnProjectNo" id="hdnProjectNo" name ="TeamProject.ProjectNo" value="<%: Model.TeamProject != null ? Model.TeamProject.ProjectNo : 0%>">
		<input type="hidden" title="hdnIsOutput" id="hdnIsOutput" name="TeamProject.IsOutput" value="<%:Model.IsOutput%>" />
		<input type="hidden" title="hdnUpdateCourseGroupNo" id="hdnUpdateCourseGroupNo" name="TeamProject.UpdateCourseGroupNo" value="<%:Model.TeamProject != null ? Model.TeamProject.GroupNo : 0 %>">
		<input type="hidden" title="hdnGroupNo" id="hdnGroupNo" name="TeamProject.GroupNo" value="<%:Model.TeamProject != null ? Model.TeamProject.GroupNo : 0 %>">
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		$(document).ready(function () {

			fnAppendHour("ddlStartHour", <%:Model.TeamProject != null ? Model.TeamProject.SubmitStartHour : "00"%>);
			fnAppendMin("ddlStartMin", <%:Model.TeamProject != null ? Model.TeamProject.SubmitStartMin : "00"%>, 1);
			fnAppendHour("ddlEndHour", <%:Model.TeamProject != null ? Model.TeamProject.SubmitEndHour : "23"%>);
			fnAppendMin("ddlEndMin", <%:Model.TeamProject != null ? Model.TeamProject.SubmitEndMin : "59"%>, 1);

			fnFromToCalendar("txtTeamProjectSubmitStartDay", "txtTeamProjectSubmitEndDay", $("#txtTeamProjectSubmitStartDay").val());

			$("#txtTeamProjectSubmitStartDay").val("<%:Model.TeamProject != null ? DateTime.Parse(Model.TeamProject.SubmitStartDay).ToString("yyyy-MM-dd") : ""%>");
			$("#txtTeamProjectSubmitEndDay").val("<%:Model.TeamProject != null ? DateTime.Parse(Model.TeamProject.SubmitEndDay).ToString("yyyy-MM-dd") : ""%>");

		})

		<%-- 팀 편성 보기 모달 --%>
		$("#btnGroupTeamMember").click(function () {

			if ($("#ddlTeamProjectGroup").val() == "") {
				bootAlert("그룹을 선택해주세요.");
				$("#ddlTeamProjectGroup").focus();
				return false;
			}
			var courseNo = $("#hdnCourseNo").val();
			var groupNo = $("#ddlTeamProjectGroup").val();
			var isTeamProject = 0;

			fnGroupTeam(courseNo, groupNo, isTeamProject);
		});

		<%-- 저장 --%>
		$("#btnSave").click(function () {

			var submitStartDay = fnReplaceAll($("#txtTeamProjectSubmitStartDay").val().trim(), "-", "");
			var submitEndDay = fnReplaceAll($("#txtTeamProjectSubmitEndDay").val().trim(), "-", "");
			var submitStartTime = $("#ddlStartHour").val().trim() + $("#ddlStartMin").val().trim();
			var submitEndTime = $("#ddlEndHour").val().trim() + $("#ddlEndMin").val().trim();

			if ($("#txtTeamProjectTitle").val() == "") {
				bootAlert("제목을 입력하세요.", function () {
					$("#txtTeamProjectTitle").focus();
				});
				return;
			}

			if ($("#hdnIsOutput").val() == 0) {
				if ($("#ddlTeamProjectSubmitType").val() == "") {
					bootAlert("제출 구분을 선택하세요.", function () {
						$("#ddlTeamProjectSubmitType").focus();
					});
					return false;
				}
			}

			if ($("#ddlTeamProjectGroup").val() == "") {
				bootAlert("팀 그룹을 선택하세요.", function () {
					$("#ddlTeamProjectGroup").focus();
				});
				return false;
			}

			if ($("#txtTeamProjectContents").val() == "") {
				bootAlert("팀프로젝트 내용을 입력하세요.", function () {
					$("#txtTeamProjectContents").focus();
				});
				return false;
			}

			if (submitStartDay.trim() == "") {
				bootAlert("팀프로젝트 제출기간 시작일을 입력하세요.", function () {
					$("#txtTeamProjectSubmitStartDay").focus();
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtTeamProjectSubmitStartDay").val())) {
				bootAlert("제출 시작일자 날짜 형식을 확인해주세요.");
				return false;
			}

			if (submitEndDay.trim() == "") {
				bootAlert("팀프로젝트 제출기간 종료일을 입력하세요.", function () {
					$("#txtTeamProjectSubmitEndDay").focus();
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtTeamProjectSubmitEndDay").val())) {
				bootAlert("제출 종료일자 날짜 형식을 확인해주세요.");
				return false;
			}

			if (parseInt(submitStartDay + submitStartTime) >= parseInt(submitEndDay + submitEndTime)) {
				bootAlert("팀프로젝트 제출기간 종료일시가 종료일시보다 같거나 빠를 수 없습니다.", function () {
					$("#txtEndDay").focus();
				});
				return false;
			}

			document.forms["mainForm"].submit();
		});

		<%-- 취소 --%>
		$("#btnCancel").click(function () {

			if ($("#hdnIsOutput").val() == 0) {
				location.href = "/TeamProject/ListTeacher/<%:ViewBag.Course.CourseNo %>";
			} else {
				location.href = "/Report/List/<%:ViewBag.Course.CourseNo %>";
			}

		});

		<%-- 수정 할 때 등록된 기존 그룹번호와 비교 --%>
		function fnGroupNoSelect() {
			var selectBox;
			var groupNoValue;
			selectBox = event.target;
			groupNoValue = selectBox.value;

			$("#hdnUpdateCourseGroupNo").val(groupNoValue);
		}
	</script>
</asp:Content>