<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/WeekList/<%:ViewBag.Course.CourseNo%>" id="mainForm" method="post">
        
        <!-- 탭리스트 -->
        <ul class="nav nav-tabs mt-3" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <a class="nav-link"  id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="false"
                     onclick="javascript:location.href='/Ocw/LectureRoom/<%:ViewBag.Course.CourseNo%>'">OCW 연계 현황 <!--등록현황? -->
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link active show" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="true">OCW 연계 목록
                </a>
            </li>
            <li class="nav-item" role="presentation">
                <a class="nav-link" id="tab3" href="#" data-toggle="tab" role="tab" aria-controls="tab3" aria-selected="false"
                     onclick="javascript:location.href='/Ocw/ProfOcwAuth/<%:ViewBag.Course.CourseNo%>'">신청/승인
                </a>
            </li>
        </ul>

        <% Html.RenderPartial("/Views/Shared/OCW/WeekListData.ascx"); %>
    </form>
</asp:Content>


<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>
