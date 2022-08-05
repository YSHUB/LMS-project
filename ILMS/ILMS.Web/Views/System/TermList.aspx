<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.SystemViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <link href="/site/resource/www/css/contents.css" rel="stylesheet">
    <form action="/System/TermList" id="mainForm" method="post">
        <div class="row">
            <div class="col-12 mt-2">
                <h3 class="title04"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 리스트(<strong class="text-primary"><%=Model.TermList.Count.ToString("#,##0") %></strong>건)</h3>
            </div>
        </div>
        <div class="card">
            <div class="card-body py-0">
                <div class="table-responsive">
                    <table class="table table-hover" summary="<%:ConfigurationManager.AppSettings["TermText"].ToString() %>설정리스트입니다. ">
                        <caption><%:ConfigurationManager.AppSettings["TermText"].ToString() %>설정 리스트</caption>
                        <thead>
                            <tr>
                                <th scope="col">년도</th>
                                <th scope="col"><%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
                                <th scope="col">운영기간</th>
                        <%--        <th scope="col">수강신청기간</th>--%>
                                <th scope="col">수강기간</th>
                                <th scope="col">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                foreach (var item in Model.TermList)
                                {
                            %>
                            <tr>
                                <td class="text-center"><%:item.TermYear%></td>
                                <td class="text-center"><%:item.TermSemester%></td>
                                <td class="text-center text-nowrap"><%:item.TermStartDay%>~<%:item.TermEndDay.Substring(0, 10)%></td>
                                <%--<td class="text-center"><%:item.LectureRequestStartDay%>~<%:item.LectureRequestEndDay.Substring(0, 10)%></td>--%>
                                <td class="text-center text-nowrap"><%:item.LectureStartDay%>~<%:item.LectureEndDay.Substring(0, 10)%></td>
                                <td class="text-center">
                                    <a class="text-primary" href="/System/TermWrite/<%=item.TermNo%>" title="수정"><i class="bi bi-pencil-square"></i></a>
                                </td>
                            </tr>
                            <%
                                }
                                if (Model.TermList.Count < 1)
                                {
                            %>
                            <tr>
                                <td colspan="5" class="text-center">등록된 내용이 없습니다.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-6">
            </div>
            <div class="col-6">
                <div class="text-right">
                    <button type="button" class="btn btn-primary" onclick="fnTermSave();">등록</button>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

        function fnTermSave() {
            document.location.href = "/System/TermWrite";
        }

    </script>
</asp:Content>