<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Course/ListAdmin" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-3 col-lg-2">
							<label for="ddlAssign" class="sr-only">소속</label>
							<select id="ddlAssign" name="Course.AssignNo" class="form-control">
								<option value="">전체</option>
								<%
									if (Model.AssignList == null)
									{
								%>
										<option value="">등록된 소속이 없습니다.</option>
								<%
									}
									else
									{
										foreach (var item in Model.AssignList) 
										{
								%>
											<option value="<%:item.AssignNo %>" <% if (item.AssignNo.Equals(Model.Course == null ? null : Model.Course.AssignNo)) { %> selected="selected" <% } %> ><%:item.AssignName %></option>
								<%
										}
									}
								%>
							</select>
						</div>
						<div class="form-group col-6 col-md-3 col-lg-2">
							<label for="ddlTerm" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></label>
							<select id="ddlTerm" name="Course.TermNo" class="form-control">
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
											<option value="<%:item.TermNo %>" <%if (item.TermNo.Equals(Model.Course == null ? 0 : Model.Course.TermNo)) { %> selected="selected" <% } %> ><%:item.TermName.ToString() %></option>
									<%
										}
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-2">
							<label for="txtSearchText" class="sr-only"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></label>
							<input type="text" class="form-control" id="txtSearchText" name="SearchText" placeholder="<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>" value=""/>
						</div>
						<div class="form-group col-12 col-md-10 col-lg-2">
							<label for="txtSearchProf" class="sr-only"><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명</label>
							<input type="text" class="form-control" id="txtSearchProf" name="SearchProf" placeholder="<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명" value="" />
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
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
						if (Model.CourseList.Count.Equals(0)) 
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
											총 <span class="text-primary font-weight-bold" id="spanTotalCount"><%:Model.PageTotalCount %></span>건
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
										<table class="table table-hover table-sm table-striped table-horizontal" summary="분반별 상세 설정 목록">
											<thead>
												<tr>
													<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></th>
													<th scope="col" class="d-none d-md-table-cell">소속</th>
													<th scope="col" class="d-none d-md-table-cell">분반</th>
													<th scope="col" class="d-none d-md-table-cell">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
													<th scope="col" class="d-none d-md-table-cell">이수구분</th>
													<th scope="col" class="d-none d-lg-table-cell">학점</th>
													<%
														if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")) 
														{
													%>
															<th scope="col">학년</th>
													<%
														}
													%>
													<th scope="col" class="d-none d-md-table-cell">강의형태</th>
													<th scope="col">개설상태</th>
													<th scope="col">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.CourseList) 
													{
												%>
														<tr>
															<td class="text-left"><%:item.SubjectName %></td>
															<td class="text-center d-none d-md-table-cell"><%:item.AssignName %></td>
															<td class="text-center d-none d-md-table-cell"><%:item.ClassNo %></td>
															<td class="text-center d-none d-md-table-cell"><%:item.ProfessorName %></td>
															<td class="text-center d-none d-md-table-cell"><%:item.FinishGubunName %></td>
															<td class="text-center d-none d-lg-table-cell"><%:(int)item.Credit %></td>
															<%
																if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")) 
																{
															%>
																	<td class="text-center"><%:item.TargetGradeName %></td>
															<%
																}
															%>
															<td class="text-center d-none d-lg-table-cell"><%:item.StudyTypeName %></td>
															<td class="text-center"><%:item.CourseOpenStatusName %></td>
															<td class="text-center">
																<a class="font-size-20 text-primary" href="#" onclick="fnGo(<%:item.CourseNo %>,<%:item.TermNo %>)" title="관리">
																	<i class="bi bi-card-list"></i>
																</a>
																<a href="<%: ConfigurationManager.AppSettings["BaseUrl"] %>/Account/AutoLogOnProcess/?userNo=<%:item.UserNo %>&returnUrl=<%:ConfigurationManager.AppSettings["BaseUrl"] %>/LectureRoom/Index/<%:item.CourseNo %>" class="font-size-20 text-danger" title="입장">
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

		$(document).ready(function () {

			$("#spanTotalCount").html(fnAddCommas("B", "<%:Model.PageTotalCount%>"));

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});

			$("#txtSearchText").val(decodeURI(decodeURIComponent('<%:Model.SearchText%>')));
			$("#txtSearchProf").val(decodeURI(decodeURIComponent('<%:Model.SearchProf%>')));

		});

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {

			if (<%:Model.CourseList.Count %> > 0) {
			
				var param1 = $("#ddlTerm").val();
				var param2 = $("#ddlAssign").val();
				var param3 = $("#txtSearchText").val();
				var param4 = $("#txtSearchProf").val();

				window.location = "/Course/ListAdminExcel/" + param1.toString() + "/" + param2 + "/" + param3 + "/" + param4;
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function fnGo(courseNo, termNo) {

			window.location.href = "/Course/DetailAdmin/" + courseNo + "?AssignNo=" + '<%:Model.Course.AssignNo %>' + "&TermNo=" + termNo + "&SearchText=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&SearchProf=" + encodeURI(encodeURIComponent('<%:Model.SearchProf%>')) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>