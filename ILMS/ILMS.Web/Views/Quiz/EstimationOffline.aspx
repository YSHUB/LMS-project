<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<%-- 응시자 리스트 --%>
	<% Html.RenderPartial("/Views/Shared/Exam/CandidatesOffline.ascx"); %>
</asp:Content>