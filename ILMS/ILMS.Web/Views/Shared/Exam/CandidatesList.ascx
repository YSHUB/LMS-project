<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : ConfigurationManager.AppSettings["ExamText"].ToString();
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
	<li class="nav-item" role="presentation"><a class="nav-link active show" id="tab1-tab" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="true">개인별 평가현황</a></li>
	<li class="nav-item" role="presentation"><a class="nav-link" href="/<%:GubunCd%>/Statistics/<%:Model.CourseNo %>/<%:Model.ExamNo %>">문항별 통계</a></li>
</ul>

<div class="mt-4 alert bg-light rounded">
	<p class="font-size-14 text-danger font-weight-bold"><i class="bi bi-info-circle-fill"></i> 자동 채점 기능 사용 시 아래사항에 대하여 검토가 필요합니다.</p>
	<ul class="list-style03 mb-0">
		<li> 단답형 자동 채점은 기호 또는 생각하지 못한 유사답안으로 인해 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>에게 오답으로 처리될 수 있으므로 반드시 단답형의 점수를 확인하시고 점수가 맞지 않는 경우 올바른 점수로 수정하시기 바랍니다.</li>
		<li> 단답형의 자동 채점은 띄어쓰기 구분이 없으며, 영문자의 경우 대소문자 구분없이 사용자 답안과 비교됩니다.</li>
		<li class="mb-0"> 비공개 상태 시 학습자들에게 해당 <%:GubunNm %>목록이 노출되지 않습니다.</li>
	</ul>
</div>

