<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<ul class="nav nav-tabs">
		<li class="nav-item"><a class="nav-link active show" href="CourseListAdmin">강좌별 수강현황</a> </li>
		<li class="nav-item"><a class="nav-link" href="LectureListAdmin">개인별 수강현황</a> </li>
		<li class="nav-item"><a class="nav-link" href="AttendanceListAdmin">개인별 출석확인</a> </li>
	</ul>
	<form action="/Lecture/CourseListAdmin" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-6 col-md-4 col-lg-2">
							<%="" %>
							<%
								if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
								{
							%>
							<label for="ddlProgram" class="sr-only">과정</label>
							<select id="ddlProgram" name="Course.ProgramNo" class="form-control">
								<% 
									foreach (var item in Model.ProgramList)
									{
								%>
								<option value="<%:item.ProgramNo%>" <%if (item.ProgramNo.Equals(Model.Course == null ? 0 : Model.Course.ProgramNo))
									{ %>
									selected="selected" <%} %>><%:item.ProgramName%></option>
								<%
									}
								%>
							</select>
							<%
								}
								else
								{
							%>
							<label for="ddlStudyType" class="sr-only">과정</label>
							<select id="ddlStudyType" name="Course.StudyType" class="form-control">
							<%
									foreach(var item in Model.BaseCode)
									{ 
							%>
							<option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.Course == null ? "" : Model.Course.StudyType))
								{ %>
								selected="selected" <%} %>><%:item.CodeName%></option>
							<%
									}
							%>
							</select>
							<%
								}
							%>
						</div>
						<div class="form-group col-6 col-md-4 col-lg-3">
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
						<div class="form-group col-12 col-md-10 col-lg-3">
							<label for="txtSearch" class="sr-only"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</label>
							<input type="text" id="txtSearch" class="form-control" name="Course.SubjectName" value="<%:!string.IsNullOrEmpty(Model.Course.SubjectName) ? Model.Course.SubjectName : "" %>" placeholder="<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
								
						</div>
						<div class="form-group col-sm-auto <%: Model.CourseList.Count > 0 ? "" : "d-none" %>">
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
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>검색된 과정이 없습니다.</div>
					<%
						}
						else
						{
					%>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto mt-1">
									총 <span class="text-primary font-weight-bold"><%:string.Format("{0:#,###}" , Model.CourseList.Count > 0 ? Model.CourseList[0].TotalCount : 0) %></span>건 

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
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<th scope="col" class="d-none d-md-table-cell">과정</th>
										<%} %>
										<th scope="col" class="d-none d-md-table-cell">강의형태</th>
										<th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<th scope="col" class="<%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : "d-none d-md-table-cell"%>">개설처 /분반</th>
										<%} %>
										<th scope="col" class="d-none d-md-table-cell"><%: Model.Course.ProgramNo.ToString() == "2" ? "신청기간" : "수강기간"%></th>
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<th scope="col" class="<%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : "d-none d-md-table-cell"%>">이수구분</th>
										<th scope="col" class="<%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : ""%>">학점</th>
										<%} %>
										<th scope="col">담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
										<th scope="col" class="d-none d-md-table-cell">수강인원</th>
										<th scope="col" class="d-none d-md-table-cell">개설상태</th>
										<th scope="col" class="d-none d-md-table-cell">강의실</th>
										<th scope="col">관리</th>
									</tr>
								</thead>
								<tbody>

									<%
										foreach (var item in Model.CourseList)
										{
									%>
									<tr>
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<td class="text-center">
											<%:item.ProgramName %>
										</td>
										<%} %>
										<td class="text-center">
											<%:item.StudyTypeName %>
										</td>
										<td class="text-left">
											<%:item.SubjectName %>
										</td>
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<td class="text-center <%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : ""%>">
											<%:item.AssignName %>/<%:item.ClassNo %>
										</td>
										<%} %>
										<td class="text-center text-nowrap">
											<%: Model.Course.ProgramNo.ToString() == "1" ? DateTime.Parse(item.LectureRequestStartDay).ToString("yyyy-MM-dd") + " ~ " + DateTime.Parse(item.LectureRequestEndDay).ToString("yyyy-MM-dd")
													: item.RStart + " ~ " + item.REnd %> 
										</td>
										<%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %>
										<td class="<%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : ""%>">
											<%:item.FinishGubunName %>
										</td>
										<td class="<%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : ""%>">
											<%:item.Credit %>
										<%} %>
										</td>
										<td class="text-center">
											<%:item.ProfessorName %>
										</td>
										<td>
											<%:item.StudentCount %>
										</td>
										<td>
											<%:item.CourseOpenStatusName %>
										</td>
										<td class="text-nowrap">
											<a href="<%: ConfigurationManager.AppSettings["BaseUrl"] %>/Account/AutoLogOnProcess/?userNo=<%:item.UserNo %>&returnUrl=<%:ConfigurationManager.AppSettings["BaseUrl"] %>/LectureRoom/Index/<%:item.CourseNo %>" class="font-size-20 text-danger" title="입장">
												<i class="bi bi-card-list"></i>
											</a>
										</td>
										<td class="text-nowrap">
											<a class="font-size-20 text-primary" href="/Lecture/CourseDetailAdmin/<%:item.CourseNo %>" title="상세보기">
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

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});
		});

		function fnExcel() {
			if (<%:Model.CourseList.Count%> > 0) {
				var param1 = $("#ddlProgram").val();
				var param2 = $("#ddlYearTerm").val();
				var UnivYN = "<%:ConfigurationManager.AppSettings["UnivYN"].ToString()%>";

				if (UnivYN == "Y")
				{
					window.location = "/Lecture/CourseListAdminExcel/" + param1 + "/" + param2;
				}
				else
				{
					window.location = "/Lecture/CourseListAdminExcel/2/" + param2;
				}
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}
	</script>
</asp:Content>
