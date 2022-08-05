<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<ul class="nav nav-tabs">
		<li class="nav-item"><a class="nav-link" href="CourseListAdmin">강좌별 수강현황</a> </li>
		<li class="nav-item"><a class="nav-link active show" href="LectureListAdmin">개인별 수강현황</a> </li>
		<li class="nav-item"><a class="nav-link" href="AttendanceListAdmin">개인별 출석확인</a> </li>
	</ul>
	<form action="/Lecture/LectureListExcelAdmin" id="ExcelForm" method="post">
		<input type="hidden" name="CourseLecture.TermNo" value="<%:Model.CourseLecture != null ? Model.CourseLecture.TermNo : 0 %>" />
		<input type="hidden" name="CourseLecture.AssignNo" value="<%:Model.CourseLecture != null ? Model.CourseLecture.AssignNo : "" %>" />
		<input type="hidden" name="CourseLecture.SearchText" value="<%:Model.CourseLecture != null ? Model.CourseLecture.SearchText : "" %>" />
	</form>
	<form action="/Lecture/LectureListAdmin" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-4 col-lg-3">
							<label for="ddlYearTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlYearTerm" name="CourseLecture.TermNo" class="form-control">
								<option value="0">전체</option>
								<%
									if (Model.TermList == null)
									{
								%>
								<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
								<% 
									}
									foreach (var item in Model.TermList)
									{
								%>
								<option value="<%:item.TermNo %>" <%if(item.TermNo.Equals(Model.CourseLecture == null ? 0 : Model.CourseLecture.TermNo)){ %>selected="selected" <% } %> ><%:item.TermName.ToString() %></option>
								<% 
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only">이름 / <%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></label>
							<input type="text" id="txtSearch" class="form-control" name="CourseLecture.SearchText" value="<%:!string.IsNullOrEmpty(Model.CourseLecture.SearchText) ? Model.CourseLecture.SearchText : "" %>" placeholder="이름 / <%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto <%: Model.CourseLectureList.Count > 0 ? "" : "d-none" %>">
							<input type="button" class="btn btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (!(Model.CourseLectureList.Count > 0))
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>검색된 과정이 없습니다.</div>
					<%
						}
						else
						{
					%>
					
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold"><%:string.Format("{0:#,###}" ,Model.CourseLectureList.Count > 0 ? Model.CourseLectureList[0].TotalCount : 0) %></span>건 
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
							<table class="table table-sm table-horizontal" summary="과제 제출 정보 목록">
								<thead>
									<tr>
										<th scope="col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
										<th scope="col" class="d-none d-md-table-cell">이름</th>
										<th scope="col" class=" <%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">소속</th>
										<th scope="col" class=" <%:ConfigurationManager.AppSettings["StudIDText"].Equals("학번") ? "" : "d-none" %>">학적</th>
										<th scope="col" class="<%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">과정</th>
										<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
										<th scope="col" class="d-none d-md-table-cell">년도/<%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
										<th scope="col" class="<%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : "d-none d-md-table-cell"%>">분반</th>
										<th scope="col" class="<%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">이수구분</th>
										<th scope="col" class="d-none d-md-table-cell">신청일</th>
										<th scope="col">신청상태</th>
									</tr>
								</thead>
								<tbody>

									<%
										foreach (var item in Model.CourseLectureList)
										{
									%>
									<tr>
										<td class="text-center">
											<%:item.UserID %>
										</td>
										<td class="text-center d-none d-md-table-cell">
											<%:item.HangulName %>
										</td>
										<td class="text-left <%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">
											<%:item.AssignName %>
										</td>
										<td class="text-center <%:ConfigurationManager.AppSettings["StudIDText"].Equals("학번") ? "" : "d-none" %>">
											<%:item.HakjeokGubunName %>
										</td>
										<td class="text-center <%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">
											 <%:item.ProgramName %>
										</td>
										<td class="text-left text-nowrap">
											<%:item.SubjectName %>
										</td>
										<td class="text-center d-none d-md-table-cell">
											<%:item.TermYear + "/" + item.TermQuarter %>
										</td>
										<td class="<%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : "d-none d-md-table-cell"%>">
											<%:item.ClassNo %>
										</td>
										<td class="text-center <%: ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">
											<%:item.FinishGubunName %>
										</td>
										<td class="d-none d-md-table-cell">
											<%:DateTime.Parse(item.LectureRequestStartDay).ToString("yyyy-MM-dd") %>
										</td>
										<td>
											<%:item.LectureStatusName %>
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
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});

		});

		<%--function fnExcel() {
			if (<%:Model.CourseLectureList.Count%> > 0) {
				var param1 = $("#ddlProgram").val();
				var param2 = $("#ddlYearTerm").val();

				window.location = "/Lecture/CourseListAdminExcel/" + param1.toString() + "/" + param2.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}

		}--%>

		function fnExcel() {
			if (<%:Model.CourseLectureList.Count%> > 0) {

				document.forms["ExcelForm"].submit();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}
	</script>
</asp:Content>
