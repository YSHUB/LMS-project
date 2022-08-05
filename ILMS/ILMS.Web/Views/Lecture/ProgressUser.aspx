<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">상세 보기</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="content">
		<div class="col-12">
			<div class="card card-style02">
				<div class="card-header">
					<span class="card-title01 text-dark">개인출결관리</span>
				</div>
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>소속</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.AssignName %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>이름(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.LectureUserDetail.HangulName %>(<%:Model.LectureUserDetail.UserID %>)</dd>
					</dl>
				</div>
			</div>
			<div class="tab-content" id="myTabContent">
				<ul class="nav nav-tabs mt-4" role="tablist">
					<li class="nav-item" role="presentation">
						<a href="/Lecture/ProgressUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link active" role="tab">학습진도 관리</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/LogUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link" role="tab">접속정보</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/OcwUser/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link" role="tab">콘텐츠 정보</a>
					</li>
				</ul>
			</div>
			<div class="card card-style02">
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>학습 진도율</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetTotalStudyInning()%>/<%:Model.GetTotalInning()%></dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>권장 진도율</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.RecommandProgressRate %>%</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>마지막 학습 차시</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetLastStudyWeek()%>주차~<%:Model.GetLastStudyInning() %></dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>총 학습시간</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetTotalStudyTime() %>분</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>강의 접속 수</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetTotalConnectedCount() %>회</dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>평균 학습시간</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetAvgStudyTime() %>분</dd>
					</dl>
				</div>
			</div>
			<div class="card">
				<div class="card-body py-0">
					<%
						if (Model.StudyInningInfo.Count > 0)
						{
					%>
					<div class="table-responsive">
						<table class="table table-hover" summary="학습상황관리 - 학습진도현황 - 학습상세">
							<caption>학습상황관리 - 학습진도현황 - 학습상세 리스트</caption>
							<thead>
								<tr>
									<th scope="col">주차</th>
									<th scope="col">차시</th>
									<th scope="col">수업형태</th>
									<th scope="col">학습페이지</th>
									<th scope="col">학습시간(분)</th>
									<th scope="col">출결변경사유</th>
									<th scope="col">출결</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<%	
										foreach(var item in Model.WeekList)
										{
											var inning = Model.Inning.Where(c => c.Week == item.Week);
											foreach (var item2 in inning)
											{
												var subItem = Model.StudyInningInfo.Where(c => c.InningNo == item2.InningNo).FirstOrDefault();
												subItem = subItem ?? new ILMS.Design.Domain.StudyInning();
									%>
									<td class="text-center"><%:item2.Week %></td>
									<td class="text-center"><%:item2.InningSeqNo %></td>
									<td class="text-center"><%:item2.LectureTypeName %></td>
									<td class="text-center"><a href="#" onclick="viewPageInfo(<%:item2.InningNo %>, <%:Model.LectureUserDetail.UserNo %>);"><%:subItem.PageCnt %></a> / <%:item2.TotalContentPage %></td>
									<td class="text-center"><a href="#" onclick="viewTimeInfo(<%:item2.InningNo %>, <%:Model.LectureUserDetail.UserNo %>);"><%:subItem.StudyTime %></a> / <%:item2.AttendanceAcceptTime %></td>
									<td class="text-center">
										<input type="button" title="출결변경사유" class="btn btn-sm btn-primary mb-0" onclick="viewReason(<%:subItem.StudyInningNo %>, <%:Model.LectureUserDetail.UserNo%>);" value="보기">
									<td class="text-center">
										<select id="ddlAttend" class="form-control form-control-sm mr-3" onchange="javascript:viewAttendance(<%:subItem.StudyInningNo %>,<%:Model.LectureUserDetail.UserNo %>,this);">
											<%
												foreach (var code in Model.BaseCode)
												{
											%>
											<option value="<%:code.CodeValue %>" <%:code.CodeValue == subItem.AttendanceStatus ? "selected='selected'" : "" %>><%:code.CodeName %></option>
											<%
												}
											%>
										</select>
									</td>
								</tr>
								<%
										}
									}
								%>
							</tbody>
						</table>
					</div>
					<%
						}
					%>
				</div>
				<div class="card-footer">
					<div class="row">
						<div class="col-6">
							<small>※ 학습페이지의 숫자를 클릭하면 미학습 페이지를 조회할 수 있습니다.</small>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade show" id="attReason" tabindex="-1" aria-labelledby="attReason" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4">출결변경사유</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body" id="mbAttReason">
					<p class="font-size-14 text-dark font-weight-bold mb-0">
						2022-01-06 10:18
					</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-6">미체크
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade show" id="attSelect" tabindex="-1" aria-labelledby="attSelect" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4">출결변경사유</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14">
						출석 변경 사유를 입력 후 [저장] 버튼을 누르면 출결 변경이 완료됩니다.
					</p>
					<div class="form-group">
						<textarea id="txtInput" name="" rows="5" class="form-control"></textarea>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="btnSave">저장</button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var ajax = new AjaxHelper();
		var _ajax = new AjaxHelper();
		var selectInning;
		var selectUser;
		var selectStatus;

		$(document).ready(function () {
			$("#btnSave").click(function () {
				if ($("#txtInput").val() == "") {
					bootAlert("사유를 입력하세요.", 1);
					return false;
				} else {
					ajax.CallAjaxPost("/Lecture/InsertAttendance", { param1: selectInning, param2: selectUser, param3: selectStatus, param4: $("#txtInput").val() }, "cbInsert");
					$(".clse", "#attSelect").click();
				}
			});
		});

		function viewAttendance(studyInningNo, userNo, obj) {
			selectInning = studyInningNo
			selectUser = userNo
			selectStatus = $(obj).val();

			$("#attSelect").modal("show");

			return false;
		}

		function viewReason(studyInningNo, userNo) {
			_ajax.CallAjaxPost("/Lecture/GetAttendanceReason", { param1: studyInningNo, param2: userNo }, "cbReason");
		}

		function viewPageInfo(inningNo, userNo) {
			window.open($.stringFormat("/Lecture/StudyPagePopup/{0}/{1}", inningNo, userNo), "StudyPagePopup", "width=800,height=600,scrollbars=yes");
		}

		function viewTimeInfo(inningNo, userNo) {
			window.open($.stringFormat("/Lecture/StudyTimePopup/{0}/{1}", inningNo, userNo), "StudyPagePopup", "width=800,height=600,scrollbars=yes");
		}

		function cbInsert() {
			var result = ajax.CallAjaxResult();
			if (result > 0) alert("변경되었습니다.");
			location.reload();
		}

		function cbReason() {
			var result = _ajax.CallAjaxResult();
			var rsHtml = "";

			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					rsHtml += "<p class='font-size-14 text-dark font-weight-bold mb-0'>" + result[i].CreateDateTime + "</p><ul class='list-style03 mb-0'>" +
						"<li class='font-size-6'>" + result[i].AttendanceReason + "</li></ul>";
				}
			}
			else {
				rsHtml = "<p class='font-size-14 text-dark font-weight-bold mb-0'>" + "데이터가 없습니다." + "</p>";
			}
			$("#mbAttReason").html(rsHtml);
			$("#attReason").modal("show");
		}

	</script>
</asp:Content>
