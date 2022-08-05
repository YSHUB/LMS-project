<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.ExamViewModel>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<div class="row">
	<input type="hidden" id="hdnChkExamNo" name="hdnChkExamNo" />
	
	<div class="col-12 mt-2">
		<form action="/<%:GubunCd %>/DetailAdmin/<%:Model.CourseNo %>" id="mainForm" method="post">
			<h3 class="title04"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트<strong class="text-primary">(<%:Model.QuizList.Count() %>건)</strong></h3>
			<div class="card">
				<div class="card-header">
					<div class="row justify-content-between">
						<div class="col-auto">
							<input type="button" class="btn btn-sm btn-secondary" value="엑셀 다운로드" onclick="fnExcel()">
						</div>
					</div>

				</div>
				<div class="card-body py-0">
					<div class="table-responsive">
					<table class="table table-hover table-sm table-striped table-horizontal" summary="<%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트">
						<caption><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 리스트</caption>
						<thead>
							<tr>
								<th scope="col" class="text-nowrap">주차</th>
								<th scope="col" class="text-nowrap">차시</th>
								<th scope="col" class="text-nowrap"><%:ConfigurationManager.AppSettings["ExamText"].ToString() %> 제목</th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">응시방법</th>
								<th scope="col" class="text-nowrap">응시기간</th>
								<th scope="col" class="text-nowrap">상태</th>
								<th scope="col" class="text-nowrap">응시인원</th>
								<th scope="col" class="text-nowrap">평가인원</th>
								<th scope="col" class="text-nowrap">관리</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (Model.QuizList.Count < 1)
								{
							%>
								<tr>
									<td colspan="9">등록된 <%:GubunNm %>정보가 없습니다.</td>
								</tr>
							<%
								}
								else
								{
									foreach (var item in Model.QuizList)
									{
							%>
									<tr>
										<td class=""><%:item.Week %>주차</td>
										<td class=""><%:item.InningSeqNo %>차시</td>
										<td class="text-nowrap"><%:item.ExamTitle %></td>
										<td class="d-none d-lg-table-cell"><%:item.LectureTypeNm %></td>
										<td class=""><%:(item.SEType.Equals(0) && item.SE0StateGbn.Equals(-1)) ? "응시대기" : item.StartDayFormat + " ~ " + ((item.SEType.Equals(0) && item.SE0State.Equals(1)) ? "임의종료시점까지" : item.EndDayFormat) %></td>
										<td class=""><%:item.EstimationGubunNm %></td>
										<td class="text-right"><%:item.TakeStudentCount %></td>
										<td class=""><%:item.CheckStudentCount %>/<%:item.TotalStudentCount %></td>
										<td class="">
											<button type="button" class="font-size-20 text-primary" id="btnDetailList" title="상세보기" onclick="fnExamineeList(<%:item.ExamNo %>)"><i class="bi bi-card-list"></i></button>
										</td>
									</tr>
							<%
									}
								}
							%>
						</tbody>
					</table>
				</div>
				</div>
			</div>

		</form>
	</div>

	<div class="col-12 mt-2 d-none" id="DetailList">
		<h3 class="title04"><%:GubunNm %> 대상 리스트<strong class="text-primary" id="examineeCnt">(0건)</strong></h3>
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
		<div class="card card-style01 mt-2" id="examineeList">
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
							<button type="button" class="btn btn-sm btn-secondary" id="btnExcel" onclick="fnExcelDownload()">엑셀 다운로드</button>
						</div>
					</div>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table table-hover table-sm table-horizontal" id="personalTable">
						<caption>개인별 평가 현황 리스트</caption>
						<thead>
							<tr>
								<th scope="col" class="text-nowrap"><input type="checkbox" class="checkbox" id="AllCheck" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">소속</th>
								<th scope="col" class="text-nowrap"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
								<th scope="col" class="text-nowrap">성명</th>
								<th scope="col" class="text-nowrap d-none <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-lg-table-cell" : "" %>">학적</th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">IP</th>
								<th scope="col" class="text-nowrap">상태</th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">응시일시</th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">제출일시</th>
								<th scope="col" class="text-nowrap d-none d-lg-table-cell">경과시간</th>
								<th scope="col" class="text-nowrap">답안보기</th>
								<th scope="col" class="text-nowrap">총점</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="alert bg-light alert-light rounded text-center mt-2 d-none" id="emptyDiv"><i class="bi bi-info-circle-fill"></i> 응시 대상이 없습니다.</div>
	</div>
</div>

<div class="row mt-2">
	<div class="col-12">
		<div class="text-right">
			<a href="/<%:GubunCd%>/ListAdmin/1?ProgramNo=<%: Model.ProgramNo %>&TermNo=<%:Model.TermNo %>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" class="btn btn-secondary">목록</a>
		</div>
	</div>
</div>

