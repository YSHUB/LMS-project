<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	
	<div id="content">
		<div>
			<button class="btn btn-secondary mt-3 d-none" onclick="courselinkdbupdate(<%: Model.Course.CourseNo %>);">학사정보 동기화</button>
		</div>

		<div class="card card-style02">
			<div class="card-header">
				<div>
					
					<%--<span class="badge <%:Model.ExamDetail.ProgramNo.Equals(1) ? "badge-regular" : "badge-irregular" %>"><%:Model.ExamDetail.ProgramName %></span>--%>
					<span class="badge badge-1"></span>
				</div>
				<a href="#" class="card-title01 text-dark mt-0"><%= Model.Course.SubjectName%></a>
			</div>
			<div class="card-body">
				<div class="row <%=Model.Course.ProgramNo == 2 ? "d-none" : ""%>">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>주관학과</dt>
							<dd class="col"><%: Model.Course.AssignName%></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>학점/시간</dt>
							<dd class="col"><%: Model.Course.Credit%> / <%: Model.Course.LecTime.ToString("#,0.##") %></dd>
						</dl>
					</div>
				</div>
				<div class="row <%=Model.Course.ProgramNo == 2 ? "d-none" : ""%>">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>대상학년</dt>
							<dd class="col"><%: Model.Course.TargetGradeName%></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>개설년도/<%:ConfigurationManager.AppSettings["TermText"].ToString() %></dt>
							<dd class="col"><%: Model.Course.TermName%></dd>
						</dl>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>강의형태</dt>
							<dd class="col"><%: Model.Course.StudyTypeName %></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
							<dd class="col"><%: Model.Course.HangulName%></dd>
						</dl>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>연락처</dt>
							<dd class="col"><%:Model.Course.OfficePhone ?? "-" %></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>이메일</dt>
							<dd class="col"><%:Model.Course.Email %></dd>
						</dl>
					</div>
				</div>
				<div class="row <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none" %>">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>교재/참고자료</dt>
							<dd class="col"><%: Model.Course.TextbookData ?? ""%></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>교육대상</dt>
							<dd class="col"><%: Model.Course.TargetUser ?? "" %></dd>
						</dl>
					</div>
				</div>
				<div class="row <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none" %>">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem"><i class="bi bi-dot"></i>교육시간</dt>
							<dd class="col"><%: Model.Course.ClassTime ?? "" %></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>교육비</dt>
							<dd class="col"><%: string.IsNullOrEmpty(Model.Course.CourseExpense.ToString()) ? "" : Model.Course.CourseExpense.ToString("#,##0") + " 원" %></dd>
						</dl>
					</div>
				</div>
				<div class="row <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none" %>">
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>수료증</dt>
							<dd class="col"><%: Model.Course.Completion ?? "" %></dd>
						</dl>
					</div>
					<div class="col-lg-6">
						<dl class="row dl-style02">
							<dt class="col-auto w-7rem text-dark"><i class="bi bi-dot"></i>기기지원</dt>
							<dd class="col"><%: Model.Course.SupportDevice ?? "" %></dd>
						</dl>
					</div>
				</div>
				<dl class="row dl-style02">
					<dt class="col-md-auto w-7rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>소개</dt>
					<dd class="col"><%:Model.Course.Introduce ?? "" %></dd>
				</dl>
				<dl class="row dl-style02">
					<dt class="col-md-auto w-7rem text-dark"><i class="bi bi-dot"></i>학습목표</dt>
					<dd class="col">
						<%
							if(Model.Course.ProgramNo == 2)
							{
						%>

								
								<%:Html.Raw(Server.UrlDecode((Model.Course.ClassTarget ?? "")))%>
						<%
							}
							else
							{
						%>
								<%:Html.Raw((Model.Course.SubjectSummary ?? "").Replace("\r\n", "<br />").Replace("\n", "<br />"))%>
						<%
							}
						%>
				</dl>
			</div>
			<!-- card-body -->
		</div>
		<!-- card -->

		<h3 class="title04 mt-4">평가기준</h3>
		<div class="card mt-2">
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table" summary="">
						<thead>
							<tr>
								<th scope="col">평가항목</th>
								 <%
                                        for (int i = 0; i < Model.EstimationItemBasis.Count; i++)
                                        {
                                    %>
								<th scope="col" class="text-nowrap"><%= Model.EstimationItemBasis[i].EstimationItemGubunName%></th>
								<%
                                        }
                                    %>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row">비율(%)</th>
								<%
                                        for (int i = 0; i < Model.EstimationItemBasis.Count; i++)
                                        {
                                %>
										<td class="text-center">
											<div class="item" id="basisitemtext">
												<%= Model.EstimationItemBasis != null ? Model.EstimationItemBasis[i].RateScore.ToString() : "" %>
											</div>
										</td>
								<%
                                        }
                                %>
							</tr>
						</tbody>
					</table>

				</div>
			</div>
		</div>

		<h3 class="title04 mt-4"><%:ConfigurationManager.AppSettings["CourseText"].ToString() %></h3>
		
		<%
			if (Model.Inning.Count > 0)
			{
		%>

			<div class="card mt-2">
				<div class="card-body py-0">
					<div class="table-responsive">
						<table class="table" summary="">
							<thead>
								<tr>
									<th scope="col">주차</th>
									<th scope="col">차시</th>
									<th scope="col" class="d-none d-md-table-cell">출석기간</th>
									<th scope="col">강의내용</th>
								</tr>
							</thead>
							<tbody>
								<%
									foreach (var item in Model.Inning)
									{
								%>
								<tr>
									<th scope="row"><%:item.Week %></th>
									<th scope="row"><%:item.InningSeqNoName%></th>
									<td class="text-nowrap d-none d-md-table-cell"><%:item.InningStartDay %> ~ <%:item.InningEndDay %></td>
									<td class="text-left"> <%:Html.Raw(item.Title) %> <%if(item.IsPreview == "Y"){ %><span class="text-danger">[맛보기]</span><%} %> </td>
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
		<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 학습이 없습니다.</div>

		<%
			}
		%>

	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {



		});

		function courselinkdbupdate(cno) {
			if (confirm("학사정보를 업데이트하시겠습니까?")) {

				ajaxHelper.CallAjaxPost("/Import/ImportCourse", { CourseNo: <%: Model.Course.CourseNo%> }, "fnCbcourselinkdbupdate");
			}

			Prevent();
		}

		function fnCbcourselinkdbupdate() {
			alert("학사정보를 업데이트하였습니다.");
			location.href = location.href;
		}

	</script>
	
</asp:Content>
