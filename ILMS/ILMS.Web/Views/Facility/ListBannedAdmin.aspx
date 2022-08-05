<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">예약제한 관리</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="modalForm" method="post" enctype="multipart/form-data">
		<!-- 기본 정보 -->
		<div id="content">
			<%="" %>
			<div class="tab-pane fade show p-4" id="contInfo" role="tabpanel" aria-labelledby="contInfo-tab">
				<h4 class="title04">예약제한 관리</h4>
				<div class="row">
					<div class="col-12 mt-2">
						<%
							if (!(Model.FacilityBanList.Count > 0))
							{
						%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 예약 제한 현황이 없습니다.</div>
						<%
							}
							else
							{
						%>
						<div class="card">
							<div class="card-header">
								<div class="row justify-content-between">
									<div class="col-auto">
										총 <span class="text-primary font-weight-bold"><%:Model.FacilityBanList.Count > 0 ? Model.FacilityBanList[0].TotalCount : 0 %></span>건 
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
												<th scope="col">소속</th>
												<th scope="col">제한일자</th>
												<th scope="col">제한사유</th>
												<th scope="col">관리</th>
											</tr>
										</thead>
										<tbody>
											<%
												foreach (var item in Model.FacilityBanList)
												{
											%>
											<tr>
												<td class="text-left">
													<%:item.BannedUserName %>
												</td>
												<td class="text-left">
													<%:item.BannedAsignName %>
												</td>
												<td class="text-center">
													<%:item.BannedDate %>
												</td>
												<td class="text-center">
													<%:item.BannedReason %>
												</td>
												<td class="text-nowrap">
													<a class="btn btn-sm btn-danger" href="#" onclick="fnCancelBan(<%:item.BanNo %>);" title="제한취소">취소
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
						<input type="button" onclick="fnModal();" data-toggle="modal" data-target="#divModal" class="btn btn-primary" value="등록" />
						<input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade show" id="divModal" tabindex="-1" aria-labelledby="newMname" role="dialog" aria-modal="true">
        	<div class="modal-dialog modal-md">
        	    <div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="ModalTitle">예약제한 사용자 추가</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
                    <div class="modal-body">
                    	<div class="card">
							<div class="card-body">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="collapseCourse" class="form-label">사용자 <strong class="text-danger">*</strong></label>
										<div class="card" id="collapseCourse">
											<div class="card-body bg-light pb-1">
												<div class="form-row align-items-end">
													<div class="form-group col-4 col-md-6" id="selectUser">
														<label for="SearchText" class="sr-only">검색어 입력</label>
														<input class="form-control" title="사용자 검색" id="SearchText" readonly="readonly" type="text" placeholder="사용자를 선택하세요">      
														 <input type="hidden" id="hdnUserNo" name="UserNo" /> 
													</div>
													<div class="form-group col-sm-auto text-right">
														<button type="button" id="btnSearch" onclick="fnOpenUserPopup('single', 'hdnUserNo', 'SearchText', 'modalForm');" class="btn btn-primary">
															<span class="icon search">검색
															</span>
														</button>
														<button type="button" class="d-none" onclick=""></button>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group col-md-12">
										<label for="txtDate" class="form-label">제한일자 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<input class="form-control datepicker text-center" id="txtDate" type="text">
											<div class="input-group-append">
												<span class="input-group-text">
													<i class="bi bi-calendar4-event"></i>
												</span>
											</div>
										</div>
									</div>
									<div class="form-group col-md-12">
										<label for="txtReason" class="form-label">제한사유 <strong class="text-danger">*</strong></label>
										<input type="text" id="txtReason" class="form-control" value="">
									</div>
								</div>
							</div>
							<div class="card-footer">
								<div class="row align-items-center">
									<div class="col-md">
										<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
									</div>
									<div class="col-md-auto text-right">
										<button type="button" class="btn btn-primary" id="btnSave" title="저장">저장</button>
                                        <button type="button" class="btn btn-secondary" id="btnCancel"  data-dismiss="modal" title="닫기">닫기</button>
									</div>
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

		$(document).ready(function () {
			fnCalendar("txtDate", "TODAY");

			$("#btnSave").click(function () {
				fnSaveBan();
			});
		});

		function fnCancelBan(BanNo) {
			bootConfirm("취소하시겠습니까?", function () {
				_ajax.CallAjaxPost("/Facility/CancelBan", { param1: BanNo }, "cbCancelResult");
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

		function fnSaveBan() {
			var userNo = $("#hdnUserNo").val();
			var txtDate = $("#txtDate").val();
			var txtReason = $("#txtReason").val();

			if (!(userNo > 0)) {
				bootAlert("사용자를 선택해야합니다.");
				return;
			}

			if (txtDate == "") {
				bootAlert("제한일자는 필수 입력값입니다.");
				return;
			}
			if (txtReason == "") {
				bootAlert("제한사유는 필수 입력값입니다.");
				return;
			}
			bootConfirm("추가하시겠습니까?", function () {
				_ajax2.CallAjaxPost("/Facility/AddBan", { param1: userNo, param2: txtDate, param3: txtReason }, "cbAddResult");
			});
			
		}

		function cbAddResult() {
			var result = _ajax2.CallAjaxResult();
			if (result != null) {
				bootAlert("추가되었습니다.", function () {
					window.location.reload();
				});
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

	</script>

</asp:Content>
