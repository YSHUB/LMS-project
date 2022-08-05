<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">학습진도현황 상세</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Lecture/StudentStatusDetail" id="mainForm" method="post" enctype="multipart/form-data">
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
						<a href="/LecInfo/StudentStatusDetail/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link active" role="tab">학습진도 관리</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/LecInfo/StudentStatusOcwUserDetail/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" class="nav-link" role="tab">콘텐츠 정보</a>
					</li>
				</ul>
			</div>

			<!-- 출결현황 -->
			<h5 class="title04 mt-4">출결현황</h5>
			<div class="card">
				<div class="card-body py-0">
					<div class="table-responsive">
				<table class="table table-hover" summary="출결현황">
					<thead>
						<tr>
							<th>주차
							</th>
							<%for (int i = 1; i <= Model.Inning.Max(c => c.Week); i++)
								{%>
							<th>
								<%:i %>
							</th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						<%: Model.GetWeekAttendanceStatus()%>
					</tbody>
				</table>
				<div class="text-right">
					<small class="font-size-14">※ 출결 표시 구분 : <strong class="text-primary">온라인</strong> <strong class="text-danger">오프라인</strong> (출석 ○ 지각 X 결석 /  수업없음 - )</small>
				</div>				
			</div>
				</div>


			</div>
			<!-- 출결현황 -->

			<!-- 학습 참여현황 -->
			<h5 class="title04 mt-4">학습 참여현황</h5>
			<div class="card">
				<div class="card-body py-0">
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습참여현황">
							<caption>학습참여현황</caption>
							<thead>
								<tr>
									<th scope="col">온라인강의</th>
									<th scope="col">오프라인강의</th>
									<th scope="col"><%: ConfigurationManager.AppSettings["UnivCode"].Equals("IDINO") ? "시험" : "성취도평가" %></th>
									<th scope="col">과제</th>
									<th scope="col">퀴즈</th>
									<th scope="col" class="<%: ConfigurationManager.AppSettings["UnivCode"].Equals("KIRIA") ? "d-none" : "" %>">토론</th>		
									<th scope="col">강의Q&A</th>
									<th scope="col">콘텐츠 접근횟수</th>
									<th scope="col">학습의견</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="text-center"><%:Model.Student.OnlineAttendance %>/<%:Model.Student.OnlineInningCount %></td>
									<td class="text-center"><%:Model.Student.OfflineAttendance %>/<%:Model.Student.OfflineInningCount %></td>
									<td class="text-center"><%:Model.ProgressDetail["IsUseExam"].Equals("Y") ? Model.ProgressDetail["ExamSubmitCount"] + "/" + Model.ProgressDetail["ExamCount"] : "-" %></td>	
									<td class="text-center"><%:Model.ProgressDetail["IsUseHomework"].Equals("Y") ? Model.ProgressDetail["HomeworkSubmitCount"] + "/" + Model.ProgressDetail["HomeworkCount"] : "-" %></td>									
									<td class="text-center"><%:Model.ProgressDetail["IsUseQuiz"].Equals("Y") ? Model.ProgressDetail["QuizSubmitCount"] + "/" + Model.ProgressDetail["QuizCount"] : "-" %></td>
									<td class="text-center <%: ConfigurationManager.AppSettings["UnivCode"].Equals("KIRIA") ? "d-none" : "" %>"><%:Model.ProgressDetail["IsUseDisscussion"].Equals("Y") ? Model.ProgressDetail["DiscussionCheckCount"] + "/" + Model.ProgressDetail["DiscussionCount"] : "-" %></td>
									<td class="text-center"><%:Model.ProgressDetail["IsUseParticipationQA"].Equals("Y") ? Model.ProgressDetail["QACheckCount"] + "/" + Model.ProgressDetail["QACount"] : "-" %></td>
									<td class="text-center"><%:Model.ProgressDetailOCW["TotalViewCount"] %></td>
									<td class="text-center"><%:Model.ProgressDetailOCW["OcwOpinionCount"] %></td>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- 학습 참여현황 -->

			<!-- 학습 접속확인 -->
			<h5 class="title04 mt-4">학습 접속확인</h5>
			<div class="card card-style02">
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>학습 진도율</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.Student.OnlineAttendance + Model.Student.OfflineAttendance%>/<%:Model.GetTotalInning()%></dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>권장 진도율</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.RecommandProgressRate %>%</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>마지막 학습 차시</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.GetLastStudyWeek()%>주차<%:Model.GetLastStudyInning() %>차시</dd>
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
			<div class="alert alert-info">※ 미학습페이지 확인 방법 : 학습페이지 진한 앞의 숫자를 클릭하면 확인 가능</div>
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
									<th scope="col">학습시간(분)</th>
									<th scope="col">강의접속수</th>
									<th scope="col">최초학습일</th>
									<th scope="col">PC중간체크일</th>
									<th scope="col">학습완료일</th>
									<th scope="col">최근학습일</th>
									<th scope="col">출결변경사유</th>
									<th scope="col" class="text-nowrap">출결</th>
									<%	if (false.Equals(ViewBag.IsProfessor))
										{
									%>
											<th class="text-center text-nowrap">오프라인<br />출결</th>
									<% 	
										}
									%>
								</tr>
							</thead>
							<tbody>
								<tr>
									<%	
										foreach (var item in Model.WeekList)
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
									<td class="text-center"><a href="#" class="font-weight-bold" onclick="viewTimeInfo(<%:item2.InningNo %>, <%:Model.LectureUserDetail.UserNo %>);"><%:subItem.StudyTime %></a> / <%:item2.AttendanceAcceptTime %></td>
									<td class="text-center"><%:subItem.StudyConnectCount %></td>
									<td class="text-center"><%:subItem.StudyStartDateTime %></td>
									<td class="text-center"><%:subItem.StudyMiddleDateTime %></td>
									<td class="text-center"><%:subItem.StudyEndDateTime %></td>
									<td class="text-center"><%:subItem.StudyLatelyDateTime %></td>
									<td class="text-center">
										<input type="button" title="출결변경사유" class="btn btn-sm btn-primary" onclick="viewReason(<%:subItem.StudyInningNo %>, <%:Model.LectureUserDetail.UserNo%>);" value="보기">

									</td>
									<td class="text-center m-0 p-0">
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
									<%	if (false.Equals(ViewBag.IsProfessor))
										{
									%>
											<td class="text-center">
											<%if (item2.LectureType.Equals("CINN002"))
											{
											%>
												<a href="#" class="btn btn-sm btn-outline-dark" onclick="javascript:return showAttendanceCode(<%:item2.InningNo %>, <%:item2.CourseNo %>, <%:item2.Week %>, <%:item2.InningSeqNo %>)" >출석체크</a>
											<%
											}
											%>
											</td>
											<% 	
												}
											%>
									
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
					<div class="text-right">
						<a href="/LecInfo/ConnectionLogExcel/<%:Model.LectureUserDetail.CourseNo %>/<%:Model.LectureUserDetail.UserNo %>" title="접속로그다운로드" class="btn btn-sm btn-outline-primary">접속로그 다운로드</a>
					</div>
				</div>
			</div>
			<!-- 학습 접속확인 -->

		</div>
	</div>

	<%-- 출석변경사유 모달 --%>
	<div class="modal fade show" id="attReason" tabindex="-1" aria-labelledby="attReason" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4">출결변경사유</h5>
				</div>
				<div class="modal-body" id="mbAttReason">

				</div>
				<div class="modal-footer">
					<button type="button" id="btnCancel" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<%-- 출석변경사유 모달 --%>

	<%-- 출석변경 모달 --%>
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
					<div class="form-group" id="divFileUpload">
						<label for="AccountFileUpload" class="form-label">첨부파일</label>
						<div class="form-row">
							<% Html.RenderPartial("./Common/File"
								, Model.FileList
								, new ViewDataDictionary{
									  { "name", "FileGroupNo" }
									, { "fname", "AttendanceFile" }
									, { "value", 0 }
									, { "fileDirType", "Attendance"}
									, { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } 								});							%>
						</div>
					</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" id="btnSave">저장</button>
					<button type="button" id="btnCancelAtt" class="btn btn-outline-secondary" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
			<input type="hidden" name="StudyInningAttendanceList.StudyInningNo" value="" />
			<input type="hidden" name="StudyInningAttendanceList.StudyStatus" value="" />
			<input type="hidden" name="StudyInningAttendanceList.UserID" value="" />
			<input type="hidden" name="StudyInningAttendanceList.AttendanceReason" value="" />
		</div>
	</div>

	<%-- 출석변경 모달 --%>

	<!--오프라인 출석체크 팝업-->
	<div class="modal fade show" id="divOffAttendance" tabindex="-1" aria-labelledby="attCode" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">오프라인 출석체크</h5>
				</div>
				<div class="modal-body">
					<div class="alert alert-info">
						<span class="text-info">출석체크 코드를 입력하시면 출석이 변경됩니다.</span>
					</div>

					<div class="form-row">
						<div class="form-group col-md-6">
							<input type="text" id="txtAttCode1" class="form-control d-inline " />
						</div>
						<div class="form-group col-md-6">
							<input type="text" id="txtAttCode2" class="form-control d-inline" />
						</div>
					</div>

					<input type="hidden" id="hdnInningNo" />
					<input type="hidden" id="hdnCourseNo" />
					<input type="hidden" id="hdnWeek" />
					<input type="hidden" id="hdnInningSeqNo" />
				</div>
				<div class="modal-footer">
					<div class="text-right">
					<button class="btn btn-primary" type="button" id="btnOffAttendanceSave">저장</button>
					<button class="btn btn-secondary clse" type="button" id="btnOffAttendanceClose">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--오프라인 출석체크 팝업-->
	<input type="hidden" id="UserType" value="<%:Model.LectureUserDetail.Usertype %>" />
	</form>
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
					debugger;
					$("input[name='StudyInningAttendanceList.StudyInningNo']").val(selectInning);
					$("input[name='StudyInningAttendanceList.UserID']").val(selectUser);
					$("input[name='StudyInningAttendanceList.StudyStatus']").val(selectStatus);
					$("input[name='StudyInningAttendanceList.AttendanceReason']").val($("#txtInput").val());
					var formData = new FormData($("#mainForm")[0]);

					ajax.CallAjaxPostFile("/Lecture/InsertAttendance", formData, "cbInsert");
					$(".clse", "#attSelect").click();
				}
			});


			//오프라인 출석변경처리
			$("#btnOffAttendanceSave").click(function () {
				if ($("#txtAttCode").val() == "") {
					bootAlert("코드를 입력하세요.");
					return false;
				} else if ($("#txtAttCode2").val() == "") {
					bootAlert("코드를 입력하세요.");
					return false;
				} else {
					ajax.CallAjaxPost("/LecInfo/OffAttendanceSave"
						, { ino: $("#hdnInningNo").val(), cno: $("#hdnCourseNo").val(), weekno: $("#hdnWeek").val(), seqno: $("#hdnInningSeqNo").val(), attCode1: $("#txtAttCode1").val(), attCode2: $("#txtAttCode2").val() }
						, "fnCompleteOffAttendanceSave");
				}
			});

			//오프라인 출석변경 창닫기
			$("#btnOffAttendanceClose").click(function () {
				$("#divOffAttendance").hide();
			});

		});

		function fnCompleteOffAttendanceSave() {
			var result = ajax.CallAjaxResult();

			if (result > 0) {
				bootAlert("출석 처리되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("입력한 문자열이 잘못되었거나 유효시간이 아닙니다.");
			}
		}

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

		function viewTimeInfo(inningNo, userNo) {
			window.open($.stringFormat("/LecInfo/StudyTimePopup/{0}/{1}", inningNo, userNo), "StudyPagePopup", "width=800,height=600,scrollbars=yes");
		}

		function cbInsert() {
			var result = ajax.CallAjaxResult();
			if (result > 0)
				bootAlert("변경되었습니다.", function () {
				location.reload();
			});
		}

		function cbReason() {
			var result = _ajax.CallAjaxResult();
			var rsHtml = "";

			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					rsHtml += "<p class='font-size-14 text-dark font-weight-bold mb-0'>" + result[i].CreateDateTime + "</p><div class='form-row'><ul class='list-style03 mb-0'>" +
						"<li class='font-size-6'>" + result[i].AttendanceReason + "</li></ul>";
					if (result[i].FileNo > 0) {
						rsHtml += "<button type='button' onclick='fileDownLoad(" + result[i].FileNo + ")' class='text-primary btn btn-link'><i class='bi bi-download'></i></button>";
					}
					rsHtml += "</div>";
				}
			}
			else {
				rsHtml = "<p class='font-size-14 text-dark font-weight-bold mb-0'>" + "데이터가 없습니다." + "</p>";
			}
			$("#mbAttReason").html(rsHtml);
			$("#attReason").modal("show");
		}


		function fileDownLoad(fileNo) {
			location.href = '/Common/FileDownLoad/' + fileNo;
		}


		function showAttendanceCode(ino, cno, w, seqno) {
			$("#hdnInningNo").val(ino);
			$("#hdnCourseNo").val(cno);
			$("#hdnWeek").val(w);
			$("#hdnInningSeqNo").val(seqno);

			$("#divOffAttendance").show();
		}

		function CompleteAttendanceCode() {
			var result = ajax.CallAjaxResult();

			if (result > 0) {
				bootAlert("출석 처리되었습니다.");
				location.reload();

			} else {
				bootAlert("입력한 문자열이 잘못되었거나 유효시간이 아닙니다.");
			}
		}
	</script>
</asp:Content>