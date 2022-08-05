<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">자격취득등록</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Homework/RegisterLicense/<%:ViewBag.Course.CourseNo %>" name="mainForm" id="mainForm" method="post" enctype="multipart/form-data">
		<div class="p-4">
			<h4 class="title04">수강생 정보</h4>
			<div class="card">
				<div class="card-body">
					<ul class="list-inline-style03">
						<li class="list-inline-item">
							<strong class="pr-2"><%:ConfigurationManager.AppSettings["StudIDText"].ToString()%></strong>
							<span><%:Model.HomeworkSubmit.UserID %></span>
						</li>
						<li class="list-inline-item bar-vertical"></li>
						<li class="list-inline-item">
							<strong class="pr-2">이름</strong>
							<span><%:Model.HomeworkSubmit.HangulName %></span>
						</li>
					</ul>
					<input type="hidden" name="License.CourseNo" value="<%:ViewBag.Course.CourseNo %>" />
					<input type="hidden" name="License.HomeworkNo" value="<%:Model.HomeworkSubmit.HomeworkNo %>" />
					<input type="hidden" name="License.UserNo" value="<%:Model.HomeworkSubmit.SubmitUserNo %>" />
					<input type="hidden" name="License.UpdateCertCode" value="<%:Model.License != null ? Model.License.CertCode : "" %>" />
				</div>
			</div>
			<h4 class="title04">자격취득 정보</h4>
			<div class="card">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-12 col-md-3">
							<label class="form-label" for="">자격증 종류 <span class="text-danger">*</span></label>
							<select class="form-control" name="License.CertCode">
								<% 
									foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CFCD")).ToList())
									{
								%>
								<option value="<%:item.CodeValue %>" <%if (item.CodeValue.Equals(Model.License == null ? "" : Model.License.CertCode))
									{ %> selected="selected" <%} %>><%:item.CodeName%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-3">
							<label class="form-label" for="">취득일자 <span class="text-danger">*</span></label>
							<input type="text" class="form-control datepicker text-center" id="getDate" name="License.CertDate" value="<%:Model.License != null ? Model.License.CertDate : "" %>"">
						</div>
						<div class="form-group col-12 col-md-6">
							<label class="form-label" for="">자격증 사본 <span class="text-danger">*</span></label>
							<small class="text-muted">jpg, gif, png, bmp, pdf 등 이미지 파일로 업로드</small>
							<% Html.RenderPartial("./Common/File"
							, Model.FileList
							, new ViewDataDictionary {
							{ "name", "FileGroupNo" },
							{ "fname", "LicenseFile" },
						    { "value", Model.License == null ? 0 : Model.License.FileGroupNo },
							{ "fileDirType", "License"},
							{ "filecount", 1 }, { "width", "100" }, {"isimage", 1 } }); %>
						</div>
					</div>
				</div>
			</div>
			<div class="text-right">
				<button class="btn btn-primary" title="등록" id="btnSave">저장</button>
			</div>
			<h4 class="title04">자격취득 등록내역</h4>
			<div class="card">
				<div class="card-body py-0">
					<table class="table table-hover" summary="자격증 취득 내역">
						<caption>자격증 취득 내역</caption>
						<thead>
							<tr>
								<th>자격증 종류</th>
								<th>취득일자</th>
								<th>자격증 사본</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (Model.LicenseList.Count > 0)
								{
									foreach(var item in Model.LicenseList)
									{
								%>
								<tr>
									<td class="text-center"><%:item.CertName %></td>
									<td class="text-center"><%:item.CertDate %></td>
									<td class="text-center">
										<%
											if (item.FileNo > 0)
											{
										%>
											<a href="/Common/FileDownLoad/<%:item.FileNo%>" class="text-primary btn btn-link"><i class="bi bi-download"></i></a>
										<%
											}
											else
											{
										%>-
										<%
											}
										%>
									</td>
									<td class="text-center">
										<a href="/Homework/RegisterLicense/<%:ViewBag.Course.CourseNo %>/<%:Model.HomeworkSubmit.HomeworkNo %>/<%:Model.HomeworkSubmit.SubmitUserNo %>/<%:string.IsNullOrEmpty(item.CertCode) ? "" : item.CertCode %>" class="text-primary btn btn-link"><i class="bi bi-pencil-square"></i></a>
									</td>
								</tr>
								<%
									}
								}
								else
								{
							%>
							<tr>
								<td colspan="4" class="text-center">등록된 자격증이 없습니다. </td>
							</tr>
							<%
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			fnCalendar("getDate", "TODAY");

			$("#btnSave").click(function () {
				if (confirm("저장하시겠습니까?")) {
					document.forms["mainForm"].submit();
				}
			});

			<%
				if (!string.IsNullOrEmpty(Model.ErrorMessage))
				{
			%>
				alert('<%:Model.ErrorMessage%>');
			<%
				}
			%>

		});
	</script>
</asp:Content>
