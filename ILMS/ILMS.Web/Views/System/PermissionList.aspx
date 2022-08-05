<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.SystemViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<div class="row">
			<div class="col-12 col-md-12">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover" summary="사용자별 권한 목록">
								<caption>사용자별 권한 목록</caption>
								<thead>
									<tr>
										<th scope="col">권한그룹명</th>
										<th scope="col">사용자구분</th>
										<th scope="col">사용여부</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody id="tbody">
									<%
										if (Model.AuthorityGroupList.Count > 0)
										{
											foreach (var item in Model.AuthorityGroupList)
											{
									%>
									<tr>
										<td class="text-left">
											<%:item.AuthorityGroupName %>
										</td>
										<td class="text-left">
											<%:item.UserTypeArray %>
										</td>
										<td>
											<%:item.UseYesNo %>
										</td>
										<td class="text-nowrap">
											<button type="button" class="text-primary" title="수정" onclick="fnGetAuthorityDetail('<%:item.GroupNo %>');">
												<i class="bi bi-pencil-square"></i>
											</button>
											<button type="button" class="text-danger" title="삭제" onclick="fnDeleteAuthority('<%:item.GroupNo %>');">
												<i class="bi bi-"></i>
											</button>
										</td>
									</tr>
									<%
											}
										}
										else
										{
									%>
									<tr>
										<td colspan="4">등록된 권한이 없습니다.</td>
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="col-12 col-md-12">
				<div class="card">
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-4">
								<label for="txtGroupNo" class="form-label">권한그룹코드</label>
								<input type="text" id="txtGroupNo" name="AuthorityGroup.GroupNo" class="form-control" readonly="readonly">
							</div>
							<div class="form-group col-8">
								<label for="txtAuthorityGroupName" class="form-label">권한그룹명 <strong class="text-danger">*</strong></label>
								<input type="text" id="txtAuthorityGroupName" name="AuthorityGroup.AuthorityGroupName" class="form-control">
							</div>
							<div class="form-group col-12 col-md-8">
								<label for="chkUserType" class="form-label">사용자유형 <strong class="text-danger">*</strong></label>
								<div>
								<input type="hidden" id="hdnUserTypeArray" name="AuthorityGroup.UserTypeArray"/>
								<% 
									foreach (var item in Model.BaseCode)
									{
								%>
									<div class="form-check-inline">
									<input type="checkbox" class="form-check-input mr-1" id="chkUserType<%:Model.BaseCode.IndexOf(item) %>" name="chkUserType" value="<%:item.CodeValue %>"/ >
									<label class="form-check-label mr-1" for="chkUserType<%:Model.BaseCode.IndexOf(item) %>"><%:item.CodeName%></label>
								</div>
								<%
									}
								%></div>
							</div>
							<div class="form-group col-4">
								<label for="chkUseYesNo" class="form-label">사용여부</label>
								<label class="switch">
									<input type="checkbox" id="chkUseYesNo" name="AuthorityGroup.UseYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
							</div>
							<div class="form-group col-12">
								<label for="txtRemark" class="form-label">비고</label>
								<textarea id="txtRemark" name="AuthorityGroup.Remark" class="form-control" rows="2"></textarea>
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="row align-items-center">
							<div class="col">
								<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
							</div>
							<div class="col-auto text-right">
								<input type="hidden" id="hdnRowState" name="AuthorityGroup.RowState" value="C" />
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

		$(document).ready(function () {
			$("#btnSave").click(function () {
				if ($("#txtAuthorityGroupName").val() == "") {
					bootAlert("권한그룹명을 입력하세요.");
					$("#txtAuthorityGroupName").focus();
					return false;
				}
				else if (!fnIsChecked("chkUserType")) {
					bootAlert("사용자 유형을 1개 이상 선택하세요.");
					$("#chkUserType0").focus();
					return false;
				}
				else {
                    $("#hdnUserTypeArray").val(fnGetCheckboxListWithSelection("chkUserType"));

					ajaxHelper = new AjaxHelper();
					var form = $("#mainForm").serialize();

					var a = form.split("&");
					a.forEach((item) => { console.log(item) });

					ajaxHelper.CallAjaxPost("/System/PermissionWrite", form, "fnCompleteAction()", "'S'");
				}
				fnPrevent();
			});
		});

		function fnInit() {
			$("#txtGroupNo").val("");
			$("#txtAuthorityGroupName").val("");
			$("#hdnUserTypeArray").val("");
			$("input[id*=chkUserType]").prop("checked", false);
			$("#chkUseYesNo").prop("checked", true);
			$("#txtRemark").val("");
			$("#hdnRowState").val("C");
		}

		function fnGetAuthorityDetail(groupNo) {
			ajaxHelper = new AjaxHelper();
			ajaxHelper.CallAjaxPost("/System/PermissionGroup", { GroupNo: groupNo }, "fnSetAuthorityDetail", null);
		}

		function fnSetAuthorityDetail() {
			var data = ajaxHelper.CallAjaxResult();

			$("#txtGroupNo").val(data.GroupNo);
			$("#txtAuthorityGroupName").val(data.AuthorityGroupName);
			$("#hdnUserTypeArray").val(data.UserTypeArray);
			$("input[id*=chkUserType]").prop("checked", false);
			if (data.UserTypeArray != null) {
                fnSetSplitValueInChk("chkUserType", data.UserTypeArray, '|');
            }
			$("#chkUseYesNo").prop("checked", data.UseYesNo == "Y");
			$("#txtRemark").val(data.Remark);
			$("#hdnRowState").val("U");
		}

		function fnDeleteAuthority(groupNo) {
			if (confirm('삭제하시겠습니까?')) {
				ajaxHelper = new AjaxHelper();
				ajaxHelper.CallAjaxPost("/System/PermissionDelete", { GroupNo: groupNo }, "fnCompleteAction", "'D'");
			}
		}

		function fnCompleteAction(gbn) {
			var data = ajaxHelper.CallAjaxResult();

			var strGbn = gbn == "D" ? "삭제" : "저장";
			if (data > 0) {
				bootAlert(strGbn + "되었습니다.");
				location.reload();
			} else {
				bootAlert(strGbn + "에 실패하였습니다. 다시 시도해 주세요.");
			}
		}
    </script>
</asp:Content>
