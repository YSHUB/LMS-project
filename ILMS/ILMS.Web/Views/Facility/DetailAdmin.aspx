<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Facility/DetailAdmin/<%:Model.Facility.FacilityNo %>" id="mainForm" method="post">
		<div id="content">
			<div class="card card-style02">
				<div class="card-header">
						<div>
							<span class="badge badge-regular"><%:Model.Facility.FacilityTypeName %></span>
							<span class="badge badge-1"><%:Model.Facility.CategoryName %></span>
							<%
								if (Model.Facility.IsFree == "CHARGED")
								{
							%>
							<span class="badge badge-2">유료</span>
							<%
								}
							%>
						</div>
					<span class="card-title01 text-dark"><%:Model.Facility.FacilityName %></span>
				</div>
				<div class="card-body">
					<%:Html.Raw(Server.UrlDecode(Model.Facility.FacilityText ?? "").Replace(System.Environment.NewLine, "<br />")) %>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
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
								<div class="form-group col-sm-auto">
									<button type="button" id="btnSearch" class="btn btn-secondary">
										<span class="icon search">검색</span>
									</button>
								</div>
								<div class="form-group col-sm-auto text-right">
									<input type="button" class="btn btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
								</div>
							</div>
						</div>
					</div>
					<%
						if (!(Model.FacilityReservationList.Count > 0))
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>예약 신청 내역이 없습니다.</div>
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
											<th scope="col">신청인</th>
											<%
												if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
												{
											%>
											<th scope="col">소속</th>
											<%
												}
											%>
											<th scope="col">예약날짜</th>
											<th scope="col">예약시간</th>
											<th scope="col">신청일자</th>
											<%
												if (Model.Facility.FacilityType == "FACILITY")
												{
											%>
											<th scope="col">신청인원</th>
											<%
												}
											%>
											<th scope="col">예약현황</th>
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
											<td class="text-center">
												<%:item.ReservedDate %>
											</td>
											<td class="text-center">
												<%:item.ReservedHourList %>
											</td>
											<td class="text-center">
												<%:item.CreateDateTime %>
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
													if (item.ReservationState == "RVCD001" || item.ReservationState == "RVCD002")
													{
												%>
												<a class="btn btn-sm btn-danger" href="#" onclick="fnCancelReservation(<%:item.FacilityNo %>, '<%:item.ReservedDate %>', <%:item.ReservationNo %>);" title="예약취소">취소
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
				<div class="col-12 text-right">
					<a class="btn btn-secondary" href="/Facility/<%:Model.Facility.FacilityType.Equals("FACILITY") ? "ListFacilityAdmin" : Model.Facility.FacilityType.Equals("EQUIPMENT") ? "ListEquipmentAdmin" : "ListFacilityAdmin" %>?Category=<%:ViewBag.Category %>&SearchText=<%:ViewBag.SearchText%>&PageRowSize=<%:ViewBag.PageRowSize%>&PageNum=<%:ViewBag.PageNum%>">목록</a>
				</div>
			</div>
		</div>
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();

		$(document).ready(function () {

			fnFromToCalendar("txtReserveStartDay", "txtReserveEndDay", $("#txtReserveStartDay").val());

			$("#txtReserveStartDay").val("<%: Model.SearchStartDay %>");
			$("#txtReserveEndDay").val("<%: Model.SearchEndDay %>");

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});
		});

		function fnCancelReservation(time, date, rsvNo) {
			bootConfirm("<%:Model.Facility.FacilityName%>의 " + date + "일 " + time + "시의 예약을 취소하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/CancelReservation", { facilityNo: <%:Model.Facility.FacilityNo%>, ReservationNo: rsvNo }, "cbCancelResult");
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

		function fnExcel() {
			if (<%:Model.FacilityReservationList.Count%> > 0) {
				var param1 = <%:Model.Facility.FacilityNo%>;
				var param2 = $("#txtReserveStartDay").val();
				var param3 = $("#txtReserveEndDay").val();
				var param4 = $("#txtSearch").val();

				window.location = "/Facility/DetailAdminExcel/" + param1.toString() + "/" + param2.toString() + "/" + param3.toString() + "/" + param4.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

	</script>
</asp:Content>
