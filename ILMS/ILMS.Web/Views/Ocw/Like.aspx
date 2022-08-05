<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/Like" id="mainForm" method="post">
        <%: Html.HiddenFor(m => m.UserCat) %>

        <div class="text-right">
            <button type="button" class="btn btn-secondary" onclick="fnManageCat();"><i class="bi bi-folder-plus"></i> <span class="d-none d-md-inline-block">폴더 관리</span></button>
        </div>

        <!-- 폴더리스트 -->
        <div class="card">
            <div class="card-body bg-light">
                <ul class="list-inline list-inline-style02 mb-0">
                    <li class="list-inline-item bar-vertical">
                        <a href="#" onclick="fnGoTab(-1);">전체<span class="ml-1 badge badge-<%:Convert.ToInt32( Model.UserCat) == -1 ? "primary" : "secondary" %>"><%: Model.OcwUserCatList.Sum(s => s.OcwPocketCount).ToString("#,0") %></span></a>
                    </li>

                    <%
                        foreach(var ocwUserCat in Model.OcwUserCatList)
			            {
                    %>
                        <li class="list-inline-item bar-vertical">
                            <a href="#" onclick="fnGoTab(<%:ocwUserCat.CatCode %>);"><%: ocwUserCat.CatName %>
                                <span class="ml-1 badge badge-<%:Convert.ToInt32(Model.UserCat) == ocwUserCat.CatCode ? "primary" : "secondary" %>"><%: ocwUserCat.OcwPocketCount.ToString("#,0") %></span>                            
                            </a>
                        </li>
                    <%
                        }
                    %>

                </ul>
            </div>
        </div>

    </form>

    <!-- 관심 OCW 리스트 -->
    <div class="card card-style01">
		<div class="card-body">
            <%
                if (Model.OcwList.Count < 1)
                {
            %>
                <div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i> 조회된 게시물이 없습니다.</div>
            <%
                }
                else
                {
                    foreach(var likeOcw in Model.OcwList)
                    {
            %>
                    <div class="card-item01">
                    <div class="row no-gutters align-items-md-stretch">
                        <div class="col-md-4 col-lg-3 mb-2 mb-md-0">

                            <!-- icon type -->
                            <div class="thumb-wrap icon">
                                <div class="thumb">
                                    <i class="<%: likeOcw.FileExtension %>"></i>
                                </div>
                            </div>
                        </div>


                        <%-- ocwDataType에 따라 제어 --%>
                        <!-- image type -->
                        <%--                                    <div class="thumb-wrap">
                                <div class="thumb">
                                    <img src="./images/420by300.png">
                                </div>
                            </div>--%>

                        <div class="col-md-8 col-lg-9 pl-md-4">
                            <div class="text-secondary d-flex flex-wrap align-items-center">
                                <strong class="font-size-14 bar-vertical"><span><%: string.Join(", ", Model.OcwThemeList.Where(w=>(likeOcw.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></span></strong>
                                <strong class="font-size-14 bar-vertical"><%: likeOcw.CreateDateTime %></strong>
                                <strong class="font-size-14 bar-vertical">조회(<%: likeOcw.UsingCount %>)</strong>
                                <a href="#"  onclick="viewOcw(<%: likeOcw.OcwNo%>
                                                            , <%: likeOcw.OcwType %>
                                                            , <%: likeOcw.OcwSourceType %>
                                                            , '<%: likeOcw.OcwType == 1 || (likeOcw.OcwType == 0 && likeOcw.OcwSourceType == 0) ? (likeOcw.OcwData ?? "") : "" %>'
                                                            , <%: likeOcw.OcwFileNo %>
                                                            , <%: likeOcw.OcwWidth %>
                                                            , <%: likeOcw.OcwHeight %>
                                                            , 'formPop');" 
                                    title="강의 바로보기" class="font-size-20 text-point <%:likeOcw.OcwType == 2 ? "d-none" : ""%>">
                                    <i class="bi bi-eye-fill"></i>
                                </a>
                            </div>
                            <div class="my-1 text-truncate">
                                <a href="/Ocw/Detail/<%: likeOcw.OcwNo %>" class="text-dark">
                                    <strong class="font-size-22"><%: likeOcw.OcwName %></strong>
                                </a>
                            </div>
                            <div class="text-secondary text-truncate">
                                <%: likeOcw.DescText %>
                            </div>
                            <div class="mt-2 btn-group">
                                <button class="btn btn-sm btn-outline-secondary" type="button" data-toggle="modal"  data-target="#divModalCat" 
                                        onclick="fnChangeCat('<%: likeOcw.CatName%>', <%: likeOcw.OcwNo%>, '<%: likeOcw.OcwName %>');">폴더 변경</button>
                                <button class="btn btn-sm btn-outline-danger" type="button" onclick="fnDelPocket( <%: likeOcw.OcwNo%>);">삭제</button>

                            </div>

                        </div>
                    </div>

                </div>

            <%
                    }
                }
            %>
        </div>
    </div>

    <!-- 폴더 변경 modal -->
    <div class="modal fade show" id="divModalCat" tabindex="-1" aria-labelledby="divCat" aria-modal="true" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="divCat">폴더 변경</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="card d-md-block">
                        <div class="card-body">
                            <div class="form-row">
                                <div class="form-group col-12 mb-2">
                                    <label for="changeOcwName" class="form-label w-8rem">선택 OCW</label>
                                    <span id="changeOcwName"></span>
                                    <input type="hidden" name="changeOcwNo" id="changeOcwNo" />
                                </div>
                                <div class="form-group col-12 mb-2">
                                    <label for="changeOcwCat" class="form-label w-8rem">현재 폴더</label>
                                    <span id="changeOcwCat"></span>
                                </div>

                                <div class="form-group col-12 mb-2">
                                    <label for="CatCode" class="form-label w-8rem">변경 폴더</label>
                                    <select id="CatCode" name="CatCode" class="form-control">
                                        <%
                                            string userCatcode = string.Empty;
                                            foreach (var ocwUserCat in Model.OcwUserCatList)
                                            {
                                                userCatcode = ocwUserCat.CatCode.ToString();
                                        %>
                                            <option value="<%:userCatcode %>"><%: ocwUserCat.CatName%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>

                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="row align-items-center">
                                <div class="col-6">
                                    <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 선택한 폴더에 OCW를 저장합니다.</p>
                                </div>
                                <div class="col-6 text-right">
                                    <button type="button" class="btn btn-primary" onclick="fnChangePocket();">저장</button>
                                    <button type="button" class="btn btn-outline-primary" data-dismiss="modal" title="닫기">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 페이징 --%>
    <%--<%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.dic)%>--%>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnRefresh() {
            fnSubmit();
        }

        function fnGoTab(catNo) {
            $("#UserCat").val(catNo);
            fnSubmit();
            fnPrevent();
        }

        //OCW 폴더 변경
        function fnChangeCat(catName, ocwNo, ocwName) {
            $("#changeOcwCat").text(catName);
            $("#changeOcwName").text(ocwName);
            $("#changeOcwNo").val(ocwNo);

            fnPrevent();

        }

        function fnChangePocket() {
            if (confirm("해당 폴더로 변경하시겠습니까?")) {
                ajaxHelper.CallAjaxPost("/Ocw/ChangeOcwCat", { OcwNo: $("#changeOcwNo").val(), CatCode: $("#CatCode").val() }, "fnCbSave");
            }
        }

        function fnCbSave() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                alert('변경되었습니다.');
                fnSubmit();
            }
        }

        //관심OCW 삭제
        function fnDelPocket(ocwNo) {
            if (confirm("해당 컨텐츠를 관심OCW에서 삭제하시겠습니까?")) {
                ajaxHelper.CallAjaxPost("/Ocw/DeleteOcwCat", { OcwNo: ocwNo }, "fnCbDel");
            }
        }

        function fnCbDel() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                alert('삭제되었습니다.');
                fnSubmit();
            }
        }

        //폴더관리 팝업 열기
        function fnManageCat() {
            fnOpenPopup("/Ocw/UserCategory/0", "OcwUserCat", 650, 500, 0, 0, "auto");
        }

    </script>
</asp:Content>
