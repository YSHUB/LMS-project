<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
<form id="mainForm" method="post" action="/System/MenuAccessList">
	<div id="content">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a class="nav-link active" href="/System/MenuAccessList"><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %> 메뉴 활동 현황</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="/Board/ListAdmin/0/0">게시물 등록 현황</a>
			</li>
		</ul>
		<div class="card mt-4">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-6 col-md-3">
						<label for="ddlSemester" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
						<select id="ddlSemester" name="TermNo" class="form-control">
							<%
								if (Model.TermList == null)
								{
							%>
									<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
							<%
								}
								else
								{
									foreach (var item in Model.TermList)
									{
							%>
	
									<option value="<%:item.TermNo %>" <%:Model.TermNo == item.TermNo ? "selected" : "" %>><%:item.TermName%></option>
							<%
									}
								}
							%>
						</select>
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">검색</span>
						</button>
					</div>
					<div class="form-group col-sm-auto">
						<button class="btn btn-secondary" id="btnExcelSave"><i class="bi bi-download"></i> 엑셀 다운로드</button>
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
								총 <span class="text-primary font-weight-bold" id="spanTotalCount"><%:Model.PageTotalCount %></span> 건
								
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
							<table class="table table-horizontal" summary="<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %> 메뉴 활동 현황">
								<caption><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %> 메뉴 활동 현황</caption>
								<thead>
									<tr>										
										<th scope="col" class="text-nowrap"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
										<%
											if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
											{
										%>
											<th scope="col" class="text-nowrap">분반</th>
											<th scope="col" class="d-none d-md-table-cell">학점</th>
											<th scope="col" class="d-none d-md-table-cell">시간</th>
											<th scope="col" class="d-none d-md-table-cell">소속</th>
											<th scope="col" class="d-none d-md-table-cell">강의형태</th>
										<%
											}
										%>
										<th scope="col" class="text-nowrap">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
										<th scope="col" class="text-nowrap">퀴즈</th>
										<th scope="col" class="text-nowrap">과제</th>
										<th scope="col" class="text-nowrap">팀프로젝트</th>
										<th scope="col" class="text-nowrap">토론</th>
										<th scope="col" class="text-nowrap">강의OCW<br>적용현황</th>
										<th scope="col" class="text-nowrap">주별<br>학습의견</th>
									</tr>
								</thead>
								<tbody>
								<%
									foreach (var item in Model.StatisticsList)
									{
								%>
									<tr>
										
										<td class="text-left text-nowrap"><%:item.SubjectName %></td>
										<%
											if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
											{
										%>
											<td class="text-nowrap"><%:item.ClassNo %></td>
											<td class="text-nowrap d-none d-md-table-cell"><%:item.Credit %></td>
											<td class="text-nowrap d-none d-md-table-cell"><%:item.LecTime %></td>
											<td class="text-nowrap d-none d-md-table-cell"><%:item.AssignName %></td>
											<td class="text-nowrap d-none d-md-table-cell"><%:item.StudyTypeName %></td>
										<%
											}
										%>
										<td class=""><%:item.ProNameList %></td>
										<td class="text-nowrap"><%:item.ExamCount %></td>
										<td class="text-nowrap"><%:item.HomeworkCount %></td>
										<td class="text-nowrap"><%:item.ProjectCount %></td>
										<td class="text-nowrap"><%:item.DiscussionCount %></td>
										<td class="text-nowrap"><%:item.CourseOcwCount %></td>
										<td class="text-nowrap"><%:item.CourseOcwOpinionCount %></td>
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
			<%--숫자 콤마 처리--%>
			$("#spanTotalCount").html(fnAddCommas("B", "<%:Model.PageTotalCount%>"));
		});

		$("#btnExcelSave").click(function () {
			if (<%:Model.StatisticsList.Count()%> <= 0) {
				bootAlert("다운로드할 내용이 없습니다.");
				return false;
			} else {
				document.forms[0].action = "/System/MenuAccessExcel";
				document.forms[0].submit();

			}
		});

		$("#pageRowSize").change(function () {
			$("#mainForm").attr("action", "/System/MenuAccessList/").submit();
		});

		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/System/MenuAccessList/").submit();
		});

	</script>
</asp:Content>