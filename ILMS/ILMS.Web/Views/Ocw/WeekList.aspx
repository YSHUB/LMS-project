<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/WeekList/<%:ViewBag.Course.CourseNo%>" id="mainForm" method="post">

        <% Html.RenderPartial("/Views/Shared/OCW/WeekListData.ascx"); %>
        
    </form>
</asp:Content>


<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
</asp:Content>
