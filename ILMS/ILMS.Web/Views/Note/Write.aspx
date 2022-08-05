<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.NoteViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<ul class="nav nav-tabs mt-4" role="tablist">
		<li class="nav-item" role="presentation">
			<a class="nav-link" id="receiveTab" href="/Note/ReceiveList" role="tab">받은 쪽지</a>
		</li>
		<li class="nav-item" role="presentation">
			<a class="nav-link" id="sendTab" href="/Note/SendList" role="tab">보낸 쪽지</a>
		</li>
		<li class="nav-item" role="presentation">
			<a class="nav-link active" id="writeTab" href="/Note/Write" role="tab">쪽지 쓰기</a>
		</li>
	</ul>

	<form id="mainForm" method="post" enctype="multipart/form-data">
		<div class="tab-pane fade active show" role="tabpanel" aria-labelledby="writeTab">
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-4 col-md-3">
							<label for="ddlTagetSel" class="form-label">수신 대상 <strong class="text-danger">*</strong></label>
							<select class="form-control" id="ddlTagetSel" name="tagetSel" onchange="chgTagetVal()">
								<%
									foreach (var code in Model.BaseCode)
									{
								%>
								<option value="<%:code.CodeValue%>"><%:code.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-8 col-md-9" id="selectUser">
							<label for="txtselectUser" class="form-label">받는사람 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control" id="txtselectUser" title="받는사람" type="text" readonly="" value="">
								<span class="input-group-append">
									<button type="button" class="btn btn-primary" onclick="fnOpenUserPopup('multi', 'hdnUserNo', 'txtselectUser');">사용자 검색</button>
								</span>
								<input type="hidden" name="Note.UserID" id="hdnUserNo" value="" />
							</div>
						</div>
						<div class="form-group col-4 col-md-4 d-none" id="semester">
							<label for="ddlTermNo" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
							<select id="ddlTermNo" class="form-control" onchange="changeSemester(this)">
							<%
							if (Model.TermList == null)
							{
							%>
								<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
							<%
							}
							else
							{
							%>
								<option value=""><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 선택</option>
							<%
							}

							foreach (var item in Model.TermList)
							{
							%>
								<option value="<%:item.TermNo %>">
									<%:item.TermName %>
								</option>
							<%
							}
							%>
							</select>
						</div>
						<div class="form-group col-4 col-md-5 d-none" id="subject">
							<label for="ddlCourseNo" class="form-label"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>선택 <strong class="text-danger">*</strong></label>
							<select class="form-control" id="ddlCourseNo">
							</select>
						</div>
						<div class="form-group col-12">
							<label for="txtTitle" class="form-label">제목 <strong class="text-danger">*</strong></label>
							<input class="form-control" name="Note.NoteTitle" id="txtTitle">
							
						</div>
						<div class="form-group col-md-12">
							<label for="txtContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
							<textarea id="txtContents" name="Note.NoteContents" rows="5" class="form-control"></textarea>
						</div>
						<div class="form-group col-12">
							<label for="NoteFileUpload" class="form-label">파일 첨부</label>
							<% Html.RenderPartial(
							"./Common/File"
							, Model.FileList
							, new ViewDataDictionary {
							{ "name", "FileGroupNo" },
							{ "fname", "MessageFile"},
							{ "value", 0},
							{ "fileDirType", "Message"},
							{ "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
						</div>
					</div>
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
						</div>
						<div class="col-6 text-right">
							<button type="button" class="btn btn-primary" onclick="fnSendNote();">발송</button>
							<button type="button" class="btn btn-secondary" onclick="fnGoBack();">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>

	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			var ocwGubun = "<%=Request.Form["hdnOcwGubun"]%>"; 


			<%--받은 쪽지 - 답장--%>
			if ("<%:Model.NoteGubun%>" == "R") {
				$("#txtselectUser").val("(<%:Model.Note.SendUserID%>)<%:Model.Note.SendUserName%>");
				$("#hdnUserNo").val(<%:Model.Note.SendUserNo%>);
				$("#txtTitle").val("Re: " + "<%:Model.Note.NoteTitle%>");
			}

			<%-- OCW에서 OCW등록자 쪽지보내기 --%>
			if (ocwGubun == "ocw") {
				var txtselectUser = "<%=Request.Form["txtselectUser"]%>";
				var hdnUserNo = "<%=Request.Form["hdnUserNo"]%>";

				$("#txtselectUser").val(txtselectUser);
				$("#hdnUserNo").val(hdnUserNo);
			}
		});

		<%--수신대상 변경 시--%>
		function chgTagetVal() {
			var tagetValue = $("#ddlTagetSel option:selected").val();

			$("#txtselectUser").val("");
			$("#hdnUserNo").val("");

			if (tagetValue == "NTTG001") {

				$("#selectUser").attr("class", "form-group col-8 col-md-9");
				$("#semester").attr("class", "form-group col-4 col-md-4 d-none");
				$("#subject").attr("class", "form-group col-4 col-md-5 d-none");

			}
			else if (tagetValue == "NTTG002") {
				$("#selectUser").attr("class", "form-group col-8 col-md-9 d-none");
				$("#semester").attr("class", "form-group col-4 col-md-4");
				$("#subject").attr("class", "form-group col-4 col-md-5");

				$("#ddlTermNo option:eq(0)").prop("selected", true);
				$("#ddlCourseNo option").remove();
				$("#ddlCourseNo").append("<option value=''><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 선택</option>");
			}
			else if (tagetValue == "NTTG003") {
				$("#selectUser").attr("class", "form-group col-8 col-md-9 d-none");
				$("#semester").attr("class", "form-group col-4 col-md-4");
				$("#subject").attr("class", "form-group col-4 col-md-5");

				$("#ddlTermNo option:eq(0)").prop("selected", true);
				$("#ddlCourseNo option").remove();
				$("#ddlCourseNo").append("<option value=''><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 선택</option>");

			}
			else if (tagetValue == "NTTG004") {
				$("#selectUser").attr("class", "form-group col-8 col-md-9 d-none");
				$("#semester").attr("class", "form-group col-4 col-md-4 d-none");
				$("#subject").attr("class", "form-group col-4 col-md-5 d-none");
			}
			else if (tagetValue == "NTTG005") {
				$("#selectUser").attr("class", "form-group col-8 col-md-9 d-none");
				$("#semester").attr("class", "form-group col-4 col-md-4 d-none");
				$("#subject").attr("class", "form-group col-4 col-md-5 d-none");
			}

		}

		function changeSemester(obj) {

			var targetVal = $("#ddlTagetSel").val();
			var innerHtml = "";

			if ($(obj).val() == "") {
				innerHtml = "<option value=''><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 선택</option>"
				$("#ddlCourseNo").html(innerHtml);
			}
			else {
				ajaxHelper.CallAjaxPost("/Note/SubjectList", { param1: $(obj).val(), param2: targetVal }, "CompleteSubList", "");
			}

		}

		function CompleteSubList() {

			var ajaxResult = ajaxHelper.CallAjaxResult();

			var innerHtml = "";

			if (ajaxResult.length > 0) {

				innerHtml += "<option value=''><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 선택</option>";

				for (var i = 0; i < ajaxResult.length; i++) {
					innerHtml += "<option value='" + ajaxResult[i].CourseNo + "'>";

					if (ajaxResult[i].ProgramNo == "1") {
						innerHtml += ajaxResult[i].SubjectName + "(" + fnNumberPad(ajaxResult[i].ClassNo, 3) + ")";
					}
					else {
						innerHtml += ajaxResult[i].SubjectName;
					}

					innerHtml += "</option>";
				}
			}
			else {
				innerHtml = "<option value=''>" + "수강하는 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>이 없습니다." + "</opion>"
			}

			$("#ddlCourseNo").html(innerHtml);

		}

		function fnSendNote() {
			var targetVal = $("#ddlTagetSel").val();
			var termNo = $("#ddlTermNo").val();
			var subjectNo = $("#ddlCourseNo").val();

			if (targetVal == "NTTG001") {
				if ($("#hdnUserNo").val() == "") {
					bootAlert("받는 사람을 추가해주세요.");
					return false;
				}
			}
			else if (targetVal == "NTTG002" || targetVal == "NTTG003") {

				if ($("#ddlCourseNo").val() == "") {
					bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택해주세요.");
					return false;
				}
			}

			if ($("#txtTitle").val() == "") {
				bootAlert("제목을 입력해주세요.");
				return false;
			}
			else if ($("#txtContents").val() == "") {
				bootAlert("내용을 입력해주세요.");
				return false;
			}

			$("form[id=mainForm]").attr("action", "/Note/Save/" + targetVal + "/" + termNo + "/" + subjectNo).submit();
		}

		<%--그 전 페이지로 이동--%>
		function fnGoBack() {
			location.href = document.referrer;
		}

	</script>
</asp:Content>
