<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server"><%if(!Model.isAdmin){ %>나의 예약현황 <%}else{ %>예약현황(관리자)<%} %></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post" enctype="multipart/form-data">
		<!-- 기본 정보 -->
		<div id="content">
			<%="" %>
			<div class="tab-pane fade show p-4" id="contInfo" role="tabpanel" aria-labelledby="contInfo-tab">
				<h4 class="title04"><%if(!Model.isAdmin){ %>나의 예약현황 <%}else{ %>예약현황(관리자)<%} %></h4>
				<div class="row">
					<div class="col-12 mt-2">
						<%
							if (!(Model.FacilityReservationList.Count > 0))
							{
						%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>신청된 예약 내역이 없습니다.</div>
						<%
							}
							else
							{
								if (Model.isAdmin)
								{
						%>
						<div class="card mt-4">
							<div class="card-body pb-1">
								<div class="form-row align-items-end">
									<div class="form-group col-6 col-md-3">
										<label for="txtReserveStartDay" class="form-label">검색시작일자 </label>
										<div class="input-group">
											<input class="form-control datepicker" name="SearchStartDay" id="txtReserveStartDay" title="ReserveStartDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text">
											<div class="input-group-append">
												<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
											</div>
										</div>
									</div>
									<div class="form-group col-6 col-md-3">
										<label for="txtReserveEndDay" class="form-label">검색종료일자 </label>
										<div class="input-group">
											<input class="form-control datepicker" name="SearchEndDay" id="txtReserveEndDay" title="ReserveEndDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text">
											<div class="input-group-append">
												<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
											</div>
										</div>
									</div>
									<div class="form-group col-12 col-md-3">
										<label for="txtSearch" class="form-label">성명으로 검색</label>
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
						<%
								}
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
									<table class="table table-hover table-horizontal" summary="시설 및 장비 예약 현황">
										<thead>
											<tr>
												<%
													if (Model.isAdmin)
													{
												%>
												<th scope="col">신청인</th>
												<%
													if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
													{
												%>
												<th scope="col">소속</th>
												<%
													} 
												%>
												<%
													}
												%>
												<th scope="col">예약일자</th>
												<th scope="col">예약시간</th>
												<%
													if (Model.Facility.FacilityType == "FACILITY")
													{
												%>
												<th scope="col">신청인원</th>
												<%
													}
												%>
												<th scope="col">예약상태</th>
												<th scope="col">관리</th>
											</tr>
										</thead>
										<tbody>
											<%
												foreach (var item in Model.FacilityReservationList)
												{
											%>
											<tr>
												<%
													if (Model.isAdmin)
													{
												%>
												<td class="text-left">
													<%:item.ReservedUserName %>(<%:item.ReservedUserID %>)
												</td>
												<%
													if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
													{
												%>
												<td class="text-left">
													<%:item.ReservedAssignName %>
												</td>
												<%
													}
												%>
												<%
													}
												%>
												<td class="text-center text-nowrap">
													<%:item.ReservedDate %>
												</td>
												<td class="text-center text-nowrap">
													<%:item.ReservedHourList %>
												</td>
												<%
													if (Model.Facility.FacilityType == "FACILITY")
													{
												%>
												<td class="text-center">
													<%:item.ReservedUserCount %>명
												</td>
												<%
													}
												%>
												<td class="text-center">
													<%:item.ReservationStateName %>
												</td>
												<td class="text-nowrap">
													<%
														if ((DateTime.Parse(item.ReservedDate) > DateTime.Now || Model.isAdmin) && (item.ReservationState == "RVCD001" || item.ReservationState == "RVCD002"))
														{
													%>
													<a class="btn btn-sm btn-danger" href="#" onclick="fnCancelReservation('<%:item.ReservedHourList %>', '<%:item.ReservedDate %>', <%:item.ReservationNo %>);" title="예약취소">취소
													</a>
													<%
														}
													%>
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
	</form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		<%="" %>
		var _ajax = new AjaxHelper();

		function fnCancelReservation(time, date, rsvNo) {
			debugger;
			<%
				if (!Model.isAdmin)
				{
			%>
			if ('<%:DateTime.Now.ToString("yyyy-MM-dd")%>' == date) {
				bootAlert("당일에는 예약 및 예약취소를 할 수 없습니다.<br/> 관리자에게 문의해주세요.");
				return;
			}
			<%
				}
			%>

			bootConfirm("<%:Model.Facility.FacilityName%>의 " + date + "일 " + time + "시의 예약을 취소하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/CancelReservation", { facilityNo: <%:Model.Facility.FacilityNo%>, ReservationNo: rsvNo }, "cbCacenlResult");
			});
		}

		function cbCancelResult() {
			var result = _ajax.CallAjaxResult();

			if (result != null) {
				bootAlert("취소되었습니다.", function () {
					window.location.reload();
				});
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

	</script>

</asp:Content>
