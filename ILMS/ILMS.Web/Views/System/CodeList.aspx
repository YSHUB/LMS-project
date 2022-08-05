<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.SystemViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/System/CodeList" method="post">
	<div id="content">
		<div class="row">
			<div class="col-12 mt-2">
				<h3 class="title04">상위 코드 리스트(<strong class="text-primary"><%=Model.CodeList.Count.ToString("#,##0") %></strong>건)</h3>
            <div class="card">
                <div class="card-body p-0">
                    <div class="overflow-auto bg-white overflow-xs overflow-sm overflow-md">
                        <div class="table-responsive">
                            <table class="table table-hover" id="codeTable">
                                <caption>상위코드</caption>
                                <thead>
                                    <tr>
                                        <th scope="row">연번</th>
                                        <th scope="row" class="d-none d-md-table-cell">상위코드</th>
                                        <th scope="row">상위코드명</th>
                                        <th scope="row" class="d-none d-lg-table-cell">설명</th>
                                        <th scope="row" class="d-none d-md-table-cell">사용여부</th>
                                        <th scope="row" class="text-nowrap">관리</th>
                                    </tr>
                                </thead>
                                <tbody id="tbClass">
                                    <%
                                    foreach (var item in Model.CodeList)
                                    {
                                    %>
                                    <tr id="tr<%=item.ClassCode %>" class="trbackground">
                                        <td class="text-center">
                                            <%=item.No %>
                                        </td>
                                        <td class="code text-left text-norwap d-none d-md-table-cell">
                                            <%=item.ClassCode %>
                                        </td>
                                        <td class="text-left text-nowrap">
                                            <%=item.CodeName %>
                                        </td>
                                        <td class="text-left d-none d-lg-table-cell">
                                            <%=item.Remark == null ? "" : item.Remark.Replace("\n", "</br>")%>
                                        </td>
                                        <td class="d-none d-md-table-cell">
                                            <%:item.UseYesNo %>
                                        </td>
                                        <td>
                                            <button type="button" onclick="fnUpdateClass('<%:item.ClassCode%>','<%:item.CodeName %>','<%:item.UseYesNo %>','<%:item.Remark %>')" class="font-size-20 text-primary" data-toggle="modal" data-target="#ClassCodeModal" role="button" title="상위코드 편집"><i class="bi bi-pencil"></i></button>
                                            <button type="button" onclick="fnDetail('<%:item.ClassCode %>')" class="font-size-20 text-info" title="하위코드 편집"><i class="bi bi-card-list"></i></button>
                                        </td>
                                    </tr>
                                    <%
                                    }
                                    %>

                                    <%
                                    if (Model.CodeList.Count.Equals(0))
                                    {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center"><i class="bi bi-info-circle-fill"></i> 아직 등록된 코드가 없습니다.</td>
                                    </tr>
                                    <%
                                    }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
                <div class="row">
                    <div class="col-6">
                    </div>
                    <div class="col-6">
                        <div class="text-right">
                            <input type="button" class="btn btn-primary" data-toggle="modal" onclick="fnInsertCode()" data-target="#ClassCodeModal" role="button" title="추가" value="추가">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12 mt-2">
                <h3 class="title04">하위 코드 리스트(<strong class="text-primary"><%: Model.DetailCodeList != null ? Model.DetailCodeList.Count.ToString("#,##0") : "0" %></strong>건)</h3>
                <div class="card">
                    <div class="card-body p-0">
                        <div class="overflow-auto bg-white">
                            <div class="table-responsive">
                                <table class="table table-hover" id="datatable2">
                                    <caption>하위코드</caption>
                                    <thead>
                                        <tr>
                                            <th scope="row">연번</th>
                                            <th scope="row" class="d-none d-md-table-cell">하위코드</th>
                                            <th scope="row">하위코드명</th>
                                            <th scope="row" class="d-none d-md-table-cell">순서</th>
                                            <th scope="row" class="d-none d-md-table-cell">사용여부</th>
                                            <th scope="row" class="text-nowrap">관리</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbDetail">
                                        <%
                                            foreach (var item in Model.DetailCodeList)
                                            {
                                        %>
                                        <tr>
                                            <td class="text-center">
                                                <%=item.No %>
                                            </td>
                                            <td class="detail text-left text-norwap d-none d-md-table-cell">
                                                <%:item.CodeValue %>
                                            </td>
                                            <td class="text-left text-nowrap">
                                                <%:item.CodeName %>
                                            </td>
                                            <td class="text-right d-none d-md-table-cell">
                                                <%:item.SortNo %>
                                            </td>
                                            <td class="d-none d-md-table-cell">
                                                <input type="hidden" name="DetailCodeList.CodeValue" id="hdnClassCode" value="<%:item.ClassCode %>" />
                                                <%:item.UseYesNo %>
                                            </td>
                                            <td>
                                                <button type="button" name="btnDetailModify" onclick="fnUpdateDetail('<%:item.CodeValue %>','<%:item.CodeName %>','<%:item.SortNo %>','<%:item.UseYesNo %>')"class="font-size-20 text-primary" data-toggle="modal" data-target="#detailCodeModal" role="button" title="수정"><i class="bi bi-pencil"></i></button>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>

                                        <% 
                                            if (Model.DetailCodeList.Count.Equals(0))
                                            {
                                        %>
                                        <tr>
                                            <td colspan="6" class="text-center"><i class="bi bi-info-circle-fill"></i> 아직 등록된 코드가 없습니다.</td>
                                        </tr>
                                        <%
                                            }
                                        %>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-6">
                    </div>
                    <div class="col-6">
                        <div class="text-right">
                            <input type="button" class="btn btn-primary" onclick="fnInsertDetailCode()" data-toggle="modal" data-target="#detailCodeModal" role="button" title="등록" value="등록">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--초기클래스코드-->
    <!--layer popup 상위코드 팝업-->
        <div class="modal fade show" id="ClassCodeModal" tabindex="-1" aria-labelledby="ClassCodeModalTitle"  role="dialog">
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title h4" id="ClassCodeModalTitle">상위코드 추가/수정</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group col-6">
                                        <label for="txtClassCode" class="form-label">코드 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtClassCode" name="code.ClassCode" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-6">
                                        <label for="txtCodeName" class="form-label">코드명 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtCodeName" name="code.CodeName" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-12 col-md-12">
                                        <label for="chkUseYN" class="form-label">사용여부 <strong class="text-danger">*</strong></label>
                                        <div class="switch-wrap">
                                            <label class="switch">
                                                <input type="checkbox" id="chkUseYN">
                                                <span class="slider round"></span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-12">
                                        <label for="txtRemark" class="form-label">설명 <strong class="text-danger">*</strong></label>
                                        <textarea class="form-control" rows="4" id="txtRemark"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row align-items-center">
                                    <div class="col-md">
                                        <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                    </div>
                                    <div class="col-md-auto text-right">
                                        <button type="button" class="btn btn-primary" id="btnCodeSave">저장</button>
                                        <button type="button" class="btn btn-secondary" id="btnCancel" data-dismiss="modal" title="닫기">닫기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!--layer popup 하위코드 팝업-->
        <div class="modal fade show" id="detailCodeModal" tabindex="-1" aria-labelledby="detailCodeModalLabel" role="dialog">
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title h4" id="detailCodeModalTitle">하위코드 추가/수정</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group col-6">
                                        <label for="txtdetailCode" class="form-label">코드 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtDetailCode" name="code.detailCode" class="form-control" readonly="readonly" value="">
                                    </div>
                                    <div class="form-group col-6">
                                        <label for="txtdetailCodeName" class="form-label">코드명 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtDetailCodeName" name="code.detailCodeName" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-6">
                                        <label for="txtDetailSortNo" class="form-label">순서 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtDetailSortNo" name="code.SortNo" class="form-control" value="">
                                    </div>
                                    <div class="form-group col-6">
                                        <label for="chkDetailUseYesNo" class="form-label">사용여부 <strong class="text-danger">*</strong></label>
                                        <div class="switch-wrap">
                                            <label class="switch">
                                                <input type="checkbox" id="chkDetailUseYesNo">
                                                <span class="slider round"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row align-items-center">
                                    <div class="col-md">
                                        <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                    </div>
                                    <div class="col-md-auto text-right">
                                        <button type="button" id="btnDatailSave" class="btn btn-primary">저장</button>
                                        <button type="button" class="btn btn-secondary" id="btnDetailCancel" data-dismiss="modal" title="닫기">닫기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="hdnRowState"   name="CodeList.RowState" />
        <input type="hidden" id="hdnClass" value="<%: Model.ClassCode %>"/>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<script type="text/javascript">
        var ajaxHelper = new AjaxHelper();

        //상위코드 수정 팝업
        function fnUpdateClass(code, codeName, use, remark) {
            $("#txtClassCode").attr("readonly", true);
            $("#txtClassCode").val(code);
            $("#txtCodeName").val(codeName);
            $("#txtRemark").val(remark);
            $("#hdnRowState").val("U");
            if (use == "Y") {
                $("#chkUseYN").attr("checked", "checked");
            }
        }

        //하위코드 수정 팝업
        function fnUpdateDetail(code, codeName, sortNo, use) {
            $("#txtDetailCode").attr("readonly", true);
            $("#txtDetailCode").val(code);
            $("#txtDetailCodeName").val(codeName);
            $("#txtDetailSortNo").val(sortNo)
            $("#hdnRowState").val("U");
            if (use == "Y") {
                $("#chkDetailUseYesNo").attr("checked", "checked");
            }
        }

        // 상위코드 추가
        function fnInsertCode() {
            $("#txtClassCode").attr("readonly", false);
            $("#txtClassCode").val("");
            $("#txtCodeName").val("");
            $("#txtRemark").val("");
            $("#hdnRowState").val("C");
            $("#chkUseYN").attr("checked", "checked");
        }

        // 하위코드 리스트 조회
        function fnDetail(classCode) {
            location.href = "/System/CodeList/" + classCode;
        }


        // 하위코드 추가
        function fnInsertDetailCode() {

            var Num = fnCodeNum(( <%:Model.DetailCodeList.Count %> + 1), 3);

            $("#txtDetailCode").val($("#hdnClass").val() + Num);
            $("#txtDetailCode").attr("readonly", true);
            $("#txtDetailCodeName").val("");
            $("#txtDetailSortNo").val("");
            $("#hdnRowState").val("C");
            $("#chkDetailUseYesNo").attr("checked", "checked");
        }

        // 하위코드 CodeValue 생성
        function fnCodeNum(n, width) {
            n = n + '';
            return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
        };

        // 상위코드 저장
        $("#btnCodeSave").click(function () {

            if ($("#txtClassCode").val() == "") {
                bootAlert("코드를 입력해주세요.")
                $("#txtClassCode").focus();
                return false;
            }

            var expression = RegExp(/[^A-Z]/);
            if (expression.test($("#txtClassCode").val())) {
                bootAlert("코드는 영문 대문자만 입력가능합니다.");
                $("#txtClassCode").focus();
                return false;
            }

            if (($("#txtClassCode").val()).length != 4) {
                bootAlert("코드는 4자리 숫자로 입력해주세요.")
                $("#txtClassCode").focus();
                return false;
            }

            if ($("#hdnRowState").val() == "C") {
                var isVaild = true;
                $.each($("#tbClass td.code"), function (i, r) {
                    if ($.trim($(r).text()) == $("#txtClassCode").val()) {
                        isVaild = false;
                        return false;
                    }
                });
                if (!isVaild) {
                    bootAlert("이미 존재하는 코드입니다.");
                    return false;
                }
            }

            if ($("#txtCodeName").val() == "") {
                bootAlert("코드명을 입력해주세요.")
                $("#txtCodeName").focus();
                return false;
            }
            if ($("#txtRemark").val() == "") {
                bootAlert("설명을 입력해주세요.")
                $("#txtRemark").focus();
                return false;
            }
            if ($("#chkUseYN").prop("checked")) {
                var UseYN = "Y";
            } else {
                UseYN = "N";
            }

            var objParam = {
                Code     : $("#txtClassCode").val(),
                CodeName : $("#txtCodeName").val(),
                UseYN    : UseYN ,
                Remark   : $("#txtRemark").val(),
                RowState : $("#hdnRowState").val()
            };

            ajaxHelper.CallAjaxPost("/System/CodeSaveAjax", objParam, "fnCbSave");
        });

        //하위코드 저장
        $("#btnDatailSave").click(function () {

            if ($("#txtDetailCode").val() == "") {
                bootAlert("코드를 입력해주세요.")
                $("#txtDetailCode").focus();
                return false;
            }

            if ($("#txtDetailCodeName").val() == "") {
                bootAlert("코드명을 입력해주세요.");
                $("#txtDetailCodeName").focus();
                return false;
            }
            if ($("#txtDetailSortNo").val() == "") {
                bootAlert("순서를 입력해주세요.");
                $("#txtDetailSortNo").focus();
                return false;
            }
			if ($("#txtDetailSortNo").val() < 1) {
				bootAlert("순서는 0 이상으로 입력해주세요.");
				$("#txtDetailSortNo").focus();
				return false;
			}
            if ($("#chkDetailUseYesNo").prop("checked")) {
                var DetailUseYN = "Y";
            } else {
                DetailUseYN = "N";
            }

            var objParam = {
                ClassCode : $("#hdnClass").val(),
                Code      : $("#txtDetailCode").val(),
                CodeName  : $("#txtDetailCodeName").val(),
                SortNo    : $("#txtDetailSortNo").val(),
                UseYN     : DetailUseYN,
                RowState  : $("#hdnRowState").val()
            };

            ajaxHelper.CallAjaxPost("/System/CodeDetailSaveAjax", objParam, "fnCbSave");
        });


        function fnCbSave() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert('저장되었습니다');
                location.reload(true);
            } else {
                bootAlert('저장에 실패하였습니다.');
                return false;
            }
        }

	</script>
</asp:Content>

