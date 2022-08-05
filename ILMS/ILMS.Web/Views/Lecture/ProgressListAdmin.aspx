<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
<form id="mainForm" method="post">
	<div id="content">
		<div class="card mt-4">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-6 col-md-3 col-lg-2 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
						<label for="ddlProgram" class="sr-only">과정</label>
						<select id="ddlProgram" name="ProgramNo" class="form-control">
						<%
						foreach (var item in Model.ProgramList)
						{
						%>
							<option value="<%:item.ProgramNo %>" <%:item.ProgramNo == Model.ProgramNo ? "selected" : "" %>><%:item.ProgramName %></option>
						<%
						}
						%>
						</select>
					</div>
					<div class="form-group col-6 col-md-3 col-lg-2">
						<label for="ddlTermNo" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
						<select id="ddlTermNo" name="TermNo" class="form-control">
						<%
						foreach (var item in Model.TermList)
						{
						%>
							<option value="<%:item.TermNo %>" <%:item.TermNo == Model.TermNo ? "selected" : "" %>><%:item.TermName %></option>
						<%
						}
						%>
						</select>
					</div>
					<div class="form-group col-12 col-md-10 col-lg-2">
						<label for="SearchText" class="sr-only">강좌명</label>
						<input type="text" class="form-control" name="SearchText" id="SearchText" placeholder="강좌명으로 검색" value="<%:Model.SearchText%>"/>
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">검색</span>
						</button>
					</div>
					<div class="form-group col-sm-auto <%: Model.CourseList.Count > 0 ? "" : "d-none" %>">
						<button type="button" class="btn btn-secondary" id="btnExcelSave">
							<i class="bi bi-download"></i> 엑셀 다운로드
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-12 mt-2">
			<%
			if (Model.CourseList.Count() == 0)
			{
			%>
				<div class="alert bg-light alert-light rounded text-center mt-2">
					<i class="bi bi-info-circle-fill"></i> 과정이 없습니다.
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
								총 <span class="text-primary font-weight-bold" id="spanTotalCount"><%:Model.PageTotalCount %></span> 건 
								
							</div>
							<div class="col-auto text-right">
								<div class="dropdown">
									<label for="pageRowSize" class="sr-only">건수</label>
									<select class="form-control form-control-sm form-control" name="pageRowSize" id="pageRowSize">
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
							<table class="table table-hover table-horizontal" summary="학습 상황 관리">
							<caption>학습 상황 관리 리스트</caption>
								<thead>
									<tr>
										<%
										if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
										{
										%>
											<th scope="col">과정</th>
										<%
										}
										%>
										
										<th scope="col">강의형태</th>
										<th scope="col">수강기간</th>
										<th scope="col""><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
										<th scope="col" class="d-none d-lg-table-cell">분반</th>
										<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
										<th scope="col">수강인원</th>
										<th scope="col">학습진도율</th>
										<th scope="col">관리<th>
									</tr>
								</thead>
								<tbody>
								<%
								foreach (var item in Model.CourseList)
								{
								%>
									<tr>
										<%
										if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
										{
										%>
											<td class="text-center"><%:item.ProgramName%></td>
										<%
										}
										%>
										
										<td class="text-center"><%:item.StudyTypeName %></td>
										<td class="text-center"><%:item.LectureStartDay %> ~ <%:item.LectureEndDay %></td>
										<td class="text-center"><%:item.SubjectName %></td>
										<td class="text-center d-none d-lg-table-cell"><%:item.ClassNo %></td>
										<td class="text-center"><%:item.ProfessorName != "" ? item.ProfessorName : "-" %></td>
										<td class="text-center"><%:item.StudentCount%></td>
										<td class="text-center"><%:item.InningRate%>%</td>
										<td class="text-center"><a class="font-size-20 text-primary" href="/Lecture/ProgressDetailAdmin?CourseNo=<%:item.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" title="상세보기"><i class="bi bi-card-list"></i></a></td>
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

			$("#spanTotalCount").html(fnAddCommas("B", "<%:Model.PageTotalCount%>"));
		});

		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/Lecture/ProgressListAdmin").submit();
		});

		$("#pageRowSize").change(function () {
			$("#mainForm").attr("action", "/Lecture/ProgressListAdmin").submit();
		});

		$("#btnExcelSave").click(function () {
			$("#mainForm").attr("action", "/Lecture/ProgressListExcel").submit();
		});

	</script>
</asp:Content>