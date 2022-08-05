<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.SystemViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" action="/System/MenuWrite" method="post">
		<div class="card search-form mb-3">
			<div class="card-body pb-1">
				<div class="form-row">
					<div class="form-group col-12 col-md-3">
						<label for="ddlDepth1" class="sr-only">1단계 메뉴</label>
						<select id="ddlDepth1" name="Depth1" onchange="fnChangeDepth(this, 2);" class="form-control">
							<option value="%">1단계 메뉴</option>
						</select>
					</div>
					<div class="form-group col-12 col-md-3">
						<label for="ddlDepth2" class="sr-only">2단계 메뉴</label>
						<select id="ddlDepth2" name="Depth2" onchange="fnChangeDepth(this, 3);" class="form-control">
							<option value="%">2단계 메뉴</option>
						</select>
					</div>
					<div class="form-group col-12 col-md-3">
						<label for="ddlDepth3" class="sr-only">3단계 메뉴</label>
						<select id="ddlDepth3" name="Depth3" onchange="fnChangeDepth(this, 4);" class="form-control">
							<option value="%">3단계 메뉴</option>
						</select>
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSetTable();">
							<span class="icon search">검색</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="form-row">
			<div class="col-12 col-md-8">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover" summary="메뉴 목록">
								<caption>메뉴 목록</caption>
								<thead>
									<tr>
										<%--
										<th scope="col">
											<label for="chkAll" class="sr-only">전체선택</label>
											<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkMenuCode');" />
										</th>
										--%>
										<th scope="col">메뉴명</th>
										<th scope="col">URL</th>
										<th scope="col">출력순서</th>
										<th scope="col">사용여부</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody id="tbody">
									<tr>
										<td colspan="6">
											등록된 메뉴가 없습니다.
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<%--
					<div class="card-footer text-right">
						<button type="button" class="btn btn-sm btn-danger" onclick="fnDelete();" title="삭제">삭제</button>
					</div>
					--%>
				</div>
			</div>

			<div class="col-12 col-md-4">
				<div class="card">
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-6">
								<label for="txtMenuCode" class="form-label">메뉴코드</label>
								<input type="text" id="txtMenuCode" name="Menu.MenuCode" class="form-control text-center" readonly="readonly">
								<input type="hidden" id="hdnUpperMenuCode" name="Menu.UpperMenuCode" />
							</div>
							<div class="form-group col-6">
								<label for="txtMenuName" class="form-label">메뉴명 <strong class="text-danger">*</strong></label>
								<input type="text" id="txtMenuName" name="Menu.MenuName" class="form-control">
							</div>
							<div class="form-group col-12">
								<label for="txtMenuUrl" class="form-label">메뉴Url <strong class="text-danger">*</strong></label>
								<input type="text" id="txtMenuUrl" name="Menu.MenuUrl" class="form-control">
							</div>
							<div class="form-group col-12">
								<label for="ddlMenuType" class="form-label">메뉴유형 <strong class="text-danger">*</strong></label>
								<select class="form-control" id="ddlMenuType" name="Menu.MenuType">
									<% 
										foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MNUT")).ToList()){ 
									%>
									<option value="<%:item.CodeName.Substring(0, 1) %>"><%:item.CodeName%></option>
									<%
										}
									%>
								</select>
							</div>
							<div class="form-group col-8 col-lg-6">
								<label for="ddlLinkTarget" class="form-label">연결방식 <strong class="text-danger">*</strong></label>
								<select class="form-control" id="ddlLinkTarget" name="Menu.LinkTarget">
									<% 
										foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("LNKT")).ToList()){ 
									%>
									<option value="<%:item.CodeName %>"><%:item.CodeName%></option>
									<%
										}
									%>
								</select>
							</div>
							<div class="form-group col-4 col-lg-6">
								<label for="txtSortNo" class="form-label">정렬순서 <strong class="text-danger">*</strong></label>
								<input type="number" id="txtSortNo" name="Menu.SortNo" class="form-control text-right">
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkVisibleYesNo" class="form-label">표시여부</label>
								<label class="switch">
									<input type="checkbox" id="chkVisibleYesNo" name="Menu.VisibleYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkUseYesNo" class="form-label">사용여부</label>
								<label class="switch">
									<input type="checkbox" id="chkUseYesNo" name="Menu.UseYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-4 col-lg-4">
								<label for="chkPopupYesNo" class="form-label">팝업여부</label>
								<label class="switch">
									<input type="checkbox" id="chkPopupYesNo" name="Menu.PopupYesNo" onclick="fnChangePopupDiv(this);">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-6 col-lg-6" id="divPopupWidth">
								<label for="txtPopupWidth" class="form-label">팝업 가로px</label>
								<input type="text" id="txtPopupWidth" name="Menu.PopupWidth" class="form-control">
							</div>
							<div class="form-group col-6 col-lg-6" id="divPopupHeight">
								<label for="txtPopupHeight" class="form-label">팝업 세로px</label>
								<input type="text" id="txtPopupHeight" name="Menu.PopupHeight" class="form-control">
							</div>
							<div class="form-group col-12">
								<label for="txtMenuExplain" class="form-label">메뉴 설명</label>
								<textarea id="txtMenuExplain" name="Menu.MenuExplain" class="form-control" rows="2"></textarea>
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="row align-items-center">
							<div class="col">
								<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
							</div>
							<div class="col-auto text-right">
								<input type="hidden" id="hdnRowState" name="Menu.RowState" />
								<button type="button" id="btnNew" onclick="fnInit();" class="btn btn-info">신규</button>
								<button type="button" id="btnSave" class="btn btn-primary">저장</button>
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
		var result;

		$(document).ready(function () {
			fnChangeDepth($("#ddlDepth1"), 1);
			<%
				if(Request.QueryString["depth1"] != null && Request.QueryString["depth1"] != "%")
				{
			%>
			$("#ddlDepth1").val("<%=string.IsNullOrEmpty(Request.QueryString["depth1"]) ? "%" : Request.QueryString["depth1"] %>");
			fnChangeDepth($("#ddlDepth1"), 2);
			<%
					if(Request.QueryString["depth2"] != null && Request.QueryString["depth2"] != "%")
					{
			%>
			$("#ddlDepth2").val("<%=string.IsNullOrEmpty(Request.QueryString["depth2"]) ? "%" : Request.QueryString["depth2"] %>");
			fnChangeDepth($("#ddlDepth2"), 3);
			<%
						if(Request.QueryString["depth3"] != null && Request.QueryString["depth3"] != "%")
						{
			%>
			$("#ddlDepth3").val("<%=string.IsNullOrEmpty(Request.QueryString["depth3"]) ? "%" : Request.QueryString["depth3"] %>");
			fnChangeDepth($("#ddlDepth3"), 4);
			<%
						}
					}
				}
			%>
			fnSetTable();
			fnInit();

			$("#btnSave").click(function () {
				if ($("#txtMenuName").val() == "") {
					bootAlert("메뉴명를 입력하세요.");
					$("#txtMenuName").focus();
					return false;
				}
				else if ($("#txtMenuUrl").val() == "") {
					bootAlert("메뉴Url을 입력하세요.");
					$("#txtMenuUrl").focus();
					return false;
				}
				else if ($("#txtSortNo").val() == "") {
					bootAlert("정렬순서를 입력하세요.");
					$("#txtSortNo").focus();
					return false;
				}
				else if (parseInt($("#txtSortNo").val()) < 1 || parseInt($("#txtSortNo").val()) > 99) {
					bootAlert("정렬순서는 1~99까지 입력가능합니다.");
					$("#txtSortNo").focus();
					return false;
				}
				else {
					document.forms["mainForm"].submit();
				}
				fnPrevent();
			});
		});
		
		function fnChangeDepth(obj, depth) {
			var originVal = $(obj).val();
			var val = $(obj).val();

			if (val == "%" && $(obj).attr("id") != "ddlDepth1") {
				val = $("#ddlDepth" + (depth - 2)).val();
			}

			if (val != "") {
				ajaxHelper = new AjaxHelper();
				ajaxHelper.CallAjaxPost("/System/MenuList", { upperMenuCode: val }, "fnSetDepth", depth);
			}

			depth = depth == 1 ? 2 : depth;
			if (originVal == "%") {
				depth = depth - 1;
			}
			for (var i = depth + 1; i <= 3; i++) {
				$("#ddlDepth" + i).html("<option value='%'>" + i + "단계 메뉴</option>");
				$("#ddlDepth" + i).parent().hide();
			}
		}

		function fnSetDepth(depth) {
			var data = ajaxHelper.CallAjaxResult();
			var depthHtml = "<option value='%'>" + depth + "단계 메뉴</option>";

			if (data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					depthHtml += "<option value='" + data[i].MenuCode + "'>" + data[i].MenuName + "</option>";
				}

				var menuType = data[0].MenuType;
				if ((menuType == "U" && depth < 3) || (menuType != "U")) {
					$("#ddlDepth" + depth).parent().show();
				}
			}
			$("#ddlDepth" + depth).html(depthHtml);

			result = ajaxHelper.CallAjaxResult();
		}

		function fnSetTable() {
			var tableHtml = "";

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					tableHtml += "<tr>";
					//tableHtml += "	<td>";
					//tableHtml += "		<label for='chkMenuCode" + i.toString() + "' class='sr-only'>선택</label>";
					//tableHtml += "		<input type='checkbox' class='checkbox' id='chkMenuCode" + i.toString() + "' name='chkMenuCode' value='" + result[i].MenuCode + "' />";
					//tableHtml += "	</td>";
					tableHtml += "	<td class='text-left'>";
					tableHtml += "		" + result[i].MenuName;
					tableHtml += "	</td>";
					tableHtml += "	<td class='text-left'>";
					tableHtml += "		" + result[i].MenuUrl;
					tableHtml += "	</td>";
					tableHtml += "	<td>";
					tableHtml += "		" + result[i].SortNo;
					tableHtml += "	</td>";
					tableHtml += "	<td>";
					tableHtml += "		" + result[i].UseYesNo;
					tableHtml += "	</td>";
					tableHtml += "	<td>";
					tableHtml += "		<button type=\"button\" class=\"text-primary\"  title=\"수정\" onclick=\"fnGetMenuDetail(\'" + result[i].MenuCode + "\');\"><i class=\"bi bi-pencil-square\"></i></button>";
					tableHtml += "		<button type=\"button\" class=\"text-danger\" title=\"삭제\" onclick=\"fnDelete(" + result[i].MenuCode +");\"><i class=\"bi bi-trash\"></i></button>";
					tableHtml += "	</td>";
					tableHtml += "</tr>";
				}
			} else {
				tableHtml += "<tr>";
				tableHtml += "	<td colspan=\"5\" class=\"text-center\">";
				tableHtml += "		등록된 메뉴가 없습니다.";
				tableHtml += "	</td>";
				tableHtml += "</tr>";
			}

			$("#tbody").html(tableHtml);
			fnInit();
		}

		function fnChangePopupDiv(obj) {
			if ($(obj).is(":checked")) {
				$("#divPopupWidth").show();
				$("#divPopupHeight").show();
			} else {
				$("#divPopupWidth").hide();
				$("#divPopupHeight").hide();
			}
		}

		function fnInit() {
			$("#hdnUpperMenuCode").val("");
			$("#txtMenuCode").val("");
			$("#txtMenuName").val("");
			$("#txtMenuUrl").val("");
			$("#ddlMenuType option")[0].selected = true;
			$("#ddlLinkTarget option")[0].selected = true;
			$("#txtSortNo").val("");
			$("#chkVisibleYesNo").prop("checked", true);
			$("#chkUseYesNo").prop("checked", true);
			$("#chkPopupYesNo").prop("checked", false);
			$("#txtPopupWidth").val("");
			$("#txtPopupHeight").val("");
			$("#txtMenuExplain").val("");
			$("#hdnRowState").val("C");

			$("#divPopupWidth").hide();
			$("#divPopupHeight").hide();

			var upperMenuCode = "";
			if ($("#ddlDepth3").val() != "%") {
				upperMenuCode = $("#ddlDepth3").val();
			} else if ($("#ddlDepth2").val() != "%") {
				upperMenuCode = $("#ddlDepth2").val();
			} else {
				upperMenuCode = $("#ddlDepth1").val();
			}
			$("#hdnUpperMenuCode").val(upperMenuCode);
		}

		function fnGetMenuDetail(menuCode) {
			ajaxHelper = new AjaxHelper();
			ajaxHelper.CallAjaxPost("/System/Menu", { menuCode: menuCode }, "fnSetMenuDetail", null);
		}

		function fnSetMenuDetail() {
			var data = ajaxHelper.CallAjaxResult();

			$("#hdnUpperMenuCode").val(data.UpperMenuCode);
			$("#txtMenuCode").val(data.MenuCode);
			$("#txtMenuName").val(data.MenuName);
			$("#txtMenuUrl").val(data.MenuUrl);
			$("#ddlMenuType option[value*=" + data.MenuType + "]").prop("selected", true);
			$("#ddlLinkTarget").val(data.LinkTarget);
			$("#txtSortNo").val(data.SortNo);
			$("#chkVisibleYesNo").prop("checked", data.VisibleYesNo == "Y");
			$("#chkUseYesNo").prop("checked", data.UseYesNo == "Y");
			$("#chkPopupYesNo").prop("checked", data.PopupYesNo == "Y");
			$("#txtPopupWidth").val(data.PopupWidth);
			$("#txtPopupHeight").val(data.PopupHeight);
			$("#txtMenuExplain").val(data.MenuExplain);
			$("#hdnRowState").val("U");
		}

		function fnDelete(menuCode) {
			if (confirm("삭제하시겠습니까?")) {
				ajaxHelper = new AjaxHelper();
				ajaxHelper.CallAjaxPost("/System/MenuDelete", { menuCode: menuCode }, "fnDeleteComplete");
				<%--
				var row = $("#tbody tr").length;
				for (var i = 0; i < row; i++) {
					var tr = $("tbody tr")[i];
					var chk = tr.getElementsByClassName("checkbox")[0];

					if (chk.checked) {
						ajaxHelper.CallAjaxPost("/System/MenuDelete", { menuCode: chk.value }, "fnDeleteComplete");
					}
				}
				--%>
			}
		}

		function fnDeleteComplete() {
			var data = ajaxHelper.CallAjaxResult();
			if (data > 0) {
				bootAlert("삭제되었습니다", function () {
					var hrefStr = "/System/MenuList?depth1=" + $("#ddlDepth1").val() + "&depth2=" + $("#ddlDepth2").val() + "&depth3=" + $("#ddlDepth3").val();
					location.href = hrefStr;
				});
			} else {
				bootAlert("삭제에 실패하였습니다.");
			}
		}
	</script>
</asp:Content>