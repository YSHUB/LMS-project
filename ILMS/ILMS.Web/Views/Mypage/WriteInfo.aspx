<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<form action="/MyPage/WriteInfo" name="mainForm" id="mainForm" method="post">
		<div id="divJoinForm">
			<div class="card card-style01">
				<div class="card-header">
					<p class="mb-0"><i class="bi bi-info-circle-fill"></i>모든 항목은 <strong class="text-danger">필수입력</strong> 항목입니다.</p>
				</div>
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-md-4">
							<label for="txtUserId" class="form-label">아이디<strong class="text-danger">*</strong></label>
							<input class="form-control" type="text" id="txtUserId" name="Student.UserID" maxlength="16" readonly="readonly" value="<%:Model.User != null ? Model.User.UserID : "" %>">
						</div>
						<div class="form-group col-md-4">
							<label for="txtHangulname" class="form-label">이름<strong class="text-danger">*</strong></label>
							<input class="form-control" type="text" id="txtHangulname" name="Student.HangulName" readonly="readonly" value="<%: Model.User.HangulName %>">
						</div>
						<div class="form-group col-md-4">
							<label for="txtResidentNo" class="form-label">생년월일<strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control datepicker" id="txtResidentNo" name="Student.ResidentNo" type="text" placeholder="YYYY-MM-DD" autocomplete="off" value="<%:Model.User.ResidentNo %>">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-row">

						<div class="form-group col-md-4">
							<label for="txtEmail" class="form-label">이메일주소<strong class="text-danger">*</strong></label>
							<input class="form-control" id="txtEmail" name="Student.Email" type="text" placeholder="ex)abc123@abc.com" value="<%: Model.User.Email %>">
						</div>
						<div class="form-group col-md-4">
							<label for="txtMobile" class="form-label">핸드폰번호<strong class="text-danger">*</strong></label>
							<input class="form-control" id="txtMobile" name="Student.Mobile" type="text" placeholder="[-] 없이 숫자만 입력" maxlength="11" value="<%: Model.User.Mobile %>">
						</div>
						<div class="form-group col-md-4">
							<label for="rdoSexGubunM" class="form-label">성별<strong class="text-danger">*</strong></label>
							<div class="form-control-plaintext">

								<div class="form-check form-check-inline">
									<input type="radio" class="form-check-input" name="Student.SexGubun" id="rdoSexGubunM" value="M" <%:Model.User.SexGubun == "USEX001" ? "checked" : "" %>>
									<label class="form-check-label" for="rdoSexGubunM">남자</label>
								</div>
								<div class="form-check form-check-inline ml-md-4">
									<input type="radio" class="form-check-input" name="Student.SexGubun" id="rdoSexGubunF" value="F" <%:Model.User.SexGubun == "USEX002" ? "checked" : "" %>>
									<label class="form-check-label" for="rdoSexGubunF">여자</label>
								</div>
							</div>
						</div>
					</div>
					<div class="form-row align-items-end">
						<div class="form-group col-md-4">
							<label for="btnZipCode" class="form-label">주소<strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input type="text" class="form-control" id="txtHousezipcode" name="Student.HouseZipCode" maxlength="5" placeholder="우편번호" readonly="readonly" value="<%:Model.User.HouseZipCode %>">
								<div class="input-group-append">
									<button type="button" id="btnZipCode" class="input-group-text" onclick="openSearchPopup($('#txtHousezipcode'), $('#txtHouseaddress1'), $('#txtHouseaddress2'));"><i class="bi bi-search"></i></button>
								</div>
							</div>
						</div>
						<div class="form-group col-md-8">
							<input type="text" class="form-control" id="txtHouseaddress1" name="Student.HouseAddress1" placeholder="주소" readonly="readonly" value="<%: Model.User.HouseAddress1 %>">
						</div>
						<div class="form-group col-md-12">
							<input type="text" class="form-control" id="txtHouseaddress2" name="Student.HouseAddress2" placeholder="상세주소" value="<%: Model.User.HouseAddress2 %>">
						</div>
					</div>

				</div>
			</div>
			<div class="text-right">
				<button type="button" class="btn btn-warning" onclick="fnSave();">수정</button>
				<a href="/Mypage/Withdrawal" class="btn btn-danger">비밀번호 변경/탈퇴</a>
				<%--<button type="button" class="btn btn-danger" onclick="fnSave()">탈퇴</button>--%>
				<a class="btn btn-secondary" href="/MyPage/MyInfo">취소</a>
			</div>
		</div>
		
		<input type="hidden" id="hdnUserNo" name="Student.UserNo" value="<%:Model.User != null ? Model.User.UserNo : -1 %>"/>

	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			fnBirthCalendar("txtResidentNo", $("#txtResidentNo").val());

		})

		function openSearchPopup(우편번호, 주소, 상세주소) {

			new daum.Postcode({
				oncomplete: function (data) {

					// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
					var fullAddr = ''; // 최종 주소 변수
					var extraAddr = ''; // 조합형 주소 변수

					// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						fullAddr = data.roadAddress;

					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						fullAddr = data.jibunAddress;
					}

					// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
					if (data.userSelectedType === 'R') {

						//법정동명이 있을 경우 추가한다.
						if (data.bname !== '') {
							extraAddr += data.bname;
						}
						// 건물명이 있을 경우 추가한다.
						if (data.buildingName !== '') {
							extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
						fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
					}

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					우편번호.val(data.zonecode); //5자리 새우편번호 사용
					주소.val(fullAddr);

					//// 커서를 상세주소 필드로 이동한다.
					상세주소.focus();
				}
			}).open();
			return false;
		}


		function val(id) {
			if ($("#" + id).length < 1) {
				return "";
			}
			return $.trim($("#" + id).val());
		}

		function fnRemoveSpace(id) {
			if ($("#" + id).length > 0) {

				var temp = $("#" + id).val().trim();
				temp = temp.replace(/ /gi, '').replace(/	/gi, '');
				$("#" + id).val(temp);
			}
		}

		function isValidDate(dateStr) {

			var year = Number(dateStr.substr(0, 4));
			var month = Number(dateStr.substr(4, 2));
			var day = Number(dateStr.substr(6, 2));
			var today = new Date(); // 날자 변수 선언
			var yearNow = today.getFullYear();
			var adultYear = yearNow - 20;

			if (month < 1 || month > 12) {
				bootAlert("달은 1월부터 12월까지 입력 가능합니다.");
				return false;
			}
			if (day < 1 || day > 31) {
				bootAlert("일은 1일부터 31일까지 입력가능합니다.");
				return false;
			}
			if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
				bootAlert(month + "월은 31일이 존재하지 않습니다.");
				return false;
			}
			if (month == 2) {
				var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
				if (day > 29 || (day == 29 && !isleap)) {
					bootAlert(year + "년 2월은  " + day + "일이 없습니다.");
					return false;
				}
			}
			return true;
		}

		function fnSave() {

			var idReg = /^[a-zA-Z]+[a-zA-Z0-9]/g;
			var idReg2 = /[ㄱ-ㅎ]/g;
			var idReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
			var pwReg = /[a-zA-Z]/g;
			var pwReg2 = /[0-9]/g;
			var pwReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
			var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})[0-9]{3,4}[0-9]{4}$/;

			fnRemoveSpace("txtUserId");
			fnRemoveSpace("txtpassword");
			fnRemoveSpace("txtpassword2");

			v = val("txtUserId");

			if (v == "") {
				bootAlert("아이디를 입력해주세요.", function () {
					$("#txtUserID").focus();
				});

				return false;
			}
			else if (v.length < 6 || !idReg.test(v) || idReg2.test(v) || idReg3.test(v)) {
				bootAlert("영문자로 시작하는 [영문/숫자 6자리이상]의 아이디를 입력해주세요.", function () {
					$("#txtUserID").focus();
				});

				return false;
			}
			else if (val("txtHangulname").length < 2) {
				bootAlert("2자리 이상의 이름을 입력해주세요.", function () {
					$("#txtHangulname").focus();
				});

				return false;
			}
			else if ($("#txtResidentNo").val() == "") {

				bootAlert("생년월일을 확인해주세요.", function () {
					$("#txtResidentNo").focus();
				});

				return false;

			}
			else if (!isValidDate(fnReplaceAll($("#txtResidentNo").val(), "-", ""))) {

				return false;
			}
			else if (!regExp.test(val("txtEmail"))) {
				bootAlert("올바른 이메일주소를 입력해주세요.", function () {
					$("#txtEmail").focus();
				});

				return false;
			}
			else if ((val("txtMobile").length > 0 && (val("txtMobile").search(/[0-9]/g) < 0) || !regTel.test(val("txtMobile")))) {
				bootAlert("핸드폰번호를 올바르게 입력해주세요.", function () {
					$("#txtMobile").focus();
				});

				return false;
			}
			else if ($(':radio[name="Student.SexGubun"]:checked').length < 1) {
				bootAlert("성별을 선택해주세요.", function () {
					$(':radio[name="Student.SexGubun"]').focus();
				});

				return false;
			}
			else if (val("txtHousezipcode").length < 1) {
				bootAlert("주소를 입력해 주세요.", function () {
					$("#btnZipCode").focus();
				});

				return false;
			}
			else if (val("txtHouseaddress1").length < 1) {
				bootAlert("주소를 입력해 주세요.", function () {
					$("#btnZipCode").focus();
				});

				return false;
			}

			else {
				var form = $("#mainForm").serialize();

				if ($("#hdnUserNo").val() != -1) {

					ajaxHelper.CallAjaxPost("/Account/CheckIdEmail", { id: val("txtUserId"), email: val("txtEmail") }, "fnCbcheckIdEmail");

				} else {
					bootAlert("오류가 발생하였습니다.");
				}
			}
		}

		function fnCbcheckIdEmail() {

			var data = ajaxHelper.CallAjaxResult();

			if (data["email"].Data > 0) {

				bootAlert("이미 사용중인 이메일입니다.", function () {
					$("#txtEmail").focus();
				});

				return false;
			}
			else {

				var form = $("#mainForm").serialize();

				bootConfirm("수정하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Mypage/WriteGeneral", form, "fnCbSave");
				});
			}
		}


		function fnCbSave() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert('수정되었습니다.', function () {
					location.href = "/Mypage/MyInfo";
				});
			} else {
				bootAlert("오류가 발생하였습니다.");
			}
		}

		//bootConfirm("수정하시겠습니까?", function () {
		//	ajaxHelper.CallAjaxPost("/Mypage/WriteGeneral", form, "fnCbSave");
		//});

	</script>
</asp:Content>