<form id="excelForm" method="post">
	<input type="hidden" name="hdnExamStatus" id="hdnExamStatus" />
	<input type="hidden" name="hdnSearchGubun" id="hdnSearchGubun" />
	<input type="hidden" name="hdnSearchText" id="hdnSearchText" />
	<input type="hidden" name="hdnSearchSortGubun" id="hdnSearchSortGubun" />
	<input type="hidden" name="hdnadminYn" id="hdnadminYn" value="Y" />
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
	})

	// 검색
	function fnSearch() {
		var examStatus = $("#ddlExamStatus").val();
		var searchGubun = $("#ddlSearchGubun").val();
		var searchText = $("#txtSearchText").val();
		var sortGubun = $("#hdnSortGubun").val().trim();
		var examNo = $("#hdnChkExamNo").val();

		ajaxHelper.CallAjaxPost("/<%:GubunCd%>/ExamineeSearch", { courseno: <%:Model.CourseNo %>, examno: examNo, examstatus: examStatus, searchgubun: searchGubun, searchtext: searchText, sortgubun: sortGubun }, "fnSetList", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
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
				htmlStr += "<td class=''><input type='checkbox' name='chkSel' id='chkSel' value='" + result[i].UserNo + "' class='checkbox'><input type='hidden' value='" + result[i].UserNo + "'><input type='hidden' value='" + result[i].HangulName + "(" + result[i].UserID + ")'></td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>" + result[i].AssignName + "</td>";
				htmlStr += "<td class=''>" + result[i].UserID + "</td>";
				htmlStr += "<td class='text-nowrap'>" + result[i].HangulName + "</td>";
				htmlStr += "<td class='d-none <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-lg-table-cell" : "" %>'>" + result[i].HakjeokGubunName + "</td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>" + (staring == "N" ? "-" : result[i].ExamUserIpAddr) + "</td>";
				htmlStr += "<td class='" + statusCss + "'>" + result[i].ExamStatusNm + "</td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>";
				htmlStr += "<span class='text-nowrap text-dark d-block'>" + (staring == "N" ? "-" : result[i].TakeDateTimeFormat) + "</span>";
				htmlStr += "<span class='text-nowrap text-secondary " + (staring == "N" ? "d-none" : "") + "'>" + result[i].TakeTime + "</span>";
				htmlStr += "</td>";					
				htmlStr += "<td class='d-none d-lg-table-cell'>";
				htmlStr += "<span class='text-nowrap text-dark d-block'>" + (staringLast == "N" ? "-" : result[i].LastDateTimeFormat) + "</span>";
				htmlStr += "<span class='text-nowrap text-secondary font-size-15 " + (staringLast == "N" ? "d-none" : "") + "'>" + result[i].LastTime + "</span>";
				htmlStr += "</td>";
				htmlStr += "<td class='d-none d-lg-table-cell'>" + (staring == "N" ? "-" : result[i].RemainTime + "분 " + result[i].RemainSecond + "초") + "</td>";

				htmlStr += "<td>";
				htmlStr += "<button type='button' id='btnDetailGrades" + result[i].UserNo + "' class='btn btn-sm btn-outline-primary' onclick=\"fnOpenPopup('/<%:GubunCd %>/AnswerAdmin/<%:Model.CourseNo %>/" + result[i].ExamNo + "/" + result[i].ExamineeNo + "', 'AnswerAdmin', 1200, 800, 0, 0, 'auto')\" title='새창열림'>보기</button>";
				htmlStr += "</td>";

				htmlStr += "<td class=''>" + result[i].TotalScore + "</td>";
				htmlStr += "</tr>";
			}

			$("#personalTable > tbody").html(htmlStr);
		} else {
			$("#examineeList").addClass("d-none");
			$("#emptyDiv").removeClass("d-none");
		}
	}

	function fnExamineeList(getExamNo) {
		$("#hdnChkExamNo").val(getExamNo);
		$("#DetailList").removeClass("d-none");
		fnSearch();
	}

	function fnExcelDownload() {
		var form = $("#excelForm");

		$("#hdnExamStatus").val($("#ddlExamStatus").val());
		$("#hdnSearchGubun").val($("#ddlSearchGubun").val());
		$("#hdnSearchText").val($("#txtSearchText").val());
		$("#hdnSearchSortGubun").val($("#hdnSortGubun").val().trim());

		form.attr("action", "/<%:GubunCd%>/ExamineeExcel/<%:Model.CourseNo %>/" + $("#hdnChkExamNo").val());
		form.serialize();
		form.submit();
	}

	function fnExcel() {

		if (<%:Model.QuizList.Count%> > 0) {
			var param1 = <%:Model.CourseNo %>;
			var param2 = '<%:Model.ExamDetail.Gubun %>';

			window.location = "/<%:GubunCd%>/DetailAdminExcel/" + param1.toString() + "/" + param2;
		}
		else {
			bootAlert("다운로드할 내용이 없습니다.");
		}
	}
</script>