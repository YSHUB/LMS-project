<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Title" runat="server">아이디/비밀번호 찾기</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <div class="findid-box p-4">
        <ul class="nav nav-tabs" id="findTab" role="tablist">
          <li class="nav-item w-50 text-center" role="presentation">
            <a class="nav-link active" id="id-tab" data-toggle="tab" href="#tab1" role="tab" aria-controls="lms" aria-selected="true">아이디 찾기</a>
          </li>
          <li class="nav-item w-50 text-center" role="presentation">
            <a class="nav-link" id="password-tab" data-toggle="tab" href="#tab2" role="tab" aria-controls="button" aria-selected="false">비밀번호 찾기</a>
          </li>
        </ul>
        <div class="tab-content pt-4" id="findTabContent">
            <div class="alert p-2 border bg-light text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">
                <p class="mb-0 font-size-14 text-danger font-weight-bold"><i class="bi bi-info-circle-fill"></i> 일반 회원이 아닌 경우에는 학사시스템에서 확인하시기 바랍니다.</p>
            </div>
            <!-- 아이디 찾기 -->
            <div class="tab-pane fade active show" id="tab1" role="tabpanel" aria-labelledby="id-tab">
            <h2 class="sr-only">아이디 찾기</h2>
                <div class="find-id mb-2">
                    <div class="form-group">
                        <label for="txtNmaeForID" class="form-label">이름<strong class="text-danger">*</strong></label>
                        <input class="form-control" id="txtNmaeForID" name="user.HangulName" type="text" value="">
                    </div>
                    <div class="form-group">
                        <label for="txtEmailForID" class="form-label">이메일주소<strong class="text-danger">*</strong></label>
                        <input class="form-control" id="txtEmailForID" name="user.Email" value="" type="text">
                    </div>
                </div>
                <div class="text-center">
                    <button type="button" id="btnSearchID" class="btn btn-primary">아이디 찾기</button>
                </div>
            </div>
            <!-- 아이디 찾기 -->

            <!-- 비밀번호 찾기 -->
            <div class="tab-pane fade" id="tab2" role="tabpanel" aria-labelledby="password-tab">
            <h2 class="sr-only">비밀번호 찾기</h2>

            <div class="find-password mb-2">
              <div class="form-row">
                <div class="form-group col-12">
                  <label for="user_HangulName2" class="form-label">이름<strong class="text-danger">*</strong></label>
                  <input class="form-control" id="user_HangulName2" name="user.HangulName2" value="" type="text">
                </div>
                <div class="form-group col-12">
                  <label for="txtUserIdForPW" class="form-label">아이디<strong class="text-danger">*</strong></label>
                  <input class="form-control" id="txtUserIdForPW" name="user.UserID" value="" type="text">
                </div>
                <div class="form-group col-12">
                  <label for="user_Email2" class="form-label">이메일주소<strong class="text-danger">*</strong></label>
                  <input class="form-control" id="user_Email2" name="user.Email2" value="" type="text">
                </div>
              </div>
            </div>
            <div class="text-center">
              <button type="button" id="btnSearchPW" class="btn btn-primary">비밀번호 초기화</button>
            </div>
            </div>
            <!-- 비밀번호 찾기 -->

        </div>
    </div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>
        var _ajax = new AjaxHelper();

        $(document).ready(function () {

            // 아이디 찾기
            $("#btnSearchID").click(function () {
                if ($("#txtNmaeForID").val() == "") {
					bootAlert("이름을 입력하세요.", function () {
						$("#txtNmaeForID").focus();
					});
					return false;
                }
                if ($("#txtEmailForID").val() == "") {
					bootAlert("이메일주소를 입력하세요.", function () {
						$("#txtEmailForID").focus();
					});
					return false;
                }
                _ajax.CallAjaxPost("/Account/CheckID", { "paramHangulName": $("#txtNmaeForID").val(), "paramEmail": $("#txtEmailForID").val() }, "fnIDSearchResult");
            });

            //비밀번호 찾기
            $("#btnSearchPW").click(function () {
                if ($("#user_HangulName2").val() == "") {
                    bootAlert("이름을 입력하세요.", function () {
						$("#user_HangulName2").focus();
                    });
                    return false;
                }
                if ($("#txtUserIdForPW").val() == "") {
                    bootAlert("<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>을 입력하세요.", function () {
                        $("#txtUserIdForPW").focus();
                    });
                    return false;
                }
                if ($("#user_Email2").val() == "") {
                    bootAlert("이메일주소를 입력하세요.", function () {
                        $("#user_Email2").focus();
                    });
                    return false;
                }

				_ajax.CallAjaxPost("/Account/ChkUser", { "paramHangulName": $("#user_HangulName2").val(), "paramUserID": $("#txtUserIdForPW").val(), "paramEmail": $("#user_Email2").val() }, "fnCompleteChkUser");
            });
        });

		function fnCompleteChkUser() {
            var result = _ajax.CallAjaxResult();
			if (result == "ChkUser") {

				bootConfirm("비밀번호가 사용자의 휴대폰번호 뒤 8자리로 변경됩니다. 초기화하시겠습니까?", function () {
					_ajax.CallAjaxPost("/Account/ResetPassword2", { "paramHangulName": $("#user_HangulName2").val(), "paramUserID": $("#txtUserIdForPW").val(), "paramEmail": $("#user_Email2").val() }, "fnResetPasswordCallBack2");
                });
            } else {
				bootAlert("입력하신 정보와 일치하는 정보를 찾을수 없습니다.\n<%=ConfigurationManager.AppSettings["UnivName"].ToString() %>에 가입하지 않았거나\n입력란에 오타가 있는지 다시 한번 확인해 주십시오.");
            }
        }

		function fnResetPasswordCallBack2() {
			var result = _ajax.CallAjaxResult();
			if (result == 1) {

                bootAlert("비밀번호가 초기화 되었습니다.");
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

        function fnIDSearchResult() {

            var result = _ajax.CallAjaxResult();
            console.log(result);
            if (result.length > 0) {
                bootAlert("찾으시는 아이디는 " + result + " 입니다.");
            }
            else {
                bootAlert("입력하신 정보와 일치하는 ID를 찾을수 없습니다.\n<%=ConfigurationManager.AppSettings["UnivName"].ToString() %>에 가입하지 않았거나\n입력란에 오타가 있는지 다시 한번 확인해 주십시오.");
            }
        }

	</script>
</asp:Content>
