<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Ocw/ThemeList/0" id="mainForm" method="post">
        <div class="card">
            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" cellspacing="0" summary="">
                        <thead>
                            <tr>
                                <th scope="col">순서</th>
                                <th scope="col">테마키워드</th>
                                <th scope="col">등록일</th>
                                <th scope="col">관리전용</th>
                                <th scope="col">공개여부</th>
                                <th scope="col">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                foreach (var theme in Model.OcwThemeList)
                                {
                            %>
                                <tr>
                                    <td class="text-center"><%: theme.RowNum%></td>
                                    <td class="text-center"><%: theme.ThemeName%></td>
                                    <td class="text-center"><%: theme.CreateDateTime%></td>
                                    <td class="text-center"><%: theme.IsAdminName%></td>
                                    <td class="text-center"><%: theme.IsOpenName%></td>
                                    <td><button type="button" class="btn btn-sm btn-secondary" onclick="fnOpenThemePopup(<%:theme.ThemeNo %>);"">관리</button></td>
                                </tr>
                            <%
                                }
                            %>

                            <tr>
                                <td colspan="6" class="text-center <%: Model.OcwThemeList.Count() > 0 ? "d-none" : ""%>">등록된 테마키워드가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 text-right">
                        <button type="button" class="btn btn-primary" id="btnDel" onclick="fnOpenThemePopup(0);">신규키워드 등록</button>
                    </div>
                </div>
            </div>
        </div>

    </form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        function fnOpenThemePopup(themeNo) {
            fnOpenPopup("/Ocw/ThemeWrite/" + themeNo, "ThemeRegPop", 450, 550, 0, 0, "auto");
        }

    </script>

</asp:Content>
