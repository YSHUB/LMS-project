<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.MessageViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">메세지 전송</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">

		<div class="tab-pane fade active show" role="tabpanel" aria-labelledby="writeTab">
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<%
							if (ViewBag.IsAdmin) 
							{
						%>
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
						<%
							}
						%>
						<div class="form-group col-8 col-md-9" id="selectUser">
							<label for="txtselectUser" class="form-label">받는 사람 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control" id="txtselectUser" name="txtselectUser" title="받는 사람" type="text" <%--readonly=""--%> value="">
								<input type="hidden" id="hdnUserNo" name="hdnUserNo" value="<%:ViewBag.Users != null ? ViewBag.Users : "" %>" />
								<%
									if (ViewBag.IsAdmin)
									{
								%>
										<span class="input-group-append">
											<button type="button" class="btn btn-primary" onclick="fnOpenUserPopup('multi', 'hdnUserNo', 'txtselectUser');">사용자 검색</button>
										</span>
								<%
									}
								%>
							</div>
						</div>
						<%
							if (ViewBag.IsAdmin) 
							{
						%>
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
									<label for="ddlCourseNo" class="form-label"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 선택 <strong class="text-danger">*</strong></label>
									<select class="form-control" id="ddlCourseNo">
									</select>
								</div>
						<%
							}
						%>
						<div class="form-group col-12">
							<label for="txtTitle" class="form-label">발신 번호 <strong class="text-danger">*</strong></label>
							<input class="form-control" name="Message.SendPhoneNo" id="txtSendPhoneNo" value="<%:Model.SendPhoneNo %>">							
						</div>
						<div class="form-group col-md-12">
							<label for="txtContents" class="form-label">메세지 내용 <strong class="text-danger">*</strong>
								<small class="text-muted text-small">(한글 40자, 영문 80자 이내, 행간: 1Byte)</small>
							</label>
							<textarea id="txtContents" name="Message.SendContents" rows="5" class="form-control" onkeyup="fnChkByte('80');" ></textarea>
							<div class="row align-items-center">
								<div class="col-4 mt-1">
									<small class="font-size-14 mb-0 text-muted"><label id="lblChkByte">0</label> / 80 Byte</small>
								</div>
								<div class="col-8 text-right">
									<small class="text-primary"><strong class="">※ 내용에 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명 또는 <%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명을 입력하여야 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 확인 가능합니다.</strong></small>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
						</div>
						<div class="col-6 text-right">
							<button type="button" class="btn btn-primary" onclick="<%:ViewBag.IsAdmin ? "fnAdminSend();" : "fnSend();" %>">발송</button>
							<button type="button" class="btn btn-secondary" onclick="fnGoBack();">취소</button>
							
						</div>
					</div>
				</div>
			</div>
		</div>

		<input type="hidden" id="hdnCourseNo" name="Message.CourseNo" value="0" />
		<input type="hidden" id="hdnIsAdmin" value="<%:ViewBag.IsAdmin %>"/>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			var txtselectUser = "<%=Request.Form["txtselectUser"]%>";
			var hdnUserNo = "<%=Request.Form["hdnUserNo"]%>";

			$("#txtselectUser").val(txtselectUser);
			$("#hdnUserNo").val(hdnUserNo);
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

		<%-- SMS바이트체크 --%>
		function fnChkByte(byteLimit) {

			var byteLimit = byteLimit;
			var contents = $("#txtContents").val();

			var byteLength = contents.length;

			var contentsLimt = byteLimit;
			var i = 0;
			var contentsByte = 0;
			var contentsLength = 0;
			var contentsOneChar = "";
			var contentsString = "";

			for (var i = 0; i < byteLength; i++)
			{
				contentsOneChar = contents.charAt(i);

				if (escape(contentsOneChar).length > 4) {
					contentsByte += 2;
				} else {
					contentsByte++;
				}

				if (contentsByte <= contentsLimt) {
					contentsLength = i + 1;
					$("#txtByte").text(contentsByte + "/ 80 Byte");
				}
				else {
					bootAlert("메시지란에 허용 길이 이상의 글을 쓰셨습니다.\n 메시지란에는 한글 40자, 영문80자까지만 쓰실 수 있습니다.");
					$("#txtContents").val(contents.substring(0, contentsLength));

					if (escape(contentsOneChar).length > 4) {
						contentsByte -= 2;
					} else {
						contentsByte--;
					}

					i = byteLength.length;
				}
			}

			var cTn = (contents == "") ? "0" : contentsByte;
			$("#lblChkByte").text(cTn);

		}

		<%-- 교수 SMS 발송 --%>
		function fnSend() {

			var userNo = $("#hdnUserNo").val();
			var contents = $("#txtContents").val();
			var sendPhoneNo = $("#txtSendPhoneNo").val();
			var courseNo = $("#hdnCourseNo").val();

			if (sendPhoneNo == "") {
				bootAlert("발신번호를 입력해주세요.", function () {
					$("#txtSendPhoneNo").focus();
				});
				return false;
			}

			if (contents == "") {
				bootAlert("메시지를 입력해주세요.", function () {
					$("#txtContents").focus();
				});
				return false;
			}

			ajaxHelper.CallAjaxPost("/Message/SMSWriteSave", { userNo: userNo, contents: contents, sendPhoneNo: sendPhoneNo, courseNo: courseNo }, "fnCompleteSMSWriteSave", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
						
		}

		function fnCompleteSMSWriteSave() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert("문자메세지가 발송되었습니다.");
			} else {

				bootAlert("문자메시지가 발송되지 않았습니다.");
			}
		}

		<%-- 관리자 SMS 발송 --%>
		function fnAdminSend() {

			var userNo = $("#hdnUserNo").val() == "" ? "0" : $("#hdnUserNo").val();
			var contents = $("#txtContents").val();
			var sendPhoneNo = $("#txtSendPhoneNo").val();

			var targetVal = $("#ddlTagetSel").val();
			var termNo = $("#ddlTermNo").val() == "" ? 0 : $("#ddlTermNo").val();
			var courseNo = $("#ddlCourseNo").val() == "" ? 0 : $("#ddlCourseNo").val();

			if (targetVal == "NTTG001") {
				if ($("#hdnUserNo").val() == "") {
					bootAlert("받는 사람을 추가해주세요.");
					return false;
				}

				if (sendPhoneNo == "") {
					bootAlert("발신번호를 입력해주세요.", function () {
						$("#txtSendPhoneNo").focus();
					});
					return false;
				}
			}
			else if (targetVal == "NTTG002" || targetVal == "NTTG003") {

				if ($("#ddlCourseNo").val() == "") {
					bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택해주세요.");
					return false;
				}
			}

			if (contents == "") {
				bootAlert("메시지를 입력해주세요.", function () {
					$("#txtContents").focus();
				});
				return false;
			}

			$("form[id=mainForm]").attr("action", "/Message/SMSWriteAdminSave/" + targetVal + "/" + userNo + "/" + courseNo + "/" + termNo).submit();
			
		}

	</script>
</asp:Content>
