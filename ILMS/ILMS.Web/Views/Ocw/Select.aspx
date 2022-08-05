<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/Select/0" id="mainForm" method="post">
        <div class="card search-form m-3">
            <div class="card-body pb-1">
                <div class="form-row align-items-end">
                    <div class="form-group">
                        <label for="UserCatModal" class="sr-only"></label>
                        <select id="UserCat" name="UserCat" class="form-control">
                            <option value="-1">전체(<%: Model.OcwUserCatList.Sum(s => s.OcwCount).ToString("#,0") %>)</option>
                            <%
                                foreach (var ocwUserCat in Model.OcwUserCatList)
                                {
                            %>
                                <option value="<%: ocwUserCat.CatCode %>" <%: ocwUserCat.CatCode == Convert.ToInt32(Model.UserCat) ? "selected" : "" %>><%: ocwUserCat.CatName%>(<%: ocwUserCat.OcwCount.ToString("#,0") %>)</option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group col-5 ">
                        <label for="" class="sr-only">검색어</label>
                        <input id="SearchText" name="SearchText" type="text" class="form-control" placeholder="콘텐츠명 검색" value="<%:Model.SearchText %>">
                    </div>

                    <div class="form-group col-sm-auto text-right">
                        <button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch();">
                            <span class="icon search">검색</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="form-row m-3">
            <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 콘텐츠명을 클릭하시면 선택이 완료됩니다.</p>
            <div class="col-12 p-0">
                <div class="card">
                    <div class="card-body py-0">
                        <div class="table-responsive">
                            <table id="OcwList" class="table table-hover " cellspacing="0" summary="">
                                <thead>
                                    <tr>
                                        <th scope="col">제목</th>
                                        <th scope="col">등록일</th>
                                        <%--<th scope="col">관리</th>--%>
                                    </tr>
                                </thead>
                                <tbody>

                                    <%
                                        foreach (var myOcw in Model.OcwList)
                                        {
                                    %>
                                    <tr>
                                        <td class="text-left">
                                            <button type="button" onclick="fnSelectOcw(<%:myOcw.OcwNo %>, '<%: myOcw.OcwName %>');">
                                                [<%: myOcw.CatName %>] <%: myOcw.OcwName %></button>
                                        </td>
                                        <td class="text-center text-nowrap "><%: myOcw.CreateDateTime %></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    <tr>
                                        <td colspan="3" class="text-center <%: Model.OcwList.Count() > 0 ? "d-none" : "" %>">OCW가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
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
        function fnSearch() {
            fnSubmit();
        }

        function fnSelectOcw(ocwNo, ocwName) {
            opener.fnSetSelectOcw(ocwNo, ocwName);
            self.close();
        }

    </script>

</asp:Content>
