<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.QuestionViewModel>" %>

<%--메인 템플릿 시작 --%>
<div id="mainTemplateArea" class="d-none">
    <div id="template_single" class="form-group col-md-12 mb-3 templateSingle">
        <div class="col-md-12 p-0 m-0">
            <label for="Exam_ExamContentSingle_{0}" class="form-label">
                <input type="radio" class="radio-inline" value="{0}" name="CorrectAnswerYesNo" id="Exam_ExamContentSingle_{0}" title="단일선택 정답선택">
                {0}번 항목 <strong class="text-danger">*</strong></label>
            <textarea id="Exam_ExamContentsSingle" name="ExampleContents" title="단일선택 문항예제" rows="3" class="form-control"></textarea>
        </div>
        <div class="col-md-12  p-0 mt-3">
            <% Html.RenderPartial("./Common/File"
                                              , Model.newFileList
                                              , new ViewDataDictionary {
                                { "name", "FileGroupNo" },
                                { "fname", "MJBANKFile" },
                                { "value", 0 },
                                { "fileDirType", "MJBANK"},
                                { "filecount", 1 }, { "width", "100" }, {"isimage", 0 }
                                              }); %>
        </div>
    </div>

    <div id="template_multi" class="form-group col-md-12 mb-3 templateMulti">
        <div class="col-md-12 p-0 m-0">
            <label for="Exam_ExamContentsMulti_{0}" class="form-label">
                <input type="checkbox" class="checkbox-inline" value="{0}" name="CorrectAnswerYesNo" id="Exam_ExamContentsMulti_{0}" title="다중선택 정답선택">
                {0}번 항목 <strong class="text-danger">*</strong></label>
            <textarea id="Exam_ExamContentsMulti" name="ExampleContents" title="다중선택 문항예제" rows="3" class="form-control" ></textarea>
        </div>
        <div class="col-md-12  p-0 mt-3">
            <% Html.RenderPartial("./Common/File"
                                            , Model.newFileList
                                            , new ViewDataDictionary {
                                { "name", "FileGroupNo" },
                                { "fname", "MJBANKFile" },
                                { "value", 0 },
                                { "fileDirType", "MJBANK"},
                                { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
        </div>
    </div>

   
    <div class="form-row" id="Notice_ShortAnswer">
        <div class="form-group col-12">
            <label class="form-label">유의사항</label>
            <div class="alert alert-light border-dark">
                <p>
                    1. 단답형 출제 시 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>들의 예상 가능한 제출 답안을 최대 5개까지 작성하여 자동채점하실 수 있습니다.<br>
                    - 영문자의 경우 대소문자 구분없이, 띄어쓰기 구분 없이 사용자 답안과 비교합니다.  
						<br>
                    ex) 답이 Korea일 경우 : "korea"(O), "k orea"(O)", " KORE A "(O)", Corea"(X), "대한민국"(X)
                </p>

                <p>
                    2. 단답형은 기호 또는 생각하지 못한 유사답안으로 인해 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>에게 오답으로 처리될 수 있으므로 항상 평가시에 주관식 평가란에서 단답형에 대한 자동채점 배점사항을 확인하시고 잘못 채점된 단답형 답안에
                                        대해서는 수동으로 수정하시어 올바른 점수를 주셔야 합니다.  
						<br>
                    ex) 답이 "한국" 일 때, <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 "대한민국", "KOREA", "korea"이라고도 적을 수 있으므로,
                                        이에 대해 정답으로 인정하고자 하면, 예상 답안 수를 지정하여, <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 제출 가능한 유사답("대한민국", "KOREA")을 모두 적으시면, 보다 자동채점에 도움이 됩니다.
                </p>
            </div>
        </div>
    </div>
    
    <div class="form-row" id="template_ShortAnswer">
        <% for (int i = 1; i < 6; i++)
            { %>
        <div class="form-group col-md-12">
            <label for="txtExampleContents_<%:i%>" class="form-label">정답<%:i%></label>
            <input type="text" title="단답형 정답 내용" id="txtExampleContents_<%:i%>" name="ExampleContents" class="form-control">
            <label for="chkShortAnswer_<%:i%>" class="d-none">단답형 정답 여부</label>
            <input name="CorrectAnswerYesNo" id="chkShortAnswer_<%:i%>" title="단답형 정답 <%:i%>" class="i_radio d-none" value="<%:i%>" type="checkbox" checked="checked" />
        </div>

        <% } %>
    </div>
</div>
<%-- 메인 템플릿 종료 --%>

