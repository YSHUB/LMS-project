<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">테마키워드 <%: Model.OcwTheme.ThemeNo > 0 ?"수정" :"등록" %></asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Ocw/ThemeWrite/0" id="mainForm" method="post">
        <input type="hidden" name="ThemeNo" value="<%:Model.OcwTheme.ThemeNo %>"/>
        <div class="modal-body">
            <div class="card">
                <div class="card-body">
                    <div class="form-row">
                        <div class="form-group col-12">
                            <label for="txtKwordCd" class="form-label">키워드 코드 </label>
                            <input type="text" id="txtKwordCd" class="form-control" value="<%:Model.OcwTheme.ThemeNo > 0 ? Model.OcwTheme.ThemeNo.ToString() : "" %>" readonly="readonly"/>
                        </div>
                        <div class="form-group col-6">
                            <label for="txtKword" class="form-label">키워드명 <strong class="text-danger">*</strong></label>
                            <input type="text" id="txtKwordNm" class="form-control" name="ThemeName" value="<%:Model.OcwTheme.ThemeNo > 0 ? Model.OcwTheme.ThemeName : "" %>"/>
                        </div>
                        <div class="form-group col-6">
                            <label for="txtSort" class="form-label">정렬순서 <strong class="text-danger">*</strong></label>
                            <input type="text" id="txtSort" class="form-control" name="SortNo" value="<%:Model.OcwTheme.ThemeNo > 0 ? Model.OcwTheme.SortNo.ToString() : "" %>" oninput="fnOnlyNumber(this);"/>
                        </div>
                        <div class="form-group col-6">
                            <label for="selIsAdmin" class="form-label">관리자 전용 <strong class="text-danger">*</strong></label>
                            <select class="form-control" id="selIsAdmin" name="IsAdmin" >
                                <%
                                    foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "ADYN").OrderByDescending(w =>w.SortNo))
                                    { 
                                %>
                                     <option value=<%:baseCode.Remark %> 
                                         <%:Model.OcwTheme.ThemeNo > 0 && Model.OcwTheme.IsAdmin == Convert.ToInt32(baseCode.Remark) ? "selected" : "" %>><%:baseCode.CodeName %></option>
                                <%
                                    }    
                                %>


                            </select>
                        </div>
                        <div class="form-group col-6">
                            <label for="selIsOpen" class="form-label">공개여부 <strong class="text-danger">*</strong></label>
                            <select class="form-control" id="selIsOpen" name="IsOpen">
                                <%
                                    foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "OPYN"))
                                    { 
                                %>
                                     <option value=<%:baseCode.Remark %> 
                                         <%:Model.OcwTheme.ThemeNo > 0 && Model.OcwTheme.IsOpen == Convert.ToInt32(baseCode.Remark) ? "selected" : "" %>><%:baseCode.CodeName %></option>
                                <%
                                    }    
                                %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-12 text-right">
                            <input type="hidden" id="hdnDelYN" name="DeleteYesNo" value="<%:Model.OcwTheme.DeleteYesNo %>" />
                            <input type="button" onclick="fnSaveThemeConfirm();" class="btn <%:Model.OcwTheme.ThemeNo > 0 ? "btn-warning": "btn-primary"%>" value="<%:Model.OcwTheme.ThemeNo > 0 ? "수정": "저장"%>" />
                            <input type="button" onclick="fnDelThemeConfirm();" class="btn btn-danger <%:Model.OcwTheme.ThemeNo > 0 ? "" : "d-none" %>" value="삭제" />
                            <input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        function fnSaveThemeConfirm() {
            if ($.trim($("#txtKwordNm").val()) == "" || $("#txtKwordNm").length < 1) {
                bootAlert("테마키워드명을 입력하세요.", function () {
                    $("#txtKwordNm").focus();
                });

                fnPrevent();

            } else if ($.trim($("#txtSort").val()) == "" || $.trim($("#txtSort").val()) == "0") {
                bootAlert("정렬순서를 1 이상으로 입력하세요.", function () {
                    $("#txtSort").focus();
                });

                fnPrevent();

            } else {
                var objParam = $("#mainForm").serializeArray();
                
                bootConfirm("저장하시겠습니까?", fnSaveOcwTheme, objParam);
            }           
        }

        function fnSaveOcwTheme(objParam) {
            ajaxHelper.CallAjaxPost("/Ocw/SaveOcwTheme", objParam, "fnCbSaveOcwTheme");
        }

        function fnCbSaveOcwTheme() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("저장되었습니다.", function () {
                    opener.parent.location.reload(true);
                    self.close();
                })
            }
        }

        function fnDelThemeConfirm() {
            $("#hdnDelYN").val("Y");
            var objParam = $("#mainForm").serializeArray();

            bootConfirm("삭제하시겠습니까?", fnDelOcwTheme, objParam);
        }

        function fnDelOcwTheme(objParam) {
            ajaxHelper.CallAjaxPost("/Ocw/SaveOcwTheme", objParam, "fnCbDelOcwTheme");
        }

        function fnCbDelOcwTheme() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert("삭제되었습니다.", function () {
                    opener.parent.location.reload(true);
                    self.close();
                })
            } else {
                bootAlert("이미 사용하고 있는 테마키워드는 삭제할 수 없습니다.");

                fnPrevent();
            }
        }

    </script>

</asp:Content>
