<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/ProfOcwAuth/<%:ViewBag.Course.CourseNo%>" id="mainForm" method="post">
        <input hidden id="hdnCourseNo" value="<%:ViewBag.Course.CourseNo%>" />
        <!-- 탭리스트 -->
        <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="false"
                    onclick="javascript:location.href='/Ocw/LectureRoom/<%:ViewBag.Course.CourseNo%>'">OCW 연계 현황 <!--등록현황? -->
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="false"
                    onclick="javascript:location.href='/Ocw/WeekListSub/<%:ViewBag.Course.CourseNo%>'">OCW 연계 목록</a>
            </li>
            <li class="nav-item active show" role="presentation">
                <a class="nav-link" id="tab3" href="#" data-toggle="tab" role="tab" aria-controls="tab3" aria-selected="true">신청/승인
                </a>
            </li>
        </ul>

        <div class="card card-style01">
            <div class="card-header">
                <div class="form-row align-items-end">
                    <div class="col-md-3">
                        <label for="OcwCCStatus" class="sr-only">승인상태</label>
                        <select id="CCStatus" name="CCStatus" class="form-control" onchange="fnSubmit();">
                            <option value="-1">승인상태 전체</option>
                            <%
                                foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "CCST"))
                                {
                            %>
                                    <option id="<%: baseCode.CodeValue %>" value="<%: baseCode.Remark %>" 
                                        <%: Convert.ToInt32(baseCode.Remark) == Convert.ToInt32(Model.CCStatus) ? "selected" : "" %>>
                                        <%: baseCode.CodeName%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </div>
            </div>
            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" cellspacing="0" summary="">
                        <thead>
                            <tr>
                                <th scope="row">
                                    <label for="chkAll"></label>
                                    <input type="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');"/>
                                </th>
                                <th scope="col">주차</th>
                                <th scope="col">제목</th>
                                <th scope="col">신청일</th>
                                <th scope="col">신청자</th>
                                <th scope="col">형태</th>
                                <th scope="col">종류</th>
                                <th scope="col">승인상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                foreach (var ocwCourse in Model.OcwCourseList)
                                {
                            %>
                            <tr>
                                <td class="text-center">
                                    <label for="chkSel<%:Model.OcwCourseList.IndexOf(ocwCourse) %>" class="sr-only">체크박스</label>
                                    <input type="checkbox" name="checkbox" id="chkSel<%:Model.OcwCourseList.IndexOf(ocwCourse) %>"
                                        value="<%:ocwCourse.OcwNo%>_<%:ocwCourse.Week %>" class="checkbox" />
                                    <input type="hidden" id="hdnOcwNo" name="OcwCourse.OcwNo" value="" />
                                </td>
                                <td class="text-center"><%:ocwCourse.Week %></td>
                                <td class="text-left"><a href="javascript:void(window.open('/Ocw/Detail/<%:ocwCourse.OcwNo %>'))"><%:ocwCourse.OcwName %></a></td>
                                <td class="text-center"><%: ocwCourse.CreateDateTime %></td>
                                <td class="text-center"><%: ocwCourse.RegUserName %></td>
                                <td class="text-center"><%:ocwCourse.OcwTypeName%></td>
                                <td class="text-center"><%:ocwCourse.OcwSourceTypeName %></td>
                                <td class="text-center"><%:ocwCourse.CCStatusName %></td>
                            </tr>
                            <%
                                }
                            %>

                            <tr>
                                <td colspan="8" class="text-center <%: Model.OcwCourseList.Count == 0 ? "" : "d-none" %>">조회된 데이터가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer">

                <div class="text-right">
                    <button type="button" class="btn btn-sm btn-primary" onclick="fnOcwAuth(2);">선택 승인</button>
                    <button type="button" class="btn btn-sm btn-danger" onclick="fnOcwAuth(1);">선택 거절</button>
                </div>

            </div>
        </div>

    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        var ajaxHelper = new AjaxHelper();

        function fnOcwAuth(auth) {
            if (fnIsChecked("chkSel") == ! true) {
                bootAlert("선택된 항목이 없습니다.");
                return;
            } else {
                $("#hdnOcwNo").val(fnLinkChkValue("chkSel"));
                var param = $("#hdnOcwNo").val();
                                
                if (auth == 2) {
                    bootConfirm('선택내역을 승인 처리하시겠습니까?', fnAddAuthCourse, param);

                } else if (auth == 1) {
                    bootConfirm('선택내역을 거절 처리하시겠습니까?', fnDelAuthCourse, param);
                }
            }
        }

        //선택 승인
        function fnAddAuthCourse(param) {
            ajaxHelper.CallAjaxPost("/Ocw/AuthCourse", { CourseNo: $("#hdnCourseNo").val(), ChkVal: param, Auth: 2 }, "fnCbAddAuthCourse");
        }

        function fnCbAddAuthCourse() {
            var result = ajaxHelper.CallAjaxResult();

            if (result > 0) {
                bootAlert("승인처리 되었습니다.", function () {
                    fnSubmit();
                });
            }
        }

        //선택 거절
        function fnDelAuthCourse(param) {
            ajaxHelper.CallAjaxPost("/Ocw/AuthCourse", { CourseNo: $("#hdnCourseNo").val(), ChkVal: param, Auth: 1 }, "fnCbDelAuthCourse");
        }

        function fnCbDelAuthCourse() {
            var result = ajaxHelper.CallAjaxResult();

            if (result > 0) {
                bootAlert("거절처리 되었습니다.", function () {
                    fnSubmit();
                });
            }
        }

    </script>
</asp:Content>
