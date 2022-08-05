<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ContentViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Content/BannerList" id="mainForm" method="post">
    <input type="hidden" id="hdnBannerNo" name="banner.BannerNo" value="" />
        <h3 class="title04">배너 리스트(<strong class="text-primary"><%:Model.PageTotalCount.ToString("#,##0") %></strong>건)</h3>
        <div class="card">
            <div class="card-body py-0">
                <table class="table" summary="배너 리스트">
                    <caption>배너 리스트</caption>
                    <thead>
						<tr>
							<th scope="col">No</th>
							<th scope="col">배너설명</th>
							<th scope="col">출력기간</th>
							<th scope="col">출력여부</th>
							<th scope="col">출력순서</th>
							<th scope="col">관리</th>
						</tr>
					</thead>
                    <tbody>
                    <% 
                        foreach (var item in Model.BannerList)
                        { 
                    %>
                        <tr>
                            <td><%:item.Row %></td>
                            <td class="text-nowrap text-left"><%:item.BannerExplain %></td>
                            <td><%:item.StartDay %>~<%:item.EndDay%></td>
                            <td><%:item.OutputYesNo%></td>
                            <td><%:item.SortNo%></td>
                            <td>
                                <button type="button" onclick="fnUpdate('<%:item.BannerNo %>')" class="text-primary" title="수정"><i class="bi bi-pencil-square"></i></button>
                                <button type="button" onclick="fnDelete('<%:item.BannerNo %>')" class="text-danger" title="삭제"><i class="bi bi-trash"></i></button>
                            </td>
                        </tr>
                    <%
                        }
                    %>

                    <% if (Model.BannerList.Count.Equals(0))
                        {
                            %>
                            <tr><td colspan="6" class="text-center">검색결과가 없습니다.</td></tr>
                    <%
                        }                  
                    %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 text-right">
                        <button type="button" id="btnNew" class="btn btn-primary">등록</button>
                    </div>
                </div>
                </div>
            </div>
        <!-- paginate-->
        <%= Html.Pager((int)Model.PageNum, 10, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
        <!--//paginate-->
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <script type="text/javascript">
        var _ajax = new AjaxHelper();

        $(document).ready(function () {
            $("#btnNew").click(function () {
				window.open("/Content/BannerWrite", "배너등록", "width=850, height=750");
            });
        });

        function fnCompleteAdd() {
            window.location.reload();
        }

        function fnUpdate(bannerNo) {
			window.open($.stringFormat("/Content/BannerWrite/{0}", bannerNo), "배너수정", "width=850, height=750");
            return false;
        }

        function fnDelete(bannerNo) {
            if (confirm("배너를 삭제하시겠습니까?")) {
                _ajax.CallAjaxPost("/Content/BannerDeleteAjax", { paramBannerNo : bannerNo }, "fnCompleteDelete");
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