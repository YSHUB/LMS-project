<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" action="/System/PermissionMenuList" method="post">
		<div class="card search-form mb-3">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-6 col-md-4">
						<label for="ddlAuthorityGroupNo" class="sr-only">권한그룹</label>
						<select id="ddlAuthorityGroupNo" name="MenuAuthority.GroupNo" class="form-control">
							<%
								foreach(var item in Model.AuthorityGroupList)
								{
							%>
							<option value="<%:item.GroupNo %>"<%:item.GroupNo == Model.MenuAuthority.GroupNo ? " selected" : "" %>><%:item.AuthorityGroupName %></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="form-group col-auto text-right">
						<button type="submit" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">검색</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="form-row">
			<div class="col-12">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
								<table class="table table-hover" summary="사용자별 메뉴 권한 목록">
									<caption>사용자별 메뉴 권한 목록</caption>
									<thead>
										<tr>
											<th scope="col">메뉴유형</th>
											<th scope="col">메뉴명</th>
										</tr>
									</thead>
									<tbody id="tbody">
										<%
											if(Model.MenuAuthorityList.Count > 0)
											{
												foreach(var item in Model.MenuAuthorityList){ 
										%>
										<tr>
											<td>
												<%:item.MenuType %>
											</td>
											<td class="text-left">
												<%:item.MenuPath %>
											</td>
										</tr>
										<%
												}
											}
											else
											{
										%>
										<tr>
											<td colspan="2">해당 권한으로 등록된 메뉴가 없습니다.</td>
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
								<a href="/System/PermissionMenuWrite/<%:Model.MenuAuthority.GroupNo %>" class="btn btn-info">변경</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>
