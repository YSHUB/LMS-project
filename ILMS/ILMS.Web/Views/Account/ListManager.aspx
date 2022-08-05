<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Account/ListManager" method="post" id="mainForm">
        <ul class="nav nav-tabs">
			<%
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
				{

			%>
            <li class="nav-item"><a class="nav-link" href="ListStudent"><%:ConfigurationManager.AppSettings["StudentText"].ToString() %></a> </li>
            <li class="nav-item"><a class="nav-link" href="ListStaff"><%:ConfigurationManager.AppSettings["EmpIDText"].ToString() %></a> </li>
            <%
				}
			%>
			<li class="nav-item"><a class="nav-link active show" href="ListManager">관리자</a> </li>
        </ul>

        <div class="card mt-4">
            <div class="card-body pb-1">

                <div class="form-row align-items-end">
                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="ddlAdminType" class="sr-only">관리자 구분</label>
                        <select id="ddlAdminType" name="UserType" class="form-control">
                            <option value="">전체</option>
                            <% 
                                foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("USRT") && (c.CodeValue.Equals("USRT010")) || (c.CodeValue.Equals("USRT011")) || (c.CodeValue.Equals("USRT012")) || (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") && (c.CodeValue.Equals("USRT012")))).ToList())
                                {
                            %>
                            <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="ddlSearchGubun" class="sr-only">검색구분</label>
                        <select id="ddlSearchGubun" name="SearchOption" class="form-control">
                            <%--<% 
                            foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MJDF")).ToList())
                            {
                        %>
                        <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                        <%
                            }
                        %>--%>
                            <option value="I" <%: (Model.SearchOption == "I") ? "selected" : "" %>>아이디</option>
                            <option value="N" <%: (Model.SearchOption == "N") ? "selected" : "" %>>이름</option>
                        </select>
                    </div>
                    <div class="form-group col-6 col-md-3 col-lg-2">
                        <label for="txtSearchText" class="sr-only">검색어</label>
                        <input type="text" class="form-control" name="SearchText" id="txtSearchText" value="<%:Model.SearchText%>" placeholder="검색어 입력" />
                    </div>
                    
                    <div class="form-group col-sm-auto text-right">
                        <button type="submit" id="btnSearch" class="btn btn-secondary">
                            <span class="icon search">검색
                            </span>
                        </button>
                    </div>

                </div>

            </div>
        </div>

        <div class="card">
            <div class="card-body py-0">
                <table class="table table-hover table-horizontal" summary="관리자 리스트">
                    <caption>Category 분류설정</caption>
                    <thead>
                        <tr>
                            <th scope="col">관리자구분</th>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>연락처</th>
                            <th>이메일</th>
                            <th>인증상태</th>
                            <th scope="col">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            foreach (var item in Model.UserList)
                            {
                        %>
                        <tr>
                            <td><%:item.UserTypeName %></td>
                            <td class="text-left" ><%:item.HangulName %></td>
                            <td class="text-left" ><%:item.UserID %></td>
                            <td><%:item.Mobile %></td>
                            <td class="text-left"><%:item.Email%></td>
                            <td><%:item.ApprovalGubunName%></td>
                            <td>
                                <a class="text-primary" href="#" onclick="fnModal('U','<%:item.UserType %>','<%:item.ApprovalGubun %>','<%:item.HangulName %>','<%:item.UserID %>','<%:item.Mobile %>','<%:item.Email %>','<%:item.UserNo %>', this)" data-toggle="modal" data-target="#divModal" title="수정"><i class="bi bi-pencil-square"></i></a>
                            </td>
                        </tr>
                        <%
                            }
                        %>

                        <% if (Model.UserList.Count.Equals(0))
                            {
                        %>
                        <tr>
                            <td colspan="6" class="text-center">검색결과가 없습니다.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                    
                </table>
            </div>
            <div class="card-footer">
                <div class="row">
                    <div class="col-12 text-right">
                        <button type="button" id="btnNew" class="btn btn-primary" onclick="fnModal('C', this)" data-toggle="modal" data-target="#divModal">등록</button>
                    </div>
                </div>
            </div>
        </div>
        <%= Html.Pager((int)Model.PageNum, 10, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>

        <%--분류수정 / 등록 modal--%>
        
        <div class="modal fade show" id="divModal" tabindex="-1" aria-labelledby="newMname" role="dialog">
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="ModalTitle">관리자 등록</h5>
                        <input type="hidden" id="hdnMNo" value="0" />
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="modalDDlUserType" class="form-label">구분 <strong class="text-danger">*</strong></label>
                                        <select class="form-control" id="modalDDlUserType" name="User.UserType">
                                            <% 
                                                foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("USRT") && (c.CodeValue.Equals("USRT010")) || (c.CodeValue.Equals("USRT011")) || (c.CodeValue.Equals("USRT012"))).ToList())
                                                {
                                            %>
                                            <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="modalDdlApprovalGubun" class="form-label">상태 <strong class="text-danger">*</strong></label>
                                        <select class="form-control" id="modalDdlApprovalGubun" name="User.ApprovalGubun">
                                            <% 
                                                foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("UAST") && (c.CodeValue.Equals("UAST001")) || (c.CodeValue.Equals("UAST002"))).ToList())
                                                {
                                            %>
                                            <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtHangulName" class="form-label">이름 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="modalTxtHangulName" name="User.HangulName" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtUserId" class="form-label">아이디 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="modalTxtUserId" name="User.UserID" class="form-control" value="">

                                        <label for="modalHdnUserNo" class="d-none">아이디 <strong class="text-danger">*</strong></label>
                                        <input type="hidden" id="modalHdnUserNo" name="User.UserNo" value="">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtPassword" class="form-label">비밀번호 <strong class="text-danger">*</strong></label>
                                        <input type="password" id="modalTxtPassword" name="User.Password" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtPasswordCheck" class="form-label">비밀번호확인 <strong class="text-danger">*</strong></label>
                                        <input type="password" id="modalTxtPasswordCheck" class="form-control" value="">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtMobile" class="form-label">휴대폰 <small class="text-muted text-small">하이픈(-)포함 입력.</small> <strong class="text-danger">*</strong></label>
                                        <input type="text" id="modalTxtMobile" name="User.Mobile" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="modalTxtEmail" class="form-label">이메일 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="modalTxtEmail" name="User.Email" class="form-control" value="">

                                        <label for="modalHdnEmail" class="d-none">이메일비교 <strong class="text-danger">*</strong></label>
                                        <input type="hidden" id="modalHdnEmail" class="form-control" value="">
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row align-items-center">
                                    <div class="col-md">
                                        <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                    </div>
                                    <div class="col-md-auto text-right">

                                        <label for="modalHdnRowstate" class="d-none">저장구분값</label>
                                        <input type="hidden" id="modalHdnRowstate" value=""/>
                                        <button type="button" class="btn btn-primary" id="btnSave"  title="저장">저장</button>
                                        <button type="button" class="btn btn-secondary" id="btnCancel" data-dismiss="modal" title="취소">취소</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>
        var ajaxHelper = new AjaxHelper();


        function fnModal(RowState, Obj) {
            fnModal(RowState, '', '', '', '', '', '','', Obj);
        }

        function fnModal(RowState, UserType, ApprovalGubun, HangulName, UserID, Mobile, Email,UserNo, Obj) {

            fnClearModal();
            $("#modalHdnRowstate").val(RowState);

            if (RowState == "U") {
                $("#modalTxtUserId").attr("disabled", "disabled");
                $("#modalTxtUserId")
                $("#modalDDlUserType").val(UserType);
                $("#modalDdlApprovalGubun").val(ApprovalGubun);
                $("#modalTxtHangulName").val(HangulName);
                $("#modalTxtUserId").val(UserID);
                $("#modalTxtMobile").val(Mobile);
                $("#modalTxtEmail").val(Email);
                $("#modalHdnUserNo").val(UserNo);
                $("#modalHdnEmail").val(Email);
            } else {
                $("#modalTxtUserId").removeAttr("disabled")
            }
        }

        function fnClearModal() {
            $("#modalTxtUserId").removeAttr("disabled")
            $("#modalDDlUserType").index(1);
            $("#modalDdlApprovalGubun").index(1);
            $("#modalTxtHangulName").val("");
            $("#modalTxtUserId").val("");
            $("#modalTxtPassword").val("");
            $("#modalTxtPasswordCheck").val("");
            $("#modalTxtMobile").val("");
            $("#modalTxtEmail").val("");
            $("#modalHdnUserNo").val("");
            $("modalHdnRowstate").val("");
            
        }

        function fnFocusTarget() {
            console.trace();

        }

        function val(id) {
            if ($("#" + id).length < 1) {
                return "";
            }
            return $.trim($("#" + id).val());
        }

        $(document).ready(function () {

            $("#divModal").bind("keypress", function (e) {
                if (e.keyCode == 13) {
                    /*$("#btnSave").trigger();*/
                    //add more buttons here
                    return false;
                }
            });

            $("#btnSave").click(function () {

                var idReg = /^[a-zA-Z]+[a-zA-Z0-9]/g;
                var idReg2 = /[ㄱ-ㅎ]/g;
                var idReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
                var pwReg = /[a-zA-Z]/g;
                var pwReg2 = /[0-9]/g;
                var pwReg3 = /[`~!@#$%^&*|\\\'\";:\/?]/gi;
                var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
				var regTel = /^(01[016789]{1}|070|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;

                v = val("modalTxtUserId");


                if ($("#modalHdnRowstate").val() == "C") {
					if (val("modalTxtHangulName").length < 2) {
						bootAlert("2자리 이상의 이름을 입력해주세요.", function () {
							$("#modalTxtHangulName").focus();

						});
						return false;
                    }

                    if (v == "") {
                        bootAlert("아이디를 입력해주세요.", function () {
                            $("#modalTxtUserId").focus();
                        });

                        return false;

                    }
                    if (v.length < 6 || !idReg.test(v) || idReg2.test(v) || idReg3.test(v)) {
                        bootAlert("영문자로 시작하는 [영문/숫자 6자리이상]의 아이디를 입력해주세요.", function () {
                            $("#modalTxtUserId").focus();

                        });

                        return false;

                    }

                    if (val("modalTxtPassword").length < 8) {
                        bootAlert("8자리 이상의 비밀번호를 입력해주세요.", function () {
                            $("#modalTxtPassword").focus();

                        });

                        return false;

                    }
                    if (val("modalTxtPassword").length < 8 || !pwReg.test(val("modalTxtPassword")) || !pwReg2.test(val("modalTxtPassword")) || !pwReg3.test(val("modalTxtPassword"))) {
                        bootAlert("8자리 이상의 [영문/숫자/특수문자]로 조합된 비밀번호를 입력해주세요.", function () {
                            $("#modalTxtPassword").focus();

                        });
                        
                        return false;
                    }


                    if (val("modalTxtPassword") != val("modalTxtPasswordCheck")) {
                        bootAlert("비밀번호가 일치하지 않습니다.", function () {
                            $("#modalTxtPasswordCheck").focus();

                        });

                        return false;
                    }

                    if ((val("modalTxtMobile").length > 0 && (val("modalTxtMobile").search(/[0-9]/g) < 0) || !regTel.test(val("modalTxtMobile")))) {
						bootAlert("핸드폰번호를 올바르게 입력해주세요.", function () {
							$("#modalTxtMobile").focus();

						});

						return false;
					}

                    if (!regExp.test(val("modalTxtEmail"))) {
                        bootAlert("올바른 이메일주소를 입력해주세요.", function () {
                            $("#modalTxtEmail").focus();

                        });

                        return false;
                    }                    
                }
				else <%--수정 시 --%>
                {
                    if ($("#modalTxtPassword").val() != "")
                    {
                        if (val("modalTxtPassword").length < 8) {
                            bootAlert("8자리 이상의 비밀번호를 입력해주세요.", function () {
                                $("#modalTxtPassword").focus();

                            });

                            return false;

                        }
                        if (val("modalTxtPassword").length < 8 || !pwReg.test(val("modalTxtPassword")) || !pwReg2.test(val("modalTxtPassword")) || !pwReg3.test(val("modalTxtPassword"))) {
                            bootAlert("8자리 이상의 [영문/숫자/특수문자]로 조합된 비밀번호를 입력해주세요.", function () {
                                $("#modalTxtPassword").focus();

                            });

                            return false;
                        }
                    }

					if ((val("modalTxtMobile").length > 0 && (val("modalTxtMobile").search(/[0-9]/g) < 0) || !regTel.test(val("modalTxtMobile")))) {
						bootAlert("핸드폰번호를 올바르게 입력해주세요.", function () {
							$("#modalTxtMobile").focus();

						});

						return false;
					}

					if (!regExp.test(val("modalTxtEmail"))) {
						bootAlert("올바른 이메일주소를 입력해주세요.", function () {
							$("#modalTxtEmail").focus();

						});

						return false;
					}
                }

                ajaxHelper.CallAjaxPost("/Account/CheckIdEmail", { id: val("modalUserId"), email: val("modalTxtEmail") }, "fnCbcheckIdEmail");

            });
        });

        function fnCbcheckIdEmail() {
            var data = ajaxHelper.CallAjaxResult();
            console.log(data);

            if ($("#modalHdnRowstate").val() == "C") {
                if (data["id"].Data > 0 && data["email"].Data > 0) {
                    bootAlert("이미 사용중인 아이디와 이메일입니다.", function () {
                        $("#txtUserId").focus();

                    });

                    return false;
                }
                if (data["id"].Data > 0) {
                    bootAlert("이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요.", function () {
                        $("#txtUserId").focus();

                    });

                    return false;
                }
                if (data["email"].Data > 0) {
                    bootAlert("이미 사용중인 이메일입니다.", function () {
                        $("#txtEmail").focus();

                    });

                    return false;
                }
            } else {
                if ($("#modalHdnEmail").val() != $("#modalTxtEmail").val()) {
                    if (data["email"].Data > 0) {

                        bootAlert("이미 사용중인 이메일입니다.", function () {
                            $("#txtEmail").focus();

                        });

                        return false;
                    }
                }
            }


            bootConfirm("저장하시겠습니까?", function () {
				/*capf("/account/joinokgeneral", "mainForm", "fnCallBackJoin");*/
				var form = $("#mainForm").serialize();

				console.count("fnCbcheckIdEmail")

				if ($("#modalHdnRowstate").val() == "C") {
					ajaxHelper.CallAjaxPost("/Account/CreateAdmin", form, "fnCallBackJoin");
				} else {
					ajaxHelper.CallAjaxPost("/Account/ManagerUpdate", form, "fnCallBackJoin");
				}


				console.count("fnCbcheckIdEmail")
            })


            //if (confirm("저장하시겠습니까?")) {
            //    /*capf("/account/joinokgeneral", "mainForm", "fnCallBackJoin");*/
            //    var form = $("#mainForm").serialize();

            //    console.count("fnCbcheckIdEmail")

            //    if ($("#modalHdnRowstate").val() == "C") {
            //        ajaxHelper.CallAjaxPost("/Account/CreateAdmin", form, "fnCallBackJoin");
            //    } else {
            //        ajaxHelper.CallAjaxPost("/Account/ManagerUpdate", form, "fnCallBackJoin");
            //    }


            //    console.count("fnCbcheckIdEmail")


            //}
        }

        function fnCallBackJoin() {
            bootAlert('저장되었습니다.', function () {
                location.reload(true);
            });
        }

	</script>
</asp:Content>
