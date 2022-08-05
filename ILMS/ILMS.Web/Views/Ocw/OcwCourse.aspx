<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">강의연계</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Ocw/OcwCourse/<%:Model.Ocw.OcwNo %>" id="mainForm" method="post" enctype="multipart/form-data">

        <div class="tab-content mt-3" id="myTabContent"role="tablist">

            <!-- 탭리스트 -->
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="false"
                        onclick="javascript:location.href='/Ocw/OcwReg/<%:Model.Ocw.OcwNo%>'">기본 정보</a>
                </li>
                <li class="nav-item active show" role="presentation">
                    <a class="nav-link" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="false">강의연계</a>
                </li>
            </ul>
        </div>

        <!-- 강의 연계 -->
        <div class="tab-pane fade show p-4" id="courseInfo" role="tabpanel" aria-labelledby="courseInfo-tab">

            <h4 class="title04">강의별 OCW 추가</h4>
            <div class="card">
                <div class="card-body">
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label for="txtContNm" class="form-label">콘텐츠명 <strong class="text-danger">*</strong></label>
                            <input type="text" id="txtContName" name="Ocw.OcwName" readonly="readonly" class="form-control" value="<%:Model.Ocw.OcwName%>" />
                        </div>
                        <div class="form-group col-3">
                            <label for="term" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
                            <select id="term" onchange="fnGetCourse();" class="form-control">
                                <option value="termBlock"><%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요</option>
                                <% 
                                    foreach (var term in Model.TermList)
                                    { 
                                %>
                                    <option value="<%: term.TermNo %>"><%: term.TermName%></option>
                                <%                                                    
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group col-4">
                            <label for="course" class="form-label"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반 <strong class="text-danger">*</strong></label>
                            <select id="course" onchange="fnGetWeek();" class="form-control">
                                <option value="courseBlock"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>
                            </select>
                        </div>

                        <div class="form-group col-3">
                            <label for="week" class="form-label">적용주차 <strong class="text-danger">*</strong></label>
                            <select id="week" class="form-control">
                                <option value="weekBlock">주차를 선택하세요</option>

                            </select>
                        </div>

                        <div class="form-group col-2">
                            <label for="impt" class="form-label">중요도 <strong class="text-danger">*</strong></label>
                            <select id="impt" class="form-control">
                                <%
                                    foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "IMPT"))
                                    {
                                %>
                                    <option value="<%: baseCode.CodeValue %>"><%: baseCode.CodeName%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                    </div>
                    <div class="text-right">
                        <button type="button" class="btn btn-primary" onclick="fnAddCourse();">저장</button>
                    </div>
                </div>
            </div>

            <h4 class="title04 mt-4">강의 연계 현황</h4>
            <div class="card">
                <div class="card-body">
                    <div class="form-row">
                        <div class="form-group col-3">
                            <select id="termSub" name="termNo" onchange="fnGetCourseLink();" class="form-control">
                                <option value="termBlock"><%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요</option>
                                <% 
                                    foreach (var term in Model.TermList)
                                    {
                                %>
                                    <option value="<%: term.TermNo %>" <%: term.TermNo == Model.TermNo ? "selected" : ""%>><%: term.TermName%></option>
                                <%                                                    
                                    }
                                %>
                            </select>
                        </div>
                    </div>
                    <div class="overflow-auto">
                        <div class="table-responsive">
                            <table id="CourseLinkList" class="table table-hover " cellspacing="0" summary="">
                                <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <th scope="col"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
                                        <th scope="col"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반</th>
                                        <th scope="col">주차</th>
                                        <th scope="col">차시(순서)</th>
                                        <th scope="col">중요도</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        foreach(var ocwCourse in Model.OcwCourseList)
			                            {			                                
                                    %>
                                        <tr>
                                            <td class="text-center"><%:ocwCourse.IsCourseOcwName %></td>
                                            <td class="text-center"><%:string.Format("{0}/{1}", ocwCourse.TermYear, ocwCourse.TermQuarterName) %></td>
                                            <td class="text-left"><%:ocwCourse.SubjectName %>(<%:ocwCourse.ClassNo.ToString("000") %>)</td>
                                            <td class="text-center"><%:ocwCourse.Week%></td>
                                            <td class="text-center"><%:ocwCourse.SeqNo %></td>
                                            <td class="text-center"><%:ocwCourse.IsImportantName %></td>

                                        </tr>
                                    <%
                                        }
                                    %>

                                    <tr>
                                        <td colspan="6" class="text-center <%:Model.OcwCourseList.Count() > 0 ? "d-none" : "" %> ">조회된 자료가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
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

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnHrefTab() {
            if ('<%: Model.Ocw.IsAuth %>' === '2') {
                $("#courseInfo-tab").prop("href", "#courseInfo");

            } else {
                bootAlert("관리자 승인 후 강의연계 요청하실 수 있습니다.");
            }

        }

        //교과목 바인딩
        function fnGetCourse() {
            var termNo = $("#term").val();
            if (termNo != "termBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetCourse", { TermNo: termNo }, "fnCbCourse");
            }
            else {
                $("#course").html();
                $("#week").html();

                var innerCourseBlock = "";
                var innerWeekBlock = "";

                innerCourseBlock = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>";

                $("#course").html(innerCourseBlock);
                $("#week").html(innerWeekBlock);

            }
        }

        function fnCbCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerCourseHtml = "";
            innerCourseHtml = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";

            $("#week").html();
            var innerWeekHtml = "";
            innerWeekHtml = "<option value=courseBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerCourseHtml += "<option value='" + ajaxResult[i].CourseNo + "'>" + ajaxResult[i].SubjectName + "";
            }

            $("#course").html(innerCourseHtml);
            $("#week").html(innerWeekHtml);

        }

        //주차 바인딩
        function fnGetWeek() {
            var courseNo = $("#course").val();
            if (courseNo != "courseBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetWeek", { CourseNo: courseNo }, "fnCbWeek");
            }
            else {
                $("#week").html();

                var innerWeekBlock = "";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>"
                $("#week").html(innerWeekBlock);
            }
        }

        function fnCbWeek() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerHtml = "";
            innerHtml = "<option value=weekBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerHtml += "<option value='" + ajaxResult[i].Week + "'>" + ajaxResult[i].Week + "";
            }

            $("#week").html(innerHtml);
        }

        //강좌 적용하기
        function fnAddCourse() {
            if ($("#term").val() == "termBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요.");
            }
            else if ($("#course").val() == "courseBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반을 선택하세요.");
            }
            else if ($("#week").val() == "weekBlock") {
                bootAlert("주차를 선택하세요.");
            }
            else {
                var objParam = {
                    CourseNo: parseInt($("#course").val()),
                    OcwNo: <%:Model.Ocw.OcwNo%>,
                    Impt: $("#impt").val() == "IMPT001" ? 1 : 0,
                    WeeK: parseInt($("#week").val())
                };

                ajaxHelper.CallAjaxPost("/Ocw/AddCourse", objParam, "fnCbAddCourse");
            }

        }

        function fnCbAddCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert("추가되었습니다.", function () {
                    fnSubmit();
                    opener.window.location.reload(true);
                });
            }
            else {
                bootAlert("이미 등록된 OCW거나 미승인된 OCW입니다.");
            }
        }

        //강의 연계 현황 조회
        function fnGetCourseLink() {
            fnSubmit();
        }

    </script>

</asp:Content>
