<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">OCW 강의연계</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/CourseListAdmin/<%:Model.Ocw.OcwNo %>" id="mainForm" method="post">
        <div class="tab-content mt-3" id="myTabContent" role="tablist">
            <!-- 탭리스트 -->
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="false"
                        onclick="javascript:location.href='/Ocw/WriteAdmin/<%:Model.Ocw.OcwNo%>'">기본 정보</a>
                </li>
                <li class="nav-item active show" role="presentation">
                    <a class="nav-link" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="false">강의연계</a>
                </li>
            </ul>
        </div>

        <!-- 강의 연계 -->
        <div class="tab-pane fade show p-4" id="courseInfo" role="tabpanel" aria-labelledby="courseInfo-tab">
            <div class="card mt-0 mb-4">
                <div class="card-body py-2">
                    <ul class="list-inline-style03">
                        <li class="list-inline-item">
                            <strong class="pr-2">콘텐츠 번호</strong>
                            <span><%:Model.Ocw.OcwNo %></span>
                        </li>
                        <li class="list-inline-item bar-vertical"></li>
                        <li class="list-inline-item">
                            <strong class="pr-2">콘텐츠 명</strong>
                            <span><%:Model.Ocw.OcwName %></span>
                        </li>
                        <li class="list-inline-item bar-vertical"></li>
                        <li class="list-inline-item">
                            <strong class="pr-2">작성자</strong>
                            <span><%:Model.Ocw.CreateUserName %></span>
                        </li>

                    </ul>
                </div>
            </div>

            <h4 class="title04">강의 연계 현황</h4>
            <div class="card">
                <div class="card-body">
                    <div class="form-row">
                        <div class="form-group col-3">
                            <select id="TermNo" name="TermNo" onchange="fnGetCourseLink();" class="form-control">
                                <option value="termBlock"><%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요</option>
                                <% 
                                    foreach (var term in Model.TermList)
                                    {
                                %>
                                <option value="<%: term.TermNo %>" <%:Model.TermNo == term.TermNo ? "selected" : "" %>><%: term.TermName%></option>
                                <%                                                    
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table id="CourseLinkList" class="table table-hover " cellspacing="0" summary="강의연계 리스트">
                            <thead>
                                <tr>
                                    <th scope="col">구분</th>
                                    <th scope="col"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
                                    <th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>(분반)</th>
                                    <th scope="col">주차</th>
                                    <th scope="col">차시(순서)</th>
                                    <th scope="col">중요도</th>
                                    <th scope="col">승인여부</th>
                                    <th scope="col">연계삭제</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    foreach (var ocwCourse in Model.OcwCourseList)
                                    {
                                %>
                                <tr>
                                    <td class="text-center"><%:ocwCourse.IsCourseOcwName %></td>
                                    <td class="text-center"><%:string.Format("{0}/{1}", ocwCourse.TermYear, ocwCourse.TermQuarterName) %></td>
                                    <td class="text-left"><%:ocwCourse.SubjectName %>(<%:ocwCourse.ClassNo.ToString("000") %>)</td>
                                    <td class="text-center"><%:ocwCourse.Week%></td>
                                    <td class="text-center"><%:ocwCourse.SeqNo %></td>
                                    <td class="text-center"><%:ocwCourse.IsCourseOcw ? ocwCourse.IsImportantName : "-"%></td>
                                    <td class="text-center"><%:ocwCourse.IsCourseOcw ? ocwCourse.CCStatusName : "-"%></td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-danger 
                                            <%:(ocwCourse.IsCourseOcw && ocwCourse.CCStatus < 2 && ocwCourse.UserType != "USRT001") ? "" : "d-none"%>" 
                                            onclick="fnDelOcwCourseConfirm(<%:ocwCourse.CourseNo %>, <%:ocwCourse.Week %> );">삭제</button>
                                    </td>

                                </tr>
                                <%
                                    }
                                %>

                                <tr>
                                    <td colspan="9" class="text-center <%:Model.OcwCourseList.Count() > 0 ? "d-none" : "" %>">조회된 자료가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
            <div class="text-right">
                <input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
            </div>

        </div>

    </form>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        //강의 연계 현황 조회
        function fnGetCourseLink() {
            fnSubmit();
        }

        function fnDelOcwCourseConfirm(courseNo, week) {
            var objParam = {
                CourseNo: courseNo,
                OcwNo: <%:Model.Ocw.OcwNo%>,
                WeeK: week
            };

            bootConfirm("삭제하시겠습니까?", fnDelCourse, objParam);
        }

        function fnDelCourse(objParam) {
            ajaxHelper.CallAjaxPost("/Ocw/DeleteCourse", objParam, "fnCbDelCourse");
        }

        function fnCbDelCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("삭제되었습니다.", function () {
                    location.reload(true);
                });
            }
        }

    </script>
</asp:Content>
