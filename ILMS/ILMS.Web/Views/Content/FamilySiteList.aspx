<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/FamilySiteList" method="post">
        <input type="hidden" id="hdnSiteNo" name="FamilySiteNo" value="" />
        <h3 class="title04">관련사이트 리스트(<strong class="text-primary"><%=Model.FamilySiteList.Count.ToString("#,##0") %></strong>건)</h3>
        <div class="card">
            <div class="card-body py-0">
                <table class="table table-hover" summary="관련사이트 리스트">
                    <caption>관련사이트 리스트</caption>
                    <thead>
                        <tr>
                            <th scope="col">No</th>
                            <th scope="col">설명</th>
                            <th scope="col" class="d-none d-md-table-cell">URL</th>
                            <th scope="col" class="text-nowrap">사용여부</th>
                            <th scope="col" class="text-nowrap">표시순서</th>
                            <th scope="col">바로가기</th>
                            <th scope="col">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                        <% 
                            foreach (var item in Model.FamilySiteList)
                            {
                        %>
                        <tr>
                            <td class="text-center"><%:item.Row %></td>
                            <td class="text-left"><%:item.SiteName %></td>
                            <td class="text-left d-none d-md-table-cell"><%:item.SiteUrl %></td>
                            <td><%:item.OutputYesNo %></td>
                            <td><%:item.DisplayOrder %></td>
                            <td class="text-center">
                                <a href="<%:item.SiteUrl %>" class="text-point" target="_blank" title="이동"><i class="bi bi-arrow-right-square"></i></a>
                            </td>
                            <td class="text-center text-nowrap">
                                <button type="button" onclick="fnUpdate('<%:item.SiteNo %>')" class="text-primary" title="수정"><i class="bi bi-pencil-square"></i></button>
                                <button type="button" onclick="fnDelete('<%:item.SiteNo %>')" class="text-danger" title="삭제"><i class="bi bi-trash"></i></button>
                                
                            </td>
                        </tr>
                        <%
                            }
                        %>

                        <% if (Model.FamilySiteList.Count.Equals(0))
                            {
                        %>
                        <tr>
                            <td colspan="7" class="text-center">검색결과가 없습니다.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 text-right">
                        <span class="btn_pack large">
                            <button type="button" id="btnNew" class="btn btn-primary">등록</button></span>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        var _ajax = new AjaxHelper();

        $(document).ready(function () {
            $("#btnNew").click(function () {
				window.open("/Content/FamilySiteWrite", "관련사이트등록", "width=850, height=600");
            });
        });

        function fnCompleteAdd() {
            window.location.reload();
        }

        function fnUpdate(SiteNo) {
            window.open($.stringFormat("/Content/FamilySiteWrite/{0}", SiteNo), "관련사이트 수정", "width=850, height=600,scrollbars = yes");
            return false;
        }

        function fnDelete(SiteNo) {
            if (confirm("관련사이트 링크를 삭제하시겠습니까?")) {
                _ajax.CallAjaxPost("/Content/FamilySiteDeleteAjax", { paramSiteNo: SiteNo }, "fnCompleteDelete");
            }

        }

        function fnCompleteDelete() {
            var result = _ajax.CallAjaxResult();

            if (result > 0) {
                bootAlert("삭제되었습니다.", function () {
                    window.location.reload();
                });
            }
            else {
                bootAlert("실행 중 오류가 발생하였습니다.");
            }
        }

    </script>
</asp:Content>
