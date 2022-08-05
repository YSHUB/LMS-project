<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/SaveOcwOpinion" method="post" id="saveForm">
        <input type="hidden" name="OpinionNo" id="OpinionNo" />
        <input type="hidden" name="OpinionText" id="OpinionText" />
        <input type="hidden" name="DeleteYesNo" id="DeleteYesNo" />
    </form>

    <form action="/Ocw/MyOpinion" id="mainForm" method="post">
        <div class="alert bg-point-light alert-light rounded text-left mb-0"><i class="bi bi-info-circle-fill"></i> 총 <%: Model.OcwOpinionList.Count.ToString("#,0") %>건 </div>

        <%            
            foreach (var opinion in Model.OcwOpinionList)
            {
        %>
            <div class="card mt-3 mb-2">
                <div class="card-header bg-light">
                    <div class="row align-items-center">
                        <div class="col-md">
                            <p class="card-title02"><a href="/Ocw/Detail/<%: opinion.OcwNo %>">
                                <strong class="badge badge-success mr-2"></strong><%:opinion.OcwName %>
                            </a></p>
                        </div>
                        <div class="col-md-auto text-right">
                            <dl class="row dl-style01">
                                <dt class="col-auto text-dark">작성일자</dt>
                                <dd class="col-auto mb-0"><%:opinion.CreateDateTime %></dd>
                                <dt class="col-auto text-dark sr-only">관리</dt>
                                <dd class="col-auto mb-0">
                                    <a href="#" class="btn btn-sm btn-outline-danger" onclick="fnDelConfirm(<%: opinion.OpinionNo %>);">삭제</a>
                                    <a href="#" class="btn btn-sm btn-outline-warning" onclick="fnModiConfirm(this, <%: opinion.OpinionNo %>);">수정</a>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
                <div class="card-body bg-light">
                    <textarea class="form-control w-100"><%:opinion.OpinionText %></textarea>
                </div>

            </div>
        <%
            }
        %>
    </form>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        //수정
        function fnModiConfirm(obj, opNo) {
            $("#DeleteYesNo").val("N");
            $("#OpinionNo").val(opNo);
            $("#OpinionText").val($(obj).parents().next().find("textarea").val());

            var param = $("#saveForm").serializeArray();

            if (fnGetBytes($(obj).parents().next().find("textarea").val()) < 1 || fnGetBytes($(obj).parents().next().find("textarea").val(), true) > 300) {
                bootAlert("내용을 1 ~ 300자로 등록하세요.");
                fnPrevent();
            } else {
                bootConfirm('수정하시겠습니까?', fnModifyOp, param);

            }

            fnPrevent();
        }


        function fnModifyOp(param) {
            ajaxHelper.CallAjaxPost("/Ocw/SaveOcwOpinion", param, "fnCbModifyOp");
        }

        function fnCbModifyOp() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("수정되었습니다.", function () {
                    window.location.reload();
                })
            }
        }

        //삭제
        function fnDelConfirm(opNo) {
            $("#DeleteYesNo").val("Y");
            $("#OpinionNo").val(opNo);

            var param = $("#saveForm").serializeArray();
            bootConfirm('삭제하시겠습니까?', fnDeleteOp, param);
        }

        function fnDeleteOp(param) {
            ajaxHelper.CallAjaxPost("/Ocw/SaveOcwOpinion", param, "fnCbDeleteOp");
        }

        function fnCbDeleteOp() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("삭제되었습니다.", function () {
                    window.location.reload();
                })
            }
        }
    </script>
</asp:Content>
