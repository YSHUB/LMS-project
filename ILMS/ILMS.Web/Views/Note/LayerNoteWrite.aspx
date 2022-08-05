<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.NoteViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">쪽지 발송</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<form id="mainForm" method="post" enctype="multipart/form-data">
		<div class="p-4">
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-12" id="selectUser">
							<label for="txtselectUser" class="form-label">받는사람 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control" id="txtselectUser" title="받는사람" type="text" readonly="" value="">
								<input type="hidden" name="Note.UserID" id="hdnUserNo" value="" />
							</div>
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
			
			var txtselectUser = "<%=Request.Form["txtselectUser"]%>";
			var hdnUserNo = "<%=Request.Form["hdnUserNo"]%>";

			$("#txtselectUser").val(txtselectUser);
			$("#hdnUserNo").val(hdnUserNo);
		});

		function fnSendNote() {

			if ($("#hdnUserNo").val() == "") {
				bootAlert("받는 사람을 추가해주세요.", function () {
					$("#txtselectUser").focus();
				});
				return false;
			}

			if ($("#txtTitle").val() == "") {
				bootAlert("제목을 입력해주세요.", function () {
					$("#txtTitle").focus();
				});
				return false;
			}

			if ($("#txtContents").val() == "") {
				bootAlert("내용을 입력해주세요.", function () {
					$("#txtContents").focus();
				});
				return false;
			}

			var formData = new FormData($("#mainForm")[0]);
			ajaxHelper.CallAjaxPostFile("/Note/LayerNoteWriteSave", formData, "fnCompleteLayerNoteWriteSave");
		}

		function fnCompleteLayerNoteWriteSave() {

			var ajaxResult = ajaxHelper.CallAjaxResult();

			if (ajaxResult > 0) {
				bootAlert("전송되었습니다.", function () {
					opener.parent.location.reload();
					window.close();
				})
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

	</script>
</asp:Content>
