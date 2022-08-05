<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Ocw/MyOcw/0" id="mainForm" method="post">
        
        <%: Html.HiddenFor(m => m.UserCat) %>

        <div class="text-right">
            <button type="button" onclick="fnOpenUserCategory();" class="btn btn-secondary"><i class="bi bi-folder-plus"></i> <span class="d-none d-md-inline-block"> 폴더 추가</span></button>
            <button type="button" onclick="fnOpenOcwReg(0);" class="btn btn-primary"><i class="bi bi-plus-circle"></i> <span class="d-none d-md-inline-block"> 새 콘텐츠 추가</span></button>
        </div>

        <!-- 폴더 리스트 -->
        <div class="card">
            <div class="card-body bg-light">
                <ul class="list-inline list-inline-style02 mb-0">
                    <li class="list-inline-item bar-vertical">
                        <a href="#" onclick="fnGoTab(-1);">전체<span class="ml-1 badge badge-<%:Convert.ToInt32( Model.UserCat) == -1 ? "primary" : "secondary" %>"><%: Model.OcwUserCatList.Sum(s => s.OcwCount).ToString("#,0") %></span></a>
                    </li>

                    <%
                        foreach(var ocwUserCat in Model.OcwUserCatList)
			            {
                    %>
                        <li class="list-inline-item bar-vertical">
                            <a href="#" onclick="fnGoTab(<%:ocwUserCat.CatCode %>);"><%: ocwUserCat.CatName %>
                                <span class="ml-1 badge badge-<%:Convert.ToInt32(Model.UserCat) == ocwUserCat.CatCode ? "primary" : "secondary" %>"><%: ocwUserCat.OcwCount.ToString("#,0") %></span>                            
                            </a>
                        </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>


        <div class="card">
            <div class="card-body pb-1">
                <div class="form-row align-items-end">
                    <div class="form-group col-6 col-md-2">
                        <label for="" class="sr-only">공개상태</label>
                        <select id="OpenGb" name="OpenGb" class="form-control">
                            <option value="%" selected="selected">공개상태 전체</option>
                            <%
                                foreach (var OpenGb in Model.BaseCode.Where(w => w.ClassCode.ToString() == "OPGB"))
                                {
                            %>
                                <option value ="<%: OpenGb.CodeValue %>" <%: OpenGb.CodeValue == Model.OpenGb ? "selected" : "" %>><%: OpenGb.CodeName%></option>
                            <%
                                }
                            %>

                        </select>
                    </div>
                    <div class="form-group col-6 col-md-2">
                        <label for="" class="sr-only">등록상태</label>
                        <select id="AuthGb" name="AuthGb" class="form-control">
                            <option value="%" selected="selected">등록상태 전체</option>
                            <%
                                foreach (var AuthGb in Model.BaseCode.Where(w => w.ClassCode.ToString() == "ERGB"))
                                {
                            %>
                                <option value ="<%: AuthGb.CodeValue %>" <%: AuthGb.CodeValue == Model.AuthGb ? "selected" : "" %>><%: AuthGb.CodeName%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group col-12 col-md-auto">
                        <label for="" class="sr-only">검색어</label>
                        <input id="SearchText" name="SearchText" type="text" class="form-control" placeholder="검색어" value="<%:Model.SearchText %>">
                    </div>

                    <div class="form-group col-sm-auto text-right">
                        <button type="button" id="btn_search" class="btn btn-secondary" onclick="fnGoSearch();">
                            <span class="icon search">검색</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- card -->

        <div class="card mt-4">
            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" cellspacing="0" summary="">
                        <thead>
                            <tr>
                                <th scope="col">폴더</th>
                                <th scope="col">제목</th>
                                <th scope="col">등록일</th>
                                <th scope="col">관리</th>
                                <th scope="col">등록상태</th>
                                <th scope="col">강의적용수</th>
                            </tr>
                        </thead>
                        <tbody>

                <%
                        foreach (var myOcw in Model.OcwList)
                        {
                %>
                        <tr>
                            <td><%: myOcw.CatName %></td>
                            <td class="text-left text-nowrap">
                                <a href="/Ocw/Detail/<%: myOcw.OcwNo %>"><%: myOcw.OcwName %></a>
                            </td>
                            <td class="text-nowrap text-center"><%: myOcw.CreateDateTime %></td>
                            <td>
                                <button type="button" onclick="fnOpenOcwReg(<%: myOcw.OcwNo %>);" class="btn btn-outline-warning">수정</button>
                            </td>
                            <td class="text-center"><%: myOcw.OcwAuthName %></td>
                            <td class="text-center"><%: myOcw.CourseCount.ToString("#,0")%></td>
                        </tr>
                <%
                        }
                %>                           
                        <tr><td colspan="6" class="text-center <%: Model.OcwList.Count() > 0 ? "d-none" : "" %>">등록된 나의 OCW가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- card -->

    <%-- 페이징 --%>
    <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>

    </form>

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

        function fnGoSearch() {
            $("#OpenGb").val($("#OpenGb option:selected").val());
            $("#AuthGb").val($("#AuthGb option:selected").val());

            fnSubmit();
        }

        //폴더관리 팝업 열기
        function fnOpenUserCategory() {
            fnOpenPopup("/Ocw/UserCategory/0", "OcwUserCat", 600, 500, 0, 0, "auto");
        }

        //새 컨텐츠 추가 팝업 열기
        function fnOpenOcwReg(ocwNo) {
            fnOpenPopup("/Ocw/OcwReg/" + ocwNo, "OcwReg", 850, 800, 0, 0, "auto");
        }

    </script>

</asp:Content>
