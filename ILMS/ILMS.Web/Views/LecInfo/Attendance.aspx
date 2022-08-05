<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainform" action="/LecInfo/Attendance/<%:Model.CourseNo %>" method="post">
		<div class="card card-style02">
			<div class="card-body pb-1 pt-3">
				<div class="form-row align-items-end">
					<div class="form-group col-12 col-md-4">
						<label for="ddlWeek" class="form-label">주차 <strong class="text-danger">*</strong></label>
						<select class="form-control" id="ddlWeek" name="CourseInning.Week" onchange="fnWeekchange()">
							<option value="0">선택</option>
							<% 
								foreach (var item in Model.WeekList)
								{
							%>
							<option value="<%:item.Week %>" <%: (item.Week == (Model.CourseInning.Week)) ? "selected='selected'" : "" %>><%:item.WeekName %></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="form-group col-9 col-md-7">
						<label for="ddlInning" class="form-label">차시 <strong class="text-danger">*</strong></label>
						<select class="form-control" id="ddlInning" name="CourseInning.InningNo">
							<option value="0">선택</option>
						</select>
					</div>

					<div class="form-group col-3 col-md-1 text-center text-md-right">
						<button type="button" class="btn btn-dark" onclick="fnSearch()">조회</button>
					</div>
					<div id="hidden">

					</div>
				</div>
			</div>
			<!-- card-body -->
		</div>

		<small class="text-muted">※ 학습종료일 이후 출결정보저장이 가능합니다.</small>

		<div class="card card-style01 mt-2">
			<div class="card-header">
				<div class="row justify-content-between">
					<div class="col-auto">
						<button type="button" class="btn btn-sm btn-secondary" id="btnSort">
							<%if (Model.SortType != null)
								{
									if (Model.SortType.Equals("UserID"))
									{
							%>
							<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순
							<%
								}
								else
								{
							%>
								성명순
							<%}
								}
								else
								{
							%>
							<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순
						<%
							}
						%>
						</button>
						<button type="button" class="btn btn-sm btn-secondary <%: Model.StudyInningList.Count > 0 ? Model.StudyInningList.FirstOrDefault().LectureType.ToString().Equals("CINN002") ? "" : "d-none" : "d-none"%>" id="btnRandom" onclick="fnPopRandom()" data-toggle="modal">출석체크용 숫자 발급</button>
					</div>
					<div class="col-auto text-right">
						<div class="dropdown d-inline-block">
							<button type="button" class="btn btn-sm btn-secondary dropdown-toggle" id="ddlSend" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								메세지발송
							</button>
							<ul class="dropdown-menu" aria-labelledby="ddlSend">
									<%
										if (ConfigurationManager.AppSettings["MailYN"].ToString().Equals("Y"))
										{
									%>
									<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerMail', 'chkSel');">메일발송</button></li>
									<%
										}
									%>
                                    <li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerNote', 'chkSel');">쪽지발송</button></li>
                                    <li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerSMS', 'chkSel');">SMS발송</button></li>
							</ul>
						</div>

						<%
							if (Model.StudyInningList != null && Model.StudyInningList.Count > 0 && Model.CourseInning.Week.ToString() != null && Model.CourseInning.InningNo.ToString() != null)
							{
						%>
							<div class="dropdown d-inline-block">
								<button type="button" class="btn btn-sm btn-primary btn_save">
									출결정보저장</button>
							</div>
						<%
							}
						%>
					</div>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table" id="personalTable" summary="출결관리">
						<caption>출결 리스트</caption>
						<thead>
							<tr>
								<th scope="row">
									<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');">
								</th>							
								<th scope="row" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">소속</th>															
								<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
								<th scope="row">이름</th>
								<th scope="row" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none d-md-table-cell" : "d-none d-none d-md-table-cell"%>">구분</th>
								<%
								if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
								{
								%>
								<th scope="row">학년</th>
								<th scope="row">학적</th>
								<%
								}
								else
								{
								%>
								<th scope="row" class="d-none d-md-table-cell">이메일</th>
								<th scope="row">생년월일</th>
								<%
								}
								%>
								<th scope="row">수강시간(분)</th>
								<th scope="row">출석</th>
								<th scope="row">지각</th>
								<th scope="row">결석</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (Model.StudyInningList != null && Model.StudyInningList.Count > 0)
								{
									foreach (var item in Model.StudyInningList)
									{
							%>
							<tr>

								<td>
									<input type="checkbox" name="Homework.UserNo" id="chkSel" value="<%:item.UserNo %>" class="checkbox">
									<input type="hidden" value="<%:item.UserNo %>">
									<input type="hidden" value="<%:item.HangulName %>(<%:item.UserID %>)">
									<input type="hidden" value="<%:item.UserID %>">
								</td>
								
								<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"><%:item.AssignName%></td>
								
								<td><%:item.UserID%>
									<input type="hidden" name="StudyInningNo" value="<%:item.StudyInningNo + "|" + item.UserNo%>" />
									<%--<input type="hidden" name="UserNo" value="<%:item.UserNo%>" />--%>
								</td>
								<td class="text-left"><%:item.HangulName%></td>
								<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>"><%:item.GeneralUserCode%></td>
								<%
									if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
									{
								%>
									<td><%:item.Grade %></td>
									<td><%:item.HakjeokGubun %></td>
								<%
									}
									else
									{
								%>
									<td><%:item.Email %></td>
									<td><%:item.ResidentNo %></td>
								<%
									}
								%>
								
								<td><%:item.StudyTime %></td>
								<td>
									<div>
										<input type="radio" name="AttendanceStutus<%:item.StudyInningNo%>" id="chkrbtn1" value="CLAT001" class="radio" <%: (item.AttendanceStatus == "CLAT001") ? "checked='checked'" : "" %> />
									</div>
								</td>
								<td>
									<div>
										<input type="radio" name="AttendanceStutus<%:item.StudyInningNo%>" id="chkrbtn2" value="CLAT003" class="radio" <%: (item.AttendanceStatus == "CLAT003") ? "checked='checked'" : "" %> />
									</div>
								</td>
								<td>
									<div>
										<input type="radio" name="AttendanceStutus<%:item.StudyInningNo%>" id="chkrbtn3" value="CLAT002" class="radio" <%: (item.AttendanceStatus == "CLAT002" || item.AttendanceStatus == "CLAT004") ? "checked='checked'" : "" %> />
									</div>
								</td>


							</tr>
									<%
									}
									%>
							
							<tr>
								<td class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"></td>
								<td class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"></td>
								<td class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td class="text-nowrap">
									<strong>합계</strong><strong> : <%: Model.StudyInningList.Count() %></strong>
								</td>
								<td class="text-nowrap">
									<strong>출석</strong><strong> : <%: Model.StudyInningList.Count(c => c.AttendanceStatus.Equals("CLAT001")) %></strong>
								</td>
								<td class="text-nowrap">
									<strong>지각</strong><strong> : <%: Model.StudyInningList.Count(c => c.AttendanceStatus.Equals("CLAT003")) %></strong>
								</td>
								<td class="text-nowrap">
									<strong>결석</strong><strong> : <%: Model.StudyInningList.Count(c => c.AttendanceStatus.Equals("CLAT002") || c.AttendanceStatus.Equals("CLAT004")) %></strong>
								</td>
							</tr>

							<%
								}
								else 
								{ 
							%>
								<tr>
									<td colspan="10">
										조회된 데이터가 없습니다.
									</td>
								</tr>
							<%
								}

							%>
						</tbody>
					</table>
				</div>
			</div>
			<%
				if (Model.StudyInningList != null && Model.StudyInningList.Count > 0 && Model.CourseInning.Week.ToString() != null && Model.CourseInning.InningNo.ToString() != null)
				{
			%>
				<div class="card-footer">
					<div class="row justify-content-between">
						<div class="col-auto">
						</div>
						<div class="col-auto text-right">
							<button type="button" class="btn btn-sm btn-primary btn_save">
								출결정보저장</button>
						</div>
					</div>
				</div>
			<%
				}
			%>
		</div>


		<div class="modal fade show" id="randomPop" tabindex="-1" aria-labelledby="ParticipationMemberDetail" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header <%: Model.CourseInning.ToString().Equals("CSTD005") ? "" : "d-none"%>">
						<h5 class="modal-title h4" id="ParticipationMemberDetail">출석체크용 숫자 발급</h5>
					</div>
					<div class="modal-body">
						<div class="mb-2 alert alert-info font-size-15" >
							<%--현재 선택된 주차/차시 : <%: Model.CourseInning.Week %>주차 <%: Model.CourseInning.InningNo %> 차시<br />--%>
							재발급 하시려는 경우 팝업창을 닫은 후 '출석체크용 숫자 발급' 버튼을 다시 눌러 창을 띄우시면 코드가 다시 생성됩니다.<br />
							발급한 코드는 1분간만 유효합니다.<br />
						</div>
						<div class="text-center font-size-40 font-weight-bold" id="divRandom"></div>
						<div class="text-center" id="divRandomDate"></div>
					</div>
					<div class="modal-footer">
						<div class="text-right">
							<a class="btn btn-secondary" href="#" onclick="closePopCheck()">닫기</a>
						</div>
                </div>
				</div>
			</div>
		</div>




	</form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			$("#btnSort").click(function () {
				window.location = '/LecInfo/Attendance/<%:Model.CourseNo%>/<%: Model.CourseInning.Week %>/<%: Model.CourseInning.InningNo %>/<%:Model.SortType != null ? Model.SortType : "UserID"%>';
			});

			$(".btn_save").click(function () {
				var chkVal = $("#ddlInning option:selected").val();
				var hiddenVal = $('#chkGigan_' + chkVal).val();
				var dateVal = new Date(hiddenVal);
				var today = new Date();
				if (dateVal > today) {
					bootAlert("학습종료일 이후 출석정보 저장 할수 있습니다.");
				}
				else
				{
					ajaxHelper.CallAjaxPost("/LecInfo/AttendanceSave/<%:Model.CourseNo%>", $("#mainform").serialize(), "fnCompleteSave", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
					
					
				}
			});

			if ($("#ddlWeek").val() != 0 ){
				fnWeekchange();
			}
		});

		// 저장
		function fnCompleteSave() {
			var result = ajaxHelper.CallAjaxResult();

			if (result == 1) {
				bootAlert("변경 되었습니다.", function () {
					location.href = "/LecInfo/Attendance/<%:Model.CourseNo %>/<%:Model.CourseInning.Week %>/<%:Model.CourseInning.InningNo %>/"
				});
			}
			else if (result == -1) {
				alert('Fail');
			}
		}

		// 주차 변경시
		function fnWeekchange() {
			ajaxHelper.CallAjaxPost("/LecInfo/InningList", { courseno: <%:Model.CourseNo%>, weekno: $("#ddlWeek").val() }, "fnCompleteInningList", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
		}

		// 차시 세팅
		function fnCompleteInningList() {
			var result = ajaxHelper.CallAjaxResult();
			var option = "<option value=''>선택</option>";
			

			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					var selected = (<%: Model.CourseInning.InningNo %> == result[i].InningNo) ? "selected" : "";
					var value = "<option value='" + result[i].InningNo + "' " + selected + "  >" + result[i].InningSeqNo + "차시</option>";
					var hidden = "<input type='hidden' id='chkGigan_" + result[i].InningNo + "' value='" + result[i].InningEndDay + "'>";
					$("#hidden").append(hidden);
					option += value;
					
				}
			}

			$("#ddlInning").html(option);
			
		}

		// 조회
		function fnSearch() {

			var Week   = $("#ddlWeek").val();
			var Inning = $("#ddlInning").val();

			if (Week == "" || Week < 1) {
				bootAlert("주차를 선택해 주시길 바랍니다.");
				return false;
			}

			if (Inning == "" || Inning < 1) {
				bootAlert("차시를 선택해 주시길 바랍니다.");
				return false;
			}

			$('#mainform').submit();

		}

		//모달 닫기
		function closePopCheck() {
			bootAlert("해당 창을 닫으실 경우 발급된 코드를 다시 확인할 수 없으며 만료시간까지 재발급할 수 없습니다.", function () {
				$("#divRandom").html("");
				$("#divRandomDate").html("");
				$('#randomPop').slideUp("fast");
			});
		}

		//출석체크용 숫자 발급 모달
		function fnPopRandom() {
			var week = $('#ddlWeek').val();
			var inningNo = $('#ddlInning').val();
			var seqno = document.getElementById("ddlInning").selectedIndex;

			
			if (week != 0 && inningNo != 0 && inningNo != '') {
				if (<%: Model.StudyInningList == null || Model.StudyInningList.Count == 0 ? "true" : "false"%>) {

					bootAlert("조회 후 발급 가능합니다.");

				} else {

					$("#randomPop").slideDown("fast");
				}

			}
			else
			{
				bootAlert("선택된 주차/차시가 없습니다.");
			}

			ajaxHelper.CallAjaxPost("/LecInfo/MakeRandomNumber", { ino: <%:Model.CourseInning.InningNo %>, cno: <%:Model.CourseNo %>, weekno: $("#ddlWeek").val(), seqno: seqno }, "fnShowRandomNumber", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");

		}

		
		function closePop() {
			$('#randomPop').slideUp("fast");
		}

		//출석체크용 모달 
		function fnShowRandomNumber() {
			var result = ajaxHelper.CallAjaxResult();

			if (result == 0) {
				bootAlert("출석체크용 숫자 발급에 실패하였습니다. 다시 시도해 주시기 바랍니다.");
				closePop();
			} else if (result == -1) {
				bootAlert("해당 주차/차시는 오프라인(대면) 강좌가 아니므로 사용하실 수 없는 기능입니다.");
				closePop();
			} else if (result == 2) {
				bootAlert("현재 유효한 발급된 코드가 있어 재발급 할 수 없습니다.\n잠시 후 다시 시도해 주시기 바랍니다.");
				closePop();
			} else {
				var innerHTML = result.Random1 + "&nbsp;" + result.Random2;
				var innerHTML2 = result.ValidateStartTime + " ~ " + result.ValidateEndTime;

				$("#divRandom").html(innerHTML);
				$("#divRandomDate").html(innerHTML2);
			}
		}

	</script>
</asp:Content>
