<%@ Page Language="C#" MasterPageFile="~/Views/Shared/None.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
	<link href="/common/css/icommon.css" rel="stylesheet">
	<link href="/site/resource/www/css/style.css" rel="stylesheet">
	<link href="/site/resource/www/css/contents.css" rel="stylesheet">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="error">
		<h1 class="title number">404</h1>
		<p>
			오류가 발생하였습니다.<br />
			<span class="font-size-20">[ <%:ViewBag.InfoMessage.ToString() %> ]</span>
		</p>
		<a href="javascript:history.back();" class="btn btn-primary">이전으로 돌아가기</a>
	</div>
</asp:Content>