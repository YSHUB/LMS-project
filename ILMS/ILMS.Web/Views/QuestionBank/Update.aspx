<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.QuestionViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">문제수정</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <%-- 폼시작 --%>
    <form action="/QuestionBank/Update" name="mainForm" id="mainForm" method="post" enctype="multipart/form-data">

        <div class="row no-gutters">
            <%-- 폴더 시작 --%>
            <div class="col-xl-3 bg-point-light p-4">
                <% Html.RenderPartial("/Views/Shared/QuestionBank/FolderList.ascx"
                                         , Model
                                         , new ViewDataDictionary { { "pageType", "Write" } }); %>
            </div>
            <%-- 폴더 종료 --%>
            <%-- 문제수정 시작 --%>
            <div class="col-xl-9 p-4">
                <div class="row">
                    <div class="col col-xl-6">
                        <h3 class="title04">문제등록</h3>
                    </div>
                </div>

                <div class="card" id="collapseExample5">

                    <%-- 디자인 입력 및 수정 --%>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="spanTitle" class="form-label">위치 <strong class="text-danger">*</strong></label>
                                <div class="input-group-text">
                                    <span id="spanTitle" class=""><%: Model.BaseCode.Where(c => c.ClassCode.Equals("MJTP") && c.CodeValue.Equals(Model.QuestionBankType)).Select(c => c.CodeName).FirstOrDefault() %></span><span class="ml-1 mr-1">&gt;</span><span id="spanSubtitle"><%:string.IsNullOrEmpty(Model.GubunName)?"":Model.GubunName %></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="Exam_Title" class="form-label">문제 <strong class="text-danger">*</strong></label>
                                <% Html.RenderPartial("./Common/Editor", new ViewDataDictionary {{ "Contents", Model.QuestionEntity.Question }});%>
                            </div>
                        </div>

                        <div class="form-row">
                            <%-- 사용여부 시작 --%>
                            <div class="form-group col-3 col-md-2 col-lg-1">
                                <label for="chkUseYesNo" class="form-label">사용여부 <strong class="text-danger">*</strong></label>
								<label class="switch">
									<input type="checkbox" id="chkUseYesNo" name="UseYesNo" checked="checked">
									<span class="slider round"></span>
								</label>
                            </div>
                            <%-- 사용여부 종료 / 출제주차 시작 --%>
                            <div class="form-group col-3 col-md-2 col-lg-1">
                                <label for="ddlDifficulty" class="form-label">출제주차 <strong class="text-danger">*</strong></label>
                                <select class="form-control" id="ddlDifficulty" name="Difficulty" >
                                    <% 
                                        foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MJDF")).ToList())
                                        {
                                            if (Model.QuestionEntity.Difficulty == item.CodeValue)
                                            {

                                    %>
                                    <option selected="selected" value="<%:item.CodeValue%>"><%:item.CodeName%></option>

                                    <%}
                                    else
                                    {%>
                                    <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                    <%}
                                    %>

                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <%-- 출제주차 종료 / 문항유형 시작 --%>
                            <div class="form-group col-3 col-md-3">
                                <label for="ddlQuestionType" class="form-label">문항유형 <strong class="text-danger">*</strong></label>
                                <select class="form-control" id="ddlQuestionType" name="QuestionType" disabled="disabled">
                                    <% 
                                        foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MJQT")).ToList())
                                        {
                                            if (Model.QuestionEntity.QuestionType == item.CodeValue)
                                            {
                                    %>
                                    <option selected="selected" value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                    <%
                                        }
                                        else
                                        {
                                    %>
                                    <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                    <%}
                                        }
                                    %>
                                </select>
                            </div>
                            <%-- 문항유형 종료 / 보기개수 시작 --%>
                            <div class="form-group col-6 col-md-2 col-lg-1" id="pnlQuestionExampleCount">
                                <label for="ddlQuestionExampleCount" class="form-label">
                                    보기 개수 <strong class="text-danger">*</strong>
                                </label>
                                <select class="form-control" id="ddlQuestionExampleCount" disabled="disabled">
                                    <%for (int i = 1; 11 > i; i++)
                                        {
                                            if (i == 5)
                                            {%>
                                    <option selected="selected" value="<%=i%>"><%=i %>개</option>
                                    <%}
                                        else
                                        {%>
                                    <option value="<%=i%>"><%=i %>개</option>
                                    <%}
                                        }%>
                                </select>
                            </div>
                            <%-- 보기개수 종료 --%>
                        </div>
                        <%-- 예제 입력 시작 --%>
                        <div class="form-row" id="pnlQuestionExampleArea">
                            <%-- 서술형 시작--%>
                            <%if (Model.QuestionEntity.QuestionType == "MJQT001")
                                {  %>

                            <%}%>

                            <%-- 서술형 종료 / 단일선택 시작 --%>
                            <% else if (Model.QuestionEntity.QuestionType == "MJQT002")
                                {
                                    for (int i = 0; i < Model.ExampleEntity.Count; i++)
                                    {%>
                            <div class="form-group col-md-12 mb-3">
                                <div class="col-md-12 p-0 m-0">
                                    <label for="Exam_ExamContentSingle_<%:i%>" class="form-label" id="Exam_label_<%:i%>">
                                        <input type="radio" class="radio-inline" id="Exam_ExamContentSingle_<%:i%>" value="<%:i %>" name="CorrectAnswerYesNo" <%= Model.ExampleEntity[i].CorrectAnswerYesNo == "Y"? "checked":"" %>>
                                        <%:i+1 %>번 항목 <strong class="text-danger">*</strong></label>
                                    <textarea id="Exam_ExamContentsSingle" name="ExampleContents" rows="3" class="form-control" title=""><%:Model.ExampleEntity[i].ExampleContents %></textarea>
                                </div>
                                <div class="col-md-12  p-0 mt-3">
                                    <label for="Exam_ExamContents" class="form-label sr-only"><%:i+1 %>번 항목 첨부파일 <strong class="text-danger"></strong></label>
                                    <% 
                                        var hasPreview = "N";
                                        var preview = "";

                                        if (Model.ExampleEntity[i].SaveFileName != null)
                                        {
                                            hasPreview = "Y"; //첨부파일의 이미지를 보여주겠다
                                            preview = "<img id='previewimage_" + i + "' alt='' src='/Files" + Model.ExampleEntity[i].SaveFileName + "' style='max-width: 50%; min-height: 30px;' /><br/>";
                                    %>

                                    <%}%>

                                    <% Html.RenderPartial("./Common/File"
                                                                  , Model.ExampleEntity[i].fileList
                                                                  , new ViewDataDictionary {
                                                            { "name", "FileGroupNo" },
                                                            { "fname", "QuestionExampleFile_"+(i+1) },
                                                            { "value", Model.ExampleEntity[i].FileGroupNo == null ? 0 : Model.ExampleEntity[i].FileGroupNo },
                                                            { "fileDirType", "MJBANK"},
                                                            { "hasPreview",hasPreview},
                                                            { "preview", preview},
                                                            { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
                                </div>

                            </div>

                            <%}
                                }%>

                            <%-- 단일선택 종료 / 다중선택 시작 --%>
                            <%
                                else if (Model.QuestionEntity.QuestionType == "MJQT003")
                                {
                                    for (int i = 0; i < Model.ExampleEntity.Count; i++)
                                    {
                            %>
                            <div class="form-group col-md-12 mb-3">
                                <div class="col-md-12 p-0 m-0">
                                    <label for="Exam_ExamContentsMulti" class="form-label">
                                        <input type="checkbox" class="checkbox-inline" value="<%:i %>" name="CorrectAnswerYesNo" <%= Model.ExampleEntity[i].CorrectAnswerYesNo == "Y"? "checked":"" %>>
                                        <%:i+1 %>번 항목 <strong class="text-danger">*</strong></label>
                                    <textarea id="Exam_ExamContentsMulti" name="ExampleContents" rows="3" class="form-control" title=""><%:Model.ExampleEntity[i].ExampleContents %></textarea>
                                </div>
                                <div class="col-md-12  p-0 mt-3">
                                    <label for="Exam_ExamContents" class="form-label sr-only"><%:i+1 %>번 항목 첨부파일 <strong class="text-danger"></strong></label>
                                    <% 
                                        var hasPreview = "N";
                                        var preview = "";

                                        if (Model.ExampleEntity[i].SaveFileName != null)
                                        {
                                            hasPreview = "Y";
                                            preview = "<img id='previewimage_" + i + "' alt='' src='/Files" + Model.ExampleEntity[i].SaveFileName + "' style='max-width: 50%; min-height: 30px;' /><br/>";
                                    %>

                                    <%}%>

                                    <% Html.RenderPartial("./Common/File"
                                                                  , Model.ExampleEntity[i].fileList
                                                                  , new ViewDataDictionary {
                                                            { "name", "FileGroupNo" },
                                                            { "fname", "QuestionExampleFile_"+(i+1) },
                                                            { "value", Model.ExampleEntity[i].FileGroupNo == null ? 0 : Model.ExampleEntity[i].FileGroupNo },
                                                            { "fileDirType", "MJBANK"},
                                                            { "hasPreview",hasPreview},
                                                            { "preview", preview},
                                                            { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
                                </div>
                            </div>
                            <%-- 다중선택 종료 / 단답형 시작 --%>
                            <%}
                                }
                                else if (Model.QuestionEntity.QuestionType == "MJQT004")
                                {
                            %>

                            <div class="form-row" id="template_ShortAnswer">
                                <% for (int i = 0; i < Model.ExampleEntity.Count; i++)
                                    { %>
                                <div class="form-group col-md-12">
                                    <label for="Exam_Title" class="form-label">정답<%:i%></label>
                                    <input type="text" name="ExampleContents" class="form-control" value="<%:Model.ExampleEntity[i].ExampleContents %>">
                                    <input name="CorrectAnswerYesNo" class="i_radio d-none" value="<%:i%>" type="checkbox" checked="checked" />
                                </div>

                                <% } %>
                            </div>

                            <%} %>
                        </div>
                        <%-- 예제 입력 종료 / 답안 설명 시작 --%>
                        <div class="form-row">
                            <div class="form-group col-md-12">
                                <label for="txtAnswerExplain" class="form-label">답안설명 </label>
                                <textarea id="txtAnswerExplain" name="AnswerExplain" class="form-control" rows="7"><%=Model.QuestionEntity.AnswerExplain %></textarea>
                            </div>
                        </div>
                        <%--  답안 설명 종료 --%>
                        <p class="font-size-14 font-weight-bold mb-1">
                            <i class="bi bi-info-circle-fill"></i>
                            입력하시는 내용은 수강생이 시험문제를 풀 때는 보이지 않으며, 해당 시험이 모두 마감된 이후
                            해당 시험에 대해 <span class="text-danger">'평가완료'</span> 하셨을 때수강생에게 정답과 함께 보이는 답안설명란입니다.
                            이용에 착오가 없으시길 바랍니다.
                        </p>
                    </div>

                    <div class="card-footer">
                        <div class="row align-items-center">
                            <div class="col-md">
                                <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                            </div>
                            <div class="col-md-auto text-right">
                                <button type="button" class="btn btn-primary" onclick="fnSave();">저장</button>
                                
                                <button type="button" class="btn btn-secondary" onclick="javascript: document.location.href = '/QuestionBank/Index/<%:Model.QuestionBankType %>/<%:Model.GubunNo %>?SearchText=<%:Model.SearchText %>&pagerowsize=<%:Model.PageRowSize %>&pageNum=<%:Model.PageNum %>&GubunNo=<%:Model.GubunNo %>&QuestionType=<%:Model.QuestionType %>';">목록</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%-- Hidden --%>
        <input type="hidden" id="hdnHtmlContents" name="QuestionEntiry.Question" />
        <input type="hidden" id="hdnQuestionBankNo" name="QuestionEntity.QuestionBankNo" value="<%:Model.QuestionEntity.QuestionBankNo %>" />
        <input type="hidden" name="QuestionBankType" id="hdnQuestionBankType" value="<%:Model.QuestionBankType%>" />
        <input type="hidden" name="GubunNoOri" id="hdnGubunNoOri" value="<%:Model.GubunNo %>" />
        <input type="hidden" name="GubunNo" id="hdnGubunNo" value="<%:Model.GubunNo %>" />
        <input type="hidden" id="hdnQuestion" name="Question" />
        <%-- Hidden --%>

    </form>
    <%-- 폼 종료 --%>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="/Script/QuestionBankFolder.js" _pageType="Update"></script>
    <script type="text/javascript">
        var ajaxHelper = new AjaxHelper();
        var selectNodeNo = 0;
        var mode;
        var gubunID;
        var gubunName;
        var oEditors = [];
        var fileUpload;
        var orgCategory = "<%: Model.QuestionEntity.GubunNo %>";
        var nhnEditorHeight = 105;

        $(document).ready(function () {
            $("#ddlQuestionType").change(function () {
                ExampleLayerView();
            });

            $("#ddlQuestionExampleCount").change(function () {
                ExampleLayerView();
            });

            function ExampleLayerView() {
                $("#pnlQuestionExampleArea").empty();
                var _questionType = $("#ddlQuestionType").val();
                var _html = "";
                if (_questionType == "MJQT002") // 단일선택
                {
                    $("#pnlQuestionExampleCount").attr("class", "form-group col-6 col-md-2 col-lg-1");
                    var _count = $("#ddlQuestionExampleCount").val();
                    var _template = $("#template_single")[0].outerHTML;
                    for (var i = 1; i <= _count; i++) {
                        _html += $.stringFormat(_template, i);
                    }
                    $("#pnlQuestionExampleArea").prepend(_html);
                }
                else if (_questionType == "MJQT003") // 다중선택
                {
                    $("#pnlQuestionExampleCount").attr("class", "form-group col-6 col-md-2 col-lg-1");
                    var _count = $("#ddlQuestionExampleCount").val();
                    var _template = $("#template_multi")[0].outerHTML;
                    for (var i = 1; i <= _count; i++) {
                        _html += $.stringFormat(_template, i);
                    }
                    $("#pnlQuestionExampleArea").prepend(_html);
                }
                else if (_questionType == "MJQT001") //서술형
                {
                    $("#pnlQuestionExampleCount").attr("class", "sr-only");
                    $("#pnlQuestionExampleArea").after("");
                }
                else if (_questionType == "MJQT004") //단답형
                {
                    $("#pnlQuestionExampleCount").attr("class", "sr-only");
                    var _template = $("#template_ShortAnswer")[0].outerHTML;
                    _html = $("#Notice_ShortAnswer")[0].outerHTML;
                    _html += _template;
                    $("#pnlQuestionExampleArea").prepend(_html);
                    //$("#pnlQuestionExampleArea").after(_html);
                }
            }

        });//end of document.ready

        function fnSave() {
            myeditor.outputBodyHTML();
            try {

                var _content = $("#editorContentValue").val();
                $("#hdnQuestion").val(encodeURI(_content));

            } catch (e) {

            }

            var _correctAnswer = $("input[name='CorrectAnswerYesNo']:checked");
            var _examples = $("#pnlQuestionExampleArea textarea[name='ExampleContents']");
            var isValid = true;
            if ($("#hdnGubunNo").val() == "0") {
                //messageBox("폴더를 선택하세요.", 1);
                alert("폴더를 선택하세요.");
                return false;
            }

            if ($("#ddlDifficulty").val() == "" && $("#h_QuestionBankType").val() == "MJTP001") {
                //messageBox("출제주차를 선택하세요.", 1);
                alert("출제주차를 선택하세요.");
                return false;
            }

            if (_examples.length > 0) {
                for (var i = 0; i < _examples.length; i++) {
                    if ($(_examples[i]).val() == "") {
                        //messageBox("보기를 입력하세요.", 1);
                        alert("보기를 입력하세요");
                        isValid = false;
                        break;
                    }
                }
            }

            if (!isValid) return false;
            if ($("#ddlQuestionType").val() == "MJQT001") {
                //시험문항 : MJTP001
                if ($("#h_QuestionBankType").val() == "MJTP001") {
                    if (_correctAnswer.length == 0) {
                        //messageBox("정답을 선택하세요.", 1);
                        alert("정답을 선택하세요.");
                        return false;
                    }
                }
            }
            var iframes = $(".table-responsive .examFileFrame");
            console.log();
            for (var i = 0; i < iframes.length; i++) {
                var _fileName = $(iframes[i]).contents().find("input[name='fileName']", "#fileUploadLayer");
                var _fileNewName = $(iframes[i]).contents().find("input[name='fileNewName']", "#fileUploadLayer");
                var _fileSize = $(iframes[i]).contents().find("input[name='fileSize']", "#fileUploadLayer");
                var _fileType = $(iframes[i]).contents().find("input[name='fileType']", "#fileUploadLayer");
                $("#mainForm").append("<input type='hidden' name='fileName' value='" + (_fileName.length == 0 ? 0 : $(_fileName[0]).val()) + "' />");
                $("#mainForm").append("<input type='hidden' name='fileNewName' value='" + (_fileNewName.length == 0 ? 0 : $(_fileNewName[0]).val()) + "' />");
                $("#mainForm").append("<input type='hidden' name='fileSize' value='" + (_fileSize.length == 0 ? 0 : $(_fileSize[0]).val()) + "' />");
                $("#mainForm").append("<input type='hidden' name='fileType' value='" + (_fileType.length == 0 ? 0 : $(_fileType[0]).val()) + "' />");
            }

            document.forms[0].submit();
        }

	</script>
</asp:Content>
