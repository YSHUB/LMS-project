<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <!-- OcwView 관련-->
	<form id="frmpop">
		<input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
		<input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
	</form>

    <form action="/Ocw/ListAdmin/0" id="mainForm" method="post">
        <%: Html.HiddenFor(m => m.OcwSort) %>

        <!-- 검색 폼 -->
        <div class="card mt-4">
            <div class="card-body pb-1">
                <div class="form-row align-items-end">
                    <div class="form-group col-6 col-sm-3 col-lg-3 col-xl-2">
                        <label for="OcwThemeSel" class="sr-only">테마전체</label>
                        <select id="OcwThemeSel" name="OcwThemeSel" class="form-control">
                            <option value="%">테마전체</option>
                            <%
                                string themeNo = string.Empty;
                                foreach (var ocwTheme in Model.OcwThemeList)
                                {
                                    themeNo = ocwTheme.ThemeNo.ToString();
                            %>
                            <option value="<%:themeNo %>" <%: themeNo == Model.OcwThemeSel ? "selected" : "" %>><%: ocwTheme.ThemeName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group col-6 col-sm-3 col-lg-2 col-xl-2">
                        <label for="IsOpen" class="sr-only">공개설정 <strong class="text-danger">*</strong></label>
                        <select id="IsOpen" name="IsOpen" class="form-control">
                            <option value="-1">전체</option>
                            <%
                                foreach (var OpenGb in Model.BaseCode.Where(w => w.ClassCode.ToString() == "OPGB"))
                                {
                            %>
                            <option id="<%: OpenGb.CodeValue %>" value="<%: OpenGb.Remark %>" <%:Model.IsOpen == Convert.ToInt32(OpenGb.Remark) ? "selected" : "" %>>
                                <%: OpenGb.CodeName%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <%
                        if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y")) 
                        {
                    %>

                    <div class="form-group col-6 col-sm-3 col-lg-2 col-xl-2">
                        <label for="AssignSel" class="sr-only">전공전체</label>
                        <select id="AssignSel" name="AssignSel" class="form-control">
                            <option value="%">전공전체</option>

                            <%
                                foreach (var assign in Model.AssignList.Where(w => w.HierarchyLevel >= 2))
                                {
                            %>
                            <option value="<%: assign.AssignNo %>" <%: assign.AssignNo == Model.AssignSel ? "selected" : "" %>><%: assign.AssignName%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <%
                        }    
                    %>
                    <div class="form-group col-6 col-sm-3 col-lg-2 col-xl-3">
                        <label for="SearchText" class="sr-only">검색어 입력</label>
                        <input class="form-control" title="검색어 입력" name="SearchText" id="SearchText" value="<%:Model.SearchText %>" type="text" placeholder="작성자/제목으로 검색">
                    </div>
                    <div class="form-group col-sm-auto text-right">
                        <button type="button" id="btnSearch" onclick="fnGoSearch();" class="btn btn-secondary">
                            <span class="icon search">검색
                            </span>
                        </button>
                    </div>
                    <div class="form-group col-sm-auto">
                        <button type="button" class="btn btn-secondary" id="btnExcelSave" onclick="return fnExcelDownload();"><i class="bi bi-download"></i>엑셀 다운로드</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-header">
                <div class="row justify-content-between">
                    <div class="col-auto mt-1">
                        총 <span class="text-primary font-weight-bold" id="totalCount"><%: Model.PageTotalCount.ToString("#,##0") %></span>건              
                   
                    </div>
                    <div class="col-auto form-row">
                        <div class="form-group mt-1 mb-1 mr-2">
                            <div class="text-right font-size-14">

                                <%
                                    int cnt = 1;
                                    foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "SRTN"))
                                    {
                                        int length = Model.BaseCode.Where(w => w.ClassCode.ToString() == "SRTN").Count();
                                %>
                                <a href="#" onclick="fnGoTab('ocwSort', '<%: Model.OcwSort.Equals(baseCode.CodeValue) ? "block" : baseCode.CodeValue %>');"
                                    class="text-<%: Model.OcwSort.Equals(baseCode.CodeValue) ? "primary" : "secondary"%> <%:cnt == length ? "" : "bar-vertical"%> ">
                                    <i class="bi bi-funnel-fill <%: Model.OcwSort.Equals(baseCode.CodeValue) ?  "" : "d-none;" %> "></i>
                                    <strong><%:baseCode.CodeName %></strong>
                                </a>
                                <%
                                        cnt++;
                                    }
                                %>
                            </div>

                        </div>
                        <div class="form-group mb-0">
                            <label for="pageRowSize" class="sr-only">건수</label>
                            <select class="form-control form-control-sm" name="PageRowSize" onchange="fnChangePageRowSize();">
                                <option value="10" <%:Model.PageRowSize.Equals(10) ? "selected" : "" %>>10건</option>
                                <option value="20" <%:Model.PageRowSize.Equals(20) ? "selected" : "" %>>20건</option>
                                <option value="50" <%:Model.PageRowSize.Equals(50) ? "selected" : "" %>>50건</option>
                                <option value="100" <%:Model.PageRowSize.Equals(100) ? "selected" : "" %>>100건</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" cellspacing="0" summary="">
                        <thead>
                            <tr>
                                <th scope="col">
                                    <label for="chkAll"></label>
                                    <input type="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');" />
                                </th>
                                <th scope="col">제목</th>
                                <th scope="col">등록일</th>
                                <th scope="col">작성자</th>
                                <th scope="col">공개여부</th>
                                <th scope="col">미리보기</th>
                                <th scope="col">관리</th>
                            </tr>
                        </thead>
                        <tbody>

                            <%
                                foreach (var ocw in Model.OcwList)
                                {
                            %>
                            <tr>
                                <td class="text-center">
                                    <label for="chkSel<%:Model.OcwList.IndexOf(ocw) %>" class="sr-only">체크박스</label>
                                    <input type="checkbox" name="checkbox" id="chkSel<%:Model.OcwList.IndexOf(ocw) %>"
                                        value="<%:ocw.OcwNo%>" class="checkbox" />
                                    <input type="hidden" id="hdnOcwNo" name="Ocw.OcwNo" value="" />
                                </td>

                                <td class="text-left">
                                    <a href="/Ocw/Detail/<%: ocw.OcwNo %>"><%: ocw.OcwName %></a>
                                </td>
                                <td class="text-nowrap"><%: ocw.CreateDateTime %></td>
                                <td class="text-nowrap text-center"><%: ocw.CreateUserName %></td>
                                <td>
                                    <%: ocw.OcwOpenName%>
                                </td>
                                <td class="text-center"><a href="#" onclick="fnOcwView(<%: ocw.OcwNo%>
                                                            , <%: ocw.OcwType %>
                                                            , <%: ocw.OcwSourceType %>
                                                            , '<%: ocw.OcwType == 1 || (ocw.OcwType == 0 && ocw.OcwSourceType == 0) ? (ocw.OcwData ?? "") : "" %>'
                                                            , <%: ocw.OcwFileNo %>
                                                            , <%: ocw.OcwWidth %>
                                                            , <%: ocw.OcwHeight %>
                                                            , 'frmpop');"
                                    title="강의 바로보기" class="font-size-20 text-point <%:ocw.OcwType == 2 ? "d-none" : ""%>">
                                    <i class="bi bi-eye-fill"></i>
                                </a></td>
                                <td class="text-nowrap text-center">
                                    <button type="button" class="btn btn-sm btn-primary" onclick="fnOpenOcwPopup(<%:ocw.OcwNo %>);">상세보기</button>
                                    <button type="button" class="btn btn-sm btn-outline-dark" onclick="fnOpenWriteAdmin(<%:ocw.OcwNo %>);">관리</button>

                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td colspan="7" class="text-center <%: Model.OcwList.Count() > 0 ? "d-none" : "" %>">등록된 나의 OCW가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12">
                        <button type="button" class="btn btn-sm btn-danger" id="btnDel" onclick="fnCheckDelOcw();">선택 삭제</button>
                    </div>
                </div>
            </div>
        </div>


        <%-- 페이징 --%>
        <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
    </form>

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        function fnGoTab(id, tid) {
            if (id == "ocwSort") {
                if (tid != "block") {
                    $("#OcwSort").val(tid);
                    fnSubmit();
                }
            }
            fnPrevent();
        }

        function fnExcelDownload() {
			if (<%: Model.OcwList.Count() %> <= 0) {
                bootAlert("다운로드할 내용이 없습니다.");
                return false;
            } else {
                $("#mainForm").attr("action", "/Ocw/OcwListExcel/0").submit();
                //location.href = "Ocw/OcwListExcel/0/";
                
			}
        }

        function fnGoSearch() {
            $("#OcwThemeSel").val($("#OcwThemeSel option:selected").val());
            $("#AssignSel").val($("#AssignSel option:selected").val());
            $("#AssignSel").val($("#AssignSel option:selected").val());

			$("#mainForm").attr("action", "/Ocw/ListAdmin/0").submit();
            //fnSubmit();
        }

        function fnChangePageRowSize() {
			$("#mainForm").attr("action", "/Ocw/ListAdmin/0").submit();
            //fnSubmit();
        }

        function fnCheckDelOcw() {
            if (fnIsChecked("chkSel") == ! true) {
                bootAlert("선택된 항목이 없습니다.");
                return;
            } else {
                $("#hdnOcwNo").val(fnLinkChkValue("chkSel"));
                var param = $("#hdnOcwNo").val();

                bootConfirm('선택한 OCW를 삭제하시겠습니까?', fnDeleteOcw, param);
            }
        }

        function fnDeleteOcw(param) {            

            ajaxHelper.CallAjaxPost("/Ocw/DeleteOcw", { ChkVal: param }, "fnCbDeleteOcw");
        }

        function fnCbDeleteOcw() {
            var OcwNoLen = $("#hdnOcwNo").val().split("|").length;

            var result = ajaxHelper.CallAjaxResult();

            if (result > 0) {
                if (result < OcwNoLen) {
                    bootAlert("강의컨텐츠/강의연계에 등록된 OCW를 제외한 " + result + "개의 OCW가 삭제되었습니다.", function () {
                        location.reload(true);
                    });
                } else {
                    bootAlert(result + "개의 OCW가 삭제되었습니다.", function () {
                        location.reload(true);
                    });
                }
            } else {
                bootAlert("강의컨텐츠에 등록된 OCW는 삭제할 수 없습니다.");
            }
        }

        function fnOpenOcwPopup(ocwNo) {
            fnOpenPopup("/Ocw/OcwPopup/" + ocwNo, "ContPop", 800, 750, 0, 0, "auto");
        }

        function fnOpenWriteAdmin(ocwNo) {
            fnOpenPopup("/Ocw/WriteAdmin/" + ocwNo, "ContPop", 850, 800, 0, 0, "auto");
        }

	</script>
</asp:Content>
