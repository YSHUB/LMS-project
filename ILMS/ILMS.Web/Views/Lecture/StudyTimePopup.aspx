<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="content">
		<div class="col-12">
			<%
	if (Model.CourseInning == null)
	{
			%>
			<div class="alert alert-info">
				<div class="text-center">
					<p class="text-info mb-0">학습현황이 존재 하지 않습니다.</p>
				</div>
            </div>
			<%
	}
	else
	{
			%>
			<div class="card">
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>주차</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.CourseInning.Week %></dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>차시</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.CourseInning.InningSeqNo %></dd>
					</dl>
				</div>
			</div>
			<div class="card">
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습기간 인정 이력">
							<caption>학습페이지 상세 - 학습기간 인정 이력</caption>
							<thead>
								<tr>
									<th scope="col">학습일</th>
									<th scope="col">학습기기</th>
									<th scope="col">학습시간(초)</th>
								</tr>
							</thead>
							<tbody id="tbTime">
								<%
									if (Model.StudyInningInfo.Count > 0)
									{
										foreach (var item in Model.StudyInningInfo)
										{
								%>
								<tr>
									<td class="text-center"><%: item.StudyDevice == 9 ? "소계" : item.StudyDate %></td>
									<td class="text-center"><%: item.StudyDevice == 1 ? "PC" : item.StudyDevice == 2 ? "Mobile" : ""%></td>
									<td class="text-center"><%: item.StudyTime%></td>
								</tr>
								<%
										}
									}
									else
									{
								%>
								<tr><td class="text-center" colspan="3">데이터가 존재하지 않습니다. </td></tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="card">
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습기간 외 이력">
							<caption>학습페이지 상세 - 학습기간 외 이력</caption>
							<thead>
								<tr>
									<th scope="col">학습일</th>
									<th scope="col">학습기기</th>
									<th scope="col">학습시간(초)</th>
								</tr>
							</thead>
							<tbody id="tbTime2">
								<%
									if (Model.StudyInningList.Count > 0)
									{
										foreach (var item in Model.StudyInningList)
										{
								%>
								<tr>
									<td class="text-center"><%: item.StudyDevice == 9 ? "소계" : item.StudyDate %></td>
									<td class="text-center"><%: item.StudyDevice == 1 ? "PC" : item.StudyDevice == 2 ? "Mobile" : ""%></td>
									<td class="text-center"><%: item.StudyTime%></td>
								</tr>
								<%
										}
									}
									else
									{
								%>
								<tr><td colspan="3" class="text-center">데이터가 존재하지 않습니다.</td></tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>
