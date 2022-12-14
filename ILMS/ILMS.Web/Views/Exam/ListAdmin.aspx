<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$("#ddlPageRow").change(function () {
				$("#mainForm").submit();
			});

			$("#btnSearch").click(function () {
				$("#mainForm").submit();
			});

			$("#btnExcel").click(function () {
				location.href = "/Exam/AdminExcel/" + $("#ddlProgram").val() + "/" + $("#ddlTermYear").val() + (($("#txtSearch").val().trim() == "") ? "" : "/" + $("#txtSearch").val());
			});
		})
	</script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Exam/ListAdmin/<%:Model.ProgramNo %>" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3 col-lg-2 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<label for="ddlProgram" class="sr-only">과정</label>
							<select id="ddlProgram" name="ProgramNo" class="form-control">
								<%
									if(Model.ProgramList.Count > 0)
									{
										foreach (var item in Model.ProgramList)
										{
								%>
								<option value="<%:item.ProgramNo %>" <%:(Model.ProgramNo.Equals(item.ProgramNo)) ? "selected" : "" %>><%:item.ProgramName %></option>
								<%
										}
									}
									else
									{
								%>
								<option value="">등록된 프로그램 과정이 없습니다.</option>
								<%
									}
								%>							
							</select>
						</div>
						<div class="form-group col-6 col-md-4 col-lg-3">
							<label for="ddlTermYear" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlTermYear" name="TermNo" class="form-control">
								<%
									if(Model.TermList.Count > 0)
									{
										foreach (var item in Model.TermList)
										{
								%>
								<option value="<%:item.TermNo %>" <%:(Model.TermNo.Equals(item.TermNo)) ? "selected" : "" %>><%:item.TermName %></option>
								<%
										}
									}
									else
									{
								%>
								<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only">강좌명</label>
							<input type="text" id="txtSearch" name="SearchText" class="form-control" placeholder="강좌명" value="<%:Model.SearchText %>" />
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">
									검색
								</span>
							</button>
						</div>
						<div class="form-group col-sm-auto <%:Model.QuizList.Count > 0 ? "" : "d-none" %>">
							<input type="button" id="btnExcel" class="btn btn-secondary" value="엑셀 다운로드">
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-12 mt-2">
					<%
						if(Model.QuizList.Count > 0)
						{
					%>
					
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold"><%:Model.PageTotalCount %></span>건
								</div>
								<div class="col-auto text-right">
									<div class="dropdown d-inline-block">
										<select id="ddlPageRow" name="PageRowSize" class="form-control form-control-sm">
											<option value="10" <%:(Model.PageRowSize.Equals(10)) ? "selected" : "" %>>10건</option>
											<option value="50" <%:(Model.PageRowSize.Equals(50)) ? "selected" : "" %>>50건</option>
											<option value="100" <%:(Model.PageRowSize.Equals(100)) ? "selected" : "" %>>100건</option>
											<option value="200" <%:(Model.PageRowSize.Equals(200)) ? "selected" : "" %>>200건</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover table-sm table-horizontal" summary="<%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 관리 리스트">
									<caption><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 관리 리스트</caption>
									<thead>
										<tr>
											<th scope="col" class="text-nowrap <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">과정</th>
											<th scope="col" class="text-nowrap">강의형태</th>
											<th scope="col" class="text-nowrap"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
											<th scope="col" class="text-nowrap">분반</th>
											<th scope="col" class="text-nowrap">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
											<th scope="col" class="text-nowrap">등록 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 수</th>
											<th scope="col" class="text-nowrap">관리</th>
										</tr>
									</thead>
									<tbody>
									<%
											foreach(var item in Model.QuizList)
											{
									%>		
											<tr>
												<td class="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>"><%:item.ProgramName %></td>
												<td class=""><%:item.StudyTypeName %></td>
												<td class="text-left text-nowrap"><%:item.SubjectName %></td>
												<td class=""><%:item.ClassNo %></td>
												<td class="text-left"><%:item.ProfessorName %></td>
												<td class=""><%:item.CreateCnt %></td>
												<td class=""><a class="font-size-20 text-primary" href="/Exam/DetailAdmin/<%:item.CourseNo %>?ProgramNo=<%:item.ProgramNo%>&TermNo=<%:Model.TermNo %>&SearchText=<%:Model.SearchText %>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" title="상세보기"><i class="bi bi-card-list"></i></a></td>
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
						else
						{
					%>
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 강좌가 없습니다.</div>
					<%
						}
					%>

					<%=Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic) %>
				</div>
			</div>
		</div>
	</form>
</asp:Content>