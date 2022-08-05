<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
<form method="post" id="mainForm">
	<div id="content">
        <div>
            <ul class="nav nav-tabs nav">
                <li class="nav-item"><a href="AccessListTime" class="nav-link">시간별</a></li>
                <li class="nav-item"><a href="AccessListDay" class="nav-link">일별</a></li>
                <li class="nav-item"><a href="AccessListMonth" class="nav-link active">월별</a></li>
            </ul>
        </div>
		<div class="row">
			<div class="col-lg-12">
				<div class="card search-form mb-3">
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-6 col-sm-3 col-lg-3 col-xl-2">
								<label for="ddlTemp" class="sr-only">구분 :</label>
								<select name="Gubun" id="ddlTemp" class="form-control">
								<%	
								foreach (var code in Model.BaseCode)
								{
								%>
									<option value="<%:code.CodeValue %>" <%:Model.Gubun == code.CodeValue ? "selected" : ""%>><%:code.CodeName %></option>
								<%
								}
								%>
								</select>
							</div>

							<div class="form-group col-6 col-sm-3 col-lg-3 col-xl-2">
								<label for="ddlYear" class="sr-only">년도 :</label>
								<select id="ddlYear" name="Year" class="form-control">
								</select>
							</div>
							<div class="form-group col-sm-auto text-right">
								<button type="submit" id="btnSearch" class="btn btn-secondary">
									<span class="icon search">검색</span>
								</button>
							</div>
							<div class="form-group col-sm-auto">
								<button class="btn btn-secondary" id="btnExcelSave"><i class="bi bi-download"></i> 엑셀 다운로드</button>
							</div>
						</div>
					</div>
				</div>
				<div class="card">
					<div class="card-body p-0">
						<table class="highchart" data-graph-container-before="1" data-graph-type="column" style="display:none" data-graph-height="300">
							<caption style="font-weight:bold; color:#FF0000;">
								전체 접속자 수 : <%:Model.StatisticsList.Count() %>명
							</caption>
							<thead>
								<tr>
									<th style="vertical-align: middle" scope="col">
										시간
									</th>
									<th style="vertical-align: middle" scope="col">
										접속자 수
									</th>
								</tr>
							</thead>
							<tbody>
							<% 
							if(Model.StatisticsList.Count() > 0)
							{
							}
							%>
							<%
							for (int i = 0; i < 12; i++) {
							%>
							<tr>
								<td>
									<%:i +1%>월
								</td>
								<td>
									<%:Model.StatisticsList.Where(c => c.LoginDay.Month.Equals(i+1)).Count()%> 명
								</td>
							</tr>
							<%
							}
							%>
							</tbody>
						</table>
						<br />
						<hr />
						<br />
						<table class="highchart" data-graph-container-before="1" data-graph-type="column" style="display:none" data-graph-height="300" data-graph-color-1="#228E8E">
							<caption style="font-weight: bold; color: #FF0000;">
								전체 접속횟수 : <%:Model.HomeStatisticsList.Count()%>회
							</caption>
							<thead>
								<tr>
									<th style="vertical-align:middle" scope="col">
										시간
									</th>
									<th style="vertical-align:middle" scope="col">
										접속횟수
									</th>
								</tr>
							</thead>
							<tbody>
							<% 
							if(Model.HomeStatisticsList.Count() > 0)
							{
							}
							%>
							<%
							for (int i = 0; i < 12; i++) {
							%>
							<tr>
								<td>
									<%:i +1%>월
								</td>
								<td>
									<%:Model.HomeStatisticsList.Where(c => c.NonLoginDay.Month.Equals(i+1)).Count()%> 회
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
		</div>
	</div>
</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script src="/Common/js/highcharts.js"></script>
	<script src="/Common/js/highchartTable-min.js"></script>

	<script type="text/javascript">
		$(document).ready(function () {
			var option = "";
			var today = new Date();
			var year = today.getFullYear();

			for (var i = year - 10; i <= year; i++) {
				var selectitem = (i == <%:Model.Year%>) ? "selected" : "";
				
				option += "<option value='" + i + "' " + selectitem + ">" + i + "년" + "</option>";
			}

			$("#ddlYear").html(option);

			<%--하이차트--%>
			$('table.highchart').highchartTable();
		});
		
		$("#btnSearch").click(function () {
			$("#mainForm").attr("action", "/Account/AccessListMonth").submit();
		});

		$("#ddlTemp").change(function () {
			$("#mainForm").attr("action", "/Account/AccessListMonth").submit();
		});
		
		$("#btnExcelSave").click(function () {
			if (<%:Model.StatisticsList.Count()%> == 0 && <%:Model.HomeStatisticsList.Count()%> == 0) {
				bootAlert("다운로드할 내용이 없습니다.");
				return false;
			} else {
				$("#mainForm").attr("action", "/Account/StatisticsExcelSave").submit();
			}			
		});

	</script>
</asp:Content>