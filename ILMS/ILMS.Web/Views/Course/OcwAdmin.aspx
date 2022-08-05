<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Course/OcwAdmin" method="post" id="mainForm">

        <div id="content">
            <ul class="nav nav-tabs mt-4" role="tablist">
			    <li class="nav-item" role="presentation">
				    <a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdmin')">기본정보</a>
			    </li>
			    <li class="nav-item" role="presentation">
				    <a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdminViewOption')">분반설정</a>
			    </li>
			    <li class="nav-item" role="presentation">
				    <a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('ListWeekAdmin')">주차 설정</a>
			    </li>
			    <li class="nav-item" role="presentation">
				    <a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('EstimationWriteAdmin')">평가기준 설정</a>
			    </li>
			    <li class="nav-item" role="presentation">
				    <a class="nav-link active" href="javascript:void(0);" role="tab" onclick="fnGoTab('OcwAdmin')">콘텐츠 설정</a>
			    </li>
		    </ul>
            <div class="card card-style02">
                <div class="card-header">
                    <div>
                        <span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
                        <span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
                    </div>
                    <span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
                </div>
                <div class="card-body">
                    <dl class="row dl-style02">
                        <dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>강좌 카테고리</dt>
                        <dd class="col-9 col-md-5"><%:Model.Course.AssignName %></dd>
                        <dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
                        <dd class="col-9 col-md-2"><%:Model.Course.TermName %></dd>
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

    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        function fnOpenOcwPopup(ocwNo) {
            fnOpenPopup("/Ocw/OcwPopup/" + ocwNo, "ContPop", 800, 750, 0, 0, "auto");
        }

        <%-- 탭 이동 --%>
		function fnGoTab(pageName) {

			if (pageName == 'DetailAdminViewOption') {
				location.href = "/Course/DetailAdmin/" + <%:Model.Course.CourseNo%> + "?viewOption=1&AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			} else {
				location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> + "?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			}
		}

		function fnGo() {

			window.location.href = "/Course/ListAdmin/?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + decodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>

</asp:Content>
