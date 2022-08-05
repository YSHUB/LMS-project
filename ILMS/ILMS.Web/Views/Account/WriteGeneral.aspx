<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Account/WriteGeneral" method="post" id="mainForm">
		<div id="content">
			<div class="row">
				<div class="col-12 mt-2">
					<h3 class="title04">일반회원 등록 및 수정</h3>
				</div>
			</div>
			<div class="card d-md-block">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-12 col-md-4">
							<label for="txtUserID" class="form-label">아이디<small class="text-muted text-small">(첫 글자 영문필수)</small> <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input type="text" id="txtUserID" name="Student.UserID" class="form-control" <%if (Model.User != null) { %> readonly="readonly" <% } %> value="<%:Model.User != null ? Model.User.UserID : "" %>">
								<%
									if (Model.User == null) 
									{
								%>
										<span class="input-group-append">
											<button type="button" class="btn btn-outline-primary" id="btnIDCheck">중복체크</button>
										</span>
								<%
									}
								%>
							</div>
						</div>
						<div class="form-group col-12 col-md-4">
							<label for="txtPassword" class="form-label">비밀번호<small class="text-muted text-small">(영문자/숫자 포함 6~20자)</small> <strong class="text-danger">*</strong></label>
							<input type="password" id="txtPassword" name="Student.Password" class="form-control" value="">
						</div>
						<div class="form-group col-12 col-md-4">
							<label for="txtPasswordCheck" class="form-label">비밀번호 확인 <strong class="text-danger">*</strong></label>
							<input type="password" id="txtPasswordCheck" class="form-control" value="">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="txtHangulName" class="form-label">성명 <strong class="text-danger">*</strong></label>
							<input type="text" id="txtHangulName" name="Student.HangulName" class="form-control" value="<%:Model.User != null ? Model.User.HangulName : "" %>">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="txtResidentNo" class="form-label">생년월일<small class="text-muted text-small">ex)20001010</small> <strong class="text-danger">*</strong></label>
							<input type="text" id="txtResidentNo" name="Student.ResidentNo" maxlength="8" class="form-control" value="<%:Model.User != null ? Model.User.ResidentNo : "" %>">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="ddlSexGubun" class="form-label">성별 <strong class="text-danger">*</strong></label>
							<select class="form-control" id="ddlSexGubun" name="Student.SexGubun">
								<option value="">선택</option>
								<%
									foreach (var item in Model.BaseCode.Where(w => w.ClassCode.Equals("USEX")).ToList()) 
									{
								%>
										<option value="<%:item.CodeValue %>" <%if (item.CodeValue.Equals(Model.User != null ? Model.User.SexGubun : "")) { %> selected="selected" <% } %> ><%:item.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="txtAssignText" class="form-label">소속 </label>
							<input type="text" id="txtAssignText" name="Student.AssignText" class="form-control" value="<%:Model.User != null ? Model.User.AssignText : "" %>">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="txtMobile" class="form-label">휴대폰<small class="text-muted text-small">하이픈(-)포함 입력.</small> <strong class="text-danger">*</strong></label>
							<input type="text" id="txtMobile" name="Student.Mobile" class="form-control" value="<%:Model.User != null ? Model.User.Mobile : "" %>">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="txtEmail" class="form-label">이메일<small class="text-muted text-small">ex)OOOOO@OOOOO</small> <strong class="text-danger">*</strong></label>
							<input type="text" id="txtEmail" name="Student.Email" class="form-control" value="<%:Model.User != null ? Model.User.Email : "" %>">
						</div>
						<div class="form-group col-6 col-md-4">
							<label for="ddlApprovalGbn" class="form-label">인증상태 <strong class="text-danger">*</strong></label>
							<select id="ddlApprovalGbn" name="Student.ApprovalGubun" class="form-control">
								<option value="">선택</option>
								<%
									foreach (var item in Model.BaseCode.Where(w => w.ClassCode.Equals("UAST")).ToList()) 
									{
								%>
										<option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.User != null ? Model.User.ApprovalGubun : "")) { %> selected="selected" <% } %>><%:item.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-12 col-md-8">
							<label for="Exam_Title" class="form-label">주소 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input type="text" class="form-control col-md-2 d-inline-block" id="txtHousezipcode" name="Student.HouseZipCode" maxlength="5" placeholder="우편번호" readonly="readonly" value="<%:Model.User != null ? Model.User.HouseZipCode : "" %>">
								<button type="button" id="btnZipCode" class="btn-sm btn-dark" onclick="openSearchPopup($('#txtHousezipcode'), $('#txtHouseaddress1'), $('#txtHouseaddress2'));">주소검색</button>
								<input type="text" class="form-control col-md-12" id="txtHouseaddress1" name="Student.HouseAddress1" placeholder="주소" readonly="readonly" value="<%:Model.User != null ? Model.User.HouseAddress1 : "" %>">
								<input type="text" class="form-control col-md-4" id="txtHouseaddress2" name="Student.HouseAddress2" placeholder="상세주소" value="<%:Model.User != null ? Model.User.HouseAddress2 : "" %>">
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
						</div>
						<div class="col-6 text-right">
							<%
								if (Model.User != null) 
								{
							%>
									<button type="button" class="btn btn-danger" onclick="fnResetPasswordCheck()">비밀번호 초기화</button>
							<%
								}
							%>
							<button type="button" class="btn <%: Model.User != null ? "btn-warning" : "btn-primary" %>" onclick="fnSave()"><%: Model.User != null ? "수정" : "저장" %></button>
							<a href="#" onclick="fnGo()" class="btn btn-secondary" role="button">취소</a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<input type="hidden" id="hdnUserNo" name="Student.UserNo" value="<%:Model.User != null ? Model.User.UserNo : 0 %>"/>
		<input type="hidden" id="hdnUserUserNo" name="User.UserNo" value="<%:Model.User != null ? Model.User.UserNo : 0 %>"/>
		<input type="hidden" id="hdnMobile" name="User.Mobile" value="<%:Model.User != null ? Model.User.Mobile : "" %>"/>
		<input type="hidden" id="hdnEmail" name="User.Email" value="<%:Model.User != null ? Model.User.Email : "" %>"/>
		<input type="hidden" id="hdnIdChk" value="N"/>

	</form>		
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">


		var ajaxHelper = new AjaxHelper();

		<%-- 아이디 중복 확인 ---%>
		$("#btnIDCheck").click(function () {

			var idReg = /^[a-zA-Z]+[a-zA-Z0-9]/g;
			var idReg2 = /[ㄱ-ㅎ]/g;
			var idReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;

			var txtUserID = val("txtUserID");

			if (txtUserID == "") {

				bootAlert("아이디를 입력하세요.", function () {
					$("#txtUserID").focus();
				});
				return false;
			}
			else if (!idReg.test(txtUserID) || idReg2.test(txtUserID) || idReg3.test(txtUserID)) {

				bootAlert("올바른 아이디를 입력하세요.");
				return false;
			}
			else {

				ajaxHelper.CallAjaxPost("/Account/CheckIdEmail", { id: txtUserID }, "fnCompleteCheckId");
			}
		})

		var idChkCnt = 0;
		function fnCompleteCheckId() {
			idChkCnt++;

			var result = ajaxHelper.CallAjaxResult();

			if (result["id"].Data > 0) {

				bootAlert("이미 사용중인 아이디입니다.", function () {
					$("#txtUserID").focus();
				});

			} else {
				$("#hdnIdChk").val("Y");
				bootAlert("사용 가능한 아이디입니다.");
			}
		}

		<%-- DAUM 주소 API --%>
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

		<%-- 공백제거 ---%>
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

		<%-- 생년월일 유효성 체크 ---%>
		function isValidDate(dateStr) {			
			var year = Number(dateStr.substr(0, 4));
			var month = Number(dateStr.substr(4, 2));
			var day = Number(dateStr.substr(6, 2));
			var today = new Date(); // 날자 변수 선언
			var yearNow = today.getFullYear();
			var adultYear = yearNow - 20;

			if (isNaN(year) || isNaN(month) || isNaN(day)) {
				bootAlert("생년월일 형식이 올바르지 않습니다.");
				return false;
			}

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

		<%-- 회원 저장 ---%>
		function fnSave() {

			var idReg = /^[a-zA-Z]+[a-zA-Z0-9]/g;
			var idReg2 = /[ㄱ-ㅎ]/g;
			var idReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;		
			var pwReg = /^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
			var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;

			fnRemoveSpace("txtUserID");
			fnRemoveSpace("txtpassword");
			fnRemoveSpace("txtpassword2");

			if (val("txtUserID") == "") {
				bootAlert("아이디를 입력해주세요.", function () {
					$("#txtUserID").focus();
				});

				return false;
			}
			else if (!idReg.test(val("txtUserID")) || idReg2.test(val("txtUserID")) || idReg3.test(val("txtUserID"))) {
				bootAlert("아이디를 확인해주세요.", function () {
					$("#txtUserID").focus();

				});

				return false;
			}
			else if (idChkCnt < 1 && $("#hdnUserUserNo").val() == 0) {
				bootAlert("아이디 중복체크를 하여주세요.", function () {
					$("#txtUserID").focus();

				});
				return false;
			}
			else if ($("#hdnIdChk").val() != "Y" && $("#hdnUserUserNo").val() == 0) {
				bootAlert("이미 사용중인 아이디입니다.", function () {
					$("#txtUserID").focus();

				});
				return false;
			}
			else if (!pwReg.test(val("txtPassword")) && (val("txtPassword") != "" || val("txtPasswordCheck") != "")) {
				bootAlert("영문자로 시작하는 [영문/숫자 포함 6~20 자리]의 비밀번호를 입력해주세요.", function () {
					$("#txtPassword").focus();

				});

				return false;
			}
			else if (val("txtPassword") != val("txtPasswordCheck")) {
				bootAlert("비밀번호가 일치하지 않습니다.", function () {
					$("#txtPasswordCheck").focus();

				});

				return false;
			}
			else if (val("txtHangulName").length < 2) {
				bootAlert("2자리 이상의 이름을 입력해주세요.", function () {
					$("#txtHangulName").focus();

				});

				return false;
			}
			else if (val("txtResidentNo") == "") {
				bootAlert("생년월일을 확인해주세요.", function () {
					$("#txtResidentNo").focus();

				});

				return false;
			}
			else if (!isValidDate(val("txtResidentNo"))) {
				$("#txtResidentNo").focus();
				return false;
			}
			else if ($("#ddlSexGubun").val() == "") {
				bootAlert("성별을 선택해주세요.", function () {
					$("#ddlSexGubun").focus();

				});

				return false;
			}
			else if ((val("txtMobile").length > 0 && (val("txtMobile").search(/[0-9]/g) < 0) || !regTel.test(val("txtMobile")))) {
				bootAlert("휴대폰 번호를 올바르게 입력해주세요.", function () {
					$("#txtMobile").focus();

				});
				return false;
			}
			else if (!regExp.test(val("txtEmail"))) {
				bootAlert("올바른 이메일주소를 입력해주세요.", function () {
					$("#txtEmail").focus();

				});
				return false;
			}
			else if ($("#ddlApprovalGbn").val() == "") {

				bootAlert("인증상태를 선택해주세요.", function () {
					$("#ddlApprovalGbn").focus();

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
			else if (val("txtHouseaddress1").length < 1) {
				bootAlert("주소를 입력해 주세요.", function () {
					$("#btnZipCode").focus();

				});

				return false;
			}
			else if (val("txtEmail") != val("hdnEmail")) {

				ajaxHelper.CallAjaxPost("/Account/CheckIdEmail", { email: val("txtEmail") }, "fnCbcheckEmail");
			}

			else {
				var form = $("#mainForm").serialize();
				bootConfirm("저장하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Account/WriteGeneral", form, "fnCbSave");
				});
				//document.forms["mainForm"].submit();
			}
			
		}

		function fnCbcheckEmail() {
			var data = ajaxHelper.CallAjaxResult();
			if (data["email"].Data > 0) {

				bootAlert("이미 사용중인 이메일입니다.", function () {
					$("#txtEmail").focus();
				});

				return false;
			} else {
				var form = $("#mainForm").serialize();
				bootConfirm("저장하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Account/WriteGeneral", form, "fnCbSave");
				});
				//document.forms["mainForm"].submit();
			}
			
		}

		function fnCbSave() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0 && $("#hdnUserUserNo").val() > 0) {
				bootAlert("수정되었습니다.", function () {
					location.href = "/Account/ListGeneral";
				});
			} else if (result > 0) {
				bootAlert("등록되었습니다.", function () {
					location.href = "/Account/ListGeneral";
				});
			} else {
				bootAlert("오류가 발생하였습니다.");
			}
		}

		<%-- 비밀번호 초기화 --%>
		function fnResetPasswordCheck() {
			bootConfirm("비밀번호가 사용자의 휴대폰번호 뒤 8자리로 변경됩니다. 초기화하시겠습니까?", fnResetPassword);
		}

		function fnResetPassword() {

			var form = $("#mainForm").serialize();
			ajaxHelper.CallAjaxPost("/Account/ResetPassword", form, "fnCallBack");
		}

		function fnCallBack() {
			var result = ajaxHelper.CallAjaxResult();
			if (result == 1) {
				bootAlert("비밀번호가 초기화되었습니다.")
			} else {
				bootAlert("오류가 발생하였습니다.")
			}
		}

		function fnGo() {

			window.location = "/Account/ListGeneral/" + "?SearchText=" + encodeURIComponent('<%:Model.SearchText %>') + "&SearchGbn=" + '<%:Model.SearchGbn%>' + "&ApprovalGubun=" + '<%:Model.ApprovalGbn %>' + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>