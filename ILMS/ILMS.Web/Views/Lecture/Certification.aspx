<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Lecture/Certification" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<%="" %>
						<div class="form-group col-6 col-md-4 col-lg-3 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<label for="ddlYearTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlYearTerm" name="Course.TermNo" class="form-control">
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
								<option value="<%:item.TermNo %>" <%if (item.TermNo.Equals(Model.Course == null ? 0 : Model.Course.TermNo)) { %> selected="selected" <% } %> ><%:item.TermName.ToString() %></option>
								<% 
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "col-lg-2" : "col-lg-3" %> ">
							<label for="txtSearch" class="sr-only">강좌명</label>
							<input type="text" id="txtSearch" class="form-control" name="Course.SubjectName" value="<%:Model.Course != null ? Model.Course.SubjectName : "" %>" placeholder="강좌명">
						</div>
						<div class="form-group col-12 col-md-10 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "col-lg-2" : "col-lg-3" %>">
							<label for="txtProfessor" class="sr-only"><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명</label>
							<input type="text" id="txtProfessor" class="form-control" name="Course.ProfessorName" value="<%:Model.Course != null ? Model.Course.ProfessorName : "" %>" placeholder="<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명">
						</div>
						<div class="form-group col-12 col-md-10 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "col-lg-2" : "col-lg-3" %>">
							<label for="txtUserID" class="sr-only"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></label>
							<input type="text" id="txtUserID" class="form-control" name="Course.UserID" placeholder="<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>">
						</div>
						<div class="form-group col-6 col-md-4 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "col-lg-2" : "col-lg-3" %>">
							<label for="ddlIsPass" class="sr-only">상태</label>
							<select id="ddlIsPass" name="Course.IsPass" class="form-control">
								<option value="-1">선택</option>
								<option value="1">수료</option>
								<option value="2">미수료</option>
								<option value="0">처리전</option>
							</select>
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>

						<div class="form-group col-sm-auto <%: Model.CourseList.Count > 0 ? "" : "d-none" %> ">
							<input type="button" class="btn btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (!(Model.CourseList.Count > 0))
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>강좌가 없습니다.</div>
					<%
						}
						else
						{
					%>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold"><%:Model.CourseList.Count > 0 ? Model.CourseList[0].TotalCount : 0 %></span>건 									
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
							<table class="table table-hover table-sm table-horizontal" summary="과제 제출 정보 목록">
								<thead>
									<tr>
										<th scope="col" class="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">년도/<%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
										<th scope="col">강좌명</th>
										<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
										<th scope="col">성명(<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>)</th>
										<th scope="col" class="d-none d-md-table-cell">취득점수</th>
										<th scope="col" class="d-none d-md-table-cell">이수기준</th>
										<th scope="col">수료상태</th>
										<th scope="col" class="d-none d-md-table-cell">관리</th>
									</tr>
								</thead>
								<tbody>

									<%
										foreach (var item in Model.CourseList)
										{
									%>
									<tr>
										<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
											<%:item.TermName %>
										</td>
										<td class="text-left">
											<%:item.SubjectName %>
										</td>
										<td class="text-center">
											<%:item.ProfessorName %>
										</td>
										<td class="text-center">
											<%:item.HangulName %>
										</td>
										<td class="text-center">
											<%:item.TotalScore %>점
										</td>
										<td class="text-center">
											<%:item.PassPoint %>점
										</td>
										<td class="text-center">
											<%:item.IsPass == 0 ? "미수료" : item.IsPass == 1 ? "수료"  : "처리전"%>
										</td>
										<td class="text-nowrap">
											<%
												if (item.IsPass == 1)
												{
											%>
											<a class="font-size-20 text-primary" onclick="fnPopup(<%:item.CourseNo %>, <%:item.UserNo %>);" title="수료증 출력">
												<i class="bi bi-card-list"></i>
											</a>
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
			if (<%:Model.CourseList.Count%> > 0) {
				var param1 = $("#ddlYearTerm").val();

				window.location = "/Lecture/CertificationExcel/" + param1.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function fnPopup(ltno, ltno2) {
			if (confirm("수료증을 출력하시겠습니까?")) {
				fnOpenPopup("/Lecture/CertificationPopup/" + ltno + "/" + ltno2, "print-pass", 700, 600, 0, 0, "auto");
			}
		}

	</script>
</asp:Content>
