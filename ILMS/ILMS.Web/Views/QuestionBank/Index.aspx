<%@ Page Language="C#" MasterPagefile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.QuestionViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/QuestionBank/index/MJTP001/<%: Model.GubunNo %>" name="mainForm" id="mainForm" method="post">

        <div class="row no-gutters">
            <%-- 폴더시작 --%>
            <div class="col-xl-3 bg-point-light p-4">
                <% Html.RenderPartial("/Views/Shared/QuestionBank/FolderList.ascx"
                                     , Model
                                     , new ViewDataDictionary { { "pageType", "index" } }); %>
            </div>
            <%-- 폴더 종료 --%>
            <div class="col-xl-9 p-4">
                <%-- 수정 시작 --%>
                <div class="row">
                    <div class="col col-xl-6">
                        <h3 class="title04">문항 위치 : <span id="spanTitle">시험 문항</span><span class="ml-1 mr-1">&gt;</span><span id="spanSubtitle"><%:string.IsNullOrEmpty(Model.GubunName)?"전체":Model.GubunName %></span></h3>
                    </div>
					<div class="col- col-xl-6">
						<div class="text-right mb-2">
							<button type="button" class="btn btn-sm btn-info" id="btnExcelSave">엑셀저장</button>
							<button type="button" class="btn btn-sm btn-outline-dark" id="btnPrintQuestion">문제출력</button>
							<button type="button" class="btn btn-sm btn-outline-dark" id="btnPrintQuestionWithAnswer">답안출력</button>
							<br />
							<span class="item h3">
								<a href="/Download/QuestionUploadExcel.xls" class="btn btn-sm btn-primary">업로드용 엑셀파일 다운로드</a>
								<button type="button" class="btn btn-sm btn-primary" id="btnExcelUpload">일괄등록</button>
								<button type="button" class="d-none" onclick="window.close();">문제은행 닫기</button>
							</span>
						</div>
					</div>
                </div>
                <%-- 수정 종료 --%>
                <p class="font-size-14 font-weight-bold mb-1">
                    <i class="bi bi-info-circle-fill"></i>
                    문제은행 관리에서 등록된 문제를 선택하여 출제할 수 있습니다.
                </p>
                <p class="font-size-14 font-weight-bold">
                    <i class="bi bi-info-circle-fill"></i>
                    문제 추가등록 또는 수정, 삭제는 문제은행 관리에서 해야 합니다.
                </p>

                <div class="card">
                    <div class="card-body pb-1">
                        <div class="form-row align-items-end">
                            <div class="form-group col-md-2">
                                <label for="ddlQuestionTypeGubun" class="form-label">등록현황</label>
                                <select id="ddlQuestionTypeGubun" name="QuestionType" class="form-control">
                                    <option value="">전체</option>
                                    <%
                                        foreach (var item in Model.QuestionTypeCountList)
                                        {
                                    %>
                                    <option value="<%:item.QuestionType %>"  <%= Model.QuestionType == item.QuestionType ? "selected='selected'" : ""%>  ><%:item.QuestionTypeName%>(<%:item.QuestionTypeCount%>) </option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="form-group col-md">
                                <label for="txtSearchText" class="sr-only">검색어 입력</label>
                                <input class="form-control" title="검색어 입력" name="SearchText" id="txtSearchText" value="<%:Model.SearchText??"" %>" type="text">
                            </div>
                            <div class="form-group col-sm-auto text-right">
                                <button type="button" id="btnSearch" class="btn btn-secondary" onclick="javascript:fnSearch();">
                                    <span class="icon search">검색</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- 수정예정 종료 --%>
                <div class="card card-style01">
					<div class="card-header">
						<div class="row justify-content-between">
							<div class="col-auto">
								<div class="dropdown">
									<label for="pageRowSize" class="d-none">정렬 조건 선택</label>
									<select name="pageRowSize" title="정렬 조건 선택" id="pageRowSize" class="form-control">
										<option value="5" <%= Model.PageRowSize.Equals(5) ? "selected='selected'" : ""%>>5건</option>
										<option value="10" <%= Model.PageRowSize.Equals(10) ? "selected='selected'" : ""%>>10건</option>
										<option value="50" <%= Model.PageRowSize.Equals(50) ? "selected='selected'" : ""%>>50건</option>
										<option value="100" <%= Model.PageRowSize.Equals(100) ? "selected='selected'" : ""%>>100건</option>
										<option value="10000" <%= Model.PageRowSize.Equals(10000) ? "selected='selected'" : ""%>>전체</option>
									</select>
								</div>
							</div>
							<div class="col-auto text-right">
								<a type="button" class="btn btn-sm btn-primary" href="/QuestionBank/Write/<%:Model.QuestionBankType%>/<%:Model.GubunNo %>">신규등록</a>
								<button type="button" class="btn btn-sm btn-danger btn_delete">삭제</button>
							</div>
						</div>
					</div>

                    <div class="card-body py-0">
                        <div class="table-responsive overflow-auto " style="max-height: 400px;">
                            <table class="table table-sm table-hover" cellspacing="0" summary="문제 조회 목록" id="QuestBankTable">
                                <caption>문제 조회 목록</caption>

                                <thead>
                                    <tr>
                                        <th scope="col">
                                            <label class="d-none" for="chkAll">체크박스 전체선택</label>
                                            <input id="chkAll" name="allCheck" class="checkbox" title="체크박스 전체선택" onclick="fnSetCheckBoxAll(this,'chkId');" type="checkbox"></th>
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
                                            foreach (var item in Model.QuestionList)
                                            {
                                                var _Html = item.Question;
                                                _Html = System.Text.RegularExpressions.Regex.Replace(_Html, "<[^>]*>", string.Empty);
                                                _Html = System.Text.RegularExpressions.Regex.Replace(_Html, @"^\s*$\n", string.Empty, System.Text.RegularExpressions.RegexOptions.Multiline);

                                    %>
                                    <tr>
                                        <td class="text-center">
                                            <label for="chkId" class="d-none">체크된 항목 선택</label>
                                            <input name="QuestionBankNo" id="chkId" class="checkbox enableAllCheck" title="체크된 항목 선택" value="<%:item.QuestionBankNo %>" type="checkbox" <%:item.UseCount > 0 ? "disabled=disabled" : "" %> /></td>
                                        <td class="text-center"><%:item.Row %></td>
                                        <td class="text-left">
                                            <a href="/QuestionBank/Update/<%:Model.QuestionBankType%>/<%:Model.GubunNo %>/<%:item.QuestionBankNo %>?SearchText=<%:Model.SearchText %>&pagerowsize=<%:Model.PageRowSize %>&pageNum=<%:Model.PageNum %>&GubunNo=<%:Model.GubunNo %>&QuestionType=<%:Model.QuestionType %>"><%:_Html.Replace("&nbsp;", "") %></a>

                                        </td>
                                        <td class="text-center"><%:item.QuestionTypeName %></td>
                                        <td class="text-center"><%:item.QuestionDifficultyName %></td>
                                        <td class="text-center text-nowrap"><%:item.CreateDateTime %></td>
                                        <td class="text-center"><%:item.UseCount %></td>
                                        <td class="text-center">사용</td>
                                    </tr>
                                    <%	
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
                            <a type="button" class="btn btn-sm btn-primary" href="/QuestionBank/Write/<%:Model.QuestionBankType%>/<%:Model.GubunNo %>">신규등록</a>
                            <button type="button" class="btn btn-sm btn-danger btn_delete">삭제</button>
                        </div>
                    </div>
                    <%
                        int pageTotalCount = 0;
                        if (Model.QuestionList.Count > 0)
                        {
                            pageTotalCount = Model.QuestionList[0].TotalCount;
                        }
                    %>
                    <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
                </div>
            </div>
        </div>
        <input type="hidden" name="QuestionBankType" id="hdnQuestionBankType" value="<%:Model.QuestionBankType%>" />
        <input type="hidden" name="GubunNo" id="hdnGubunNo" value="<%:Model.GubunNo %>" />

        <%-- 엑셀 업로드용 모달 시작 --%>
        <div id="filePopup" class="modal">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">파일 업로드</h5>
                    </div>
                    <div class="modal-body pb-0">
                        <table class="table table-board mb-0" summary="엑셀 업로드용 모달">
                            <caption>엑셀 업로드용 모달입니다.</caption>
                            <colgroup>
                                <col width="150px" />
                                <col width="" />
                            </colgroup>
                            <thead>
                            </thead>
                            <tbody>
                                <tr>
                                    <th style="vertical-align: middle; text-align: left; border: 0px;">파일첨부
                                    </th>
                                    <td style="vertical-align: middle; text-align: left; border: 0px;">
                                        <div class="item">
                                            <% Html.RenderPartial("./Common/File"
                                                , Model.newFileList
                                                , new ViewDataDictionary {
                                             { "id", "excelUpload" },
                                             { "name", "FileGroupNo" },
                                             { "fname", "ExcelUpload" },
                                             { "value", 0 },
                                             { "fileDirType", "QuestionBank/excelUpload"},
                                             { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <div class="text-right">
                            <button type="button" class="btn btn-sm btn-primary" id="btnExcelSubmit">등록</button>
                            <button type="button" class="btn btn-sm btn-secondary" id="btn_close">취소</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- 엑셀 업로드용 모달 종료 --%>
    </form>

</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="/Script/QuestionBankFolder.js" _pagetype="Index"></script>
    <script type="text/javascript">

        function outtemp(t) {
            if ($.trim($(t).val()) === '') {
                $(t).closest(".deleterow").remove();
            }
        }

        var ajaxHelper = new AjaxHelper();
        var selectNodeNo = 0;
        var mode;
        var gubunNo;
        var gubunName;

        $(document).ready(function () {

            if ('<%:Model.Message%>' == 'SUCCESS') {
                bootAlert("일괄등록 되었습니다.");
            } else if ('<%:Model.Message%>' == 'FAIL') {
                bootAlert("파일 저장에 실패했습니다.", function () {
                    window.location.reload(true);
                });
			}

            //선택항목 삭제
            $(".btn_delete").click(function () {

                bootConfirm("사용횟수가 0 이상인 문제는 삭제되지 않으며, 삭제할 경우 복원할 수 없습니다.\n선택한 문제를 삭제하시겠습니까?", function () {
					var qNo = "";
					$("#QuestBankTable td input.checkbox").each(function (index) {
						if (!$(this).prop("disabled") && $(this).prop("checked")) {
							qNo += "," + $(this).val();
						}
					});

					ajaxHelper.CallAjaxPost("/QuestionBank/DeleteQuestion", { qNo: qNo }, "fnCompleteDeleteQuestion");
                })

            });

            //엑셀저장
            $("#btnExcelSave").click(function () {
                document.forms[0].action = "/QuestionBank/ExcelDownload";

                document.forms[0].submit();
            });

            // 문제출력
            $("#btnPrintQuestion").click(function () {

                if ($("#hdnGubunNo").val() != "" && $("#hdnGubunNo").val() != "0") {
                    var strUrl = "/QuestionBank/PrintQuestion?CorrectAnswerYesNo=N&GubunNo=" + $("#hdnGubunNo").val();
                    //window.open(strUrl);
                    OpenPopup(strUrl, "PrintQuestion", (screen.width), screen.height);
                }
                else {
					bootAlert("폴더를 먼저 선택하세요.");
                }
            });

            // 답안출력
            $("#btnPrintQuestionWithAnswer").click(function () {
                if ($("#hdnGubunNo").val() != "" && $("#hdnGubunNo").val() != "0") {
                    var strUrl = "/QuestionBank/PrintQuestion?CorrectAnswerYesNo=Y&GubunNo=" + $("#hdnGubunNo").val();
                    //window.open(strUrl);
                    OpenPopup(strUrl, "PrintQuestion", screen.width, screen.height);
                }
                else {
                    bootAlert("폴더를 먼저 선택하세요.");
                }
            });

            var _id = "excelUpload";

        });

        //모듈로 이동예정
        var OpenPopup = function (URL, popupName, Pwidth, Pheight, left, top, scroll) {
            var iMyWidth = (window.screen.width - Pwidth) / 2;
            var iMyHeight = (window.screen.height - Pheight) / 2 - 20;
            var objWin = window.open(URL, popupName, "width=" + Pwidth + ", height=" + Pheight + " resizable=no, left=" + left + ",top=" + top + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ", scrollbars=" + scroll);
            if (objWin != null)
                objWin.focus();
            return objWin;
        }

        //검색
        function fnSearch() {
            $('form[id=mainForm]').submit();

            return false;
        }

        function fnCompleteDeleteQuestion() {
            var result = ajaxHelper.CallAjaxResult();

            if (result > 0) {
                bootAlert("삭제가 완료되었습니다.", function () {
                    location.reload();

                });
            }
        }

        //엑셀업로드
        $("#btnExcelUpload").click(function () {
            if ($("#hdnGubunNo").val() > 0) {
                $("#filePopup").show();
            }
            else {
                bootAlert('좌측에서 폴더를 선택하신 후 일괄등록해주세요.');
                return false;
            }

        });

        $("#btnExcelSubmit").click(function () {

			if ($("#excelUpload").val() == '') {
				bootAlert('파일을 업로드하세요.');
				return false;
            } else {
                bootConfirm("일괄등록 하시겠습니까?", function () {
				    document.forms[0].action = "/QuestionBank/ExcelUpload";
				    document.forms[0].enctype = "multipart/form-data"
				    document.forms[0].submit();
                })
            }

        });

        $("#btn_close").click(function () {
            $(".temp-file-del").click();
            $("#filePopup").hide();
			$("#excelUpload").val('');
        });

	</script>
</asp:Content>
