<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="row">
		<div class="col-12 mt-2">
			<div class="card card-style02">
				<div class="card-header">
					<div>
	
						<%if (ConfigurationManager.AppSettings["UnivYN"].Equals("N"))
							{
						%>
						<span class="badge badge-1"><%:Model.Course.StudyTypeName %></span>
						<%
							}
							else
							{
						%>
						<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
						<span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
						<%
							}
						%>
					</div>
					<span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
				</div>
				<div class="card-body">

					<% 
						if (ConfigurationManager.AppSettings["UnivYN"].Equals("N"))
						{
					%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>년도 / 회차</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TermYear %>년도 <%:Model.Course.TermSemester %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-2"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>상태</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CourseOpenStatusName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.StudentCount %>명</dd>
					</dl>
					<%
						}
						else
						{
					%>

					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark "><i class="bi bi-dot"></i>개설처 / 분반</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.AssignName %> / <%:Model.Course.ClassNo %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>년도 / 학기</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TermYear %> / <%:Model.Course.TermSemester %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>학점</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.Credit %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-2"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SUBJECTTEXT"].ToString() %>상태</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CourseOpenStatusName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.StudentCount %>명</dd>
					</dl>

					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
	<form action="/Lecture/CourseDetailAdmin/<%:Model.Course.CourseNo %>" id="mainForm" method="post">
		<div class="row">
			<div class="col-12 mt-2">
				
				<div class="card">
					<div class="card-header">
						<div class="row justify-content-between">
							<div class="col-auto mt-1">
								<button type="button" class="btn btn-sm btn-secondary" id="btnSort">
									<%
										if (Model.SortType != null)
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
									<%
											}
										}
										else
										{
									%>
									<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순
									<%
										}
									%>
								</button>
								<%--총 <span class="text-primary font-weight-bold"><%:Model.CourseLectureList.Count > 0 ? Model.CourseLectureList[0].TotalCount : 0 %></span>건 --%>
							</div>
							<div class="col-auto text-right">
								<input type="button" class="btn btn-sm btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
								<input type="button" class="btn btn-sm btn-secondary <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>" value="수강신청(수강생정보)연동" onclick="linkage();">
								<input type="button" class="btn btn-sm btn-primary <%: Model.ProgramNo.ToString() == "1" ? "d-none" : "" %>" title="수강생추가" value="수강생추가" onclick="fnAddlecture();">
								<div class="dropdown d-inline-block">
									<button type="button" class="btn btn-sm btn-secondary dropdown-toggle <%: Model.ProgramNo.ToString() == "1" ? "d-none" : "" %>" id="dropdown2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
										수강상태변경
									</button>
									<ul class="dropdown-menu" aria-labelledby="dropdown2">
										<li>
											<button class="dropdown-item" id="btnApproval" onclick="fnChangeLS('btnApproval', 'CLST001');" type="button">승인</button></li>
										<li>
											<button class="dropdown-item" id="btnStop" onclick="fnChangeLS('btnStop', 'CLST002');" type="button">대기</button></li>
										<li>
											<button class="dropdown-item" id="btnCancel" onclick="fnChangeLS('btnCancel', 'CLST003');" type="button">취소</button></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover table-sm table-horizontal" summary="과제 제출 정보 목록">
								<thead>
									<tr>
										<th scope="col"><input id="ck_allCheck" class="checkbox" value="" type="checkbox" /></th>
										<th scope="col" class="d-none d-md-table-cell">번호</th>
										<%
											if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
											{
										%>
										<th scope="col">소속</th>
										<%
											}
											else
											{
										%>
										<th scope="col">회원구분</th>
										<%
											}
										%>
										<th scope="col">이름(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</th>
										<th scope="col" class="<%:ConfigurationManager.AppSettings["StudIDText"].Equals("학번") ? "d-none d-lg-table-cell" : "d-none" %>">학적</th>
										<th scope="col">신청일</th>
										<th scope="col">승인상태</th>
									</tr>
								</thead>
								<tbody id="LList">

									<%
										if ((Model.CourseLectureList.Count > 0))
										{
											foreach (var item in Model.CourseLectureList)
											{
									%>
											<tr>
												<td class="text-center">
													<input name="ck_userid" class="checkbox" value="<%: item.LectureNo %>" type="checkbox" />
												</td>
												<td class="text-center">
													<%: Model.CourseLectureList.IndexOf(item) + 1%>
												</td>
												<td class="text-center">
													<%
														if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
														{
													%>
													<%:item.AssignName %>
													<%
														}
														else
														{
													%>
													<%:item.GeneralUserName %>
													<%
														}
													%>
												</td>
												<td class="text-center">
													<%:item.HangulName %>(<%:item.UserID %>)
												</td>
												<td class="text-center <%:ConfigurationManager.AppSettings["StudIDText"].Equals("학번") ? "" : "d-none" %>">
													<%:item.HakjeokGubunName %>
												</td>
												<td>
													<%:DateTime.Parse(item.LectureRequestStartDay).ToString("yyyy-MM-dd") %>
												</td>
												<td>
													<%:item.LectureStatusName %>
												</td>
											</tr>

									<%
											}
										}
										else
										{
									%>
										<tr id="nodata">
											<td class="text-center" colspan="7">등록된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다.</td>
										</tr>

									<%
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-6">
					</div>
					<div class="col-6">
						<div class="text-right">
							<a href="/Lecture/CourseListAdmin" class="btn btn-secondary">목록</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var _ajax = new AjaxHelper();

		$(document).ready(function () {

			$("#btnSort").click(function () {
				window.location = '/Lecture/CourseDetailAdmin/<%:Model.Course.CourseNo%>/<%:Model.SortType != null ? Model.SortType : "UserID"%>';
			});

			$("#ck_allCheck").change(function () {
				if ($(this).is(":checked")) {
					$("input[name='ck_userid']").prop("checked", true);
				} else {
					$("input[name='ck_userid']").prop("checked", false);
				}
			});

		});

		function fnExcel() {
			if (<%:Model.CourseLectureList.Count%> > 0) {

				window.location = '/Lecture/CourseDetailAdminExcel/<%:Model.Course.CourseNo%>/<%:Model.SortType != null ? Model.SortType : "UserID"%>';
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function linkage() {
			if (!bootConfirm("수강신청을 연동하시겠습니까?"))
				return;

			_ajax.CallAjaxPost("/Lecture/LectureLink", { CourseNo: <%:Model.Course.CourseNo%>, ClassNo: <%:Model.Course.ClassNo%> }, "cbupdate");
		}

		function cbupdate() {
			var result = _ajax.CallAjaxResult();

			bootAlert("수강데이터를 연동하였습니다.");
			fnSubmit("mainForm");
		}

		function fnChangeLS(btnName, stateVal) {
			var lscount = $("#LList input.checkbox:checked").length;
			if (lscount < 1) {
				bootAlert("변경할 수강자를 선택해주세요.");
			}
			else  {
				var lenos = "";
				$.each($("#LList input.checkbox:checked"), function (i, c) {
					lenos += "," + $(c).val();
				});
				lenos = lenos.substr(1);

				bootConfirm(lscount + "명의 수강상태를 " + $("#" + btnName + "").text() + "로 변경하시겠습니까?", function () {
					_ajax.CallAjaxPost("/Lecture/ChangeLS", { lenos: lenos, LS: stateVal }, "fnStateupdate");
				})

			}
		}

		function fnStateupdate() {
			var result = _ajax.CallAjaxResult();

			if (result > 0) {
				bootAlert("수강상태를 변경했습니다.", function () {
					fnSubmit("mainForm");
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
			
		}

		function fnAddlecture() {
			window.location = '/Lecture/CourseDetailExcelUploadAdmin/<%:Model.Course.CourseNo%>';
		}

	</script>
</asp:Content>
