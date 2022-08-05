<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <h3 class="title04">과제 정보</h3>
    <div class="card card-style01">
        <div class="card-header">
            <div class="row no-gutters align-items-center">
                <div class="col">
                    <div class="row">
                        <div class="col-md">
                            <div class="text-primary font-size-14">
                                <strong class="text-danger bar-vertical"><%:Model.Homework.Week %>주 <%:Model.Homework.InningSeqNo %>차시</strong>
                                <strong class="text-success bar-vertical"><%:Model.Homework.SubmitTypeName %></strong>

                                <%: Model.Homework.OpenYesNo.Equals("Y") ? Html.Raw("<strong class='text-info'>공개</strong>") : Html.Raw("<strong class='text-danger'>비공개</strong>")%>
                            </div>
                        </div>
                        <div class="col-md-auto text-right">
                            <dl class="row dl-style01">
                                <dt class="col-auto">제출인원</dt>
                                <dd class="col-auto"><%:Model.HomeworkSubmitList.Where(x =>  !string.IsNullOrEmpty(x.SubmitContents) || x.FileGroupNo > 0).Count() %>명</dd>
                                <dt class="col-auto">평가인원</dt>
                                <dd class="col-auto"><%:Model.HomeworkSubmitList.Where(x => x.Score != null).Count() %>명/<%:Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.TargetYesNo) && x.TargetYesNo.Equals("Y")).Count() %>명</dd>
                            </dl>
                        </div>
                    </div>
                </div>
                <div class="col-auto text-right d-md-none">
                    <button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#colHomework" aria-expanded="false" aria-controls="colHomework">
                        <span class="sr-only">더 보기</span>
                    </button>
                </div>
            </div>
            <a class="card-title01 text-dark"><%:Model.Homework.HomeworkTitle %>   </a>
        </div>
        <div class="card-body collapse d-md-block" id="colHomework">
            <div class="row mt-2 align-items-end">
                <div class="col-md">
                    <dl class="row dl-style02">
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>과제유형</dt>
                        <dd class="col-8 col-md"><%:Model.Homework.HomeworkTypeName %></dd>
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>평가공개여부</dt>
                        <dd class="col-8 col-md"><%:Model.Homework.EstimationOpenYesNo == "Y" ? "공개" : "비공개" %>
                            <input type="button" id="btnEstimation" class="btn btn-sm btn-outline-primary" value="<%:Model.Homework.EstimationOpenYesNo == "Y" ? "비공개" : "공개" %>로 변경" /></dd>
                    </dl>
                    <dl class="row dl-style02">
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출기간</dt>
                        <dd class="col-8 col-md"><%:DateTime.Parse(Model.Homework.SubmitStartDay).ToString("yyyy-MM-dd HH:mm") %> ~ <%:DateTime.Parse(Model.Homework.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
                    </dl>
                    <dl class="row dl-style02">
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>추가제출기간</dt>
                        <dd class="col-8 col-md"><%if(Model.Homework.AddSubmitPeriodUseYesNo.Equals("Y")) {%><%:DateTime.Parse(Model.Homework.AddSubmitStartDay).ToString("yyyy-MM-dd HH:mm") %> ~ <%:DateTime.Parse(Model.Homework.AddSubmitEndDay).ToString("yyyy-MM-dd HH:mm") %><%} else {%>사용안함<%} %></dd>
                    </dl>
                    <dl class="row dl-style02">
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>내용</dt>
                        <dd class="col"><%:Model.Homework.HomeworkContents %>
                        </dd>
                    </dl>
                    <dl class="row dl-style02">
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>만점기준</dt>
                        <dd class="col-8 col-md"><%:Model.Homework.Weighting %>점</dd> 
                        <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>평균점수</dt>
                        <dd class="col-8 col-md"><%:Model.HomeworkSubmitList.Where(x => x.TargetYesNo.Equals("Y")).Where(c => c.Score != null).Count().Equals(0) ? "0" : Model.HomeworkSubmitList.Where(x => x.TargetYesNo.Equals("Y")).Where(c => c.Score != null).Average(c => c.Score.Value).ToString("##.##") %>점</dd>
                    </dl>
                    	<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>첨부파일</dt>
						<dd class="col">
							<%
								if (Model.Homework != null)
								{
									if(Model.Homework.FileGroupNo > 0)
									{
								%>
								    <button title="첨부파일 다운로드" id="btnDownload" class="btn btn-lg"><i class="bi bi-download"></i></button>
								<%
									}
									else
									{
								%>
								없음
								<%}
								}
								else 
								{
								%>
								없음
								<%
								}
								%>
						</dd>
					</dl>
                </div>
                <div class="col-md-auto mt-2 mt-md-0 text-right">
                    <div class="btn-group btn-group-lg">
                        <a class="btn btn-lg btn-outline-warning w-100 w-md-auto" href="/Homework/Write/<%:Model.Homework.CourseNo %>/<%:Model.Homework.IsOutput %>/<%:Model.Homework.HomeworkNo %>">수정</a>
                        <a class="btn btn-lg btn-outline-danger w-100 w-md-auto" id="btnDelete">삭제</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--학생/수강생 리스트-->
    <div class="row">
        <div class="col-12 mt-2">
            <h3 class="title04">제출 대상 리스트<strong class="text-primary">(<%:Model.Homework.TotalCount %>건)</strong></h3>
            <div class="card">
                <div class="card-body">
                    <ul class="list-inline list-inline-style02 mb-0">
                        <li class="list-inline-item bar-vertical">
                            <a <%:Model.Present.Equals("a") ? "class=text-primary" : "" %> href="/Homework/Detail/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/a">전체<span class="ml-1 badge <%:Model.Present.Equals("a") ? "badge-primary" : "badge-secondary" %>"><%:Model.Homework.TotalCount %></span></a>
                        </li>
                        <li class="list-inline-item bar-vertical">
                            <a <%:Model.Present.Equals("y") ? "class=text-primary" : "" %> href="/Homework/Detail/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/y">제출<span class="ml-1 badge <%:Model.Present.Equals("y") ? "badge-primary" : "badge-secondary" %>"><%:Model.Homework.SubmitCnt %></span></a>
                        </li>
                        <li class="list-inline-item bar-vertical">
                            <a <%:Model.Present.Equals("n") ? "class=text-primary" : "" %> href="/Homework/Detail/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/n">미제출<span class="ml-1 badge <%:Model.Present.Equals("n") ? "badge-primary" : "badge-secondary" %>"><%:Model.Homework.TotalCount - Model.Homework.SubmitCnt %></span></a>
                        </li>
                    </ul>
					<input type="hidden" name="Present" id="hdnPresent">
                </div>
            </div>
            <%
				if (Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.TargetYesNo) && x.TargetYesNo.Equals("Y")).Count() == 0)
				{
			%>
            <div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>제출 대상이 없습니다.</div>
            <%
				}
				else
				{
			%>
            <div class="card card-style01 mt-2">
                <div class="card-header">
                    <div class="row justify-content-between">
                        <div class="col-auto">
                            <button type="button" class="btn btn-sm btn-secondary" id="btnSort">
								<%if(Model.SortType != null)
									{
										if (Model.SortType.Equals("UserID"))
										{
									%>
										<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순
									<%
										}
										else
										{
									%>
										성명순
									<%} 
									}
									else
									{
									%>
										<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순
								<%
									}
								%>
                            </button>
                        </div>
                        <div class="col-auto text-right">
                            <div class="dropdown d-inline-block">
                                <button type="button" class="btn btn-sm btn-secondary dropdown-toggle" id="ddlSend" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    메세지발송
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="ddlSend">
									<%
										if (ConfigurationManager.AppSettings["MailYN"].ToString().Equals("Y"))
										{
									%>
									<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerMail', 'chkSel');">메일발송</button></li>
									<%
										}
									%>
                                    <li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerNote', 'chkSel');">쪽지발송</button></li>
                                    <li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerSMS', 'chkSel');">SMS발송</button></li>
                                </ul>
                            </div>
                            <div class="dropdown d-inline-block">
                                <button type="button" class="btn btn-sm btn-point dropdown-toggle" id="ddlManage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    과제설정
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="ddlManage">
                                    <li><a class="dropdown-item" role="button" id="btnFilezip">파일 일괄 다운로드</a></li>
                                    <li>
                                        <button class="dropdown-item" type="button" id="btn_open" data-toggle="modal" data-target="#mdlScore" role="button">선택<%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 일괄평가</button></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body py-0">
                    <div class="table-responsive">
                        <table class="table" id="personalTable" summary="과제제출리스트">
                            <caption>과제 제출 리스트</caption>
                            <thead>
                                <tr>
                                    <th scope="row">
                                        <input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');">
                                    </th>
                                    <th scope="row">번호</th>
                                    <th scope="row" class="d-none d-md-table-cell">상태</th>
									<%
									if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
									{
									%>
									<th scope="row" class="d-md-table-cell">소속</th>
									<%
									}
									%>
                                    <th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
                                    <th scope="row">성명</th>
                                    <%
										if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
										{
									%>
									<th scope="row">학적</th>
									<%
										}
										else
										{
									%>
									<th scope="row">생년월일</th>
									<th scope="row" class="d-md-table-cell">구분</th>
									<%
										}
									%>
                                    <th scope="row" class="d-none d-md-table-cell">제출일시</th>
                                    <th scope="row" class="text-nowrap">제출파일</th>
                                    <th scope="row" class="text-nowrap">점수</th>
                                    <th scope="row" class="text-nowrap">추천</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
									foreach (var item in Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.TargetYesNo) && x.TargetYesNo.Equals("Y")))
									{
								%>
                                <tr>
                                    <td>
                                        <input type="checkbox" name="Homework.UserNo" id="chkSel" value="<%:item.UserNo.ToString() + "|" + item.FileGroupNo.ToString() %>" class="checkbox">
                                        <input type="hidden" value="<%:item.UserNo %>">
                                        <input type="hidden" value="<%:item.UserID %>">
                                        <input type="hidden" value="<%:item.HangulName %>(<%:item.UserID %>)">
                                    </td>
                                    <td><%:Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.TargetYesNo) && x.TargetYesNo.Equals("Y")).ToList().IndexOf(item) + 1%></td>
                                    <td class="d-none d-md-table-cell"><%= Model.Homework.HomeworkType == "CHWT004" && item.TeamLeaderYesNo == "N" ? "-" : item.SubmitContents != null  || item.FileGroupNo > 0 ? "<span class='text-primary'>제출</div>" : "<span class='text-danger'>미제출</span>"%></td>
                                   
									<%
									if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
									{
									%>
									<td class="text-nowrap text-left d-md-table-cell"><%:item.AssignName %></td>
									<%
									}
									%>						
                                    <td>
                                        <span class="text-nowrap text-secondary font-size-15">
											<a href="/Homework/Feedback/<%:item.CourseNo %>/<%:item.HomeworkNo %>/<%:item.SubmitUserNo %>"><%:item.UserID %></a>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="text-nowrap text-dark d-block"><%: Model.Homework.HomeworkType == "CHWT004" && !string.IsNullOrEmpty(item.TeamName) ? "(" + item.TeamName + ")" : ""  %><%: item.HangulName%><%: Model.Homework.HomeworkType == "CHWT004" && item.TeamLeaderYesNo == "Y" ? "[팀장]" : ""  %></span>
                                    </td>
                                    <%
										if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
										{
									%>
									<td><%:item.HakjeokGubunName %></td>
									<%
										}
										else
										{
									%>
									<td><%:item.ResidentNo %></td>
									<td class="text-nowrap text-center d-md-table-cell"><%:item.GeneralUserCode %></td>
									<%
										}
									%>
                                    <td class="d-none d-md-table-cell">
										<span class="text-nowrap text-dark d-block"><%:string.IsNullOrEmpty(item.UpdateDateTime) || string.IsNullOrEmpty(item.SubmitContents) && !(item.FileGroupNo > 0) ? "" : DateTime.Parse(item.UpdateDateTime).ToString("yyyy-MM-dd") %></span>
										<span class="text-nowrap text-secondary font-size-15"><%:string.IsNullOrEmpty(item.UpdateDateTime) || string.IsNullOrEmpty(item.SubmitContents) && !(item.FileGroupNo > 0) ? "" : DateTime.Parse(item.UpdateDateTime).TimeOfDay.ToString() %></span>
                                    </td>
                                    <td>
                                        <%
											if (item.FileGroupNo > 0)
											{
										%>
                                        <a href="/Common/FileDownLoad/<%:item.FileNo%>" class="font-size-20" title="제출파일 다운로드"><i class="bi bi-file-earmark-arrow-down"></i></a>
                                        <%
											}
											else
											{
										%>
                                                <%
													if (item.IsGood == 1)
													{
                                                %>
                                                        <button type="button" class="font-size-20" title="제출내용 상세보기" onclick="fnSubmitDetail('<%:item.SubmitContents %>')" data-toggle="modal" data-target="#divSubmitDetail"><i class="bi bi-list"></i></button>
                                                <%
													} else 
                                                    {
                                                %>
                                                        -
                                                <%
                                                    }
                                                %>										
										<%
											}
										%>
                                    </td>
                                    <td class="text-right"><a href="/Homework/Feedback/<%:item.CourseNo %>/<%:item.HomeworkNo %>/<%:item.SubmitUserNo %>"><%:item.Score == null ? "0" : item.Score.Value.ToString("F0")%>점</a>
                                    </td>
                                    <td>
                                        <%
											if (item.IsGood == 0)
											{
										%>
                                        <button class="btn btn-sm btn-outline-primary <%:(Model.Homework.HomeworkType == "CHWT004" && !(item.TeamLeaderYesNo == "Y")) ? "d-none" : (item.SubmitContents != null  || item.FileGroupNo > 0) ? "" : "d-none"%>" title="추천" onclick="fnIsGood(<%:item.IsGood%>,<%:item.SubmitNo%>,'<%: (item.SubmitContents != null || item.FileGroupNo > 0) ? "Y" : "N"%>');"><i class="bi bi-hand-thumbs-up"></i></button>
                                        <%
											}
											else
											{
										%>
                                        <button class="btn btn-sm btn-outline-primary" title="추천취소" onclick="fnIsGood(<%:item.IsGood%>,<%:item.SubmitNo%>,'Y');"><i class="bi bi-hand-thumbs-up-fill"></i></button>
                                        <%
											}
										%>
                                    </td>
                                </tr>
                                <% 
                                    } 
								%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <%
				}
			%>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="text-right">
                <a href="/Homework/ListTeacher/<%:ViewBag.Course.CourseNo %>" class="btn btn-primary">목록</a>
            </div>
        </div>
    </div>
    <div class="modal fade show" id="mdlScore" tabindex="-1" aria-labelledby="mdlScoreLabel" role="dialog">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h4" id="mdlScoreLabel">일괄평가</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>선택된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>에게 모두 동일한 점수가 부여됩니다.</p>
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12">
                                    <div class="form-row">
                                        <div class="form-group col-8">
                                            <label for="txtScore" class="form-label">평가점수 <strong class="text-danger">*</strong></label>
                                            <div class="input-group">
                                                <input type="text" class="form-control text-right" id="txtScore"/>
                                                <div class="input-group-append">
                                                    <div class="input-group-text">점/<%:Model.Homework.Weighting %>점</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-12">
                                            <label for="txtFeedback" class="form-label">코멘트 <strong class="text-danger">*</strong></label>
                                            <div class="input-group">
                                                <textarea class="form-control" rows="5" id="txtFeedback"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 text-right">
                            <input type="button" class="btn btn-primary" id="btnSave" value="저장" />
                            <button type="button" class="btn btn-secondary" id="btnCancel"  data-dismiss="modal" title="닫기">닫기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 제출내용 상세보기-->
	<div class="modal fade show" id="divSubmitDetail" tabindex="-1" aria-labelledby="submitDetail" aria-modal="true" role="dialog">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="submitDetail">제출내용 상세보기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p><label id="lblSubmitContents"></label></p>
				</div>
			</div>
		</div>
	</div>
	<!-- 제출내용 상세보기-->
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();
        var _ajax2 = new AjaxHelper();
		var _ajax3 = new AjaxHelper();

		$(document).ready(function () {

            $("#btnEstimation").click(function () {
                bootConfirm("과제 평가를 " + '<%:Model.Homework.EstimationOpenYesNo.Equals("Y") ? "비공개" : "공개"%>' + "하시겠습니까?", function () {
					window.location = '/Homework/DetailEstimationEdit/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>';
                });

			});

			$("#btnSort").click(function () {
				window.location= '/Homework/Detail/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/<%:Model.Present%>/<%:Model.SortType != null ? Model.SortType : "UserID"%>';
			});

			$("#btnDelete").click(function () {
                if ("<%:Model.HomeworkSubmitList.Where(x=>x.SubmitContents != null || x.FileGroupNo > 0).Count()%>" > "0") {
                    bootConfirm("과제를 제출한 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 존재합니다. 삭제된 정보는 복구할 수 없습니다. 그래도 삭제하시겠습니까?", function () {
						window.location = '/Homework/DetailDelete/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>';
                    })
					
				}
                else {
                    bootConfirm("과제를 삭제하시겠습니까?", function () {
						window.location= '/Homework/DetailDelete/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>';
                    })
					
				}
			});

			$("#btnSave").click(function () {
				var chkUserNo = "";

				if ($("input[name='Homework.UserNo']:checked").length == 0) {
					bootAlert("선택된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다.");
					return false;
				}

				if ($("#txtScore").val() == "") {
					bootAlert("평가점수를 입력해주세요.");
					return false;
				}

				if (parseInt($("#txtScore").val()) > parseInt("<%:Model.Homework.Weighting%>")) {
					bootAlert("만점기준점수보다 평가점수가 큽니다.");
					return false;
				}
				
				$("input[name='Homework.UserNo']:checked").each(function () {
					chkUserNo = chkUserNo + "|" + $(this).val().split('|')[0];
				});

				_ajax.CallAjaxPost("/Homework/AddFeedback", {
                    param1: <%:ViewBag.Course.CourseNo%>,
                    param2: <%:Model.Homework.HomeworkNo%>,
                    param3: chkUserNo,
                    param4: $("#txtScore").val(),
                    param5: $("#txtFeedback").val() }, "fnUpdateFeedback");

			});

			$("#btnFilezip").click(function () {

				var chkfilegroupno = "";

				if ($("input[name='Homework.UserNo']:checked").length == 0) {
					bootAlert("선택된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다.");
					return;
				}

				$("input[name='Homework.UserNo']:checked").each(function () {
					chkfilegroupno = chkfilegroupno + "|" + $(this).val().split('|')[1];
				});

                _ajax2.CallAjaxPost("/Common/DownloadFileZip", {
                    param1: chkfilegroupno,
                    param2: "<%:Model.Homework.HomeworkTitle.Replace("\"", "")%>",
                    param3: "CourseHomework",
                    param4: "123456789" }, "fnFilezip");
            });


			$("#btnDownload").click(function () {
                var filegroupno = '<%:Model.Homework.FileGroupNo%>';

				_ajax3.CallAjaxPost("/Common/DownloadFileZip", { param1: filegroupno, param2: "<%:Model.Homework.HomeworkTitle.Replace("\"", "")%>", param3: "CourseHomework", param4: "" }, "fnFilezipDownload");
			});
		});

		function fnIsGood(isGood, submitNo, submitYesNo) {

			if (submitYesNo == "N") {
				bootAlert("미제출된 과제는 추천할 수 없습니다.");
				return false;
			}

            if (isGood == 1) {
                bootConfirm("추천을 취소하시겠습니까?", function () {
                    window.location = '/Homework/DetailIsGoodEdit/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/' + submitNo;
                })
            } else {
				bootConfirm("추천을 하시겠습니까?", function () {
					window.location = '/Homework/DetailIsGoodEdit/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/' + submitNo;
				})
			}

		}

		function fnUpdateFeedback() {
			var result = _ajax.CallAjaxResult();
            if (result.length > 0) {
                bootAlert(result);
			}
            else {
                bootAlert("저장되었습니다.", function () {
				    window.location = '/Homework/Detail/<%:ViewBag.Course.CourseNo%>/<%:Model.Homework.HomeworkNo%>';
                });
			}
		}

        function fnFilezip() {
			var result = _ajax2.CallAjaxResult();
			if (result != "") {
				window.location.href = result;
			}
			else {
				bootAlert("일괄 다운 받을 파일이 없습니다.");
			}
        }

        function fnFilezipDownload() {
			var result = _ajax3.CallAjaxResult();
			if (result != "") {
				window.location.href = result;
			}
			else {
				bootAlert("다운 받을 파일이 없습니다.");
			}
		}

        <%-- 제출내용 상세보기 --%>
		function fnSubmitDetail(submitContents) {

			$("#lblSubmitContents").text(submitContents);
		}

        $("#btnCancel").click(function () {
			$("#txtScore").val('');
			$("#txtFeedback").val('');			
        });

	</script>
</asp:Content>
