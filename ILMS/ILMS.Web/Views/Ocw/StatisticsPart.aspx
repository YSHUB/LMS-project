<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<div id="content">
			<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link" id="UserTab" href="/OCW/StatisticsUser/0">컨텐츠기준</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link active" id="PartTab" href="/OCW/StatisticsPart/0">참여기준</a>
				</li>
			</ul>
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-2">
							<label for="ddlGubun" class="sr-only">구분</label>
							<select id="ddlGubun" name="Gubun" class="form-control">
								<option value="">전체</option>
							<%
							foreach (var item in Model.BaseCode)
							{
							%>
								<option value="<%:item.CodeValue %>" <%:Model.Gubun == item.CodeValue ? "selected" : "" %>><%:item.CodeName %></option>
							<%
							}
							%>
							</select>
						</div>
						<div class="form-group col-6 col-md-2">
							<label for="ddlYear" class="sr-only">년도</label>
							<select id="ddlYear" name="Year" class="form-control">
							</select>
						</div>
						<div class="form-group col-6 col-md-2">
							<label for="ddlMonth" class="sr-only">월</label>
							<select id="ddlMonth" name="Month" class="form-control">
							</select>
						</div>
						<div class="form-group col-6 col-md-2">
							<label for="ddlSort" class="sr-only">정렬순서</label>
							<select id="ddlSort" name="Sort" class="form-control">
								<option value="USING" <%:Model.Sort == "USING" ? "selected" : "" %>>조회순</option>
								<option value="OPINION" <%:Model.Sort == "OPINION" ? "selected" : "" %>>댓글 등록순</option>
								<option value="LIKE" <%:Model.Sort == "LIKE" ? "selected" : ""%>>추천 클릭순</option>
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
				if (Model.StatisticsList.Count() < 0)
				{
				%>
					<div class="alert bg-light alert-light rounded text-center mt-2">
						<i class="bi bi-info-circle-fill"></i> 검색결과가 없습니다.
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
									총 <span class="text-primary font-weight-bold" id="totalCount"><%:Model.PageTotalCount %></span>건
									
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
								<table class="table table-hover table-horizontal" summary="컨텐츠통계-참여기준">
									<caption>컨텐츠통계-참여기준</caption>
									<thead>
										<tr>
											<th scope="col" class="text-nowrap">연번</th>
											<th scope="col" class="text-nowrap">구분</th>
											<%
											if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
											{
											%>
											<th scope="col" class="text-nowrap">소속</th>
											<%
											}
											%>
											<th scope="col" class="text-nowrap">성명(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</th>
											<th scope="col" class="text-nowrap">콘텐츠 조회건수</th>
											<th scope="col" class="text-nowrap">댓글 등록건수</th>
											<th scope="col" class="text-nowrap">추천 클릭건수</th>
										</tr>
									</thead>
									<tbody>
									<%
									foreach (var item in Model.StatisticsList)
									{
									%>	<tr>
											<td class=""><%:item.RowNum %></td>
											<td class=""><%:item.UserTypeName %></td>
											<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>"><%:item.AssignName %></td>
											<td class=""><%:item.UserName %></td>
											<%--<td class="text-center "><%:item.OcwCount %></td>
											<td class="text-center "><%:item.UsingCount%></td>
											<td class="text-center "><%:item.LikeCount %></td>--%>
											<td class="text-center "><%:item.UsingCount %></td>
											<td class="text-center "><%:item.OpinionCount%></td>
											<td class="text-center "><%:item.LikeCount %></td>
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

			<%--년도, 월 바인딩--%>
			var option = "";
			var today = new Date();
			var year = today.getFullYear();

			for (var i = year - 5; i <= year ; i++) {
				var selectitem = (i == "<%:Model.Year%>") ? "selected" : "";

				option += "<option value='" + i + "'" + selectitem + ">" + i + "년</option>";
			}

			$("#ddlYear").html(option);

			fnAppendMonth("ddlMonth");
			$("#ddlMonth option[value=" + "<%:Model.Month%>" + "]").attr("selected", "selected");

			<%--콤마 처리--%>
			$("#totalCount").html(fnAddCommas("B", "<%:Model.PageTotalCount%>"));

		});

		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/Ocw/StatisticsPart/0").submit();
		});

		$("#btnExcelSave").click(function () {
			$("#mainForm").attr("action", "/Ocw/StatisticsExcel/0/P").submit();
		});

		$("#pageRowSize").change(function () {
			$("#mainForm").attr("action", "/Ocw/StatisticsPart/0").submit();
		});

	</script>
</asp:Content>