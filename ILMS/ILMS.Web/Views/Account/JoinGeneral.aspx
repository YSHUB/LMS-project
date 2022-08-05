<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Account/JoinGeneral" name="mainForm" id="mainForm" method="post">
        <div id="divJoinForm">
            <div class="card card-style01">
                <div class="card-header">
                    <p class="mb-0"><i class="bi bi-info-circle-fill"></i> 모든 항목은 <strong class="text-danger">필수입력</strong> 항목입니다.</p>
                </div>
                <div class="card-body">
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="txtUserId" class="form-label">아이디<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtUserId" name="UserID" type="text" maxlength="16" placeholder="첫 글자 반드시 영문자 입력, 6글자 이상">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="txtHangulname" class="form-label">이름<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtHangulname" name="HangulName" type="text">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="txtResidentno" class="form-label">생년월일<strong class="text-danger">*</strong></label>
                            <div class="input-group">
                                <input class="form-control datepicker" id="txtResidentno" name="ResidentNo" type="text" placeholder="YYYY-MM-DD" autocomplete="off">
                                <div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        
                        <div class="form-group col-md-4">
                            <label for="txtEmail" class="form-label">이메일주소<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtEmail" name="Email" type="text" placeholder="ex)abc123@abc.com">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="txtMobile" class="form-label">핸드폰번호<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtMobile" name="Mobile" type="text" maxlength="11" placeholder="[-]없이 숫자만 입력">
                        </div>                        
                        <div class="form-group col-md-4">
                            <label for="rdoSexGubunM" class="form-label">성별<strong class="text-danger">*</strong></label>
                            <div class="form-control-plaintext">
                                <div class="form-check form-check-inline">
                                <input type="radio" class="form-check-input" name="SexGubun" id="rdoSexGubunM" value="M">
                                <label class="form-check-label" for="rdoSexGubunM">남자</label>
                                </div>
                                <div class="form-check form-check-inline ml-md-4">
                                <input type="radio" class="form-check-input" name="SexGubun" id="rdoSexGubunF" value="F">
                                <label class="form-check-label" for="rdoSexGubunF">여자</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-row align-items-end">
                        <div class="form-group col-md-4">
                            <label for="btnZipCode" class="form-label">주소<strong class="text-danger">*</strong></label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="txtHousezipcode" name="HouseZipCode" maxlength="5" placeholder="우편번호" readonly="readonly">
                                <div class="input-group-append">
                                <button type="button" id="btnZipCode" class="input-group-text" onclick="openSearchPopup($('#txtHousezipcode'), $('#txtHouseaddress1'), $('#txtHouseaddress2'));"><i class="bi bi-search"></i></button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col-md-8">
                            <input type="text" class="form-control" id="txtHouseaddress1" name="HouseAddress1" placeholder="주소" readonly="readonly">
                        </div>
                        <div class="form-group col-md-12">
                            <input type="text" class="form-control" id="txtHouseaddress2" name="HouseAddress2" placeholder="상세주소">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="txtPassword" class="form-label">비밀번호<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtPassword" name="Password" maxlength="20" type="password" placeholder="영문자/숫자/특수기호 조합, 8자리 이상">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="txtPasswordCheck" class="form-label">비밀번호 재입력<strong class="text-danger">*</strong></label>
                            <input class="form-control" id="txtPasswordCheck" type="password" maxlength="20" placeholder="영문자/숫자/특수기호 조합, 8자리 이상">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                        <label for="rdoGeneral1" class="form-label">구분<strong class="text-danger">*</strong></label>
                        <div class="form-control-plaintext">
                            <div class="form-check form-check-inline">
                            <%
								foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("GUCD")).OrderBy(c => c.SortNo).ToList()) 
                                {
                            %>
                                    <input type="radio" class="form-check-input" name="GeneralUserCode" id="rdoGeneral<%:item.CodeValue %>" value="<%:item.CodeValue %>">
                                    <label class="form-check-label mr-1" for="rdoGeneral<%:item.CodeValue %>"><%:item.CodeName %></label>
                            <%
                                }                
                            %>
                            </div>

                            <%--<div class="form-check form-check-inline">
                            <input type="radio" class="form-check-input" name="GeneralUserCode" id="rdoGeneral1" value="GUCD001">
                            <label class="form-check-label" for="rdoGeneral1">재직자</label>
                            </div>
                            <div class="form-check form-check-inline ml-md-4">
                            <input type="radio" class="form-check-input" name="GeneralUserCode" id="rdoGeneral2" value="GUCD002">
                            <label class="form-check-label" for="rdoGeneral2">학생</label>
                            </div>
                            <div class="form-check form-check-inline ml-md-4">
                            <input type="radio" class="form-check-input" name="GeneralUserCode" id="rdoGeneral3" value="GUCD003">
                            <label class="form-check-label" for="rdoGeneral3">미취업자</label>
                            </div>--%>
                        </div>
                        </div>
                        <div class="form-group col-md-6">
                        <label for="" class="form-label">개인정보 활용동의 여부<strong class="text-danger">*</strong></label>
                        <div class="col-md form-check form-check-inline">
                            <input type="checkbox" class="form-check-input" id="chkPrivate">
                            <label class="form-check-label" for="chkPrivate">동의합니다.</label>
                            <button type="button" class="btn btn-sm btn-outline-primary ml-2 ml-md-4" data-toggle="modal" data-target="#divAgreementModal"><i class="bi bi-clipboard-check-fill"></i> 열람하기</button>
                        </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                <div class="text-right">
                    <button type="button" class="btn btn-primary" onclick="fnSave()">확인</button>
                    <a class="btn btn-secondary" href="/">취소</a>
                </div>
                </div>
            </div>
        </div>
    </form>

    <div class="modal fade show" id="divAgreementModal" tabindex="-1" aria-modal="true" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">개인정보 활용 동의</h5>
                </div>
                <div class="modal-body pb-0">
                    <ol class="list-style01">
                      <li>
                        고용안정 선제대응 패키지 지원사업 참여에 있어 개인을 고유하게 구별하기 위해 부여된 식별정보(주민등록번호 등)를 포함한 개인정보를 다음과 같이 전산망 등에 수집 &middot; 관리하고 있습니다.
                        <div class="alert bg-light mt-2">
                          <dl class="mb-0">
                            <dt>개인정보의 수집·이용 목적 : </dt>
                            <dd>참여자 선정 &middot; 관리, 개인별 참여이력 관리 및 교육지원, 정부재정지원 활동 지원사업 중복참여 여부, 고용보험 이력 조회, 고용안정 선제대응 패키지 지원사업 실적 &middot; 성과 평가 등에 활용</dd>
                            <dt>수집하는 개인정보 항목 : </dt>
                            <dd>성명, 성별, 주민등록번호, 연락처(E-mail포함)</dd>
                            <dt>개인정보의 보유 및 이용기간 : </dt>
                            <dd>전산망에서 수집 및 계속 관리</dd>
                            <dt>개인정보의 제공 : </dt>
                            <dd class="mb-0">타법령 등에 의하여 실시되는 복지 및 일자리 사업의 적절한 대상자 선정과 관리의 목적으로 제공</dd>
                          </dl>
                        </div>
                      </li>
                      <li>
                        고용안정 선제대응 패키지 지원사업에 참여하기 위해서는 개인을 고유하게 구별하기 위해 부여된 식별정보(주민등록번호 등)를 포함한 개인정보가 필요하며, <strong>고용노동부, 부산지방고용노동청(동부지청, 북부지청 포함), 해당 지자체(부산시, 부산 강서구, 부산 사하구, 부산 사상구) 및 서부산권 고용안정 추진단. 수행기관(부산산학융합원)</strong>은 「개인정보보호법」에 따라 참여자로부터 제공받는 개인정보를 보호합니다.
                      </li>
                      <li>
                        개인정보를 처리 목적에 필요한 범위에서 적합하게 처리하고 그 목적 외의 용도로 사용하지 않으며 개인정보를 제공한 참여자는 언제나 자신이 입력한 개인정보의 열람 &middot; 수정을 신청할 수 있습니다.
                      </li>
                      <li>
                        고용안정 선제대응 패키지 지원사업 참여결과로 인한 수혜사항(이력)이 타법령 등에 의하여 실시되는 복지 및 활동 지원 사업의 적절한 대상자 선정과 관리의 목적으로 제공될 수 있음에 동의합니다.
                      </li>
                      <li>
                        본인은 위 1~4의 내용에 따른 고용안정 선제대응 패키지 지원사업 참여 &middot; 운영을 위해 개인식별정보(주민등록번호 등)를 제공할 것을 동의합니다.
                      </li>
                    </ol>
                    <p class="text-center mt-4">
                        <span><%:DateTime.Today.Year %> 년</span>
                        <span class="ml-2"><%:DateTime.Today.Month %>  월</span>
                        <span class="ml-2"><%:DateTime.Today.Day %>  일</span>
                    </p>
                </div>
                <div class="modal-footer">
                    <div class="text-right">
                        <div class="tAlignC bot-fix" style="text-align: right;">
                            <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#divAgreementModal" aria-label="Close">닫기</button>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript">

        var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			fnBirthCalendar("txtResidentno", $("#txtResidentno").val());

            $("#txtResidentno").val("");

            $("#rdoGeneralGUCD004").prop("checked", true);

        })

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
            else if (v.length < 6 || !idReg.test(v) || idReg2.test(v) || idReg3.test(v))
            {
				bootAlert("영문자로 시작하는 [영문/숫자 6자리이상]의 아이디를 입력해주세요.", function () {
					$("#txtUserID").focus();
				});

				return false;
            }
            else if (val("txtHangulname").length < 2)
            {
				bootAlert("2자리 이상의 이름을 입력해주세요.", function () {
					$("#txtHangulname").focus();
				});

                return false;
            }
            else if ($("#txtResidentno").val() == "") {

				bootAlert("생년월일을 확인해주세요.", function () {
					$("#residentno").focus();
				});

                return false;
                
            }
			else if (!isValidDate(fnReplaceAll($("#txtResidentno").val(), "-", ""))) {

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
			else if ($(':radio[name="SexGubun"]:checked').length < 1) {
				bootAlert("성별을 선택해주세요.", function () {
					$(':radio[name="SexGubun"]').focus();
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
            else if (val("txtPassword").length < 8)
            {
				bootAlert("8자리 이상의 비밀번호를 입력해주세요.", function () {
					$("#txtPassword").focus();
				});

				return false;
            }
            else if (val("txtPassword").length < 8 || !pwReg.test(val("txtPassword")) || !pwReg2.test(val("txtPassword")) || !pwReg3.test(val("txtPassword")))
            {
				bootAlert("8자리 이상의 [영문/숫자/특수문자]로 조합된 비밀번호를 입력해주세요.", function () {
					$("#txtPassword").focus();
				});

				return false;
            }
            else if (val("txtPassword") != val("txtPasswordCheck"))
            {
				bootAlert("비밀번호가 일치하지 않습니다.", function () {
					$("#txtPasswordCheck").focus();
				});

				return false;
            }
            else if ($("#chkPrivate:checked").length < 1)
            {
				bootAlert("개인정보활용동의에 동의해주세요.", function () {
					$("#chkPrivate").focus();
				});

				return false;
            }
            else
            {
                ajaxHelper.CallAjaxPost("/Account/CheckIdEmail", { id: val("txtUserId"), email: val("txtEmail") }, "fnCbcheckIdEmail");
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

        function fnCbcheckIdEmail() {

            var data = ajaxHelper.CallAjaxResult();

            if (data["id"].Data > 0 && data["email"].Data > 0) {

                bootAlert("이미 사용중인 아이디와 이메일입니다.", function () {
					$("#txtUserId").focus();
                });

                return false;
            }
            else if (data["id"].Data > 0) {

				bootAlert("이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요.", function () {
					$("#txtUserId").focus();
				});

                return false;
            }
            else if (data["email"].Data > 0) {

				bootAlert("이미 사용중인 이메일입니다.", function () {
					$("#txtEmail").focus();
				});

				return false;
            }
            else {

                var form = $("#mainForm").serialize();

                bootConfirm("회원가입하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Account/JoinGeneralJoin", form, "fnCallBackJoin");
                });
            }
        }

        function fnCallBackJoin() {

            var result = ajaxHelper.CallAjaxResult();

            if (result > 0) {

                bootAlert('가입되었습니다.', function () {
                    location.href = "/Account";
                });
            } else {
				bootAlert("오류가 발생하였습니다.");
			}
        }

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


	</script>
</asp:Content>
