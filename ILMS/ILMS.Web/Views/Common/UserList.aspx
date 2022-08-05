<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm">
		<div class="card search-form m-3">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-3">
						<label for="ddlSearchGbn" class="sr-only">검색구분</label>
						<select id="ddlSearchGbn" name="SearchGbn" class="form-control">
							<option value="">검색구분</option>
							<option value="I" selected="selected"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></option>
							<option value="N">성명</option>
						</select>
					</div>
					<div class="form-group col-3">
						<label for="txtSearchText" class="sr-only">검색어</label>
						<input title="검색어" id="txtSearchText" name="SearchText" class="form-control" type="text" placeholder="검색어" />
					</div>
					<div class="form-group col-auto text-right">
						<button type="submit" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">검색</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="form-row m-3">
			<div class="col-12 p-0">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
								<table class="table table-hover" summary="사용자 검색 목록">
									<caption>사용자 검색 목록</caption>
									<thead>
										<tr>
											<th scope="col">
												<label for="chkAll" class="sr-only">전체선택</label>
												<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkID');" />
											</th>
											<%
												if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
												{
											%>
											<th scope="col">소속</th>
											<%
												}
											%>
											<th scope="col">ID</th>
											<th scope="col">성명</th>
										</tr>
									</thead>
									<tbody id="tbody">
										<tr>
											<td colspan="4" class="text-center">
												검색된 사용자가 없습니다.
											</td>
										</tr>
									</tbody>
								</table>
							</div>
					</div>
					<div class="card-footer">
						<div class="row align-items-center">
							<div class="col-md"></div>
							<div class="col-md-auto text-right">
								<button type="button" id="btnComplete" class="btn btn-primary">선택완료</button>
								<button type="button" id="btnCancel" class="btn btn-outline-secondary">닫기</button>
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
		var paramValue = "<%=Request.QueryString["param"]%>";
		var displayValue = "<%=Request.QueryString["display"]%>";
		var fId = "<%=Request.QueryString["f"]%>";

		$(document).ready(function () {
			$("#btnSearch").click(function () {
				if ($("#ddlSearchGbn").val() == "") {
					bootAlert("검색구분을 선택하세요.");
					$("#ddlSearchGbn").focus();
					return false;
				}
				else if ($("#txtSearchText").val().length < 2) {
					bootAlert("검색어를 2자 이상입력하세요.");
					$("#txtSearchText").focus();
					return false;
				}
				else {
					var form = $("#mainForm").serialize();
					ajaxHelper = new AjaxHelper();
					ajaxHelper.CallAjaxPost("/Common/UserList", form, "fnSetUserList");
				}
				fnPrevent();
			});

			$("#btnCancel").click(function () {
				window.close();
			});

			$("#btnComplete").click(function () {
				if (fnIsChecked("chkID")) {
					var openerVal = opener.document.getElementById(displayValue).value;

					if (openerVal != "") {
						bootConfirm("기존에 입력된 내용은 유지되지 않습니다.\n계속하시겠습니까?", fnSetOpener);
					} else {
						fnSetOpener();
					}
				} else {
					bootAlert("선택된 사용자가 없습니다.");
				}
			});
		});

		function fnSetOpener() {
			var returnStr = "";
			var chkList = $("input[id*=chkID]");

			for (var i = 0; i < chkList.length; i++) {
				if (chkList[i].checked) {
					var parentNode = chkList[i].parentElement.parentElement;
					var lastText = parentNode.children[parentNode.children.length - 1].getInnerHTML().replace(/\t/gi, '');
					returnStr += ", " + lastText + "(" + chkList[i].value + ")";
				}
			}

			opener.document.getElementById(paramValue).value = fnLinkChkValue("chkID", ",");
			opener.document.getElementById(displayValue).value = returnStr.substr(2);

			if (fId != undefined && fId != null && fId.length > 0) {
				opener.document.getElementById(fId).submit();
			}

			window.close();
		}

		function fnSetUserList() {
			var data = ajaxHelper.CallAjaxResult();
			var tbodyHtml = "";

			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					tbodyHtml += "<tr>";
					tbodyHtml += "	<td>";
					tbodyHtml += "		<label for=\"chkID" + i + "\" class=\"sr-only\">선택</label>";
					tbodyHtml += "		<input type=\"checkbox\" class=\"checkbox\" id=\"chkID" + i + "\" name=\"chkID\" value=\"" + data[i].UserNo + "\" />";
					tbodyHtml += "	</td>";
					<%
						if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
					%>
					tbodyHtml += "	<td class=\"text-left\">";
					tbodyHtml += "		" + data[i].AssignName;
					tbodyHtml += "	</td>";
					<%
						}
					%>
					tbodyHtml += "	<td>";
					tbodyHtml += "		" + data[i].UserID;
					tbodyHtml += "	</td>";
					tbodyHtml += "	<td>";
					tbodyHtml += "		" + data[i].HangulName;
					tbodyHtml += "	</td>";
					tbodyHtml += "</tr>";
				}
			} else {
				tbodyHtml += "<tr>";
				tbodyHtml += "	<td colspan=\"4\" class=\"text-center\">검색된 사용자가 없습니다.</td>";
				tbodyHtml += "</tr>";
			}

			$("#tbody").html(tbodyHtml);
		}
	</script>
</asp:Content>