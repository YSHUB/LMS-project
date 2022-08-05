<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/MyPage/MyCompletion" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3 col-lg-2">
							<%="" %>
							<label for="ddlStudyType" class="sr-only">과정</label>
							<select id="ddlStudyType" name="CourseLecture.StudyType" class="form-control">
							<%
								foreach(var item in Model.BaseCode)
								{ 
							%>
							<option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.CourseLecture == null ? "" : Model.CourseLecture.StudyType))
								{ %>
								selected="selected" <%} %>><%:item.CodeName%></option>
							<%
								}
							%>
							</select>
						</div>
						<div class="form-group col-6 col-md-4 col-lg-3">
							<label for="ddlYearTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlYearTerm" name="CourseLecture.TermNo" class="form-control">
								<%
									if (Model.TermList == null)
									{
								%>
								<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
								<% }
									foreach (var item in Model.TermList)
									{
								%>
								<option value="<%:item.TermNo %>" <%if (item.TermNo.Equals(Model.CourseLecture == null ? 0 : Model.CourseLecture.TermNo)) { %> selected="selected" <% } %> > <%:item.TermName.ToString() %> </option>
								<% 
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only">강좌명</label>
							<input type="text" id="txtSearch" class="form-control" name="SearchText" value="<%:!string.IsNullOrEmpty(Model.SearchText) ? Model.SearchText : "" %>" placeholder="강좌명">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto <%: Model.CourseLectureList.Count > 0 ? "" : "d-none" %>">
							<input type="button" class="btn btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (!(Model.CourseLectureList.Count > 0))
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
									총 <span class="text-primary font-weight-bold"><%:string.Format("{0:#,###}" ,Model.CourseLectureList.Count > 0 ? Model.CourseLectureList[0].TotalCount : 0) %></span>건
									
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
											<th scope="col" class="d-none d-md-table-cell">강의형태</th>
											<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
											<th scope="col" class="d-none d-lg-table-cell">분반</th>
											<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
											<th scope="col">수료구분</th>
											<th scope="col">수료증</th>
										</tr>
									</thead>
									<tbody>

										<%
											foreach (var item in Model.CourseLectureList)
											{
										%>
										<tr>
											<td class="text-center d-none d-md-table-cell">
												<%:item.StudyTypeName %>
											</td>		
											<td class="text-left">
												<%:item.SubjectName %>
											</td>
											<td class="text-center d-none d-lg-table-cell">
												<%:item.ClassNo %>
											</td>
																	
											<td class="text-center">
												<%:item.ProfessorName %>
											</td>
											<td class="text-center">
												<%:item.IsPass == 1 ? "수료" : "미수료" %>
											</td>
											<td class="text-nowrap">
												<%
													if (item.IsPass == 0)
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
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});
		});

		function fnPopup(ltno, ltno2) {
			bootAlert("준비중입니다.");
			//bootConfirm("수료증을 출력하시겠습니까?", function () {
			//	fnOpenPopup("/MyPage/CompletionPopup/" + ltno + "/" + ltno2, "print-pass", 700, 600, 0, 0, "auto");
			//});
		}
	</script>
</asp:Content>