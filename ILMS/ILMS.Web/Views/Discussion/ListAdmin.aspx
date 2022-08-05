<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Discussion/ListAdmin/<%:Model.Discussion.ProgramNo %>" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">						
						
						<div class="form-group col-6 col-md-3 col-lg-2 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<label for="ddlProgram" class="sr-only">과정</label>
							<select id="ddlProgram" name="Discussion.ProgramNo" class="form-control">
								<%
									foreach (var item in Model.ProgramList) 
									{
								%>
										<option value="<%:item.ProgramNo %>" <%if (item.ProgramNo.Equals(Model.Discussion == null ? 0 : Model.Discussion.ProgramNo)) { %> selected="selected" <% } %>><%:item.ProgramName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-6 col-md-4 col-lg-3">
							<label for="ddlTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlTerm" name="Discussion.TermNo" class="form-control">
								<%
									if (Model.TermList == null) 
									{ 
								%>
										<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
								<%
									}
									else
									{
										foreach (var item in Model.TermList) 
										{
									%>
											<option value="<%:item.TermNo %>" <%:Model.Discussion != null ? Model.Discussion.TermNo == item.TermNo ? "selected='selected'" : "" : "" %>><%:item.TermName.ToString() %></option>
									<%
										}
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only">강좌명</label>
							<input type="text" id="txtSearch" placeholder="강좌명" class="form-control" name="SearchText" value="">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch()">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto">
							<button type="button" class="btn btn-secondary" onclick="fnExcel()">
								<i class="bi bi-download"></i> 엑셀 다운로드
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (Model.DiscussionList.Count.Equals(0))
						{
					%>
							<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 강좌가 없습니다.</div>
					<%
						}
						else 
						{
					%>
							<div class="card">
								<div class="card-header">
									<div class="row justify-content-between">
										<div class="col-auto mt-1">
											총 <span class="text-primary font-weight-bold"><%:Model.DiscussionList.Count > 0 ? Model.DiscussionList[0].TotalCount : 0 %></span>건 
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
										<table class="table table-hover table-sm table-horizontal" summary="토론 제출 정보 목록">
											<thead>
												<tr>
													<%
													if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
													{
													%>
														<th scope="col" class="d-none d-md-table-cell">과정</th>
													<%
													}
													%>
													
													<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></th>
													<th scope="col" class="d-none d-lg-table-cell">분반</th>
													<th scope="col" class="d-none d-md-table-cell">강의형태</th>
													<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
													<th scope="col">토론 등록수</th>
													<th scope="col">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.DiscussionList) 
													{
												%>
														<tr>
														<%
															if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
															{
														%>
															<td class="text-center d-none d-md-table-cell ">
																<%:item.ProgramName %>
															</td>
														<%
															}
														%>
															<td class="text-left">
																<%:item.SubjectName %>
															</td>
															<td class="text-center d-none d-lg-table-cell">
																<%:item.ClassNo%>
															</td>
															<td class="text-center d-none d-md-table-cell">
																<%:item.StudyTypeName %>
															</td>
															<td class="text-center">
																<%:item.ProfessorName %>
															</td>
															<td class="text-center">
																<%:item.DiscuccionCnt %>
															</td>
															<td class="text-center">
																<a class="font-size-20 text-primary" onclick="fnGo(<%:item.CourseNo %>,<%:item.ProgramNo %>,<%:item.TermNo %>)" href="#" title="상세보기">
																	<i class="bi bi-card-list"></i>
																</a>
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

		<%-- 검색 --%>
		$(document).ready(function () {

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});

			$("#txtSearch").val(decodeURI(decodeURIComponent('<%:Model.SearchText%>')));

		});

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {
			
			if (<%:Model.DiscussionList.Count %> > 0) {
				var param1 = $("#ddlProgram").val();
				var param2 = $("#ddlTerm").val();
				var param3 = $("#txtSearch").val();

				window.location = "/Discussion/ListAdminExcel/" + param1.toString() + "/" + param2.toString() + "/" + param3;
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function fnGo(courseNo, programNo, termNo) {
			
			window.location.href = "/Discussion/DetailAdmin/" + courseNo + "?ProgramNo=" + programNo + "&TermNo=" + termNo + "&SearchText=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>
