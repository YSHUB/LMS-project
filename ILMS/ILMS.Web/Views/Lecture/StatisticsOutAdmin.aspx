<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
<form id="mainForm" method="post">
	<div id="content">
		<div class="card mt-4">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-6 col-md-3">
						<label for="ddlSemester" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
						<select id="ddlSemester" name="TermNo" class="form-control">
						<%
						foreach (var item in Model.TermList)
						{
						%>
							<option value="<%:item.TermNo %>" <%:Model.TermNo == item.TermNo ? "selected" : ""%>><%:item.TermName %></option>
						<%
						}
						%>
						</select>
					</div>
					<div class="form-group col-6 col-md-4">
						<label for="ddlSubject" class="sr-only">강좌</label>
						<select id="ddlSubject" name="CourseNo" class="form-control">
						<%
						foreach (var item in Model.CourseList)
						{
						%>
							<option value="<%:item.CourseNo %>" <%:Model.CourseNo == item.CourseNo ? "selected" : ""%>><%:item.SubjectName %></option>
						<%
						}

						if (Model.CourseList.Count() == 0) {
						%>
							<option value=''>이수한 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>이 없습니다.</option>
						<%
						}
						%>
						</select>
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">
								검색
							</span>
						</button>
					</div>
					<div class="form-group col-sm-auto <%: Model.StatisticsList.Count > 0 ? "" : "d-none" %>">
						<button class="btn btn-secondary" id="btnExcelSave"><i class="bi bi-download"></i> 엑셀 다운로드</button>
					</div> 
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-12 mt-2">
				<h3 class="title04">이수현황</h3>
				<div class="bg-light alert">
					<ol class="list-style01 mb-0">
						<li>등록차시는 강의컨텐츠가 등록된 차시만 카운트 됩니다.</li>
						<li>강의이수완료는 소속별 수강 대상 수강생 중 등록된 차시 모두를 이수한 수강생만 카운트 됩니다.</li>
						<li>퀴즈 응시는 수강생이 한번이라도 퀴즈 페이지로 접속하여 응시일자가 생성된 경우 카운트 됩니다.</li>
						<li class="text-success">퀴즈목록이 5개 미만인 경우 퀴즈가 없거나 5개 미만임을 의미하며 주차/생성일시 순서로 상위 5개만 가져옵니다.</li>
					</ol>
				<%
					if(Model.ExamList.Count > 0)
					{
				%>
					<ul>
						<li class="text-success">&nbsp;※ 퀴즈 목록</li>
				<%
					foreach (var item in Model.ExamList)
					{
				%>
						<li class="text-success">&nbsp;&nbsp;- 퀴즈 <%:item.RowNum %> : <%:item.ExamTitle %></li>
				<%
					}
				%>
					</ul>
				<%
					}
				%>
				</div>
				<!--나중에 처리하기-->
			<%
			if (Model.StatisticsList.Count() == 0)
			{
			%>
				<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 검색 결과가 없습니다.</div>
			<%
			}
			else
			{
			%>
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover table-horizontal" id="programTable">
								<caption>프로그램 이수 현황</caption>
								<thead>
									<tr>
										<th class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>">소속</th>
										<th class="text-nowrap">수강<br />인원</th>
										<th class="text-nowrap">등록<br />차시</th>
										<th class="text-nowrap">강의<br />이수<br />완료자</th>
										<th class="text-nowrap">강의<br />이수<br />완료율</th>
										<th class="text-nowrap">퀴즈(1)<br />응시자</th>
										<th class="text-nowrap">퀴즈(1)<br />응시율</th>
										<th class="text-nowrap">퀴즈(2)<br />응시자</th>
										<th class="text-nowrap">퀴즈(2)<br />응시율</th>
										<th class="text-nowrap">퀴즈(3)<br />응시자</th>
										<th class="text-nowrap">퀴즈(3)<br />응시율</th>
										<th class="text-nowrap">퀴즈(4)<br />응시자</th>
										<th class="text-nowrap">퀴즈(4)<br />응시율</th>
										<th class="text-nowrap">퀴즈(5)<br />응시자</th>
										<th class="text-nowrap">퀴즈(5)<br />응시율</th>
									</tr>
								</thead>
								<tbody>
								<%
								foreach (var item in Model.StatisticsList)
								{
								%>
									<tr>
										<td class="text-left text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>"><%:item.AssignName %></td>
										<td class="text-center"><%:item.PersonCount %></td>
										<td class="text-center"><%:item.EnrollCourse %></td>
										<td class="text-center"><%:item.AttendanceCourse %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.AttendanceCourseRate) == "0.00" ? "-" : Convert.ToString(item.AttendanceCourseRate) %></td>
										<td class="text-center"><%:item.TakeExaminee1 %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.TakeExamineeRate1) == "0.00" ? "-" : Convert.ToString(item.TakeExamineeRate1) %></td>
										<td class="text-center"><%:item.TakeExaminee2 %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.TakeExamineeRate2) == "0.00" ? "-" : Convert.ToString(item.TakeExamineeRate2) %></td>
										<td class="text-center"><%:item.TakeExaminee3 %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.TakeExamineeRate3) == "0.00" ? "-" : Convert.ToString(item.TakeExamineeRate3) %></td>
										<td class="text-center"><%:item.TakeExaminee4 %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.TakeExamineeRate4) == "0.00" ? "-" : Convert.ToString(item.TakeExamineeRate4) %></td>
										<td class="text-center"><%:item.TakeExaminee5 %>/<%:item.PersonCount %></td>
										<td class="text-center"><%:Convert.ToString(item.TakeExamineeRate5) == "0.00" ? "-" : Convert.ToString(item.TakeExamineeRate5) %></td>
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
	</div>
</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		
		var ajaxHelper = new AjaxHelper();

		$("#ddlSemester").change(function () {
			ajaxHelper.CallAjaxPost("/Lecture/SubjectList", { param1: $("#ddlSemester").val() }, "CompleteSubjectList");
		});

		function CompleteSubjectList() {

			var ajaxResult = ajaxHelper.CallAjaxResult();
			var innerHtml = "";

			if (ajaxResult.length > 0) {
				for (var i = 0; i < ajaxResult.length; i++) {
					innerHtml += "<option value='" + ajaxResult[i].CoursNo + "'>";
					innerHtml += ajaxResult[i].SubjectName;
					innerHtml += "</option>";
				}
			}
			else {
				innerHtml += "<option value=''>" + "이수한 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>이 없습니다." + "</option>"
			}

			$("#ddlSubject").html(innerHtml);
		}

		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/Lecture/StatisticsOutAdmin").submit();
		});

		$("#btnExcelSave").click(function () {
			$("#mainForm").attr("action", "/Lecture/MenuAdminExcel").submit();
		});

	</script>
</asp:Content>