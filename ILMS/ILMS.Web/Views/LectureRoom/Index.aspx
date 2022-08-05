<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <div class="mt-4 alert bg-light rounded">
        <ul class="list-style03">
            <li class="text-warning">온라인강의 경우, 동영상 강의 버튼을 클릭하시면, 강의를 수강하실 수 있습니다.</li>
            <li class="text-primary">출석기간 내에 강의를 들으신 후 반드시 학습현황 메뉴에서 출석 여부를 확인하시기 바랍니다. </li>
        </ul>
    </div>
    
    <%
        if (ViewBag.Course.IsProf == 1)
        {
    %>
        <% Html.RenderPartial("/Views/Shared/Lecture/LectureIndexProf.ascx");

    %>

    <%
        }
        else
        {
    %>
         <% Html.RenderPartial("/Views/Shared/Lecture/LectureIndexStud.ascx"); %>
    <%
        }
    %>
    
    <%-- ocwView관련 --%>
    <form id="frmpop">
        <input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
        <input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
    </form>
   
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">

    <script type="text/javascript">

    </script>
</asp:Content>
