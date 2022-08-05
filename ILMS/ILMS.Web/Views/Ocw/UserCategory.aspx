<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">폴더 관리</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Ocw/UserCategory" id="mainForm" method="post">
		<input type="hidden" name="CatCode" id="CatCode" />
		<input type="hidden" name="CatName" id="CatName" />

        <div class="modal-body">
        <div class="card">
            <div class="card-body py-0">
                <table class="table" summary="분류설정 리스트">
                    <caption>Category 분류설정</caption>
                    <thead>
						<tr>
                            <th scope="col">순서</th>
							<th scope="col">폴더명</th>
							<th scope="col">관리</th>
						</tr>
					</thead>
                    <tbody id="dataList">
                        <tr class="data">
                            <td>1</td>
                            <td class="text-left">
                                <span class="spTxt"><strong>기본</strong></span>
                            </td>
                            <td class="d-none" colspan="2"></td>
                        </tr>

                    <%
                        foreach(var ocwUserCat in Model.OcwUserCatList)
                        {                                        
                    %>
                        <tr>
                            <td><%: Model.OcwUserCatList.IndexOf(ocwUserCat) + 2 %></td>
                            <td class="text-left">
                                <span class="spTxt"><%:ocwUserCat.CatName %></span>
                            </td>

                            <td>
                                <a class="text-primary" href="#" onclick="fnModal(<%:ocwUserCat.CatCode %>, '<%:ocwUserCat.CatName %>', this)" data-toggle="modal" data-target="#divModalCat" title="수정"><i class="bi bi-pencil-square"></i></a>
                            </td>

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
                        <button type="button" id="btnNew" class="btn btn-primary" onclick="fnModal(-1, '', this)" data-toggle="modal" data-target="#divModalCat">등록</button>
                    </div>
                </div>

            </div>
        </div>
        </div>
       
    <%--분류수정 / 등록 modal--%>
    <div class="modal fade show" id="divModalCat" tabindex="-1" aria-labelledby="divCat" aria-modal="true" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="ModalTitle">폴더 변경</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                    <div class="modal-body">
                        <div class="card">
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group col-md-12">
                                        <label for="lblCatName" class="form-label">폴더명 <strong class="text-danger">*</strong></label>
                                        <input type="text" id="txtCatName" name="CatName" class="form-control">
                                        <input type="hidden" id="hdnCatCode" name="CatName" class="form-control">
                                    </div>

                                </div>
                            </div>

                            <div class="card-footer">
                                <div class="row align-items-center">
                                    <div class="col-6">
                                        <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                    </div>
                                    <div class="col-6 text-right">
                                        <button type="button" class="btn btn-primary" id="btnSave" onclick="fnSaveCategory()">저장</button>
                                        <button type="button" class="btn btn-danger" id="btnDel" onclick="fnDelCategory()">삭제</button>
                                        <button type="button" class="btn btn-secondary" id="btnCancel" data-dismiss="modal" title="닫기" onclick="">닫기</button>
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
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnModal(catNo, catNm, obj) {
            $("#txtCatName").val("");
            $("#hdnCatCode").val("");

            if (catNo > 0) {
                $("#ModalTitle").text("폴더 수정");
                $("#btnDel").show();
                $("#txtCatName").val(catNm);


            } else {
                $("#ModalTitle").text("폴더 추가");
                $("#btnDel").hide();
            }

            $("#hdnCatCode").val(catNo);
            $("#txtCatName").focus();

            fnPrevent();

        }

        function fnSaveCategory() {

            let catVal = $("#txtCatName").val();

            if (fnGetBytes(catVal) < 1) {
                bootAlert("폴더명을 입력하세요.");
            }

            var cnt = 0;
            $.each($("#dataList tr td .spTxt"), function (index, item) {
                if (item.innerText == catVal) {
                    cnt++;
                }
            });
            if (cnt >= 1) {
                bootAlert('해당 폴더명과 같은 폴더명이 존재합니다. 다른 폴더명을 입력하세요.');

            } else {

                $("#CatCode").val($("#hdnCatCode").val());
                $("#CatName").val(catVal);

                let gbn = $("#CatCode").val();

                ajaxHelper.CallAjaxPost("/Ocw/SaveCategory", { CatCode: $("#CatCode").val(), CatName: $("#CatName").val()  }, "fnCbSave", gbn);
            }
        }

        function fnCbSave(gbn) {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert((gbn < 0 ? '저장' : '수정') + '되었습니다.', function () {
					window.location.reload(true);
                    opener.fnRefresh();
                });

            }
        }

        function fnDelCategory() {
            let catVal = $("#hdnCatCode").val();

            bootConfirm('폴더가 삭제될 경우, 선택한 폴더의 OCW는 [기본]폴더로 이동됩니다. 삭제하시겠습니까?', function () {
				$("#CatCode").val(catVal);
				ajaxHelper.CallAjaxPost("/Ocw/DelCategory", { CatCode: $("#CatCode").val() }, "fnCbDelete");
            });
            
        }

        function fnCbDelete() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert('삭제되었습니다.', function () {
                    window.location.reload(true);
                    opener.fnRefresh();
                });
            }
        }


	</script>

</asp:Content>
