<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Content/PopupList" method="post">
        <div class="row">
		<div class="col-12 mt-2">
			<h3 class="title04">팝업 리스트(<strong class="text-primary"><%=Model.PageTotalCount.ToString("#,##0") %></strong>건)</h3>
		</div>
	</div>
        <div class="card">
            <div class="card-body py-0">
                <table class="table table-hover" summary="팝업목록">
                    <caption>팝업 목록</caption>
                    <thead>
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">팝업제목</th>
                        <th scope="col" class="text-nowrap d-none d-md-table-cell">출력기간</th>
                        <th scope="col" class="text-nowrap d-none d-lg-table-cell">창 위치</th>
                        <th scope="col" class="text-nowrap d-none d-lg-table-cell">창 크기</th>
                        <th scope="col" class="text-nowrap d-none d-md-table-cell">출력여부</th>
                        <th scope="col">관리</th>
                    </tr>
                        </thead>
                    <tbody>
                    <% 
                        foreach (var item in Model.PopupList)
                        { 
                    %>
                    <tr>
                        <td class="text-center"><%:item.Row %></td>
						<td class="text-left"><span class=""><%:item.PopupTitle %></span></td>
                        <td class="text-nowrap d-none d-md-table-cell"><%:item.StartDay %>~<%:item.EndDay%></td>
                        <td class="text-nowrap d-none d-lg-table-cell"><%:item.LeftMargin %>x<%:item.TopMargin %></td>
                        <td class="text-nowrap d-none d-lg-table-cell"><%:item.WidthSize %>x<%:item.HeightSize %></td>
                        <td class="text-center d-none d-md-table-cell"><%: item.OutputYesNo%></td>
                        <td class="text-center text-nowrap">
                            <button type="button" onclick="fnUpdate('<%:item.PopupNo %>')" class="text-primary" title="수정"><i class="bi bi-pencil-square"></i></button>
                            <button type="button" onclick="fnDelete('<%:item.PopupNo %>')" class="text-danger" title="삭제"><i class="bi bi-trash"></i></button>
                        </td>
                    </tr>
                    <%
                        }
                    %>

                    <% if (Model.PopupList.Count.Equals(0))
                        {
                    %>
                        <tr><td colspan="7" style="text-align:center;">검색결과가 없습니다.</td></tr>
                    <%
                        }                  
                    %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <div class="text-right">
                    <button type="button" id="btnNew" class="btn btn-primary">등록</button>
                </div>
            </div>
        </div>
        <%= Html.Pager((int)Model.PageNum, 10, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        var _ajax = new AjaxHelper();

        $(document).ready(function () {
            $("#btnNew").click(function () {
                window.open("/Content/PopupWrite", "팝업등록", "width=850, height=800");
            });
        });

        function fnCompleteAdd() {
            window.location.reload();
        }

        function fnUpdate(PopupNo) {
            window.open($.stringFormat("/Content/PopupWrite/{0}", PopupNo), "팝업수정", "width=850, height=800");
            return false;
        }

        function fnDelete(PopupNo) {
            bootConfirm("팝업을 삭제하시겠습니까?", fnDeleteConfirm,PopupNo)
        }

        function fnDeleteConfirm(PopupNo) {
            _ajax.CallAjaxPost("/Content/PopupDeleteAjax", { paramPopupNo: PopupNo }, "fnCompleteDelete");
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
