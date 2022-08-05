<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<%-- 퀴즈 풀기 --%>
	<% Html.RenderPartial("/Views/Shared/Exam/QuestionRun.ascx"); %>
</asp:Content>