<!--학생 리스트-->
<div class="row">
	<div class="col-12 mt-2">
		<h3 class="title04"><%:GubunNm %> 대상 리스트<strong class="text-primary" id="examineeCnt">(<%:Model.ExamineeList.Count %>건)</strong></h3>
		<div class="card mt-4">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-3 col-md-2">
						<label for="searchOption" class="sr-only">상태</label>
						<select id="ddlExamStatus" name="ddlExamStatus" class="form-control">
							<option value="">전체</option>
							<option value="Y">응시완료</option>
							<option value="P">진행중</option>
							<option value="N">미응시</option>
						</select>
					</div>
					<div class="form-group col-3 col-md-2">
						<label for="optionView" class="sr-only">검색어</label>
						<select id="ddlSearchGubun" name="ddlSearchGubun" class="form-control">
							<option value="NAME">성명</option>
							<option value="ID"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></option>
						</select>
					</div>
					<div class="form-group col-6 col-md">
						<label for="Search_Text" class="sr-only">검색어 입력</label>
						<input class="form-control" title="검색어 입력" name="txtSearchText" id="txtSearchText" type="text">
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch()"><span class="icon search">검색</span></button>
					</div>
				</div>
			</div>
		</div>
			
		<div class="card card-style01 mt-2 <%:(Model.ExamineeList.Count > 0) ? "" : "d-none" %>" id="examineeList">
			<div class="card-header">
				<div class="row justify-content-between">
					<div class="col-auto">
						<input type="hidden" id="hdnSortGubun" name="hdnSortGubun" />
						<button type="button" class="btn btn-sm btn-secondary" id="btnSort" onclick=""><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순</button>
					</div>
					<div class="col-auto text-right">
						<div class="dropdown d-inline-block">
							<button type="button" class="btn btn-sm btn-secondary dropdown-toggle" id="dropdown1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">메세지발송</button>
							<ul class="dropdown-menu" aria-labelledby="dropdown1">
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
							<button type="button" class="btn btn-sm btn-point dropdown-toggle" id="dropdown2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><%:GubunNm %>설정</button>
							<ul class="dropdown-menu" aria-labelledby="dropdown2">
								<li <%:(Model.ExamDetail.SEType.Equals(0) && Model.ExamDetail.Gubun.Equals("Q")) ? "" : "class=d-none" %>>
									<input type="hidden" id="hdnChgState" name="hdnChgState" value="<%:(Model.ExamDetail.SE0State.Equals(0)) ? 1 : 0 %>" />
									<button class="dropdown-item" type="button" id="btnStatus"><%:Model.ExamDetail.SE0State.Equals(0) ? "시작하기" : "종료하기" %></button>
								</li>
								<li <%:Model.ExamDetail.Gubun.Equals("Q") ? "" : "class=d-none" %>>
									<input type="hidden" id="hdnChgOpenYn" name="hdnChgOpenYn" value="<%:(Model.ExamDetail.OpenYesNo.Equals("Y")) ? "N" : "Y" %>" />
									<button class="dropdown-item" type="button" id="btnOpen"><%:Model.ExamDetail.OpenYesNo.Equals("Y") ? "비공개 처리" : "공개 처리" %></button>
								</li>
								<li <%:(!Model.ExamDetail.EstimationGubun.Equals("EXET005")) ? "" : "class=d-none" %>>
									<input type="hidden" id="hdnChgScoringCompleteYn" name="hdnChgScoringCompleteYn" value="<%:(Model.ExamDetail.EstimationGubun.Equals("EXET003")) ? "N" : "Y" %>" />
									<button class="dropdown-item" type="button" id="btnScoringComplete"><%:Model.ExamDetail.EstimationGubun.Equals("EXET003") ? "평가완료 해제" : "평가완료 처리" %></button>
								</li>
								<li>
									<input type="hidden" id="hdnChgEstimationOpenYn" name="hdnChgEstimationOpenYn" value="<%:(Model.ExamDetail.EstimationGubun.Equals("EXET005")) ? "N" : "Y" %>" />
									<button class="dropdown-item" type="button" id="btnEstimationOpen"><%:Model.ExamDetail.EstimationGubun.Equals("EXET005") ? "평가비공개 처리" : "평가공개 처리" %></button>
								</li>
								<li><button class="dropdown-item text-danger" type="button" id="btnScoring">자동채점하기</button></li>
								<li><button class="dropdown-item" type="button" id="btnExcel" onclick="fnExcelDownload()">엑셀 다운로드</button></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table table-hover" id="personalTable">
						<caption>개인별 평가 현황 리스트</caption>
						<thead>
							<tr>
								<th scope="row"><input type="checkbox" class="checkbox" id="AllCheck" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
								<th scope="row" class="d-none d-md-block">번호</th>
								<th scope="row">성명/<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
								<th scope="row" class="d-none <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-md-table-cell" : "" %>">학적</th>
								<th scope="row" class="d-none d-md-table-cell">응시일자</th>
								<th scope="row">제출일자</th>
								<th scope="row" class="text-nowrap d-none d-lg-table-cell">경과 시간</th>
								<th scope="row" class="text-nowrap d-none d-lg-table-cell">상태</th>
								<th scope="row" class="text-nowrap">재응시</th>
								<th scope="row" class="text-nowrap">평가</th>
								<th scope="row" class="text-nowrap">오프등록</th>
								<th scope="row" class="text-nowrap <%:Model.ExamDetail.IsGrading.Equals(1) ? "d-none d-md-table-cell" : "d-none" %>">총점</th>
							</tr>
						</thead>
						<tbody>
							<%
								int i = 0;
								foreach (var item in Model.ExamineeList)
								{
									i++;

									string statusCss = "text-danger";
									if (item.ExamStatus == "P") statusCss = "text-point";
									else if (item.ExamStatus == "Y" || item.ExamStatus == "F") statusCss = "text-secondary";

									string staring = (item.TakeDateTimeFormat == null || item.TakeDateTimeFormat == "") ? "N" : "Y";
							%>
							<tr class="data NView">
								<th scope="row">
									<input type="checkbox" name="chkSel" id="chkSel" value="<%:item.UserNo %>" class="checkbox">
									<input type="hidden" value="<%:item.UserNo %>">
									<input type="hidden" value="<%:item.HangulName %>(<%:item.UserID %>)">
									<input type="hidden" value="<%:item.UserID %>">
								</th>
								<td class="d-none d-md-block"><%:i %></td>
								<td>
									<span class="text-nowrap text-dark d-block"><%:item.HangulName %></span>
									<span class="text-nowrap text-secondary font-size-15"><%:item.UserID %></span>
								</td>
								<td class="d-none <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-md-table-cell" : "" %>"><%:(item.HakjeokGubunName ?? "") %></td>
								<td class="d-none d-md-table-cell">
									<span class="text-nowrap text-dark d-block"><%:staring.Equals("N") ? "-" : item.TakeDateTimeFormat %></span>
									<span class="text-nowrap text-secondary font-size-15 <%:staring.Equals("N") ? "d-none" : "" %>"><%:staring.Equals("N") ? "" : item.TakeTime %></span>
								</td>
								<td>
									<%
										if (item.ExamStatus.Equals("P"))
										{
									%>
									<button type="button" id="btnDeadline<%:item.ExamineeNo %>" class="btn btn-sm btn-outline-primary" onclick="fnDeadline(<%:item.ExamineeNo %>)">마감처리</button>
									<%
										}
										else
										{
									%>
									<span class="text-nowrap text-dark d-block"><%:(item.LastDateTimeFormat == null || item.LastDateTimeFormat == "") ? "-" : item.LastDateTimeFormat %></span>
									<span class="text-nowrap text-secondary font-size-15 <%:(item.LastDateTimeFormat == null || item.LastDateTimeFormat == "") ? "d-none" : "" %>"><%:(item.LastDateTimeFormat == null || item.LastDateTimeFormat == "") ? "" : item.LastTime %></span>
									<%
										}
									%>
								</td>
								<td class="d-none d-lg-table-cell"><%:staring.Equals("N") ? "-" : item.RemainTime + "분 " + item.RemainSecond + "초" %></td>
								<td class="d-none d-lg-table-cell"><span class="<%:statusCss %>"><%:item.ExamStatusNm %></span></td>
								<td><button type="button" id="btnRetest<%:item.ExamineeNo %>" class="font-size-20 text-danger <%:staring.Equals("N") ? "d-none" : "" %>" onclick="fnRetest(<%:item.ExamineeNo %>, <%:item.UserNo %>)"><i class="bi bi-bootstrap-reboot"></i></button></td>
								<td><a class="btn btn-sm <%:item.ExamStatus.Equals("Y") ? "" : "d-none" %> <%:item.IsEstiamtionYesNo.Equals("Y") ? "btn-outline-warning" : "btn-primary" %>" href="/<%:GubunCd %>/EstimationWrite/<%:Model.CourseNo %>/<%:Model.ExamNo %>/<%:item.ExamineeNo %>"><%:item.IsEstiamtionYesNo.Equals("Y") ? "수정" : "평가" %></a></td>
								<td>
									<button type="button" id="btnOffSet<%:item.UserNo %>" class="btn btn-sm btn-outline-primary <%:(item.ExamStatus.Equals("N") || item.ExamStatus.Equals("F")) ? "" : "d-none" %>" onclick="fnOpenPopup('/<%:GubunCd %>/EstimationOffline/<%:Model.CourseNo %>/<%:Model.ExamNo %>/<%:item.ExamineeNo %>' , 'EstimationOffline', 900, 700, 0, 0, 'auto')" title="새창열림">오프등록</button>
								</td>
								<td class="text-right <%:Model.ExamDetail.IsGrading.Equals(1) ? "d-none d-md-table-cell" : "d-none" %>"><%:(item.IsEstiamtionYesNo.Equals("Y")) ? decimal.Parse(item.ExamTotalScore.ToString()).ToString("G29") : "" %></td>
							</tr>
							<%
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
			
		<div class="alert bg-light alert-light rounded text-center mt-2 <%:(Model.ExamineeList.Count > 0) ? "d-none" : "" %>" id="emptyDiv"><i class="bi bi-info-circle-fill"></i> 응시 대상이 없습니다.</div>
	</div>
</div>
<div class="row">
	<div class="col-6">
	</div>
	<div class="col-6">
		<div class="text-right">
			<a href="/<%:GubunCd%>/ListTeacher/<%:Model.CourseNo %>" class="btn btn-secondary">목록</a>
		</div>
	</div>
</div>

<div class="modal fade show" id="exampleModalLg" tabindex="-1" aria-labelledby="exampleModalLgLabel" aria-modal="true" role="dialog">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title h4" id="exampleModalLgLabel">일괄평가</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 선택된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>에게 모두 동일한 점수가 부여됩니다.</p>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-12">
								<div class="form-row">
									<div class="form-group col-8">
										<label for="Exam_Week" class="form-label">평가점수 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<input type="text" class="form-control text-right" />
											<div class="input-group-append">
												<div class="input-group-text">점/2점</div>
											</div>
										</div>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-12">
										<label for="Exam_Week" class="form-label">코멘트 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<textarea class="form-control" rows="5"></textarea>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12 text-right">
						<input type="button" class="btn btn-primary" value="저장" />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<form id="excelForm" method="post" action="/<%:GubunCd%>/ExamineeExcel/<%:Model.CourseNo %>/<%:Model.ExamNo %>">
	<input type="hidden" name="hdnExamStatus" id="hdnExamStatus" />
	<input type="hidden" name="hdnSearchGubun" id="hdnSearchGubun" />
	<input type="hidden" name="hdnSearchText" id="hdnSearchText" />
	<input type="hidden" name="hdnSearchSortGubun" id="hdnSearchSortGubun" />
	<input type="hidden" name="hdnadminYn" id="hdnadminYn" value="N" />
</form>

<script>
	// ajax 객체 생성
	var ajaxHelper;

	$(document).ready(function () {
		ajaxHelper = new AjaxHelper();

		$("#AllCheck").click(function () {
            fnSetCheckBoxAll(this, "chkSel");
		});

		$("#btnSort").click(function () {
			var sortGubun = "";
			var sortGubunTxt = "";

			sortGubun = ($("#hdnSortGubun").val().trim() == "ID") ? "NAME" : "ID";
			sortGubunTxt = ($("#hdnSortGubun").val().trim() == "ID") ? "<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순" : "성명순";

			$("#hdnSortGubun").val(sortGubun);
			$("#btnSort").text("");
			$("#btnSort").text(sortGubunTxt);

			fnSearch();
		});

		$("#btnStatus").click(function () {
			var msgGbn = ($("#hdnChgState").val() == "0") ? "종료" : "시작";
			bootConfirm("응시를 " + msgGbn + "하시겠습니까?", fnChgState, null);
		});

		$("#btnOpen").click(function () {
			var msgGbn = ($("#hdnChgOpenYn").val() == "Y") ? "수강생이 응시가능하도록 공개" : "수강생이 응시불가능하도록 비공개";
			bootConfirm(msgGbn + " 처리 하시겠습니까?", fnChgOpen, null);
		});

		$("#btnScoring").click(function () {
			bootConfirm("자동 채점을 진행하시겠습니까? \n서술형은 지원하지 않으니 사용에 유의하시기 바랍니다.", fnScoring, null);
		});

		$("#btnScoringComplete").click(function () {
			var msgGbn = ($("#hdnChgScoringCompleteYn").val() == "Y") ? "평가완료 처리" : "평가완료 해제";
			bootConfirm(msgGbn + " 하시겠습니까?", fnScoringComplete, null);
		});

		$("#btnEstimationOpen").click(function () {
			var msgGbn = ($("#hdnChgEstimationOpenYn").val() == "Y") ? "평가공개 처리" : "평가비공개 해제";
			bootConfirm(msgGbn + " 하시겠습니까?", fnOpenComplete, null);
		});
	})

	// 검색
	function fnSearch() {
		var examStatus = $("#ddlExamStatus").val();
		var searchGubun = $("#ddlSearchGubun").val();
		var searchText = $("#txtSearchText").val();
		var sortGubun = $("#hdnSortGubun").val().trim();

		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/ExamineeSearch", { courseno: <%:Model.CourseNo %>, examno: <%:Model.ExamNo %>, examstatus: examStatus, searchgubun: searchGubun, searchtext: searchText, sortgubun: sortGubun }, "fnSetList", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	// 시작, 종료 처리
	function fnChgState() {
		var examStatus = $("#hdnChgState").val();
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateStatus", { examno: <%:Model.ExamNo %>, examstatus: examStatus }, "fnChgStateResult", examStatus, "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnChgStateResult(examStatus) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			var msgGbn = (examStatus == "0") ? "종료" : "시작";
			var chgStatus = (examStatus == "0") ? "1" : "0";
			var chgBtnText = (examStatus == "0") ? "시작하기" : "종료하기";

			bootAlert("응시가 " + msgGbn + "되었습니다.", function () {
				$("#hdnChgState").val(chgStatus);
				$("#btnStatus").text("");
				$("#btnStatus").text(chgBtnText);

				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 공개, 비공개 처리
	function fnChgOpen() {
		var openYesNo = $("#hdnChgOpenYn").val();
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateOpen", { examno: <%:Model.ExamNo %>, openyesno: openYesNo }, "fnChgOpenResult", "'" + openYesNo + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnChgOpenResult(openYesNo) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			var msgGbn = (openYesNo == "Y") ? "수강생이 응시가능하도록 공개" : "수강생이 응시불가능하도록 비공개";
			var chgOpen = (openYesNo == "Y") ? "N" : "Y";
			var chgOpenText = (openYesNo == "Y") ? "공개" : "비공개";
			var chgBtnText = (openYesNo == "Y") ? "비공개 처리" : "공개 처리";

			bootAlert(msgGbn + " 처리 되었습니다.", function () {
				$("#hdnChgOpenYn").val(chgOpen);
				$("#btnOpen").text("");
				$("#btnOpen").text(chgBtnText);
				$("#liOpenYn").text("");
				$("#liOpenYn").text(chgOpenText);

				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 자동채점
	function fnScoring() {
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateAutoScoring", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo %> }, "fnScoringResult", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnScoringResult() {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			bootAlert("처리 되었습니다. \n반드시 가이드 내용을 확인하시기 바랍니다.", function () {
				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 평가완료 처리
	function fnScoringComplete() {
		var scoringCompleteYn = $("#hdnChgScoringCompleteYn").val();
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateQuestionnaireStatus", { btnGubun: 'C', examno: <%:Model.ExamNo %>, statusgubun: scoringCompleteYn }, "fnScoringCompleteResult", "'" + scoringCompleteYn + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnScoringCompleteResult(scoringCompleteYn) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			var msgGbn = (scoringCompleteYn == "N") ? "평가완료 해제" : "평가완료 처리";
			var chgStatus = (scoringCompleteYn == "N") ? "Y" : "N";
			var chgStatusText = (scoringCompleteYn == "Y") ? "평가완료" : "<%:(Model.ExamDetail.EndDay < DateTime.Now) ? "평가하기" : "출제완료"%>";
			var chgBtnText = (scoringCompleteYn == "N") ? "평가완료 처리" : "평가완료 해제";

			bootAlert(msgGbn + " 되었습니다.", function () {
				$("#hdnChgScoringCompleteYn").val(chgStatus);
				$("#btnScoringComplete").text("");
				$("#btnScoringComplete").text(chgBtnText);
				$("#statusGubun").text("");
				$("#statusGubun").text(chgStatusText);

				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 평가공개 / 비공개 처리
	function fnOpenComplete() {
		var estimationOpenYn = $("#hdnChgEstimationOpenYn").val();
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateQuestionnaireStatus", { btnGubun: 'O', examno: <%:Model.ExamNo %>, statusgubun: estimationOpenYn }, "fnOpenCompleteResult", "'" + estimationOpenYn + "'", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnOpenCompleteResult(estimationOpenYn) {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			var msgGbn = (estimationOpenYn == "N") ? "평가비공개 처리" : "평가공개 처리";
			var chgStatus = (estimationOpenYn == "N") ? "Y" : "N";
			var chgStatusText = (estimationOpenYn == "N") ? "<%:(Model.ExamDetail.EndDay < DateTime.Now) ? "평가하기" : "출제완료"%>" : "평가공개";
			var chgBtnText = (estimationOpenYn == "N") ? "평가공개 처리" : "평가비공개 처리";

			bootAlert(msgGbn + " 되었습니다.", function () {
				if (estimationOpenYn == "N") $("#btnScoringComplete").removeClass("d-none");
				else $("#btnScoringComplete").addClass("d-none");
					
				$("#hdnChgEstimationOpenYn").val(chgStatus);
				$("#btnEstimationOpen").text("");
				$("#btnEstimationOpen").text(chgBtnText);
				$("#statusGubun").text("");
				$("#statusGubun").text(chgStatusText);

				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 마감처리(1 : 이어보기 - 사용x / 2 : 마감처리)
	function fnDeadline(examineeNo) {
		bootConfirm("해당 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 마감처리 하시겠습니까?", fnDeadlineCall, examineeNo);
	}

	function fnDeadlineCall(examineeNo) {
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateAttendanceCheck", { courseNo: <%:Model.CourseNo %>, examno: <%:Model.ExamNo %>, examineeno: examineeNo, retestGubun: 2 }, "fnDeadlineResult", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnDeadlineResult() {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			bootAlert("해당 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>은 마감처리 되었습니다.", function () {
				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	// 재응시
	function fnRetest(examineeNo, userNo) {
		var params = [];
		params.push({ "examineeno": examineeNo, "userno": userNo });

		bootConfirm("해당 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 재응시 시키겠습니까?", fnRetestCall, params);
	}

	function fnRetestCall(params) {
		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/UpdateExamReset", { courseno: <%:Model.CourseNo%>, examno: <%:Model.ExamNo %>, examineeno: params[0].examineeno, userno: params[0].userno, adminyn: "Y" }, "fnRetestResult", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
	}

	function fnRetestResult() {
		var result = ajaxHelper.CallAjaxResult();
			
		if (result > 0) {
			bootAlert("해당 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>은 재응시가 가능합니다.", function () {
				fnSearch();
			});
		} else {
			bootAlert("실행 중 오류가 발생하였습니다.");
		}
	}

	function fnSetList() {
		var result = ajaxHelper.CallAjaxResult();
		var htmlStr = "";

		$("#examineeCnt").html("");
		$("#examineeCnt").html("(" + result.length + "건)");

		if (result != null && result.length > 0) {
			// 초기화
			$("#personalTable > tbody").empty();
			$("#examineeList").removeClass("d-none");
			$("#emptyDiv").addClass("d-none");
				
			for (var i = 0; i < result.length; i++) {
				var staring = (result[i].TakeDateTimeFormat == null || result[i].TakeDateTimeFormat == "") ? "N" : "Y";
				var staringLast = (result[i].LastDateTimeFormat == null || result[i].LastDateTimeFormat == "") ? "N" : "Y";

				var statusCss = "text-danger";
				if (result[i].ExamStatus == "P") statusCss = "text-point";
				else if (result[i].ExamStatus == "Y" || result[i].ExamStatus == "F") statusCss = "text-secondary";

				htmlStr += "<tr class='data NView'>";
				htmlStr += "<th scope='row'><input type='checkbox' name='chkSel' id='chkSel' value='" + result[i].UserNo + "' class='checkbox'></th>";
				htmlStr += "<td class='d-none d-md-block'>" + (i+1) + "</td>";
				htmlStr += "<td>";
				htmlStr += "<span class='text-nowrap text-dark d-block'>" + result[i].HangulName + "</span>";
				htmlStr += "<span class='text-nowrap text-secondary font-size-15'>" + result[i].UserID + "</span>";
				htmlStr += "</td>";
				htmlStr += "<td class='d-none <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-md-table-cell" : "" %>'>" + result[i].HakjeokGubunName + "</td>";
				htmlStr += "<td class='d-none d-md-table-cell'>";
				htmlStr += "<span class='text-nowrap text-dark d-block'>" + (staring == "N" ? "-" : result[i].TakeDateTimeFormat) + "</span>";
				htmlStr += "<span class='text-nowrap text-secondary font-size-15 " + (staring == "N" ? "d-none" : "") + "'>" + result[i].TakeTime + "</span>";
				htmlStr += "</td>";					
				htmlStr += "<td>";
				if (result[i].ExamStatus == "P") {
					htmlStr += "<button type='button' id='btnDeadline" + result[i].UserNo + "' class='btn btn-sm btn-outline-primary' onclick='fnDeadline(" + result[i].UserNo + ")'>마감처리</button>";
				} else {
					htmlStr += "<span class='text-nowrap text-dark d-block'>" + (staringLast == "N" ? "-" : result[i].LastDateTimeFormat) + "</span>";
					htmlStr += "<span class='text-nowrap text-secondary font-size-15 " + (staringLast == "N" ? "d-none" : "") + "'>" + result[i].LastTime + "</span>";
				}
					
				htmlStr += "</td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>" + (staring == "N" ? "-" : result[i].RemainTime + "분 " + result[i].RemainSecond + "초") + "</td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>";
				htmlStr += "<span class='" + statusCss + "'>" + result[i].ExamStatusNm + "</span>";
				htmlStr += "</td>";
				htmlStr += "<td><button type='button' id='btnRetest" + result[i].UserNo + "' class='font-size-20 text-danger " + (staring == "N" ? "d-none" : "") + "' onclick='fnRetest(" + result[i].UserNo + "'><i class='bi bi-bootstrap-reboot'></i></button></td>";
				htmlStr += "<td><a class='btn btn-sm " + (result[i].ExamStatus == "Y" ? "" : "d-none ") + (result[i].IsEstiamtionYesNo == "Y" ? "btn-outline-warning" : "btn-primary") + "' href='/<%:GubunCd %>/EstimationWrite/<%:Model.CourseNo %>/<%:Model.ExamNo %>/" + result[i].ExamineeNo + "'>" + (result[i].IsEstiamtionYesNo == "Y" ? "수정" : "평가") + "</a></td>";
				htmlStr += "<td>";
				htmlStr += "<button type='button' id='btnOffSet" + result[i].UserNo + "' class='btn btn-sm btn-outline-primary " + ((result[i].ExamStatus == "N" || result[i].ExamStatus == "F") ? "" : "d-none") + "' onclick=\"fnOpenPopup('/<%:GubunCd %>/EstimationOffline/<%:Model.CourseNo %>/<%:Model.ExamNo %>/" + result[i].ExamineeNo + "', 'EstimationOffline', 900, 700, 0, 0, 'auto')\" title='새창열림'>오프등록</button>";
				htmlStr += "</td>";
				htmlStr += "<td class='text-right <%:Model.ExamDetail.IsGrading.Equals(1) ? "d-none d-md-table-cell" : "d-none" %>'>" + ((result[i].IsEstiamtionYesNo == "Y") ? parseFloat((result[i].ExamTotalScore).toFixed(3)).toString() : "") + "</td>";
				htmlStr += "</tr>";
			} 

			$("#personalTable > tbody").html(htmlStr);
		} else {
			$("#examineeList").addClass("d-none");
			$("#emptyDiv").removeClass("d-none");
		}
	}

	function fnExcelDownload() {
		var form = $("#excelForm");

		$("#hdnExamStatus").val($("#ddlExamStatus").val());
		$("#hdnSearchGubun").val($("#ddlSearchGubun").val());
		$("#hdnSearchText").val($("#txtSearchText").val());
		$("#hdnSearchSortGubun").val($("#hdnSortGubun").val().trim());

		form.serialize();
		form.submit();
	}
</script>