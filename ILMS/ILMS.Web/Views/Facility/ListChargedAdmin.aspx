<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">유료예약 승인 관리</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="modalForm" method="post" enctype="multipart/form-data">
		<!-- 기본 정보 -->
		<div id="content">
			<%="" %>
			<div class="tab-pane fade show p-4" id="contInfo" role="tabpanel" aria-labelledby="contInfo-tab">
				<h4 class="title04">유료예약 승인 관리</h4>
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
							<div class="form-group col-4 col-md-7 col-lg-3">
								<label for="txtSearch" class="sr-only">검색명</label>
								<input type="text" id="txtSearch" class="form-control" name="SearchText" value="<%:!string.IsNullOrEmpty(Model.SearchText) ? Model.SearchText : "" %>" placeholder="검색명">
							</div>
							<div class="form-group col-sm-auto text-right">
								<button type="button" id="btnSearch" class="btn btn-secondary">
									<span class="icon search">검색</span>
								</button>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12 mt-2">
						<%
							if (!(Model.FacilityReservationList.Count > 0))
							{
						%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 유료예약 승인 현황이 없습니다.</div>
						<%
							}
							else
							{
						%>
						<div class="card">
							<div class="card-header">
								<div class="row justify-content-between">
									<div class="col-auto">
										총 <span class="text-primary font-weight-bold"><%:Model.FacilityReservationList.Count > 0 ? Model.FacilityReservationList[0].TotalCount : 0 %></span>건 
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
												<th scope="col">성명</th>
												<th scope="col">시설명</th>
												<th scope="col">카테고리</th>
												<th scope="col">예약일자</th>
												<th scope="col">비용</th>
												<th scope="col">관리</th>
											</tr>
										</thead>
										<tbody>
											<%
												foreach (var item in Model.FacilityReservationList)
												{
											%>
											<tr>
												<td class="text-left">
													<%:item.ReservedUserName %>
												</td>
												<td class="text-left">
													<a href="#" onclick="fnModal('<%:item.ReservedUserName %>', '<%:item.FacilityName %>', '<%:item.ReservedDate %>', '<%:item.ReservationNoList %>');" data-toggle="modal" data-target="#divModal"><%:item.FacilityName %></a>
												</td>
												<td class="text-center">
													<%:item.CategoryName %>
												</td>
												<td class="text-center">
													<%:item.ReservedDate %>
												</td>
												<td class="text-center">
													<%:item.FacilityExpense.ToString("N0") %>원
												</td>
												<td class="text-nowrap">
													<a class="btn btn-sm btn-primary" href="#" onclick="fnApprove('<%:item.ReservationNoList %>');" title="승인관리">승인
													</a>
													<a class="btn btn-sm btn-danger" href="#" onclick="fnCancel('<%:item.ReservationNoList %>');" title="승인관리">취소
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
				</div>
				<div class="row">
					<div class="col-12 text-right">
						<input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade show" id="divModal" tabindex="-1" aria-labelledby="newMname" role="dialog" aria-modal="true">
        	<div class="modal-dialog modal-md">
        	    <div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="ModalTitle">예약현황</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
                    <div class="modal-body">
                    	<div class="card">
							<div class="card-body">
								<div class="table-responsive">
									<table class="table table-hover table-horizontal" summary="예약현황">
										<thead>
											<tr>
												<th scope="col">시설명</th>
												<th scope="col">예약일자</th>
												<th scope="col">예약시간</th>
												<th scope="col">신청인원</th>
											</tr>
										</thead>
										<tbody id="tbResult">
										</tbody>
									</table>
								</div>
							</div>
						</div>
                    </div>
                </div>
            </div>
        </div>
	</form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();
		var _ajax2 = new AjaxHelper();
		var _ajax3 = new AjaxHelper();

		$(document).ready(function () {
			$("#ddlPageRowSize").change(function () {
				document.forms["modalForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["modalForm"].submit();
			});
		});

		function fnModal(name, facility, date, rsvList) {
			$("#ModalTitle").text(name + ' ' + facility + ' ' + date + ' 예약현황');

			_ajax3.CallAjaxPost("/Facility/GetChargedReservedData", { param1: rsvList }, "cbResult");
		}

		function cbResult() {
			var result = _ajax3.CallAjaxResult();

			if (result != null) {
				$("#tbResult").html(result);
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		function fnApprove(rsvList) {
			bootConfirm("해당 신청건을 승인하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/ApproveChargedReservedData", { param1: rsvList }, "cbApproveResult");
			});
		}

		function cbApproveResult() {
			var result = _ajax.CallAjaxResult

			if (result != null) {
				bootAlert("승인되었습니다.", function () {
					document.forms["modalForm"].submit();
				});
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		function fnCancel(rsvList) {
			bootConfirm("해당 신청건을 취소하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/CancelChargedReservedData", { param1: rsvList }, "cbCancelResult");
			});
		}

		function cbCancelResult() {
			var result = _ajax.CallAjaxResult

			if (result != null) {
				bootAlert("취소되었습니다.", function () {
					document.forms["modalForm"].submit();
				});
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}
		
	</script>

</asp:Content>
