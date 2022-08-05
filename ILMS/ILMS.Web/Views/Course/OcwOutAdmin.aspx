<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Course/OcwOutAdmin" method="post" id="mainForm" enctype="multipart/form-data">
        <div id="content">
            <ul class="nav nav-tabs mt-4" role="tablist">
                <li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('WriteOutAdmin')" role="tab">기본정보</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('ListWeekOutAdmin')" role="tab">주차 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('EstimationOutWriteAdmin')" role="tab">평가기준 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link active" href="javascript:void(0);" onclick="fnGoTab('OcwOutAdmin')" role="tab">콘텐츠 설정</a>
				</li>
            </ul>
			<div class="row">
				<div class="col-12 mt-2">
					<div class="card card-style02">
						<div class="card-header">
							<div>
								<%if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
								{
								%>
								<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
								<%
									}
									if (ConfigurationManager.AppSettings["UnivYN"].Equals("N")) 
									{
								%>
									<span class="badge badge-1"><%:Model.Course.StudyTypeName %></span>
								<%
									}
								  else
									{
								%>
									<span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
								<%
									}
								%>
							</div>
							<span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
						</div>
						<div class="card-body">
							<dl class="row dl-style02">
								<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></dt>
								<dd class="col-9 col-md-4"><%:Model.Course.AssignName %></dd>
								<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
								<dd class="col-9 col-md-5"><%:Model.Course.TermName %></dd>
							</dl>
						</div>
					</div>

					<h3 class="title04">콘텐츠 리스트</h3>
					<div class="card">
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover" cellspacing="0" summary="">
									<thead>
										<tr>
											<th scope="col">주차</th>
											<th scope="col">순서</th>
											<th scope="col">중요도</th>
											<th scope="col">제목</th>
											<th scope="col">형태</th>
											<th scope="col">종류</th>
											<th scope="col">작성자</th>
											<th scope="col">관리</th>
										</tr>
									</thead>
									<tbody>

										<%
											foreach (var ocwCourse in Model.OcwCourseList)
											{
										%>
										<tr>
											<td><%: ocwCourse.Week %></td>
											<td class="text-center"><%: ocwCourse.SeqNo %></td>
											<td class="text-center"><%: ocwCourse.IsImportantName %></td>
											<td class="text-left"><%:ocwCourse.OcwReName %></td>
											<td class="text-center"><%:ocwCourse.OcwTypeName%></td>
											<td class="text-center"><%:ocwCourse.OcwSourceTypeName %></td>
											<td class="text-center"><%:ocwCourse.CreateUserName %></td>
											<td class="text-center"><a class="btn btn-sm btn-primary" onclick="fnOpenOcwPopup(<%:ocwCourse.OcwNo %>);">보기</a></td>
										</tr>
										<%
											}
										%>
										<tr>
											<td colspan="8" class="text-center <%: Model.OcwCourseList.Count > 0 ? "d-none" : "" %>">조회된 데이터가 없습니다.</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12 text-right">
							<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
						</div>
					</div>
				</div>
			</div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        function fnOpenOcwPopup(ocwNo) {
            fnOpenPopup("/Ocw/OcwPopup/" + ocwNo, "ContPop", 800, 750, 0, 0, "auto");
        }

        <%-- 탭 이동 --%>
		function fnGoTab(pageName) {

			location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> +"?TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
        }

		function fnGo() {

            window.location.href = "/Course/ListOutAdmin/?TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
        }

	</script>
</asp:Content>
