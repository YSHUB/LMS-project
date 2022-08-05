<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">차시관리</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	
	<form action="/Course/WriteWeekAdmin" method="post" id="mainForm">
		<div class="p-4">
			<div class="row">
				<div class="col-12">
					<div class="card">
						<div class="card-body">
							<div class="form-row">
								<div class="form-group col-6">
									<label for="ddlWeek" class="form-label">주차 <strong class="text-danger">*</strong></label>
									<select class="form-control" id="ddlWeek" name="CourseInning.Week" onchange="fnWeekChange()" <%:Model.CourseInning != null ? Model.CourseInning.InningNo > 0 ? "disabled='disabeld'" : "" : "" %>>
										<option value="-1">선택</option>
										<%
											foreach (var item in Model.WeekList) 
											{
										%>
												<option value="<%:item.Week %>" <%:Model.CourseInning != null ? (Model.CourseInning.Week.Equals(item.Week)) ? "selected" : "" : ""%>><%:item.WeekName %></option>
										<%
											}
										%>
									</select>
								</div>
								<div class="form-group col-6">
									<label for="txtInningSeqNoName" class="form-label">차시 <strong class="text-danger">*</strong></label>
									<input type="text" id="txtInningSeqNoName" name="CourseInning.InningSeqNo" class="form-control" readonly="readonly" value="<%:Model.CourseInning != null ? Model.CourseInning.InningSeqNo + "차시" : "" %>">
								</div>
								<div class="form-group col-6">
									<label for="ddlLectureType" class="form-label">강의종류 <strong class="text-danger">*</strong></label>
									<select class="form-control" id="ddlLectureType" name="CourseInning.LectureType" onchange="fnSetChangeControl();">
										<option value="">선택</option>
										<%
											foreach(var item in Model.BaseCode.Where(w => w.ClassCode.Equals("CINN")).ToList())
											{
										%>
												<option value="<%:item.CodeValue %>" <%:Model.CourseInning != null ? (Model.CourseInning.LectureType.Equals(item.CodeValue)) ? "selected" : "" : ""%>><%:item.CodeName %></option>
										<%
											}
										%>
									</select>
								</div>
								<div class="form-group col-6">
									<label for="ddlLessonForm" class="form-label">학습방식 <strong class="text-danger">*</strong></label>
									<select class="form-control" id="ddlLessonForm" name="CourseInning.LessonForm" onchange="fnSetChangeControl()">
										<option value="">선택</option>
										<%
											
											foreach(var item in Model.BaseCode.Where(w => w.ClassCode.Equals("CINM") && (w.CodeValue.Equals("CINM001")) || (w.CodeValue.Equals("CINM002")) || (w.CodeValue.Equals("CINM003"))).ToList())
											{
										%>
												<option value="<%:item.CodeValue %>" <%:Model.CourseInning != null ? (Model.CourseInning.LessonForm.Equals(item.CodeValue)) ? "selected" : "" : ""%>><%:item.CodeName %></option>
										<%
											}
										%>
									</select>
								</div>
								<div class="form-group col-6">
									<label for="txtInningStartDay" class="form-label">학습시작일자 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="CourseInning.InningStartDay" id="txtInningStartDay" title="InningStartDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text" value="<%:Model.CourseInning != null ? Model.CourseInning.InningStartDay : "" %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-6">
									<label for="txtInningEndDay" class="form-label">학습종료일자 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="CourseInning.InningEndDay" id="txtInningEndDay" title="InningEndDay" placeholder="YYYY-MM-DD" autocomplete="off" type="text" value="<%:Model.CourseInning != null ? Model.CourseInning.InningEndDay : "" %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-6" id="divLMSContentsNo">
									<label for="lblLMSContentsNo" class="form-label">콘텐츠</label>
									<div class="input-group">
										<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#divSearchOCW" id="btnSearchOCW">콘텐츠 선택</button>
										<label id="lblLMSContentsNo" class="ml-1 text-secondary"></label>
									</div>
								</div>
								<div class="form-group col-6" id="divIsPreview">
									<label for="chkIsPreview" class="form-label">맛보기 차시</label>
									<label class="switch">
										<input type="checkbox" id="chkIsPreview" name="CourseInning.IsPreview" <% if (Model.CourseInning != null && Model.CourseInning.IsPreview.Equals("Y")) { %> checked="checked" <% } %> onchange="fnIsPreview()">
										<span class="slider round"></span>
									</label>
									<small class="text-secondary">※ 맛보기 차시는 강의 중 하나의 차시에만 적용가능합니다. </small>
								</div>
								<%
									if (ConfigurationManager.AppSettings["UseZoomYN"].ToString() == "Y") 
									{
								%>
										<div class="form-group col-12" id="divZoomURL">
											<label for="txtZoomURL" class="form-label">실시간 강의 URL</label>
											<input type="text" id="txtZoomURL" name="CourseInning.ZoomURL" class="form-control" value="<%:Model.CourseInning != null ? Model.CourseInning.ZoomURL : "" %>" onkeyup="fnZoomURL()">
										</div>
								<%
									}
								%>
								<div class="form-group col-12">
									<label for="txtContentTitle" class="form-label">강의내용 <strong class="text-danger">*</strong></label>
									<textarea id="txtContentTitle" name="CourseInning.ContentTitle" rows="3" class="form-control"><%:Model.CourseInning != null ? Model.CourseInning.ContentTitle : "" %></textarea>
								</div>
								<div class="form-group col-6 col-md-4" id="divAttendanceAcceptTime">
									<label for="txtAttendanceAcceptTime" class="form-label">출석인정시간 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input type="number" id="txtAttendanceAcceptTime" name="CourseInning.AttendanceAcceptTime" class="form-control text-right" min="0" value="<%:Model.CourseInning != null ? Model.CourseInning.AttendanceAcceptTime : 0 %>">
										<div class="input-group-append">
											<span class="input-group-text">분</span>
										</div>
									</div>
								</div>

								<div class="form-group col-6 col-md-2" id="divIsMiddleAttendance">
									<label for="chkIsMiddleAttendance" class="form-label">중간출석체크 여부</label>
									<label class="switch">
										<input type="checkbox" id="chkIsMiddleAttendance" <% if (Model.CourseInning != null && !Model.CourseInning.MiddleAttendanceStartMinute.Equals(0) && !Model.CourseInning.MiddleAttendanceEndMinute.Equals(0)) { %> checked="checked" <% } %>>
										<span class="slider round"></span>
									</label>
								</div>

								<div class="form-group col-6 col-md-3" id="divMiddleAttendanceStartMinute">
									<label for="txtMiddleAttendanceStartMinute" class="form-label">중간출석체크(시작) <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input type="number" id="txtMiddleAttendanceStartMinute" name="CourseInning.MiddleAttendanceStartMinute" class="form-control text-right" min="0" value="<%:Model.CourseInning != null ? Model.CourseInning.MiddleAttendanceStartMinute : 0 %>">
										<div class="input-group-append">
											<span class="input-group-text">분(부터)</span>
										</div>
									</div>
								</div>
								<div class="form-group col-6 col-md-3" id="divMiddleAttendanceEndMinute">
									<label for="txtMiddleAttendanceEndMinute" class="form-label">중간출석체크(종료) <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input type="number" id="txtMiddleAttendanceEndMinute" name="CourseInning.MiddleAttendanceEndMinute" class="form-control text-right" min="0" value="<%:Model.CourseInning != null ? Model.CourseInning.MiddleAttendanceEndMinute : 0 %>">
										<div class="input-group-append">
											<span class="input-group-text">분(까지)</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="card-footer">
							<div class="row align-items-center">
								<div class="col">
									<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
								</div>
								<div class="col-auto text-right">
									<button type="button" class="btn btn-primary" onclick="fnSave()">저장</button>
									<button type="button" class="btn btn-secondary" onclick="window.close()" title="닫기">닫기</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- OCW선택 모달 -->
		<div class="modal fade show" id="divSearchOCW" tabindex="-1" aria-labelledby="searchOCW" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="searchOCW">콘텐츠 선택</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="card">
							<div class="card-body pb-1">
								<div class="form-row align-items-end">
									<%
										if (!ViewBag.IsAdmin) 
										{
									%>
											<div class="form-group col-4">
												<label for="ddlThemeNos" class="sr-only">테마선택</label>
												<select id="ddlThemeNos" class="form-control">
													<option value="">테마선택</option>
													<%
														foreach (var item in Model.OcwThemeList) 
														{
													%>
															<option value="<%:item.ThemeNo %>"><%:item.ThemeName %></option>
													<%
														}
													%>
												</select>
											</div>
									<%
										}
									%>
									<div class="form-group col-5">
										<label for="txtSearchText" class="sr-only">검색어</label>
										<input title="검색어" id="txtSearchText" class="form-control" type="text" placeholder="검색어" />
									</div>
									<div class="form-group col-auto text-right">
										<button type="button" class="btn btn-secondary" onclick="fnSearchOCW()">
											<span class="icon search">검색</span>
										</button>
									</div>
								</div>
							</div>
						</div>
							<div class="col-12 p-0">
								<div class="card">
									<div class="card-body py-0">
										<div class="table-responsive overflow-auto" style="max-height: 400px">
											<table class="table table-hover" summary="OCW 검색 목록">
												<caption>OCW 검색 목록</caption>
												<thead>
													<tr>
														<th scope="col" class="d-none">No</th>
														<th scope="col">콘텐츠명</th>
														<th scope="col">생성자</th>
														<th scope="col">유형</th>
														<th scope="col">미리보기</th>
														<th scope="col">선택</th>
													</tr>
												</thead>
												<tbody id="tbody">
													<tr>
														<td colspan="6" class="text-center">
															검색된 콘텐츠가 없습니다.
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="card-footer">
										<div class="row align-items-center">
											<div class="col-12 text-right">
												<button type="button" class="btn btn-secondary" data-dismiss="modal" title="닫기">닫기</button>
											</div>
										</div>
									</div>
								</div>
							</div>		
					</div>
				</div>
			</div>
		</div>
		<!-- OCW선택 모달 -->

		<input type="hidden" id="hdnCourseNo" name="CourseInning.CourseNo" value="<%:Model.Course.CourseNo %>"/>
		<input type="hidden" id="hdnOcwNo" value=""/>
		<input type="hidden" id="hdnIsAdmin" value="<%:ViewBag.IsAdmin %>" />
		<input type="hidden" id="hdnLMSContentsNo" name="CourseInning.LMSContentsNo" value="<%:Model.CourseInning != null ? Model.CourseInning.LMSContentsNo : 0 %>"/>
		<input type="hidden" id="hdnInningNo" name="CourseInning.InningNo" value="<%:Model.CourseInning != null ? Model.CourseInning.InningNo : 0%>"/>
		<input type="hidden" id="hdnWeek" name="CourseInning.Week" value="<%:Model.CourseInning != null ? Model.CourseInning.Week : 0%>"/>
		<input type="hidden" id="hdnIsPreview" name="CourseInning.IsPreview" value="<%: Model.CourseInning != null ? Model.CourseInning.IsPreview : "N"%>"/>
	</form>
	    
	<!-- ocwView 관련-->
	<form id="frmpop">
		<input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
		<input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
	</form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			if ("<%:ConfigurationManager.AppSettings["ExamYN"].ToString()%>" == "N") {
				$("#ddlLessonForm").attr("disabled", "disabled");
				$("#ddlLessonForm").val("CINM001");
			}

			fnFromToCalendar("txtInningStartDay", "txtInningEndDay", $("#txtInningStartDay").val());

			$("#txtInningStartDay").val("<%: Model.CourseInning != null ? Model.CourseInning.InningStartDay : ""%>");
			$("#txtInningEndDay").val("<%: Model.CourseInning != null ? Model.CourseInning.InningEndDay : ""%>");

			$("#lblLMSContentsNo").text('<%:Model.CourseInning != null ? Model.CourseInning.OcwName : ""%>');

			if ($("#hdnInningNo").val() > 0 && $("#ddlLessonForm").val() != "CINM001") {
				$("#divLMSContentsNo").hide();
				$("#divIsPreview").hide();
				$("#divZoomURL").hide();
				$("#divAttendanceAcceptTime").hide();
				$("#divIsMiddleAttendance").hide();
				$("#divMiddleAttendanceStartMinute").hide();
				$("#divMiddleAttendanceEndMinute").hide();
			} else {
				$("#divLMSContentsNo").show();
				$("#divIsPreview").show();
				$("#divZoomURL").show();
				$("#divAttendanceAcceptTime").show();
				$("#divIsMiddleAttendance").show();
				$("#divMiddleAttendanceStartMinute").show();
				$("#divMiddleAttendanceEndMinute").show();
			}

			if ($("#hdnIsPreview").val() == "Y") {
				$("#divAttendanceAcceptTime").hide();
				$("#divIsMiddleAttendance").hide();
				$("#divMiddleAttendanceStartMinute").hide();
				$("#divMiddleAttendanceEndMinute").hide();
			} else {
				$("#divAttendanceAcceptTime").show();
				$("#divIsMiddleAttendance").show();
				$("#divMiddleAttendanceStartMinute").show();
				$("#divMiddleAttendanceEndMinute").show();
			}

			fnSearchOCW();

			if ($("#hdnIsPreview").val() == "N") {

				fnSetChangeControl();
			}
		})

		
		<%-- 주차 변경 시 차시 조회 --%>
		function fnWeekChange() {

			if ($("#ddlWeek").val() != -1) {

				$("#txtInningSeqNoName").val("");
			}
			ajaxHelper.CallAjaxPost("/Course/NewInning", { courseNo: $("#hdnCourseNo").val(), weekNo: $("#ddlWeek").val() }, "fnCompleteNewInning", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
		}

		<%-- 차시 조회 --%>
		function fnCompleteNewInning() {

			var result = ajaxHelper.CallAjaxResult();
			if (result != null) {

				$("#txtInningSeqNoName").val(result[0].InningSeqNo + "차시");
				$("#hdnInningSeqNo").val(result[0].InningSeqNo);
				$("#txtInningStartDay").val(result[0].InningStartDay);
				$("#txtInningEndDay").val(result[0].InningEndDay);
			}
		}

		<%-- OCW선택 모달 초기화 --%>
		$("#btnSearchOCW").click(function () {

			$("#ddlThemeNos").val('');
			$("#txtSearchText").val('');

		})

		<%-- OCW선택 검색 --%>
		function fnSearchOCW() {
			ajaxHelper.CallAjaxPost("/Course/SearchOCW", { themeNos: $("#ddlThemeNos").val(), searchText: $("#txtSearchText").val(), isAdmin: $("#hdnIsAdmin").val() }, "fnCompleteSearchOCW");
		}

		function fnCompleteSearchOCW() {
			var result = ajaxHelper.CallAjaxResult();
			var tbodyHtml = "";
			if (result.length > 0) {

				for (var i = 0; i < result.length; i++) {
					var ocwData = result[i].OcwType == 1 || (result[i].OcwType == 0 && result[i].OcwSourceType == 0) ? (result[i].OcwData ?? "") : "";

					tbodyHtml += '	<tr>';
					tbodyHtml += '		<td id="tdOcwNo" class="d-none">' + result[i].OcwNo + '</td>';
					tbodyHtml += '		<td class="text-left">' + result[i].OcwName + '</td>';
					tbodyHtml += '		<td>' + result[i].OcwUserName + '</td>';
					tbodyHtml += '		<td>' + result[i].OcwSourceTypeName + '</td>';
					tbodyHtml += '		<td>';
					tbodyHtml += '			<button type="button" title="미리보기" class="btn btn-sm btn-outline-secondary"';
					tbodyHtml += '					onclick = "fnOcwView(' + result[i].OcwNo + ',' + result[i].OcwType + ',' + result[i].OcwSourceType + ','
																			+ '\'' + ocwData + '\'' + ',' + result[i].OcwFileNo + ',' + result[i].OcwWidth + ','
																			+ result[i].OcwHeight + ',' + '\'frmpop\')">';
					tbodyHtml += '					보기</button > ';
					tbodyHtml += '		</td>';
					tbodyHtml += '		<td>';
					tbodyHtml += '			<button type="button" title="선택" class="btn btn-sm btn-outline-primary" data-dismiss="modal" onclick="fnSelectOCW(`' + result[i].OcwName + '`' + ',' + result[i].OcwNo + ')">선택</button>';
					tbodyHtml += '		</td>';
					tbodyHtml += '	</tr>';
				}
			}
			else {

				tbodyHtml += "<tr>";
				tbodyHtml += "	<td colspan=\"6\" class=\"text-center\">검색된 콘텐츠가 없습니다.</td>";
				tbodyHtml += "</tr>";
			}

			$("#tbody").html(tbodyHtml);
		}

		<%-- OCW선택 선택 --%>
		function fnSelectOCW(ocwName, ocwNo) {
			$("#hdnOcwNo").val(ocwNo);
			$("#lblLMSContentsNo").text(ocwName);
			$("#hdnLMSContentsNo").val(ocwNo);

			$("#divAttendanceAcceptTime").show();
			$("#divIsMiddleAttendance").show();
			$("#divMiddleAttendanceStartMinute").show();
			$("#divMiddleAttendanceEndMinute").show();
		}

		function fnSetChangeControl() {

			//강의종류가 온라인이고 학습방식이 강의일때만
			if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001") {
				$("#divLMSContentsNo").show();
				$("#divIsPreview").show();
				$("#divZoomURL").show();
				$("#divAttendanceAcceptTime").show();
				$("#divIsMiddleAttendance").show();
				$("#divMiddleAttendanceStartMinute").show();
				$("#divMiddleAttendanceEndMinute").show();
			} else {
				$("#divLMSContentsNo").hide();
				$("#divIsPreview").hide();
				$("#divZoomURL").hide();
				$("#divAttendanceAcceptTime").hide();
				$("#divIsMiddleAttendance").hide();
				$("#divMiddleAttendanceStartMinute").hide();
				$("#divMiddleAttendanceEndMinute").hide();
			}
		}
				
		//function fnLectureTypeChange() {

		//	//강의종류가 오프라인이면
		//	if ($("#ddlLectureType").val() == "CINN002") {
		//		$("#divLMSContentsNo").hide();
		//		$("#divIsPreview").hide();
		//		$("#divZoomURL").hide();
		//		$("#divAttendanceAcceptTime").hide();
		//		$("#divMiddleAttendanceStartMinute").hide();
		//		$("#divMiddleAttendanceEndMinute").hide();
		//	} else {
		//		$("#divLMSContentsNo").show();
		//		$("#divIsPreview").show();
		//		$("#divZoomURL").show();
		//		$("#divAttendanceAcceptTime").show();
		//		$("#divMiddleAttendanceStartMinute").show();
		//		$("#divMiddleAttendanceEndMinute").show();
		//	}
			
		//}

		//function fnLessonFormChange() {

		//	//학습방식이 강의이면
		//	if ($("#ddlLessonForm").val() == "CINM001") {
		//		$("#divLMSContentsNo").show();
		//		$("#divIsPreview").show();
		//		$("#divZoomURL").show();
		//		$("#divAttendanceAcceptTime").show();
		//		$("#divMiddleAttendanceStartMinute").show();
		//		$("#divMiddleAttendanceEndMinute").show();

		//	} else {
		//		$("#divLMSContentsNo").hide();
		//		$("#divIsPreview").hide();
		//		$("#divZoomURL").hide();
		//		$("#divAttendanceAcceptTime").hide();
		//		$("#divMiddleAttendanceStartMinute").hide();
		//		$("#divMiddleAttendanceEndMinute").hide();
		//	}
		//}

		<%-- 맛보기 차시 일 때 출석인정/중간출석체크 hide --%>
		$("#chkIsPreview").click(function () {
			var strYeseNo = "";
		
			if ($(this).is(":checked") == true) { strYeseNo = "Y"; }
			else { strYeseNo = "N"; }
		
			if (strYeseNo == "Y") {
				$("#divAttendanceAcceptTime").hide();
				$("#divIsMiddleAttendance").hide();
				$("#divMiddleAttendanceStartMinute").hide();
				$("#divMiddleAttendanceEndMinute").hide();
			} else {
				$("#divAttendanceAcceptTime").show();
				$("#divIsMiddleAttendance").show();
				$("#divMiddleAttendanceStartMinute").show();
				$("#divMiddleAttendanceEndMinute").show();
			}
		
		});

		<%-- 콘텐츠X, 실시간 강의 입력 시 출석인정/중간출석체크 hide --%>
		function fnZoomURL() {

			if ($("#lblLMSContentsNo").text() == "" && $("#txtZoomURL").val() != "") {
				$("#divAttendanceAcceptTime").hide();
				$("#divIsMiddleAttendance").hide();
				$("#divMiddleAttendanceStartMinute").hide();
				$("#divMiddleAttendanceEndMinute").hide();
			} else {
				$("#divAttendanceAcceptTime").show();
				$("#divIsMiddleAttendance").show();
				$("#divMiddleAttendanceStartMinute").show();
				$("#divMiddleAttendanceEndMinute").show();
			}
		}		

		<%-- 저장 --%>
		function fnSave() {

			if ($("#ddlWeek").val() == -1) {
				bootAlert("주차를 선택해주세요.", function () {
			
					$("#ddlWeek").focus();		
				});
				return false;
			}
			
			if ($("#txtInningSeqNoName").val() == "") {
				bootAlert("차시를 확인해주세요.", function () {
			
					$("#txtInningSeqNoName").focus();
				});
				return false;
			}
			
			if ($("#ddlLectureType").val() == "") {
				bootAlert("강의종류를 선택해주세요.", function () {
			
					$("#ddlLectureType").focus();
				});
				return false;
			}
			
			if ($("#ddlLessonForm").val() == "") {
				bootAlert("학습방식 선택해주세요.", function () {
			
					$("#ddlLessonForm").focus();
				});
				return false;
			}
			
			if ($("#txtInningStartDay").val() == "") {
				bootAlert("학습시작일자를 확인해주세요.", function () {
			
					$("#txtInningStartDay").focus();
				});
				return false;
			}
			
			if ($("#txtInningEndDay").val() == "") {
				bootAlert("학습종료일자를 확인해주세요.", function () {
			
					$("#txtInningEndDay").focus();
				});
				return false;
			}

			<%
				if (ConfigurationManager.AppSettings["UseZoomYN"].ToString() == "Y") 
				{
			%>
					if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001") {
						if ($("#txtZoomURL").val() == "") {
							if ($("#ddlLessonForm").val() == "CINM001" && $("#lblLMSContentsNo").text() == "") {
								bootAlert("학습콘텐츠를 선택해주세요.");
								return false;
							}
						}
					}
			<%
				}
			%>		

			if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && $("#lblLMSContentsNo").text() == "" && $("#chkIsPreview").is(":checked") == true) {
				bootAlert("맛보기 차시는 콘텐츠를 선택한 경우 사용할 수 있습니다. ");
				return false;
			}

			if ($("#txtContentTitle").val() == "") {
				bootAlert("강의내용을 확인해주세요.", function () {
			
					$("#txtContentTitle").focus();
				});
				return false;
			}

			if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && $("#lblLMSContentsNo").text() != "" && $("#chkIsPreview").is(":checked") == false) {

				if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && $("#txtAttendanceAcceptTime").val() == 0) {
					bootAlert("출석인정시간을 확인해주세요.", function () {

						$("#txtAttendanceAcceptTime").focus();
					});
					return false;
				}

				//중간출석체크 여부 클릭했을때, 맛보기차시가 아닐때
				if ($("#chkIsMiddleAttendance").is(":checked") == true && $("#chkIsPreview").is(":checked") == false) {

					if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && $("#txtMiddleAttendanceStartMinute").val() == 0) {
						bootAlert("중간출석시작시간을 확인해주세요.", function () {

							$("#txtMiddleAttendanceStartMinute").focus();
						});
						return false;
					}

					if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && $("#txtMiddleAttendanceEndMinute").val() == 0) {
						bootAlert("중간출석종료시간을 확인해주세요.", function () {

							$("#txtMiddleAttendanceEndMinute").focus();
						});
						return false;
					}

					if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && (Number($("#txtMiddleAttendanceStartMinute").val()) > Number($("#txtMiddleAttendanceEndMinute").val()))) {

						bootAlert("중간출석종료시간이 시작시간보다 작습니다. 확인해주세요.", function () {

							$("#txtMiddleAttendanceEndMinute").focus();
						});
						return false;
					}

					if ($("#ddlLectureType").val() == "CINN001" && $("#ddlLessonForm").val() == "CINM001" && (Number($("#txtMiddleAttendanceEndMinute").val()) > Number($("#txtAttendanceAcceptTime").val()))) {

						bootAlert("출석인정시간이 중간출석종료시간보다 작습니다. 확인해주세요.", function () {

							$("#txtMiddleAttendanceEndMinute").focus();
						});
						return false;
					}
				}				
			}

			bootConfirm("저장하시겠습니까?", function () {

				ajaxHelper.CallAjaxPost("/Course/InningSave", $("#mainForm").serialize(), "fnCompleteInningSave");
			});
		}

		function fnCompleteInningSave() {
		
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert("저장되었습니다.", function () {

					opener.parent.location.reload();
					window.close();
				});

			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
		}

	</script>
</asp:Content>