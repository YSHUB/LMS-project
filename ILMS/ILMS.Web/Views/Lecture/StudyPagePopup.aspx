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
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>총 페이지 수</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.CourseInning.TotalContentPage %></dd>
						<dt class="col-3 col-md-2 text-dark text-nowrap"><i class="bi bi-dot"></i>미학습 페이지 수</dt>
						<dd class="col-9 col-md-4 pl-4"><%:Model.CourseInning.TotalContentPage - Model.StudyInningInfo.Count%></dd>
					</dl>
				</div>
			</div>
			<div class="card">
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-hover table-horizontal" summary="학습완료여부">
							<caption>학습페이지 상세 - 학습완료여부</caption>
							<thead>
								<tr>
									<th scope="col">페이지</th>
									<th scope="col">학습완료여부</th>
								</tr>
							</thead>
							<tbody>
								<%
									for (int i = 1; i <= Model.CourseInning.TotalContentPage; i++)
									{
								%>
								<tr>
									<td class="text-center"><%:i.ToString() %></td>
									<td class="text-center">X</td>
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
		<%
			}
		%>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>
