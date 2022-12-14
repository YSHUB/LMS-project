<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.NoteViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a href="/Note/ReceiveList" class="nav-link active" id="receiveTab" role="tab">받은 쪽지</a>
			</li>
			<li class="nav-item" role="presentation">
				<a href="/Note/SendList" class="nav-link" id="sendTab" role="tab">보낸 쪽지</a>
			</li>
			<li class="nav-item" role="presentation">
				<a href="/Note/Write" class="nav-link" id="writeTab" role="tab">쪽지 쓰기</a>
			</li>
		</ul>
		<div class="tab-content">
			<div class="tab-pane fade active show" role="tabpanel" aria-labelledby="receiveTab">
				<div class="card">
					<div class="card-body">
						<ul class="list-inline list-inline-style02 mb-0">
							<li class="list-inline-item bar-vertical">
								전체 받은 쪽지<span class="ml-1 badge badge-secondary"><%:Model.Note.NoteCount %></span>
							</li>
							<li class="list-inline-item bar-vertical">
								읽지 않은 쪽지<span class="ml-1 badge badge-secondary"><%:Model.Note.NotReadNoteCount %></span>
							</li>
						</ul>
					</div>
				</div>
			<%
			if (Model.Note.NoteCount == 0)
			{
			%>
				<div class="alert bg-light alert-light rounded text-center">
					<i class="bi bi-info-circle-fill"></i> 받은 쪽지가 없습니다.
				</div>
			<%
			}
			else
			{
			%>
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover" summary="받은 쪽지 리스트">
								<caption>받은 쪽지 리스트</caption>
								<thead>
									<tr>
										<th scope = "row">
											<label for="chkAll" class="sr-only">전체선택</label>
											<input type="checkbox" id="chkAll" name="chkAll"/>
										</th>
										<th scope = "row"> 플래그 </th>
										<th scope = "row" class="d-none d-md-table-cell">보낸사람</th>
										<th scope = "row"> 제목 </th>
										<th scope = "row" class="d-none d-md-table-cell">보낸일시</th>
									</tr>
								</thead>
								<tbody>
							<%
								foreach (var item in Model.NoteList)
								{
							%>		
									<tr>
										<td class="text-center">
											<label for="chkSel<%:Model.NoteList.IndexOf(item)%>" class="sr-only">선택</label>
											<input type="checkbox" name="checkbox" id="chkSel<%:Model.NoteList.IndexOf(item)%>" value="<%:item.NoteNo %>"/>
											<input type="hidden" id="hdnNoteNo" name="Note.DelNoteNo" value=""/>
										</td>
								<%
									if (item.ReceiveDateTime != "-")
									{
								%>
										<td class="text-center text-primary font-size-20">
											<i class="bi bi-envelope-open" title="읽은쪽지"></i>
										</td>
								<%
									}
									else
									{
								%>
										<td class="text-center text-dark font-size-20">
											<i class="bi bi-envelope" title="읽지않은 쪽지"></i>
										</td>
								<%
									}
								%>
										<td class="text-center d-none d-md-table-cell">
											<%:item.SendUserName %>
										</td>
										<td class="text-left">
											<a href="/Note/Detail/<%:item.NoteNo %>/R/<%:Model.PageNum %>/<%:Model.PageRowSize%>"><%:item.NoteTitle %></a>
										</td>
										<td class="text-center d-none d-md-table-cell">
											<%:item.SendDateTime %>
										</td>
									</tr>
								<%
									}
								%>
								</tbody>
							</table>
						</div>
					</div>
					<div class="card-footer">
						<div class="row">
							<div class="col-12">
								<button type="button" class="btn btn-danger" id="btnDel">삭제</button>
							</div>
						</div>
					</div>
				</div>
			<%
			}
			%>
			<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		
		var ajaxHelper = new AjaxHelper();

		<%--전체 체크 / 해제--%>
		$("#chkAll").click(function () {
			fnSetCheckBoxAll(this, "chkSel");
		});
		
		$("#btnDel").click(function () {

			if (fnIsChecked("chkSel") == ! true) {
				bootAlert("선택된 항목이 없습니다.");
			}
			else {

				$("#hdnNoteNo").val(fnLinkChkValue("chkSel", ","));
				var param = $("#hdnNoteNo").val();

				bootConfirm("삭제하시겠습니까?", fnDelete, param);
			}

		});

		function fnDelete(param)
		{
			ajaxHelper.CallAjaxPost("/Note/Delete", { chkVal : param, Rowstate : "R"}, "fnCbDelete");
		}

		function fnCbDelete()
		{
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert('삭제되었습니다', function () {
					location.href = "/Note/ReceiveList";
				});
            }
		}
		
	</script>
</asp:Content>