<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/MyPage/Withdrawal" name="mainForm" id="mainForm" method="post">
		<div class="findid-box">	
			
			<div class="alert border bg-light text-center mt-0 mb-4">
                <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 탈퇴를 하실 경우 현재 비밀번호만 입력하세요.</p>
            </div>


			<div class="find-password mb-2">
				<div class="form-row">
					<div class="form-group col-12">
						<label for="user_HangulName2" class="form-label">현재 비밀번호<strong class="text-danger">*</strong></label>
						<input class="form-control" id="txtPassword" name="Student.Password" value="" type="password">
					</div>
					<div class="form-group col-12 mt-4">
						<label for="txtUserIdForPW" class="form-label">새 비밀번호<strong class="text-danger">*</strong></label>
						<input class="form-control" id="txtNewPassword" name="Student.NewPassword" value="" type="password">
					</div>
					<div class="form-group col-12">
						<label for="user_Email2" class="form-label">새 비밀번호 확인<strong class="text-danger">*</strong></label>
						<input class="form-control" id="txtNewPasswordCheck" value="" type="password">
					</div>
				</div>
			</div>
			<div class="text-right">
				<button type="button" id="btnSearchPW" class="btn btn-primary" onclick="fnChangePwd();">비밀번호 변경</button>
				<button type="button" id="btnWithdrawal" class="btn btn-danger" onclick="fnWithdrawal();">탈퇴</button>
				<a href="/MyPage/WriteInfo" type="button" class="btn btn-secondary">취소</a>
			</div>
		</div>

	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script>

		var ajaxHelper = new AjaxHelper();

		<%-- 공백제거 --%>
		function val(id) {
			if ($("#" + id).length < 1) {
				return "";
			}
			return $.trim($("#" + id).val());
		}

		function fnChangePwd() {
			var pwReg = /[a-zA-Z]/g;
			var pwReg2 = /[0-9]/g;
			var pwReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;

			if (val("txtPassword").length == 0) {
				bootAlert("현재 비밀번호를 입력하세요.", function () {
					$("#txtPassword").focus();
				});

				return false;
			}
			else if (val("txtNewPassword").length == 0) {
				bootAlert("새 비밀번호를 입력하세요.", function () {
					$("#txtNewPassword").focus();
				});

				return false;
			}
			else if (val("txtNewPassword").length < 8 || !pwReg.test(val("txtNewPassword")) || !pwReg2.test(val("txtNewPassword")) || !pwReg3.test(val("txtNewPassword"))) {
				bootAlert("8자리 이상의 [영문/숫자/특수문자]로 조합된 비밀번호를 입력해주세요.", function () {
					$("#txtNewPassword").focus();
				});

				return false;
			}
			else if (val("txtNewPassword") != val("txtNewPasswordCheck")) {
				bootAlert("비밀번호가 일치하지 않습니다.", function () {
					$("#txtNewPassword").val('');
					$("#txtNewPasswordCheck").val('');
				});

				return false;
			}
			else if (val("txtPassword") == val("txtNewPassword")) {
				bootAlert("현재 비밀번호와 다른 비밀번호를 입력하세요", function () {
					$("#txtNewPassword").val('');
					$("#txtNewPasswordCheck").val('');
				});

				return false;
			}			
			else {
				bootConfirm("비밀번호를 변경하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Mypage/PasswordCheck", { password: $("#txtPassword").val() }, "fnCbPasswordCheck", 1);
					//ajaxHelper.CallAjaxPost("/Mypage/ChangePassword", { newPassword: $("#txtNewPassword").val() }, "fnCbChangePwd" );
				});
			}
		}

		function fnCbPasswordCheck(gbn) {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0 && gbn == 1) {
				ajaxHelper.CallAjaxPost("/Mypage/ChangePassword", { newPassword: $("#txtNewPassword").val() }, "fnCbChangePwd");
			} else if (result > 0 && gbn == 2) {
				ajaxHelper.CallAjaxPost("/Mypage/UserWithdrawal", { password: $("#txtPassword").val() }, "fnCbWithdrawal");
			} else {
				bootAlert("현재 비밀번호가 일치하지 않습니다. 다시 비밀번호를 확인하세요", function () {
					$("#txtPassword").val('');
					$("#txtNewPassword").val('');
					$("#txtNewPasswordCheck").val('');
				});

				return false;
			}
		}


		function fnCbChangePwd() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("비밀번호가 변경되었습니다.", function () {
					window.location.href = "/Mypage/MyInfo";
				});
			} else {
				bootAlert("오류가 발생하였습니다.");
				return false;
			}
		}


		function fnWithdrawal() {

			if (val("txtPassword").length == 0) {
				bootAlert("현재 비밀번호를 입력하세요.", function () {
					$("#txtPassword").focus();
				});

				return false;
			}

			bootConfirm("탈퇴시 수강이력등 모든 정보가 없어지며, 재가입해도 복구 불가능합니다. 탈퇴하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Mypage/PasswordCheck", { password: $("#txtPassword").val()}, "fnCbPasswordCheck", 2);
			});
		}

		function fnCbWithdrawal() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("탈퇴 되었습니다.", function () {
					window.location.href = "/Account/Logout";
				});
			} else {
				bootAlert("오류가 발생하였습니다.");
				return false;
			}
		}

	</script>
</asp:Content>
