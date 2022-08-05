<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Ocw/ListAcceptAdmin/0" id="mainForm" method="post">


		<div class="card search-form mb-3">
			<div class="card-body pb-1">
				<div class="form-row">
					<div class="form-group col-12 col-md-3">
						<label for="OcwCCStatus" class="sr-only">승인상태</label>
						<select id="IsAuth" name="IsAuth" class="form-control">
							<option value="-1">전체</option>
							<%
								foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "CCST"))
								{
							%>
							<option id="<%: baseCode.CodeValue %>" value="<%: baseCode.Remark %>"
								<%: Convert.ToInt32(baseCode.Remark) == Convert.ToInt32(Model.IsAuth) ? "selected" : "" %>>
								<%: baseCode.CodeName%></option>
							<%
								}
							%>
						</select>
					</div>

					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSubmit();">
							<span class="icon search">검색</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="card">
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table table-hover" cellspacing="0" summary="">
						<thead>
							<tr>
								<th scope="row">
									<label for="chkAll"></label>
									<input type="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');" />
								</th>
								<th scope="col">제목</th>
								<th scope="col">신청자</th>
								<th scope="col">신청일</th>
								<th scope="col">승인일</th>
								<th scope="col">강의연계</th>
								<th scope="col">미리보기</th>
								<th scope="col">관리</th>
								<th scope="col">승인상태</th>
							</tr>
						</thead>
						<tbody>

							<%
								foreach (var ocw in Model.OcwList)
								{
									/*
									bool isAdmin = false;
									if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
									{
										isAdmin = new string[] { "USRT010", "USRT011", "USRT012" }.Any(ocw.UserType.Contains);
									}
									else
									{
										isAdmin = new string[] { "USRT010", "USRT011" }.Any(ocw.UserType.Contains);
									}
									
									bool isLecutre = new string[] { "USRT007", "USRT009", "USRT010", "USRT011", "USRT012" }.Any(ocw.UserType.Contains);
									*/

									bool ischeckBox = (ocw.UserType != "USRT007" && ocw.CourseCount < 1) ? true : false;

							%>
							<tr>
								<td class="text-center">
									<label for="chkSel<%:Model.OcwList.IndexOf(ocw) %>" class="sr-only">체크박스</label>
									<input type="checkbox" name="checkbox" id="chkSel<%:Model.OcwList.IndexOf(ocw) %>"
										value="<%:ocw.OcwNo %>" class="checkbox" <%: ischeckBox ? "" : "disabled" %> />
									<input type="hidden" id="hdnOcwNo" name="Ocw.OcwNo" value="<%:ocw.OcwNo %>" />
								</td>
								<td class="text-left"><%:ocw.OcwName %></td>
								<td class="text-center"><%:ocw.CreateUserName %></td>
								<td class="text-center text-nowrap"><%: ocw.CreateDateTime %></td>
								<td class="text-center text-nowrap"><%:ocw.AuthDateTime %></td>
								<td class="text-center"><%:ocw.CourseCount%></td>
								<td class="text-center"><a href="javascript:void(0);" onclick="fnOcwView(<%: ocw.OcwNo%>
                                                            , <%: ocw.OcwType %>
                                                            , <%: ocw.OcwSourceType %>
                                                            , '<%: ocw.OcwType == 1 || (ocw.OcwType == 0 && ocw.OcwSourceType == 0) ? (ocw.OcwData ?? "") : "" %>'
                                                            , <%: ocw.OcwFileNo %>
                                                            , <%: ocw.OcwWidth %>
                                                            , <%: ocw.OcwHeight %>
                                                            , 'frmpop');"
									title="강의 바로보기" class="font-size-20 text-point <%:ocw.OcwType == 2 ? "d-none" : ""%>">
									<i class="bi bi-eye-fill"></i>
								</a></td>
								<td class="text-nowrap text-center">
									<button type="button" class="btn btn-sm btn-primary" onclick="fnOpenOcwPopup(<%:ocw.OcwNo %>);">상세보기</button>
									<button type="button" class="btn btn-sm btn-outline-dark" onclick="fnOpenWriteAdmin(<%:ocw.OcwNo %>)">관리</button>

								</td>
								<td class="text-center"><span class='<%:ocw.OcwAuthName != "승인" ? "text-danger" : "" %>'><%:ocw.OcwAuthName %></span></td>
							</tr>
							<%
								}
							%>

							<tr>
								<td colspan="9" class="text-center <%: Model.OcwList.Count == 0 ? "" : "d-none" %>">조회된 콘텐츠가 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="card-footer">

				<div class="text-right">
					<button type="button" class="btn btn-primary" onclick="fnOcwAuth(2);">선택 승인</button>
					<button type="button" class="btn btn-danger" onclick="fnOcwAuth(1);">선택 거절</button>
				</div>

			</div>
		</div>




	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		function fnOcwAuth(auth) {
			if (fnIsChecked("chkSel") == ! true) {
				bootAlert("선택된 항목이 없습니다.");
				return;
			} else {
				$("#hdnOcwNo").val(fnLinkChkValue("chkSel"));
				var param = $("#hdnOcwNo").val();

				if (auth == 2) {
					bootConfirm('선택내역을 승인 처리하시겠습니까?', fnSaveOcwAuth, param);

				} else if (auth == 1) {
					bootConfirm('선택내역을 거절 처리하시겠습니까?', fnDelOcwAuth, param);
				}
			}
		}

		//선택 승인
		function fnSaveOcwAuth(param) {
			console.log(param);
			ajaxHelper.CallAjaxPost("/Ocw/SaveOcwAuth", { ChkVal: param, Auth: 2 }, "fnCbSaveOcwAuth");
		}

		function fnCbSaveOcwAuth() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("승인처리 되었습니다.", function () {
					location.reload(true);
				});
			} else {
				bootAlert("이미 승인처리 된 콘텐츠입니다.");
				return false;
			}
		}

		//선택 거절
		function fnDelOcwAuth(param) {
			ajaxHelper.CallAjaxPost("/Ocw/SaveOcwAuth", { ChkVal: param, Auth: 1 }, "fnCbDelOcwAuth");
		}

		function fnCbDelOcwAuth() {
			var OcwNoLen = $("#hdnOcwNo").val().split("|").length;

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				if (result < OcwNoLen) {
					bootAlert("강의컨텐츠/강의연계에 등록된 콘텐츠를 제외한 " + result + "개의 콘텐츠가 거절처리 되었습니다.", function () {
						location.reload(true);
					});
				} else {
					bootAlert(result + "개의 콘텐츠가 거절처리 되었습니다.", function () {
						location.reload(true);
					});
				}
			} else {
				bootAlert("강의컨텐츠에 등록된 콘텐츠는 거절할 수 없습니다.");
			}
		}

		function fnOpenOcwPopup(ocwNo) {
			fnOpenPopup("/Ocw/OcwPopup/" + ocwNo, "ContPop", 800, 750, 0, 0, "auto");
		}

		function fnOpenWriteAdmin(ocwNo) {
			fnOpenPopup("/Ocw/WriteAdmin/" + ocwNo, "ContPop", 850, 800, 0, 0, "auto");
		}

		function fnSetCheckBoxAll(obj, chkId) {

			var chkList = $("input[id*=" + chkId + "]");

			for (var i = 0; i < chkList.length; i++) {
				if (chkList[i].disabled == false) {
					chkList[i].checked = obj.checked;
				}
			}
		}


	</script>
</asp:Content>
