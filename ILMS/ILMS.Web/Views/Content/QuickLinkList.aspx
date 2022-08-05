<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/QuickLinkList" method="post">
        <input type="hidden" id="hdnSiteNo" name="FamilySiteNo" value="" />
        <h3 class="title04">퀵링크 리스트(<strong class="text-primary"><%= Model.QuickLinkList.Count.ToString("#,##0") %></strong>건)</h3>
        <div class="card">
            <div class="card-body py-0">
                <table class="table table-hover" summary="퀵링크 리스트">
                    <caption>퀵링크 리스트</caption>
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
                            foreach (var item in Model.QuickLinkList)
                            {
                        %>
                        <tr>
                            <td class="text-center"><%:item.Row %></td>
                            <td class="text-left"><%:item.QuickName %></td>
                            <td class="text-left d-none d-md-table-cell"><%:item.Url %></td>
                            <td><%:item.OutputYesNo %></td>
                            <td><%:item.DisplayOrder %></td>
                            <td class="text-center">
                                <a href="<%:item.Url %>" class="text-point" target="_blank" title="이동"><i class="bi bi-arrow-right-square"></i></a>
                            </td>
                            <td class="text-center text-nowrap">
                                <button type="button" onclick="fnUpdate('<%:item.QuickNo %>')" class="text-primary" title="수정"><i class="bi bi-pencil-square"></i></button>
                                <button type="button" onclick="fnRequest('<%:item.QuickNo %>')" class="text-danger" title="삭제"><i class="bi bi-trash"></i></button>
                                
                            </td>
                        </tr>
                        <%
                            }
                        %>

                        <% if (Model.QuickLinkList.Count.Equals(0))
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
				window.open("/Content/QuickLinkWrite", "퀵링크 등록", "width=850, height=600");
            });
        });

        function fnCompleteAdd() {
            window.location.reload();
        }

        function fnUpdate(QuickNo) {
            window.open($.stringFormat("/Content/QuickLinkWrite/{0}", QuickNo), "퀵링크 수정", "width=850, height=600,scrollbars = yes");
            return false;
        }

		function fnRequest(QuickNo) {
			bootConfirm("해당 퀵링크를 삭제하시겠습니까?", function () {
				
				_ajax.CallAjaxPost("/Content/QuickLinkDeleteAjax", { paramQuickNo: QuickNo }, "fnCompleteDelete");
			});      
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
