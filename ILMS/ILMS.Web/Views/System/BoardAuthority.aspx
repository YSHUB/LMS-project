<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">
	[<span id="spanTitle"><%:Model.BoardTitle %></span>] 권한 관리
</asp:Content>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm">
		<div class="form-row m-3">
			<div class="col-12 p-0">
				<div class="card">
					<div class="card-body p-0">
						<div class="table-responsive">
								<table class="table table-hover text-center" summary="게시판 사용자 권한">
									<caption>게시판 사용자 권한</caption>
									<thead>
										<tr>
											<th scope="col">사용자 그룹</th>
											<th scope="col">읽기</th>
											<th scope="col">쓰기</th>
										</tr>
									</thead>
									<tbody id="tbody">
										<%
											if (Model.BoardAuthorityList != null)
											{
												int index = 1;
												foreach(var item in Model.BoardAuthorityList)
												{
										%>
										<tr>
											<td>
												<%:item.AuthorityGroupName%>
												<input type="hidden" id="hdnMasterNo<%:index %>" value="<%:item.BoardMasterNo %>" />
												<input type="hidden" id="hdnGroupNo<%:index %>" value="<%:item.AuthorityGroupNo %>" />
											</td>
											<td>
												<label class="switch d-inline-block m-0">
													<input type="checkbox" id="chkIsRead<%:index %>" name="IsRead" <%:item.IsRead.Equals("Y") ? "checked" : "" %> />
													<span class="slider round"></span>
												</label>
											</td>
											<td>
												<label class="switch d-inline-block m-0">
													<input type="checkbox" id="chkIsWrite<%:index %>" name="IsWrite" <%:item.IsWrite.Equals("Y") ? "checked" : "" %> />
													<span class="slider round"></span>
												</label>
											</td>
										</tr>
										<%
													index++;
												}
											}
											else
											{
										%>
										<tr>
											<td colspan="3" class="text-center">
												등록된 사용자 그룹이 없습니다.
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
						<div class="row align-items-center">
							<div class="col-md"></div>
							<div class="col-md-auto text-right">
								<button type="button" id="btnSave" class="btn btn-primary" onclick="fnSave();">저장</button>
								<button type="button" id="btnClose" class="btn btn-outline-secondary">닫기</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script>
		var ajaxHelper = new AjaxHelper();
		var rs = 0;

		$(document).ready(function () {
			if ($("#spanTitle").text() == "") {
				bootAlert("잘못된 접근입니다.");
				window.close();
			}

			$("#btnClose").click(function () {
				window.close();
			});
		});

		function fnSave() {
			bootConfirm("저장하시겠습니까?", function () {
				for (var i = 1; i <= $("#tbody tr").length; i++) {
					ajaxHelper.CallAjaxPost("/System/BoardAuthoritySave", { "no": $("#hdnMasterNo" + i.toString()).val()
																	 , "groupNo": $("#hdnGroupNo" + i.toString()).val()
																	 , "isRead": $("#chkIsRead" + i.toString()).prop("checked") ? "Y" : "N"
																	 , "isWrite": $("#chkIsWrite" + i.toString()).prop("checked") ? "Y" : "N" }, ($("#tbody tr").length == i) ? "fnSaveComplete" : "fnSaveStack");
				}
            });
		}

		function fnSaveStack() {
			rs += ajaxHelper.CallAjaxResult();
		}

		function fnSaveComplete() {
			rs += ajaxHelper.CallAjaxResult();
			var rsStr = "";

			if ($("#tbody tr").length == rs) {
				rsStr = "저장되었습니다.";
			} else if (rs > 0) {
				rsStr = "일부 항목만 저장되었습니다. 다시 확인해 주세요.";
			} else {
				rsStr = "저장에 실패하였습니다. 다시 시도해 주세요.";
			}

			bootAlert(rsStr, function () {
				location.reload();
			});
		}
    </script>
</asp:Content>