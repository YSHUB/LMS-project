<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Discussion/Write/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
		<div id="content">			
			<h3 class="title04">토론 정보</h3>
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-md-12">
							<label for="txtDiscussionSubject" class="form-label">토론주제 <strong class="text-danger">*</strong></label>
							<input type="text" id="txtDiscussionSubject" title="DiscussionSubject" name="Discussion.DiscussionSubject" class="form-control" value="<%: Model.Discussion != null ? Model.Discussion.DiscussionSubject : ""%>">
						</div>
						<div class="form-group col-4 col-md-3">
							<label for="ddlDiscussionAttribute" class="form-label">토론속성 <strong class="text-danger">*</strong></label>
							<select class="form-control" id="ddlDiscussionAttribute" name="Discussion.DiscussionAttribute" onchange="fnDiscussionAttribute()">
								<option value="">선택</option>
								<%
									foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CDAB")).ToList())
									{
								%>
										<option value="<%:item.CodeValue %>" <%if (item.CodeValue.Equals(Model.Discussion == null ? "" : Model.Discussion.DiscussionAttribute)){ %> selected="selected"<%} %>><%:item.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>

						<%
							if (Model.Discussion == null || Model.Discussion != null && Model.Discussion.DiscussionAttribute.Equals("CDAB002"))
							{
						%>
								<%
									if (Model.Discussion == null || Model.Discussion != null && Model.Discussion.OpinionCount == 0) 
									{
								%>
										<div class="form-group col-8 col-md-4" id="divDiscussionGroup">
											<label for="ddlDiscussionGroup" class="form-label">팀 편성 <strong class="text-danger">*</strong></label>
											<div class="input-group">
												<select class="form-control" id="ddlDiscussionGroup" name="Discussion.CourseGroupNo" onchange="fnGroupNoSelect()">
													<option value="">그룹선택</option>
													<%
														foreach (var item in Model.GroupList)
														{
													%>
															<option value="<%:item.GroupNo %>" <%if (item.GroupName.Equals(Model.Discussion == null ? "" : Model.Discussion.GroupName)){ %> selected="selected"<%} %>><%:item.GroupName %></option>
													<%
														}
													%>
												</select>
												<span class="input-group-append">
													<button type="button" class="btn btn-primary" id="btnGroupTeamMember" data-toggle="modal" data-target="#divGroupTeamMember" title="팀편성보기">
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
							
								<div class="form-group col-md-5" id="divOpen">
									<label for="chkOpenYesNo" class="form-label">공개여부 <strong class="text-danger">*</strong></label>
									<label class="switch">
										<input type="checkbox" id="chkOpenYesNo" name="Discussion.OpenYesNo" <%if (Model.Discussion == null || Model.Discussion.OpenYesNo.Equals("Y")){ %> checked="checked"<%} %> >
										<span class="slider round"></span>
									</label>
									<small class="text-secondary">※ 비공개는 조별토론일 때만 선택가능하며, 비공개를 선택하면 해당 팀원만 볼 수 있습니다.</small>
								</div>
						<%
							}
						%>
						<div class="form-group col-md-12">
							<label for="txtDiscussionSummary" class="form-label">토론개요 <strong class="text-danger">*</strong></label>
							<textarea id="txtDiscussionSummary" name="Discussion.DiscussionSummary" rows="3" class="form-control" title="DiscussionSummary" ><%: Model.Discussion != null ? Model.Discussion.DiscussionSummary : ""%></textarea>
						</div>
						<div class="form-group col-6 col-md-3">
							<label for="txtDiscussionStartDay" class="form-label">토론시작일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control datepicker" name="Discussion.DiscussionStartDay" id="txtDiscussionStartDay" title="DiscussionStartDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group col-6 col-md-3">
							<label for="txtDiscussionEndDay" class="form-label">토론종료일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control datepicker" name="Discussion.DiscussionEndDay" id="txtDiscussionEndDay" title="DiscussionEndDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group col-12 col-md-6">
							<label for="DiscussionFileUpload" class="form-label">첨부파일</label>
							<% Html.RenderPartial("./Common/File"
								, Model.FileList
								, new ViewDataDictionary {
								{ "name", "FileGroupNo" },
								{ "fname", "DiscussionFile" },
								{ "value", Model.FileGroupNo },
								{ "readmode", (Model.Discussion != null ? 0 : 1) },
								{ "fileDirType", "Discussion"},
								{ "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
						</div>
						</div>
					</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-md">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
						</div>
						<div class="col-md-auto text-right">
							<button type="button" class="btn btn-primary" id="btnSave">저장</button>
							<a href="/Discussion/List/<%:ViewBag.Course.CourseNo %>" class="btn btn-secondary" role="button">취소</a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<input type="hidden" title="hdnCourseNo" id="hdnCourseNo" name ="Discussion.CourseNo" value="<%: ViewBag.Course.CourseNo%>">
		<input type="hidden" title="hdnDiscussionNo" id="hdnDiscussionNo" name ="Discussion.DiscussionNo" value="<%: Model.Discussion != null ? Model.Discussion.DiscussionNo : 0%>">
		<input type="hidden" title="hdnTeamNo" id="hdnTeamNo" name="Discussion.TeamNo" value="<%:Model.TeamNo%>">
		<input type="hidden" title="hdnGroupNo" id="hdnGroupNo" name="Discussion.GroupNo" value="<%:Model.Discussion != null ? Model.Discussion.GroupNo : 0%>">
		<input type="hidden" title="hdnUpdateCourseGroupNo" id="hdnUpdateCourseGroupNo" name="Discussion.UpdateCourseGroupNo" value="<%:Model.Discussion != null ? Model.Discussion.GroupNo : 0 %>">
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
		$(document).ready(function () {

			fnFromToCalendar("txtDiscussionStartDay", "txtDiscussionEndDay", $("#txtDiscussionStartDay").val());

			$("#txtDiscussionStartDay").val("<%: Model.Discussion != null ? Model.Discussion.DiscussionStartDay : ""%>");
			$("#txtDiscussionEndDay").val("<%: Model.Discussion != null ? Model.Discussion.DiscussionEndDay : ""%>");
		})

		var ajaxHelper = new AjaxHelper();

		<%-- 팀 편성 보기 모달 --%>
		$("#btnGroupTeamMember").click(function () {

			if ($("#ddlDiscussionGroup").val() == "") {
				bootAlert("그룹을 선택해주세요.");
				$("#ddlDiscussionGroup").focus();
				return false;
			}

			var courseNo = $("#hdnCourseNo").val();
			var groupNo = $("#ddlDiscussionGroup").val();
			var isTeamProject = 0;

			fnGroupTeam(courseNo, groupNo, isTeamProject);
		});

		<%-- 토론속성(개별/조별)에 따라 팀편성 및 공개여부 show, hide --%>
		function fnDiscussionAttribute() {
			var selectBox;
			var discussionAttributeValue;
			selectBox = event.target;
			discussionAttributeValue = selectBox.value;

			if (discussionAttributeValue == 'CDAB001') {
				$("#divDiscussionGroup").hide();
				$("#divOpen").hide();
			} else {
				$("#divDiscussionGroup").show();
				$("#divOpen").show();
			}
		}

		<%-- 저장 --%>
		$("#btnSave").click(function () {

			if ($("#txtDiscussionSubject").val() == "") {
				bootAlert("토론 주제를 입력하세요.", function () {
					$("#txtDiscussionSubject").focus();
				});
				return false;
			}

			if ($("#ddlDiscussionAttribute").val() == "") {
				bootAlert("토록 속성을 선택하세요.", function () {
					$("#ddlDiscussionAttribute").focus();
				});
				return false;
			}

			if ($("#ddlDiscussionAttribute").val() == "CDAB002") {
				if ($("#ddlDiscussionGroup").val() == "") {
					bootAlert("조별토론 생성할 팀 그룹을 선택하세요.", function () {
						$("#ddlDiscussionGroup").focus();
					});
					return false;
				}
			}

			if ($("#txtDiscussionSummary").val() == "") {
				bootAlert("토론 개요를 입력하세요.", function () {
					$("#txtDiscussionSummary").focus();
				});
				return false;
			}

			if ($("#txtDiscussionStartDay").val() == "") {
				bootAlert("토론 시작일을 입력하세요.", function () {
					$("#txtDiscussionStartDay").focus();
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtDiscussionStartDay").val())) {
				bootAlert("토론 시작일자 날짜 형식을 확인해주세요.");
				return false;
			}

			if ($("#txtDiscussionEndDay").val() == "") {
				bootAlert("토론 종료일을 입력하세요.", function () {
					$("#txtDiscussionEndDay").focus();
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtDiscussionEndDay").val())) {
				bootAlert("토론 종료 일자 날짜 형식을 확인해주세요.");
				return false;
			}

			document.forms["mainForm"].submit();

			fnPrevent();

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
