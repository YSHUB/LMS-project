<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Facility/ListFacilityAdmin" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3 col-lg-2">
							<%="" %>
							<label for="ddlType" class="sr-only">카테고리</label>
							<select id="ddlType" name="Category" class="form-control">
								<option value="">전체</option>
								<%
									foreach (var codes in Model.BaseCode)
									{
								%>
								<option value="<%:codes.CodeValue %>" <%if (codes.CodeValue.Equals(Model.Category)){ %>
									selected="selected" <%} %>><%:codes.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only">검색명</label>
							<input type="text" id="txtSearch" class="form-control" name="SearchText" value="<%:!string.IsNullOrEmpty(Model.SearchText) ? Model.SearchText : "" %>" placeholder="검색명">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto <%:Model.FacilityList.Count > 0 ? "" : "d-none" %>">
							<input type="button" class="btn btn-secondary" value="예약제한 관리" onclick="fnOpenPopup('/Facility/ListBannedAdmin', 'ContPop', 850, 800, 0, 0, 'auto');">
						</div>
						<div class="form-group col-sm-auto <%:Model.FacilityList.Count > 0 ? "" : "d-none" %>">
							<input type="button" class="btn btn-secondary" value="유료예약 승인 관리" onclick="fnOpenPopup('/Facility/ListChargedAdmin/FACILITY', 'ContPop', 850, 800, 0, 0, 'auto');">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (!(Model.FacilityList.Count > 0))
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 시설이 없습니다.</div>
					<%
						}
						else
						{
					%>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold"><%:Model.FacilityList.Count > 0 ? Model.FacilityList[0].TotalCount : 0 %></span>건 
								</div>
								<div class="col-auto text-right">
									<select class="form-control form-control-sm" id="ddlPageRowSize" name="PageRowSize">
										<option value="10" <%= Model.PageRowSize.Equals(10) ? "selected='selected'" : ""%>>10건</option>
										<option value="50" <%= Model.PageRowSize.Equals(50) ? "selected='selected'" : ""%>>50건</option>
										<option value="100" <%= Model.PageRowSize.Equals(100) ? "selected='selected'" : ""%>>100건</option>
										<option value="200" <%= Model.PageRowSize.Equals(200) ? "selected='selected'" : ""%>>200건</option>
									</select>
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover table-horizontal" summary="시설 및 장비 목록">
									<thead>
										<tr>
											<th scope="col">유료여부</th>
											<th scope="col">시설명</th>
											<th scope="col">카테고리</th>
											<th scope="col">최대수용인원</th>
											<th scope="col">예약현황</th>
											<th scope="col">관리</th>
										</tr>
									</thead>
									<tbody>

										<%
											foreach (var item in Model.FacilityList)
											{
										%>
										<tr>
											<td class="text-center">
												<%:item.IsFree == "CHARGED" ? "유료" : "무료" %>
											</td>
											<td class="text-left">
												<%:item.FacilityName %>
											</td>					
											<td class="text-center">
												<%:item.CategoryName %>
											</td>
											<td class="text-center">
												<%:item.MaxUserCount %>
											</td>
											<td class="text-nowrap">
												<a class="font-size-20 text-primary" href="/Facility/DetailAdmin/<%:item.FacilityNo %>?Category=<%:Model.Category %>&SearchText=<%:Model.SearchText %>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" title="예약현황">
													<i class="bi bi-card-list"></i>
												</a>
											</td>
											<td class="text-nowrap">
												<a class="font-size-20 text-primary" href="#" onclick="fnOpenWriteAdmin(<%:item.FacilityNo %>);" title="상세보기">
													<i class="bi bi-pencil-square"></i>
												</a>
												<a class="font-size-20 text-danger" href="#" onclick="fnDelete(<%:item.FacilityNo %>, <%:item.FileGroupNo %>);" title="상세보기">
													<i class="bi bi-trash"></i>
												</a>
											</td>
										</tr>
										<% 
											}
										%>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<%
						}
					%>
					<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
				</div>
				<div class="col-12 text-right">
					<button type="button" id="btn등록" class="btn btn-primary" onclick="fnOpenWriteAdmin(0);" >등록</button>
				</div>
			</div>
		</div>
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();

		$(document).ready(function () {
			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});
		});

		function fnOpenWriteAdmin(FacilityNo) {
            fnOpenPopup("/Facility/WriteAdmin/FACILITY/" + FacilityNo, "ContPop", 850, 800, 0, 0, "auto");
		}

		function fnDelete(FacilityNo, FileGroupNo) {
			bootConfirm("삭제하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/DeleteFacility", { param1: FacilityNo, param2: FileGroupNo }, "cbDelete");
			});
			
		}

		function cbDelete() {
			var result = _ajax.CallAjaxResult();

			if (result != null) {
				bootAlert("삭제되었습니다.");
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
			document.forms["mainForm"].submit();
		}

	</script>
</asp:Content>
