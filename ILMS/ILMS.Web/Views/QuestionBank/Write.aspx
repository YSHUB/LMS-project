<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.QuestionViewModel>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">문제등록</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/QuestionBank/Write" name="mainForm" id="mainForm" method="post" enctype="multipart/form-data">

        <div class="row no-gutters">
            <%-- 폴더 시작 --%>
            <div class="col-xl-3 bg-point-light p-4">
                <% Html.RenderPartial("/Views/Shared/QuestionBank/FolderList.ascx"
                                           , Model
                                           , new ViewDataDictionary { { "pageType", "Write" } }); %>
            </div>
            <%-- 폴더 종료 --%>

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
                                <label for="Exam_Title" class="form-label" id="lblEditor">문제 <strong class="text-danger">*</strong></label>
                                <% Html.RenderPartial("./Common/Editor"); %>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-3 col-md-2 col-lg-1">
                                <label for="chkUseYesNo" class="form-label">사용여부 <strong class="text-danger">*</strong></label>
                                <label class="switch">
                                    <input type="checkbox" id="chkUseYesNo" name="UseYesNo" checked="checked">
                                    <span class="slider round"></span>
                                </label>
                            </div>
                            <div class="form-group col-3 col-md-2 col-lg-1">
                                <label for="ddlDifficulty" class="form-label">출제주차 <strong class="text-danger">*</strong></label>
                                <select class="form-control" id="ddlDifficulty" name="Difficulty">
                                    <% 
                                        foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MJDF")).ToList())
                                        {
                                    %>
                                    <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group col-3 col-md-3">
                                <label for="ddlQuestionType" class="form-label">문항유형 <strong class="text-danger">*</strong></label>
                                <select class="form-control" id="ddlQuestionType" name="QuestionEntity.QuestionType">
                                    <% 
                                        foreach (var item in Model.BaseCode.Where(c => c.ClassCode.Equals("MJQT")).ToList())
                                        {
                                    %>
                                    <option value="<%:item.CodeValue%>"><%:item.CodeName%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="form-group col-6 col-md-2 col-lg-1" id="pnlQuestionExampleCount">
                                <label for="ddlQuestionExampleCount" class="form-label">
                                    보기 개수 <strong class="text-danger">*</strong>
                                </label>
                                <select class="form-control" id="ddlQuestionExampleCount">
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
                        </div>
                        <div class="form-row" id="pnlQuestionExampleArea">
                        </div>
                        <div class="form-row"> 
                            <div class="form-group col-md-12">
                                <label for="txtAnswerExplain" class="form-label">답안설명</label>
                                <textarea id="txtAnswerExplain" name="AnswerExplain" class="form-control" rows="7"></textarea>
                            </div>
                        </div>
                        <p class="font-size-14 font-weight-bold mb-1">
                            <i class="bi bi-info-circle-fill"></i>
                            입력하시는 내용은 수강생이 시험문제를 풀 때는 보이지 않으며, 해당 시험이 모두 마감된 이후
                            해당 시험에 대해 <span class="text-danger">'평가완료'</span> 하셨을 때수강생에게 정답과 함께 보이는 답안설명란입니다.
                            이용에 착오가 없으시길 바랍니다.
                        </p>
                    </div>
                    <%-- 디자인 입력 및 수정 종료 --%>
                    <div class="card-footer">
                        <div class="row align-items-center">
                            <div class="col-md">
                                <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                            </div>
                            <div class="col-md-auto text-right">
                                <%--<input type="submit" class="btn btn-primary" title="저장"/>--%>
                                <button type="button" class="btn btn-primary" onclick="fnSave();">저장</button>
                                <button type="button" class="btn btn-secondary" onclick="javascript: document.location.href = '/QuestionBank/Index/<%:Model.QuestionBankType %>/<%:Model.GubunNo %>';">취소</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <input type="hidden" id="hdnHtmlContents" name="QuestionEntiry.Question" />
        <input type="hidden" name="QuestionBankType" id="hdnQuestionBankType" value="<%:Model.QuestionBankType%>" />
        <input type="hidden" name="GubunNo" id="hdnGubunNo" value="<%:Model.GubunNo %>" />
        <input type="hidden" id="hdnQuestion" name="Question" />

    </form>

    <% Html.RenderPartial("/Views/Shared/QuestionBank/Template.ascx");%>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="/Script/QuestionBankFolder.js" _pagetype="Write"></script>

    <script type="text/javascript">

        var ajaxHelper = new AjaxHelper();
        var mode;

        $(document).ready(function () {

            QuestionType = $("#hdnQuestionBankType").val();

            fnExampleLayerView();

            $("#ddlQuestionType").change(function () {
                fnExampleLayerView();
            });

            $("#ddlQuestionExampleCount").change(function () {
                fnExampleLayerView();
            });

        });<%--end of document.ready--%>

        function fnExampleLayerView() {
            var _questionType = $("#ddlQuestionType").val();
            var _html = "";
            if (_questionType == "MJQT002") <%--단일선택--%>
            {
                $("#pnlQuestionExampleArea > .templateMulti").remove();

				// 항목 수
                var tmpClassSingleCnt = $(".templateSingle").length - 1;

                $("#pnlQuestionExampleCount").attr("class", "form-group col-6 col-md-2 col-lg-1");
				
				// 보기 개수
				var _count = $("#ddlQuestionExampleCount").val();       

				// 시작 템플릿
				var _index = (tmpClassSingleCnt - 1 < 0) ? 0 : tmpClassSingleCnt - 1;
				var _template = $(".templateSingle")[_index].outerHTML;

                var subtractCnt = (_count - tmpClassSingleCnt);
                if (tmpClassSingleCnt > 0) {
                    if (_count > tmpClassSingleCnt) {
                        for (let i = 1; i <= subtractCnt; i++) {

							// 마지막 인덱스 찾기
							_template = $(".templateSingle")[_index + 1].outerHTML;

                            _html += $.stringFormat(_template, (tmpClassSingleCnt + i));
                        }
                    } else {
						
						for (let j = tmpClassSingleCnt - 1; j >= _count; j--) {
                            $(".templateSingle")[j].remove();
                        }
					}					
                } else {
                    for (let i = 1; i <= _count; i++) {
					//	$(".temlateSingle").find("#Exam_Label").attr("name", "Exam_ExamContentSingle" + i);
						_html += $.stringFormat(_template, i);
					}
                }

				$("#pnlQuestionExampleArea").append(_html);

            }
            else if (_questionType == "MJQT003") <%--다중선택--%>
            {
				$("#pnlQuestionExampleArea > .templateSingle").remove();

				// 항목 수
                var tmpClassMultiCnt = $(".templateMulti").length - 1;

                $("#pnlQuestionExampleCount").attr("class", "form-group col-6 col-md-2 col-lg-1");

				// 보기 개수
				var _count = $("#ddlQuestionExampleCount").val();

				// 시작 템플릿
				var _index = (tmpClassMultiCnt - 1 < 0) ? 0 : tmpClassMultiCnt - 1;
				var _template = $(".templateMulti")[_index].outerHTML;

				var subtractCnt = (_count - tmpClassMultiCnt);

				if (tmpClassMultiCnt > 0) {
					if (_count > tmpClassMultiCnt) {
						for (let i = 1; i <= subtractCnt; i++) {

							// 마지막 인덱스 찾기
							_template = $(".templateMulti")[_index + 1].outerHTML;

							_html += $.stringFormat(_template, (tmpClassMultiCnt + i));
						}
					} else {

						for (let j = tmpClassMultiCnt - 1; j >= _count; j--) {
							$(".templateMulti")[j].remove();
						}
					}
				} else {
					for (let i = 1; i <= _count; i++) {
						_html += $.stringFormat(_template, i);
					}
				}

				$("#pnlQuestionExampleArea").append(_html);


            }
            else if (_questionType == "MJQT001") <%--서술형--%>
            {
                $("#pnlQuestionExampleArea").empty();

                $("#pnlQuestionExampleCount").attr("class", "sr-only");
                $("#pnlQuestionExampleArea").after("");

            }
            else if (_questionType == "MJQT004") <%--단답형--%>
            {
                $("#pnlQuestionExampleArea").empty();

                $("#pnlQuestionExampleCount").attr("class", "sr-only");

                var _template = $("#template_ShortAnswer")[0].outerHTML;

                _html = $("#Notice_ShortAnswer")[0].outerHTML;
                _html += _template;

                $("#pnlQuestionExampleArea").prepend(_html);
            }
                      

            //var tmpClassMultiCnt = $(".templateMulti").length - 1;

        }

        function fnSave() {
            var isValid = true;

            if ($("#hdnGubunNo").val() == "0") {
                bootAlert("폴더를 선택하세요.");
				return false;
			}

            myeditor.outputBodyHTML();

            var _content = $("#editorContentValue").val();
            $("#hdnQuestion").val(encodeURI(_content));

            if (_content.length < 1) {
                bootAlert("문제내용을 입력하세요.");
				return false;
            }


            if ($("#ddlDifficulty").val() == "" && $("#hdnQuestionBankType").val() == "MJTP001") {

                bootAlert("출제주차를 선택하세요.");
                return false;
            }

            var examples = $("#pnlQuestionExampleArea textarea[name='ExampleContents']");
			if (examples.length > 0) {
				for (var i = 0; i < examples.length; i++) {
					if ($(examples[i]).val() == "") {
						bootAlert("보기를 입력하세요");
                        isValid = false;
                        break;
                    }
                }
            }
            if (!isValid) return false;

			var correctAnswer = $("form input[name='CorrectAnswerYesNo']:checked");
            if ($("#hdnQuestionBankType").val() == "MJTP001") {
                if ($("#ddlQuestionType").val() == "MJQT002" || $("#ddlQuestionType").val() == "MJQT003") {
                    if (correctAnswer.length == 0) {
                        bootAlert("정답을 선택하세요.");
                        return false;
                    }
                }
            }
            document.forms[0].submit();
        }

	</script>

</asp:Content>
