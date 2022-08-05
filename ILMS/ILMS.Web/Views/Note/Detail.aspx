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
			<a class="nav-link" id="writeTab" href="/Note/Write" role="tab">쪽지 쓰기</a>
		</li>
	</ul>
	<div class="tab-content">
		<div class="card card-style01 mt-4">
			<div class="card-header">
				<dl class="row dl-style01">
					<dt class="col-auto text-dark">보낸 사람</dt>
					<dd class="col-auto"><%:Model.Note.SendUserName%></dd>
				</dl>
				<dl class="row dl-style01">
					<dt class="col-auto text-dark">보낸 일시</dt>
					<dd class="col-auto"><%:Model.Note.SendDateTime%></dd>
				</dl>
				<dl class="row dl-style01">
					<dt class="col-auto text-dark">받는 사람</dt>
					<dd class="col-auto"><%:Model.Note.ReceiveUserName%></dd>
				</dl>
				<dl class="row dl-style01">
					<dt class="col-auto text-dark">확인 일시</dt>
					<dd class="col-auto"><%:Model.Note.ReceiveDateTime%></dd>
				</dl>
				<span class="card-title01 text-dark mb-0 d-block text-truncate"><%:Model.Note.NoteTitle%></span>
			</div>
			<div class="card-body">
				<div style="min-height:200px;">
					<%:Html.Raw(Model.Note.NoteContents.Replace(System.Environment.NewLine, "<br />")) %>					 
				</div>
			<%
				if (Model.FileList != null) {
			%>
				<div class="card-footer">
				<%
					foreach (var item in Model.FileList) {
				%>
					<div class="font-size-15">
						<a href="/Common/FileDownLoad/<%:item.FileNo %>" title="다운로드">
							<i class="bi bi-paperclip"></i>
							<span><%:item.OriginFileName %></span>
						</a>
					</div>
				<%
					}
				%>
				</div>
			<%
				}
			%>
			</div>
		</div>
	</div>
	<form id="mainForm" method="post">
		<div class="row">
			<div class="col-6">
			</div>
			<div class="col-6 text-right">
				<button type="button" class="btn btn-primary" id="btnReply" onclick="reply()">답장</button>
				<button type="button" class="btn btn-danger" id="btnDel">삭제</button>
				<input type="hidden" id="hdnNoteNo" name="Note.DelNoteNo" value="" />
				<button type="button" class="btn btn-secondary" onclick="btnList()">목록</button>
			</div>
			<input type="hidden" id="hdnReceiveUser" name="ReceiveUserName" value="" />
			<input type="hidden" id="hdnUserNo" name="ReceiveUserID" value="" />
			<input type="hidden" id="hdnTitle" name="NoteTitle" value="" />
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			if ("<%:Model.NoteGubun%>" == "R") {
				document.getElementById("receiveTab").setAttribute("class", "nav-link active");
				document.getElementById("sendTab").setAttribute("class", "nav-link");
			}
			else if ("<%:Model.NoteGubun%>" == "S") {
				document.getElementById("receiveTab").setAttribute("class", "nav-link");
				document.getElementById("sendTab").setAttribute("class", "nav-link active");
				document.getElementById("btnReply").style.display = "none";
			}

		});
		
		function btnList() {
			var URL = "";
			var pageNum = <%:Model.PageNum%>;
			var pagerowsize = <%:Model.PageRowSize%>;

			if ("<%:Model.NoteGubun%>" == "R") {
				URL = "ReceiveList";
			}
			else if("<%:Model.NoteGubun%>" == "S"){
				URL = "SendList";
			}
			location.href = "/Note/" + URL + "?PageNum=" + pageNum + "&pagerowsize=" + pagerowsize;
		}
		
		function reply() {

			var mainForm = document.getElementById("mainForm");
			mainForm.action = "/Note/Write/<%:Model.NoteGubun%>/" + <%:Model.Note.NoteNo%>;
			mainForm.submit();
			
		}
	
		$("#btnDel").click(function () {
			
			$("#hdnNoteNo").val(<%:Model.Note.NoteNo%>);
			var param = $("#hdnNoteNo").val();

			bootConfirm("삭제하시겠습니까?", fnDelete, param);
			
		});

		function fnDelete(param)
		{
			ajaxHelper.CallAjaxPost("/Note/Delete", { chkVal : param, Rowstate : "<%:Model.NoteGubun%>" }, "fnCbDelete");
		}

		function fnCbDelete()
		{
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {
					var gubun = "<%:Model.NoteGubun%>";

					if (gubun == "R") {
						location.href = "/Note/ReceiveList";
					}
					else {
						location.href = "/Note/SendList";
					}
				});
			}
		}


	</script>
</asp:Content>