<%@ Page Language="C#" MasterPageFile="~/Views/Shared/None.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
	<link href="/common/css/icommon.css" rel="stylesheet">	
	<link href="/site/resource/www/css/login.css" rel="stylesheet" type="text/css">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="login-box">
		<div class="container">
			<h1 class="site-title">
				<span class="site-logo"><%:ConfigurationManager.AppSettings["UnivName"].ToString() %></span> 
				<span class="sub-site-title"><a href="/"><%:ConfigurationManager.AppSettings["OriginSystemName"].ToString() %></a></span>
			</h1>
			<form method="post" name="mainForm" action="/Account/LogOnProcess">
				<div class="signin-box">
					<h2 class="title">로그인</h2>
					<div class="sec-form">
						<% 
						if (ConfigurationManager.AppSettings["UnivCode"].ToString().Equals("HYC"))
						{
						%>
							<div class="form-group">
								<input type="radio" class="radio" name="LoginGbn" value="S" checked="checked" /><%:ConfigurationManager.AppSettings["StudentText"].ToString() %>
								<input type="radio" class="radio" name="LoginGbn" value="E" /><%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %>
							</div>
						<%
							}
						%>
						<div class="form-group">
							<label for="txtUserID" class="sr-only">아이디</label>
							<input title="ID" id="loginId" name="userid" class="form-control" type="text" tabindex="1" placeholder="아이디" />
						</div>
						<div class="form-group">
							<label for="txtPasswd" class="sr-only">비밀번호</label>
							<input title="Password" id="loginPw" name="password" class="form-control" type="password" tabindex="2" placeholder="비밀번호" />
						</div>
						<input type="submit" name="btnLogin" value="로그인" id="btnLogin" class="btn btn-primary btn-login" tabindex="3">
					</div>
					<div class="btn-group">
					<%
						if (ConfigurationManager.AppSettings["IDSearchYN"].ToString() == "Y")
						{
					%>
						<button type="button" class="text-secondary" onclick="fnOpenPopup('/Account/IDPWSearch', 'IDPWSearch', 500, 600, 0, 0, 'auto')" title="새창열림">아이디/비밀번호 찾기</button>
					<%
						}
						if (ConfigurationManager.AppSettings["JoinYN"].ToString() == "Y")
						{
					%>
						<a href="/Account/JoinGeneral" class="text-secondary">회원가입</a>
					<%
						}
					%>		
					</div>
				</div>
			</form>
		</div>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script>
		$(document).ready(function () {
			$("body").attr("class", "login");

			$("#loginId").focus();

			$("#loginId").on("keydown", function (e) {
				if (e.keyCode == 13) {
					$("#loginPw").focus();
				}
			});

			$("#loginPw").on("keydown", function (e) {
				if (e.keyCode == 13) {
					document.forms["mainForm"].submit();
				}
			});

			$("#btnLogin").click(function () {
				if ($("#loginId").val() == "") {
					bootAlert("아이디를 입력하세요.", function () {
						$("#loginId").focus();
					});
					return false;
				}
				else if ($("#loginPw").val() == "") {
					bootAlert("비밀번호를 입력하세요.", function () {
						$("#loginPw").focus();
					});
					return false;
				}
				else {
					document.forms["mainForm"].submit();
				}
				fnPrevent();
			});
		});
	</script>
</asp:Content>