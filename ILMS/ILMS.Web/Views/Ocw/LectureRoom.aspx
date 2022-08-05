<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/LectureRoom/<%:ViewBag.Course.CourseNo%>" id="mainForm" method="post">

        <!-- 탭리스트 -->
        <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link active show" id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="true">OCW 연계 현황
                    <!--등록현황? -->
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="false"
                    onclick="javascript:location.href='/Ocw/WeekListSub/<%:ViewBag.Course.CourseNo%>'">OCW 연계 목록</a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="tab3" href="#" data-toggle="tab" role="tab" aria-controls="tab3" aria-selected="false"
                    onclick="javascript:location.href='/Ocw/ProfOcwAuth/<%:ViewBag.Course.CourseNo%>'">신청/승인
                </a>
            </li>
        </ul>

        <div class="card card-style01">
            <div class="card-header">
                <div class="text-right">
                    <button type="button" class="btn btn-sm btn-warning <%:ViewBag.Course.ProgramNo == 1 ? "" : "d-none" %>" onclick="fnOpenCopyPopup();">이전정보 가져오기</button>
                    <button type="button" class="btn btn-sm btn-point" data-toggle="modal" data-target="#divCourseOcwModal" onclick="fnCreateCourse();">OCW 강의 연계</button>
                </div>
            </div>
            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" cellspacing="0" summary="">
                        <thead>
                            <tr>
                                <th scope="col">주차</th>
                                <%--<th scope="col">순서</th>--%>
                                <th scope="col">중요도</th>
                                <th scope="col">제목</th>
                                <th scope="col">형태</th>
                                <th scope="col">종류</th>
                                <th scope="col">작성자</th>
                                <th scope="col">주별강의실 이동</th>
                            </tr>
                        </thead>
                        <tbody>

                            <%
                                foreach (var ocwCourse in Model.OcwCourseList)
                                {
                            %>
                            <tr>
                                <td><%: ocwCourse.Week %></td>
                               <%-- <td class="text-center"><%: ocwCourse.SeqNo %></td>--%>
                                <td class="text-center"><%: ocwCourse.IsImportantName %></td>
                                <td class="text-left">
                                    <button type="button" data-toggle="modal" data-target="#divCourseOcwModal"
                                        onclick="fnCreateCourse(<%:ocwCourse.OcwNo %>, <%:ocwCourse.Week %>, <%:ocwCourse.SeqNo%>, '<%:ocwCourse.OcwName %>'
                                                                , '<%:ocwCourse.OcwReName %>', <%:ocwCourse.IsImportant %>)">
                                        <%:ocwCourse.OcwReName %></button></td>
                                <td class="text-center"><%:ocwCourse.OcwTypeName%></td>
                                <td class="text-center"><%:ocwCourse.OcwSourceTypeName %></td>
                                <td class="text-center"><%:ocwCourse.CreateUserName %></td>
                                <td class="text-center"><a class="btn btn-sm btn-primary" href="/Ocw/WeekDetail/<%: ViewBag.Course.CourseNo%>?week=<%:ocwCourse.Week %>">이동</a></td>
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

        <!--OCW 강의연계 modal -->
        <div class="modal fade show" id="divCourseOcwModal" tabindex="-1" aria-labelledby="divCourseOcw" aria-modal="true" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title h4" id="divCourseOcw">OCW 강의 연계</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card collapse d-md-block">
                            <div class="card-body">
                                <div class="form-row">                                    
                                    <div class="form-group col-md-4">
                                        <label for="Exam_Week" class="form-label">주차 선택 <strong class="text-danger">*</strong></label>
                                        <input type="hidden" id="OrgWeek"/>
                                        <select class="form-control" id="Week" name="Week">
                                            <option value="-1">주차선택</option>
                                            <%
                                                foreach(var week in Model.WeekList)
			                                    {
                                            %>
                                                <option value="<%: week.Week %>"><%: week.Week %> 주차</option>

                                            <%
                                                }    
                                            %>
			                                                                                
                                        </select>
                                    </div>

                                    <div class="form-group col-md-12 d-none">
                                        <label for="Exam_Title" class="form-label">강의 주제 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="Title" name="Title" class="form-control" value="" readonly="readonly">
                                    </div>

                                    <div class="form-group col-md-12">
                                        <label for="Exam_Title" class="form-label">콘텐츠 <strong class="text-danger">*</strong>
                                            <button type="button" id="btnContent" class="btn btn-sm btn-dark ml-2" onclick="fnOpenContPopup();">콘텐츠 선택</button></label>
                                        <input type="text" id="OcwName" name="OcwName" class="form-control" value="" readonly="readonly">
                                        <input type="hidden" id="hdnOcwNo" name="OcwNo" class="form-control" value="" readonly="readonly">
                                    </div>
                                    <div class="form-group col-md-12">
                                        <label for="Exam_Title" class="form-label">제목 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="OcwReName" name="OcwReName" class="form-control" value="">
                                    </div>

                                    <div class="form-group col-md-4 d-none">
                                        <label for="Exam_InningNo" class="form-label">순서 선택 <strong class="text-danger">*</strong></label>
                                        <select class="form-control" id="SeqNo" name="SeqNo">
                                            <option value="">차시선택</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="Exam_InningNo" class="form-label">중요도 선택 <strong class="text-danger">*</strong></label>
                                        <select class="form-control" id="IsImportant" name="IsImportant">
                                            <%
                                                foreach(var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "IMPT"))
			                                    {
                                            %>
                                                <option value="<%: baseCode.CodeValue %>"><%: baseCode.CodeName %></option>

                                            <%
                                                }    
                                            %>
                                        </select>
                                    </div>
                                </div>

                            </div>
                            <div class="card-footer">
                                <div class="row align-items-center">
                                    <div class="col-md">
                                        <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                    </div>
                                    <div class="col-md-auto text-right">
                                        <button type="button" class="btn btn-primary" onclick="fnSave();">저장</button>
                                        <button type="button" id="btnDel" class="btn btn-danger" onclick="fnDelete();">삭제</button>
                                        <button type="button" data-dismiss="modal" title="취소" class="btn btn-secondary">취소</button>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnCreateCourse(ocwNo, week, seqNo, ocwNm, ocwReNm, impt) {
                        
            ocwNo = ocwNo || 0;
            seqNo = seqNo || 1;

            if (ocwNo > 0) {
                $("#btnDel").show();
                $("#btnContent").hide();

                $("#Week").val(week);
                $("#OrgWeek").val(week);
                $("#OcwName").val(ocwNm);
                $("#OcwReName").val(ocwReNm);
                $("#hdnOcwNo").val(ocwNo);

                impt == 1 ? $("#IsImportant").val("IMPT001") : $("#IsImportant").val("IMPT002")

            } else {
                $("#Week option:eq(0)").prop("selected", true);
                $("#btnDel").hide();
                $("#btnContent").show();
                $("#hdnOcwNo").val();
                $("#OcwName").val('');
                $("#OcwReName").val('');
                $("#IsImportant").val("IMPT001");
                $("#OrgWeek").val(0);
            }
        }

        function fnOpenContPopup() {            
            fnOpenPopup("/Ocw/Select/0", "ContPop", 650, 500, 0, 0, "auto");            
        }

        function fnSetSelectOcw(ocwNo, ocwName) {
            $("#hdnOcwNo").val(ocwNo);
            $("#OcwName").val(ocwName);
            $("#OcwReName").val(ocwName);
        }

        function fnSave() {
            if ($("#Week").val() == -1) {
                bootAlert("주차를 선택하세요.", function () {
                    $("#Week").focus();
                });
            } else if ($("#OcwName").val() == "") {
                bootAlert("콘텐츠를 선택하세요.", function () {
                    $("#btnContent").focus();
                });
            } else if ($("#OcwReName").val() == "") {
                bootAlert("제목을 입력하세요.", function () {
                    $("#OcwReName").focus();
                });
            } else if ($("#IsImportant").val() == "") {
                bootAlert("중요도를 선택하세요.", function () {
                    $("#IsImportant").focus();
                });
            } else {
                var objParam = {
                    CourseNo: <%:ViewBag.Course.CourseNo%>,
                    OcwNo: parseInt($("#hdnOcwNo").val()),
                    Impt: $("#IsImportant").val() == "IMPT001" ? 1 : 0,
                    WeeK: parseInt($("#Week").val()),
                    OrgWeek: parseInt($("#OrgWeek").val()),
                    OcwReName: $("#OcwReName").val()
                };

                bootConfirm("저장하시겠습니까?", fnAddCourse, objParam);                
            }
        }

        function fnAddCourse(objParam) {
            ajaxHelper.CallAjaxPost("/Ocw/AddCourse", objParam, "fnCbAddCourse");
        }

        function fnCbAddCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("저장되었습니다.", function () {
                    location.reload(true);
                });
            } else{
                bootAlert("이미 등록된 OCW입니다.");
            }
        }

        function fnDelete() {
            var objParam = {
                CourseNo: <%:ViewBag.Course.CourseNo%>,
                OcwNo: parseInt($("#hdnOcwNo").val()),               
                WeeK: parseInt($("#Week").val())
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

        function fnOpenCopyPopup() {
            fnOpenPopup("/Ocw/Copy/" + <%:ViewBag.Course.CourseNo%>, "CopyPop", 450, 550, 0, 0, "auto");
        }

        function fnSelectPreCourse(preCourseNo, courseNm) {
            var param = {
                CourseNo: <%:ViewBag.Course.CourseNo%>,
                PreCourseNo: preCourseNo
            };

            bootConfirm(courseNm + "의 OCW를 가져오시겠습니까 ?", fnGetCopyCourse, param);
        }

        function fnGetCopyCourse(param) {
            ajaxHelper.CallAjaxPost("/Ocw/GetCopyCourse", param, "fnCbGetCopyCourse");
        }

        function fnCbGetCopyCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            bootAlert(ajaxResult + "건의 OCW를 가져왔습니다.", function () {
                location.reload(true)

            });
        }

    </script>
</asp:Content>
