<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Course/ListOutAdmin" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-12 col-md-4 col-lg-4">
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
						<div class="form-group col-12 col-md-3 col-lg-3">
							<label for="txtSearchText" class="sr-only"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</label>
							<input type="text" class="form-control" id="txtSearchText" name="SearchText" placeholder="<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명" value=""/>
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
										<div class="col-auto">
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
													<th scope="col">No</th>
													<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></th>
													<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
													<th scope="col" class="d-none d-md-table-cell">신청기간</th>
													<th scope="col" class="d-none d-md-table-cell">운영기간</th>
													<th scope="col">상태</th>
													<th scope="col">강의실</th>
													<th scope="col">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.CourseList) 
													{
												%>
														<tr>
															<td class="text-center"><%:item.RowNum %></td>
															<td class="text-left"><%:item.SubjectName %></td>
															<td class="text-center"><%:item.ProfessorName %></td>
															<td class="text-center d-none d-md-table-cell text-nowrap"><%:item.RDay %></td>
															<td class="text-center d-none d-md-table-cell text-nowrap"><%:item.LDay %></td>
															<td class="text-center"><%:item.LSituation %></td>
															<td class="text-center">
																<a href="<%: ConfigurationManager.AppSettings["BaseUrl"] %>/Account/AutoLogOnProcess/?userNo=<%:item.UserNo %>&returnUrl=<%:ConfigurationManager.AppSettings["BaseUrl"] %>/LectureRoom/Index/<%:item.CourseNo %>" class="font-size-20 text-danger" title="입장">
																	<i class="bi bi-card-list"></i>
																</a>
															</td>
															<td class="text-center">
																<a class="font-size-20 text-primary" href="#" onclick="fnGoWrite(<%:item.CourseNo %>)" title="관리">
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
						<div class="text-right"><a href="#" onclick="fnGoWrite(0)" class="btn btn-primary">등록</a></div>
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

		});

		<%-- 등록 페이지 이동 --%>
		function fnGoWrite(courseNo) {

			var no = courseNo == 0 ? "" : courseNo;
			location.href = "/Course/WriteOutAdmin/" + no + "?TermNo=" + $("#ddlTerm").val() + "&SearchText=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {

			if (<%:Model.CourseList.Count %> > 0) {

				var param1 = $("#ddlTerm").val();
				var param2 = $("#txtSearchText").val();

				window.location = "/Course/ListOutAdminExcel/" + param1.toString() + "/" + param2;
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

	</script>
</asp:Content>