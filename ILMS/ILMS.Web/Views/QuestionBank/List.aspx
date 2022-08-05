<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.QuestionViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

		<div class="row no-gutters">
            <%-- 폴더시작 --%>
            <div class="col-xl-3 bg-point-light p-4">
				<% Html.RenderPartial("/Views/Shared/QuestionBank/FolderList.ascx"
                                   , Model
                                   , new ViewDataDictionary {{ "pageType", "index" }}); %>
            </div>
            <%-- 폴더 종료 --%>
			<div class="col-xl-9 p-4">
				<p class="font-size-14 font-weight-bold mb-1">
					<i class="bi bi-info-circle-fill"></i>
					문제은행 관리에서 등록된 문제를 선택하여 출제할 수 있습니다.
				</p>
				<p class="font-size-14 font-weight-bold">
					<i class="bi bi-info-circle-fill"></i>
					문제 추가등록 또는 수정, 삭제는 문제은행 관리에서 해야 합니다.
				</p>

				<div class="card card-style01">
					<div class="card-header">
						<div class="text-right">
							<button onclick="fnSubmitQuestion();" id="btnSubmitQuestinOnTop" class="btn btn-sm btn-primary">선택문제 출제하기</button>
							<%--<button type="button" class="btn btn-sm btn-danger btn_delete">삭제</button>--%>
						</div>
					</div>

					<div class="card-body py-0">
						<div class="table-responsive overflow-auto " style="max-height: 400px;">
							<table class="table table-sm table-hover" cellspacing="0" summary="" id="QuestBankTable">
								<thead>
									<tr>
										<th scope="col">
											<input id="chkAll" name="allCheck" class="checkbox" onclick="fnSetCheckBoxAll(this,'chkId');" type="checkbox"></th>
										<th scope="col">번호</th>
										<th scope="col">제목</th>
										<th scope="col">유형</th>
										<th scope="col">주차</th>
										<th scope="col" class="text-nowrap">등록일</th>
										<th scope="col" class="text-nowrap">사용횟수</th>
										<th scope="col" class="text-nowrap">사용유무</th>
									</tr>
								</thead>
								<tbody>
                                    <% 
                                        if (Model.QuestionList.Count > 0)
                                        {
                                            int rowIndex = 1;

                                            foreach (var item in Model.QuestionList)
                                            {
                                                var _Html = item.Question;
                                                _Html = System.Text.RegularExpressions.Regex.Replace(_Html, "<[^>]*>", string.Empty);
                                                _Html = System.Text.RegularExpressions.Regex.Replace(_Html, @"^\s*$\n", string.Empty, System.Text.RegularExpressions.RegexOptions.Multiline);

                                    %>
                                    <tr>
                                        <td class="text-center">
                                            <input name="QuestionBankNo" id="chkId_<%:rowIndex %>" class="checkbox enableAllCheck" value="<%:item.QuestionBankNo %>" type="checkbox" /></td>
                                        <td class="text-center"><%:item.Row %></td>
                                        <td class="text-left">
                                            <label for="chkId_<%:rowIndex %>"><%:_Html.Replace("&nbsp;", "") %></label>

                                        </td>
                                        <td class="text-center"><%:item.QuestionTypeName %></td>
                                        <td class="text-center"><%:item.QuestionDifficultyName %></td>
                                        <td class="text-center"><%:item.CreateDateTime %></td>
                                        <td class="text-center"><%:item.UseCount %></td>
                                        <td class="text-center">사용</td>
                                    </tr>
                                    <% rowIndex++;
                                            }
                                        }
                                        else
                                        {%>

                                    <tr>
                                        <td colspan="8">조회된 데이터가 없습니다.</td>
                                    </tr>
                                    <%

                                        }
                                    %>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card-footer">
						<div class="text-right">
							<button onclick="fnSubmitQuestion();" class="btn btn-sm btn-primary">선택문제 출제하기</button>
						</div>
						
                    </div>

					<!-- paginate-->
					<%--페이징 추가 예정--%>
					<%--<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>--%>
					<!--//paginate-->
				</div>
				<!-- sec -->
			</div>
		</div>
		<input type="hidden" name="QuestionType" id="hdnQuestionType" value="<%:Model.QuestionBankType%>" />
		<input type="hidden" name="GubunNo" id="hdnGubunNo" value="<%:Model.GubunNo %>" />

	<%-- 템플릿 생성시 사용하는 스크립트 --%>
	<div id="template" style="display: none">
		<div id="divTemplateEdit">
			<div style="float: left; width: 140px; overflow: hidden; height: 30px;">
				<input type="text" class="i_text offText" value="{0}" name="{1}" id="{2}" style="width: 120px; margin-left: {3}px;" readonly="readonly" />
			</div>
			<div style="float: left">
			
				<button class="btn btn-sm btn-info btn_icon_add">추가</button>
			</div>
		</div>
		<div id="divTemplateSave">
			<div class="categoryRow col-7">
				<input type="text" name="categoryName" class="divTemplateEditText form-control" onblur="javascript:outtemp(this);" style="margin-left: {1}px;" />
			</div>
			<div class="col-5 text-right">
				
				<button class="btn btn-sm btn-dark btn_icon_save" title="저장"><i class="bi bi-save"></i></button>

			</div>
		</div>
	</div>
	
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script src="/Script/QuestionBankFolder.js" _pageType="List"></script>
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			// 부모창에 추가된 문제 선택불가
			$("input[name='QuestionBankNo']").each(function () {
				if ($("#questionList > tbody > tr:has(input[value='" + $(this).val() + "'])", opener.document).length > 0) {
					$(this).attr("disabled", true);
                }
			});
		});

        function fnSubmitQuestion() {
			if ($('input:checkbox[name=QuestionBankNo]:checked').length == 0) {
				bootAlert("문제 항목을 선택하여 주십시오");
				return false;
			}
            var questionBankNos = "";

            $('input:checkbox[name=QuestionBankNo]:checked').each(function () {
                if (questionBankNos == "")
                    questionBankNos += this.value;
                else
                    questionBankNos += ", " + this.value;
            });

			// 부모창 함수 호출
			opener.fnAddQuestion(questionBankNos);

			bootConfirm('선택하신 문제를 퀴즈/시험에 반영하였습니다. 종료하시겠습니까?\n\n예 : 종료(창 닫기)\n아니오 : 문제 계속 추가', function () {
				self.close();
			})

			/*
			setTimeout(function () {
				window.location.reload();
                if (confirm("선택하신 문제를 퀴즈/시험에 반영하였습니다. 종료하시겠습니까?\n\n예 : 종료(창 닫기)\n아니오 : 문제 계속 추가")) {
                    self.close();
                }
                else {
                    window.location.reload();
                }
            }, 100);
			*/
		}

    </script>
</asp:Content>
