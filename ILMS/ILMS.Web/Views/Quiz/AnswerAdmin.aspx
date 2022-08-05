<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<% Html.RenderPartial("/Views/Shared/Exam/CandidatesEstimationAdmin.ascx"); %>
</asp:Content>