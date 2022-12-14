<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Lecture/License" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3 col-lg-2 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<%="" %>
							<label for="ddlProgram" class="sr-only">과정</label>
							<select id="ddlProgram" name="License.ProgramNo" class="form-control">
								<%
									foreach (var item in Model.ProgramList)
									{
								%>
								<option value="<%:item.ProgramNo%>" <%if (item.ProgramNo.Equals(Model.License == null ? 0 : Model.License.ProgramNo))
									{ %>
									selected="selected" <%} %>><%:item.ProgramName%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-6 col-md-3 col-lg-2">
							<label for="ddlYearTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlYearTerm" name="License.TermNo" class="form-control">
								<%
									if (Model.TermList == null)
									{
								%>
								<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
								<% }
									foreach (var item in Model.TermList)
									{
								%>
								<option value="<%:item.TermNo %>" <%if (item.TermNo.Equals(Model.License == null ? 0 : Model.License.TermNo)) { %> selected="selected" <% } %> ><%:item.TermName.ToString() %></option>
								<% 
									}
								%>
							</select>
						</div>
						<div class="form-group col-6 col-md-3 col-lg-2">
							<%="" %>
							<label for="ddlLicense" class="sr-only">자격증</label>
							<select id="ddlLicense" name="License.CertCode" class="form-control">
								<option value="">선택</option>
								<%
									foreach (var item in Model.BaseCode)
									{
								%>
								<option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.License == null ? "" : Model.License.CertCode))
									{ 
								%>
									selected="selected" <%} %>><%:item.CodeName%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</label>
							<input type="text" id="txtSearch" class="form-control" name="License.SubjectName" value="<%:!string.IsNullOrEmpty(Model.License.SubjectName) ? Model.License.SubjectName : "" %>" placeholder="<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (!(Model.LicenseList.Count > 0))
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>강좌가 없습니다.</div>
					<%
						}
						else
						{
					%>
					<small class="d-inline-block">총 <span class="text-primary font-weight-bold"><%:Model.LicenseList.Count > 0 ? Model.LicenseList[0].TotalCount : 0 %></span>건 </small>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto">
									<input type="button" class="btn btn-sm btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
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
								<table class="table table-hover table-sm table-striped table-horizontal" summary="과제 제출 정보 목록">
									<thead>
										<tr>
											<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
											<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
											<th scope="col">성명(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</th>
											<th scope="col">자격증</th>
											<th scope="col" class="d-none d-lg-table-cell">취득일자</th>
											<th scope="col" class="d-none d-md-table-cell">자격증사본</th>
										</tr>
									</thead>
									<tbody>

										<%
											foreach (var item in Model.LicenseList)
											{
										%>
										<tr>
											<td class="text-left">
												<%:item.SubjectName %>
											</td>
											<td class="text-center">
												<%:item.ProfessorName %>
											</td>
											<td class="text-center">
												<%:item.HangulName %>
											</td>
											<td class="text-left">
												<%:item.CertName %>
											</td>
											<td class="text-center d-none d-lg-table-cell">
												<%:item.CertDate %>
											</td>
											<td class="text-center d-none d-md-table-cell">
												<%
													if (item.FileGroupNo > 0)
													{
												%>
												<a href="/Common/FileDownLoad/<%:item.FileNo%>" class="font-size-20" title="제출파일 다운로드"><i class="bi bi-file-earmark-arrow-down"></i></a>
												<%}
													else
													{
												%> - 
												<%
													}
												%>
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

		function fnExcel() {
			if (<%:Model.LicenseList.Count%> > 0) {
				var param1 = $("#ddlProgram").val();
				var param2 = $("#ddlYearTerm").val();
				var param3 = $("#txtSearch").val();
				var param4 = $("#ddlLicense").val();

				window.location = "/Lecture/LicenseExcel/" + param1.toString() + "/" + param2.toString() + "/" + param3 + "/" + param4;
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

	</script>
</asp:Content>
