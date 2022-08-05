<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.StatisticsViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3">
							<label for="ddlYear" class="sr-only">년도</label>
							<select id="ddlYear" name="Year" class="form-control">
							</select>
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto">
							<button id="btnExcelSave" class="btn btn-secondary">
								<i class="bi bi-download"></i> 엑셀 다운로드
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
				<%
				if (Model.StatisticsList.Count() == 0) {
				%>
					<div class="alert bg-light alert-light rounded text-center mt-2">
						<i class="bi bi-info-circle-fill"></i> 통계가 없습니다.
					</div>
				<%
				}
				else
				{
				%>
					<div class="card">
						<div class="card-body py-0">
							<div class="table-responsive d-none d-md-block">
								<table class="table table-sm table-horizontal" summary="컨텐츠 통계">
									<caption>컨텐츠 통계</caption>
									<thead>
										<tr>
											<th>구분</th>
											<th>1월</th>
											<th>2월</th>
											<th>3월</th>
											<th>4월</th>
											<th>5월</th>
											<th>6월</th>
											<th>7월</th>
											<th>8월</th>
											<th>9월</th>
											<th>10월</th>
											<th>11월</th>
											<th>12월</th>
											<th>소계</th>
										</tr>
									</thead>
									<tbody>
									<%
									foreach (var item in Model.StatisticsList) {
									%>
									
										<tr class="data">
											<td class="text-center text-nowrap"><%:item.OcwStatisticsGubun %></td>
											<td class="text-center text-nowrap"><%:item.JanCnt %></td>
											<td class="text-center text-nowrap"><%:item.FebCnt %></td>
											<td class="text-center text-nowrap"><%:item.MarCnt %></td>
											<td class="text-center text-nowrap"><%:item.AprCnt %></td>
											<td class="text-center text-nowrap"><%:item.MayCnt %></td>
											<td class="text-center text-nowrap"><%:item.JunCnt %></td>
											<td class="text-center text-nowrap"><%:item.JulCnt %></td>
											<td class="text-center text-nowrap"><%:item.AguCnt %></td>
											<td class="text-center text-nowrap"><%:item.SepCnt %></td>
											<td class="text-center text-nowrap"><%:item.OctCnt %></td>
											<td class="text-center text-nowrap"><%:item.NovCnt %></td>
											<td class="text-center text-nowrap"><%:item.DecCnt %></td>
											<td class="text-center text-nowrap"><%:item.TotalCount %></td>
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
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			
			$(function () {
				var option = "";
				var today = new Date();
				var year = today.getFullYear();

				for (var i = year - 10; i <= year; i++) {
					var selectitem = (i == <%:Model.Year%>) ? "selected" : "";
					option += "<option value='" + i + "' " + selectitem + ">" + i + "년" + "</option>";
				}

				$("#ddlYear").html(option);
			});
		});
		
		$("#btnSearch").click(function () {
			document.forms[0].action = "/OCW/Statistics/0";
			document.forms[0].submit();
		});
		
		$("#btnExcelSave").click(function () {
			if (<%=Model.StatisticsList.Count()%> <= 0) {
				bootAlert("다운로드할 내용이 없습니다.");
				return false;
			} else {
				document.forms[0].action = "/OCW/OcwStatisticsExcel/0";
				document.forms[0].submit();
			}
		});

	</script>
</asp:Content>