<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<div class="row">
			<div class="col-12">
				<h3 class="title04">[<span class="text-point"><%:Model.MenuAuthority.AuthorityGroupName %></span>] 그룹 권한 부여 및 해제</h3>
						<input type="hidden" id="hdnGroupNo" name="MenuAuthority.GroupNo" value="<%:Model.MenuAuthority.GroupNo %>" />
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover" summary="사용자별 메뉴 권한 목록">
								<caption>사용자별 메뉴 권한 목록</caption>
								<thead>
									<tr>
										<th scope="col">
											<label for="chkAll" class="sr-only">전체선택</label>
											<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkMenuCode');" />
										</th>
										<th scope="col">메뉴유형</th>
										<th scope="col">메뉴명</th>
									</tr>
								</thead>
								<tbody id="tbody">
									<%
										foreach(var item in Model.MenuAuthorityList){ 
									%>
									<tr>
										<td>
											<label for="chkMenuCode<%:Model.MenuAuthorityList.IndexOf(item) %>" class="sr-only">선택</label>
											<input type="checkbox" class="checkbox"id="chkMenuCode<%:Model.MenuAuthorityList.IndexOf(item) %>"  name="chkMenuCode" value="<%:item.MenuCode%>_<%:item.IncludeYN %>"<%:item.OwnYN.Equals("Y") ? " checked=\"checked\"" : ""%> />
										</td>
										<td>
											<%:item.MenuType %>
										</td>
										<td class="text-left">
											<%:item.MenuPath %>
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
								<button type="button" class="btn btn-primary" id="btnSave">저장</button>
								<a href="/System/PermissionMenuList/<%:Model.MenuAuthority.GroupNo %>" class="btn btn-secondary">목록</a>
								<input type="hidden" id="hdnMenuCode" name="MenuAuthority.MenuCodeArray"/>
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
		var ajaxHelper;

		$(document).ready(function () {
			$("#btnSave").click(function () {
				$("#hdnMenuCode").val(fnLinkChkValue("chkMenuCode"));

				ajaxHelper = new AjaxHelper();
				var form = $("#mainForm").serialize();
				ajaxHelper.CallAjaxPost("/System/PermissionMenuSave", form, "fnCompleteAction()", "'S'");
				fnPrevent();
			});
		});
		

		function fnCompleteAction() {
			var data = ajaxHelper.CallAjaxResult();

			if (data > 0) {
				bootAlert("저장되었습니다.");
				location.href = "/System/PermissionMenuList/<%:Model.MenuAuthority.GroupNo %>";
			} else {
				bootAlert("저장에 실패하였습니다. 다시 시도해 주세요.");
			}
		}

	</script>
</asp:Content>
