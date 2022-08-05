<%@ Page Language="C#" MasterPageFile="~/Views/Shared/None.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
	<link href="/common/css/icommon.css" rel="stylesheet">
	<link href="/site/resource/www/css/style.css" rel="stylesheet">
	<link href="/site/resource/www/css/contents.css" rel="stylesheet">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="container">
		<div class="error">
			<h1 class="title text">사이트 접속제한</h1>
			<p>
				<%
					if(ViewBag.PeriodName != null)
					{
				%>
				[<%:ViewBag.PeriodName.ToString() %>]으로 사이트 접속 제한 중입니다.<br />
				<%
					}
				%>
				<%
					if(ViewBag.Period != null)
					{
				%>
				제한 예정 일시 : <%:ViewBag.Period.ToString() %>
				<%
					}
				%>
				<%
					if(ViewBag.PeriodName == null && ViewBag.Period == null)
					{
				%>
				잘못된 호출입니다.<br />
				<a href="/" class="btn btn-primary">메인으로 이동</a>
				<%
					}
				%>
			</p>
		</div>
	</div>
</asp:Content>