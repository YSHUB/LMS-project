<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-2">
							<label for="ddlSemester" class="sr-only">구분</label>
							<select id="ddlSemester" name="TermNo" class="form-control">
							<%
							foreach (var item in Model.TermList)
							{
							%>
								<option value="<%:item.TermNo%>" <%:Model.TermNo == item.TermNo ? "selected" : ""%>><%:item.TermName %></option>
							<%
							}
							%>
							</select>
						</div>
						<div class="form-group col-6 col-md-2">
							<label for="txtSubject" class="sr-only"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</label>
							<input type="text" id="txtSubject" name="SearchSubject" class="form-control" placeholder="<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명" value="<%:Model.SearchSubject %>"/>
						</div>
						<div class="form-group col-6 col-md-2">
							<label for="txtName" class="sr-only">성명</label>
							<input type="text" id="txtName" name="SearchName" class="form-control" placeholder="성명" value="<%:Model.SearchName %>"/>
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">
									검색
								</span>
							</button>
							<button class="btn btn-secondary <%: Model.StatisticsList.Count > 0 ? "" : "d-none" %>" id="btnExcelSave"><i class="bi bi-download"></i> 엑셀 다운로드</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
				<%
				if (Model.StatisticsList.Count() == 0)
				{
				%>
				<div class="alert bg-light alert-light rounded text-center mt-2">
					<i class="bi bi-info-circle-fill"></i> 검색 결과가 없습니다.
				</div>
				<%
				}
				else
				{
				%>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold" id="spanTotalCount"><%:Model.PageTotalCount%></span>건 
								</div>
								<div class="col-auto text-right">
									<div class="dropdown">
										<label for="pageRowSize" class="sr-only">건수</label>
										<select class="form-control form-control-sm" name="pageRowSize" id="pageRowSize">
											<option value="10" <%:Model.PageRowSize.Equals(10) ? "selected" : "" %>>10건</option>
											<option value="20" <%:Model.PageRowSize.Equals(20) ? "selected" : "" %>>20건</option>
											<option value="50" <%:Model.PageRowSize.Equals(50) ? "selected" : "" %>>50건</option>
											<option value="100" <%:Model.PageRowSize.Equals(100) ? "selected" : "" %>>100건</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover table-horizontal">
								<caption><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>별 이수현황 통계리스트</caption>
									<thead>
										<tr>
											<th scope="col" class="text-nowrap">연번</th>
											<th scope="col" class="text-nowrap"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></th>
											<th scope="col" class="text-nowrap">분반</th>
											<th scope="col" class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>">소속</th>
											<th scope="col" class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : "" %>">구분</th>
											<th scope="col" class="text-nowrap">아이디</th>
											<th scope="col" class="text-nowrap">성명</th>
											<th scope="col" class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>">학적</th>
											<th scope="col" class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : "" %>">이메일</th>
											<th scope="col" class="text-nowrap">수강현황</th>
											<th scope="col" class="text-nowrap">강의이수율</th>
											<th scope="col" class="text-nowrap">퀴즈현황</th>
											<th scope="col" class="text-nowrap">퀴즈이수율</th>
										</tr>
									</thead>
									<tbody>
									<%
									foreach(var item in Model.StatisticsList)
									{
									%>
										<tr>
											<td class="text-center "><%:item.RowNum %></td>
											<td class="text-left"><%:item.SubjectName %></td>
											<td class="text-center"><%:item.ClassNo %></td>
											<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>"><%:item.AssignName %></td>
											<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : "" %>"><%:item.GeneralUserCode %></td>
											<td class="text-left"><%:item.UserID %></td>
											<td class=" "><%:item.HangulName %></td>

											<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>"><%:item.HakjeokGubunName %></td>
											<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : "" %>"><%:item.Email %></td>
											<td class="text-center"><%:item.AttendanceCourse %>/<%:item.EnrollCourse %></td>
											<td class="text-center"><%:Convert.ToString(item.CourseRate) != "0.00" ? item.CourseRate + "%" : "-" %></td>
											<td class="text-center"><%:item.AttendanceQuiz %>/<%:item.EnrollQuiz %></td>
											<td class="text-center"><%:Convert.ToString(item.QuizRate) != "0.00" ? item.QuizRate + "%" : "-"%></td>
										</tr>
									<%
									}	
									%>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
				<%
				}
				%>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		$(document).ready(function () {
			$("#spanTotalCount").html(fnAddCommas("B", "<%:Model.PageTotalCount%>"));
		});

		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/Lecture/StatisticsListAdmin").submit();
		});

		$("#btnExcelSave").click(function () {
			$("#mainForm").attr("action", "/Lecture/StudentExcel").submit();
		});

		$("#pageRowSize").change(function () {
			$("#mainForm").attr("action", "/Lecture/StatisticsListAdmin").submit();
		});

	</script>
</asp:Content>