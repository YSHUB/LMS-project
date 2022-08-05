<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<form action="/Course/CoursePlan" method="post" id="mainForm">
		<div id="content">

			<!-- 기본정보 -->
			<%
				if (Model.Course.CreditAcceptGubun.Equals("CHGB002")) 
				{
			%>
					<h3 class="title04">기본정보</h3>
					<div class="card d-md-block">
						<div class="card-body">
							<div class="form-row">
								<div class="form-group col-12">
									<label for="txtIntroduce" class="form-label">과정소개<strong class="text-danger">*</strong></label>
									<textarea id="txtIntroduce" class="form-control" name="Course.Introduce" rows="2" disabled="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "disabled" : "" %>"><%:Model.Course != null ? (Model.Course.Introduce ?? "").Replace("<br/>", "\r\n") : "" %></textarea>
								</div>
								<div class="form-group col-12 col-md-6">
									<label for="txtRStart" class="form-label">신청기간 <strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="Course.RStart" id="txtRStart" type="text" placeholder="YYYY-MM-DD" autocomplete="off" 
												disabled="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "disabled" : "" %>" >
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
										<div class="input-group-append input-group-prepend">
											<span class="input-group-text">~</span>
										</div>
										<input class="form-control datepicker text-center" name="Course.REnd" id="txtREnd" type="text" placeholder="YYYY-MM-DD" autocomplete="off"
											   disabled="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "disabled" : "" %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-12 col-md-6">
									<label for="txtLStart" class="form-label">강의기간<strong class="text-danger">*</strong></label>
									<div class="input-group">
										<input class="form-control datepicker text-center" name="Course.LStart" id="txtLStart" type="text" placeholder="YYYY-MM-DD" autocomplete="off"
											   disabled="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "disabled" : "" %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
										<div class="input-group-append input-group-prepend">
											<span class="input-group-text">~</span>
										</div>
										<input class="form-control datepicker text-center" name="Course.LEnd" id="txtLEnd" type="text" placeholder="YYYY-MM-DD" autocomplete="off" 
											   disabled="<%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "disabled" : "" %>">
										<div class="input-group-append">
											<span class="input-group-text">
												<i class="bi bi-calendar4-event"></i>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group col-4 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
									<label for="divCategory" class="form-label">카테고리설정<strong class="text-danger">*</strong></label>
									<div>
										<button class="btn btn-sm btn-outline-info" type="button" data-toggle="modal" data-target="#divCategoryList" title="추가" >추가</button>
										<div id="divCategory">
											<%
												if (!string.IsNullOrEmpty(Model.Course.Mnos)) 
												{
													foreach (var item in Model.CategoryList.Where(w=> ("," + Model.Course.Mnos + ",").Contains("," + w.MNo + ",")).ToList()) 
													{
											%>
														<span class="text-nowrap text-secondary" id="spanMnos">
															<%:item.MName %>
															<button type="button" class="text-danger" title="삭제" onclick="fnCategoryDelete(<%:item.MNo %>)"><i class="bi bi-trash"></i></button>
														</span>
											<%
													}
												}
											%>
										</div>										
									</div>
								</div>
							</div>
						</div>
						<div class="card-footer <%:ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<div class="row align-items-center">
								<div class="col-md">
									<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
								</div>
								<div class="col-md-auto text-right">
									<button type="button" class="btn btn-primary" id="btnMoocSave">기본정보 저장</button>
								</div>
							</div>
						</div>
					</div>


			<%
				}
			%>
			<!-- 기본정보 -->
			
			<!-- 주차별 강의계획 -->
			<div class="row">
				<div class="col-12 mt-2">
					<div class="row">
						<h3 class="title04 ml-3"><%:ConfigurationManager.AppSettings["CourseText"].ToString() %></h3>
						<div class="col-md">
						</div>
						<div class="col-auto text-right mt-2">
							<button type="button" class="btn btn-primary" onclick="fnInningSave(0);" title="차시추가">차시추가</button>
							<button type="button" class="btn btn-primary  <%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : "" %>" onclick="fnCourseCopy();" title="강의계획복사" data-toggle="modal" data-target="#divCourseCopy">강의계획복사</button>
						</div>		
					</div>
					<%
						if (Model.Inning.Count.Equals(0))
						{
					%>
							<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 학습이 없습니다.</div>
					<%
						}
						else 
						{
					%>
							
							<div class="card">
								<div class="card-body py-0">
									<div class="table-responsive">
										<table class="table table-hover table-sm table-horizontal" summary="주차 목록">
											<thead>
												<tr>
													<th scope="col">주차</th>
													<th scope="col">차시</th>
													<th scope="col" class="d-none d-md-table-cell">수업방식</th>
													<th scope="col">강의주제</th>
													<th scope="col" class="d-none d-lg-table-cell">기간</th>
													<th scope="col" class="d-none d-md-table-cell">인정시간</th>
													<th scope="col">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													var week = 0;
													foreach (var item in Model.Inning)
													{
												%>
														<tr>
															<%
																if (week != item.Week) 
																{
																	week = item.Week;
															%>
																	<td rowspan="<%:Model.Inning.Where(w => w.Week == item.Week).Count() %>"><%:item.Week %> 주차</td>
															<%
																}
															%>
															<td class=<%:item.IsPreview.Equals("Y") ? "text-danger" : "" %>><%:item.InningSeqNo %> 차시</td>
															<td class="d-none text-center d-md-table-cell"><%:item.LessonFormName %></td>
															<td class="text-left"><%:Html.Raw(item.Title) %></td>
															<td class="d-none text-center d-md-table-cell"><%:item.InningStartDay %> ~ <%:item.InningEndDay %></td>
															<td class="d-none text-center d-md-table-cell"><%:item.LectureType.Equals("CINN001") && !item.LMSContentsNo.Equals(0) ? item.AttendanceAcceptTime + "분" : "-" %></td>
															<td class="text-center">
																<button type="button" class="font-size-20 text-primary" onclick="fnInningSave(<%:item.InningNo %>);" title="상세보기"><i class="bi bi-card-list"></i></button>
																<button type="button" class="font-size-20 text-danger" onclick="fnDelete(<%:item.InningNo %>);" title="삭제"><i class="bi bi-trash"></i></button>
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
					<div class="row">					
						<div class="col-md">
							<%
								if (!Model.Inning.Count.Equals(0)) 
								{
							%>
									<small class="text-secondary text-left">※ 차시명이 <span class="text-danger">빨간색</span>일 경우 맛보기 차시입니다. </small>
							<%
								}
							%>
						</div>
						<div class="col-auto text-right">
							<button type="button" class="btn btn-primary" onclick="fnInningSave(0);" title="차시추가">차시추가</button>
							<button type="button" class="btn btn-primary <%: Model.Course.ProgramNo.ToString() == "2" ? "d-none" : "" %>" onclick="fnCourseCopy();" title="강의계획복사" data-toggle="modal" data-target="#divCourseCopy">강의계획복사</button>
						</div>		
					</div>
				</div>
			</div>
			<!-- 주차별 강의계획 -->
		</div>

		<!-- 카테고리 추가 모달 -->
		<div class="modal fade show" id="divCategoryList" tabindex="-1" aria-labelledby="category" aria-modal="true" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4">카테고리 추가</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-12">
								<div class="card">
									<div class="card-body py-0">
										<div class="table-responsive overflow-auto" style="max-height: 400px">
											<table class="table" id="tblTeamNotMemberList">
												<caption>카테고리 리스트</caption>
												<thead>
													<tr>
														<th scope="row">OCW</th>
														<th scope="row">관리</th>
													</tr>
												</thead>
												<tbody>
													<%
														if (Model.CategoryList.Count.Equals(0))
														{
													%>
															<tr>
																<td colspan="2" class="text-center">등록된 카테고리가 없습니다.</td>
															</tr>
													<%
														}
														else 
														{
															foreach (var item in Model.CategoryList) 
															{
													%>
																<tr>
																	<td>
																		<span class="text-nowrap text-secondary font-size-15"><%:item.MName %></span>
																	</td>
																	<td>
																		<button type="button" title="추가" class="btn btn-outline-primary" onclick="fnCategoryComplete(<%:item.MNo %>, '<%:item.MName %>')">선택</button>
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
									<div class="card-footer">
										<div class="row align-items-center">
											<div class="col-md-12 text-right">
												<button type="button" class="btn btn-outline-secondary" data-dismiss="modal" title="닫기">닫기</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 카테고리 추가 모달 -->

		<!-- 강의계획복사 모달 -->
		<div class="modal fade show" id="divCourseCopy" tabindex="-1" aria-labelledby="courseCopy" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="courseCopy">복사할 강좌 선택</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="alert alert-light bg-light">
							<div class="font-size-14">
								* 같은 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>에 등록된 같은 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>의 다른 분반만 아래에 표시됩니다.
							</div>
							<div class="font-size-14">
								* 현재분반에 강의가 등록되지 않은 경우만 복사 가능합니다.
							</div>
							<div class="font-size-14">
								* 복사 시 복사하는 대상 주차의 정보로 완전히 덮어씁니다.
							</div>
						</div>
						<div class="card">
							<div class="card-body p-0">
								<div class="table-responsive overflow-auto" style="max-height: 400px" id="divCourseCopyList">
									<table class="table table-hover" summary="복사할강좌리스트">
										<caption>courseCopyList</caption>
										<thead>
											<tr>
												<th scope="col">분반</th>
												<th scope="col">주차</th>
												<th scope="col">대상분반 차시수</th>
												<th scope="col">대상분반 강의 등록된 차시 수</th>
												<th scope="col">현재분반 강의 등록된 차시 수</th>
												<th scope="col">복사</th>
											</tr>
										</thead>
										<tbody id="tbodyCourseCopyList">
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer" id="divCopyAll">
					</div>
				</div>
			</div>
		</div>
		<!-- 강의계획복사 모달 -->

		<input type="hidden" id="hdnCourseNo" name="Course.CourseNo" value="<%:Model.Course.CourseNo %>"/>
		<input type="hidden" id="hdnMnos" name="Course.Mnos" value="<%:Model.Course.Mnos %>"/>
		<input type="hidden" id="hdnInningNo" value=""/>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {

			fnFromToCalendar("txtLStart", "txtLEnd", $("#txtLStart").val());
			fnFromToCalendar("txtRStart", "txtREnd", $("#txtRStart").val());

			$("#txtLStart").val("<%: Model.Course != null ? Model.Course.LStart : ""%>");
			$("#txtLEnd").val("<%: Model.Course != null ? Model.Course.LEnd : ""%>");
			$("#txtRStart").val("<%: Model.Course != null ? Model.Course.RStart : ""%>");
			$("#txtREnd").val("<%: Model.Course != null ? Model.Course.REnd : ""%>");
		})

		<%-- 카테고리 추가 --%>
		function fnCategoryComplete(mno, mname) {

			if (("," + $("#hdnMnos").val() + ",").indexOf("," + mno + ",") < 0) {
				$("#hdnMnos").val($("#hdnMnos").val() == "" ? mno : ($("#hdnMnos").val() + "," + mno));
				$("#divCategory").append('<span class="text-nowrap text-secondary" id="spanMnos">' + mname + '<button type="button" class="text-danger" title="삭제" onclick="fnCategoryDelete(' + mno + ')"><i class="bi bi-trash"></i></button></span>');
				fnSaveAlert();

			} else {
				bootAlert("이미 등록된 카테고리입니다.");
			}
		}

		<%-- 카테고리 삭제 --%>
		function fnCategoryDelete(mno) {

			var i = 0;
			var v = "";
			var Mnos = $("#hdnMnos").val().split(',');

			for (var j = 0; j < Mnos.length; j++) {
				if (Mnos[j] != mno) {
					v += "," + Mnos[j];
				} else {
					i = j;
				}
			}

			$("#hdnMnos").val(v == "" ? "" : v.substr(1));
			$("#divCategory span").eq(i).remove();
			fnSaveAlert();
		}

		function fnSaveAlert() {
			bootAlert("저장해야 반영됩니다.");
		}

		<%-- MOOC 기본정보 저장 --%>
		$("#btnMoocSave").click(function () {

			if ($("#txtIntroduce").val() == "") {
				bootAlert("과정소개를 입력하세요.", function () {

					$("#txtIntroduce").focus();
				});
				return false;
			}

			if ($("#spanMnos").text() == "") {
				bootAlert("카테고리를 설정하세요.");
				return false;
			}

			if ($("#txtRStart").val() == "" || $("#txtREnd").val() == "") {
				bootAlert("신청기간을 입력하세요.", function () {

					if ($("#txtRStart").val() == "" && $("#txtREnd").val() == "") {
						$("#txtRStart").focus();
					} else if ($("#txtRStart").val() == "") {
						$("#txtRStart").focus();
					} else if ($("#txtREnd").val() == "") {
						$("#txtREnd").focus();
					}
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtRStart").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtREnd").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if ($("#txtLStart").val() == "" || $("#txtLEnd").val() == "") {
				bootAlert("강의기간을 입력하세요.", function () {

					if ($("#txtLStart").val() == "" && $("#txtLEnd").val() == "") {
						$("#txtLStart").focus();
					} else if ($("#txtLStart").val() == "") {
						$("#txtLStart").focus();
					} else if ($("#txtLEnd").val() == "") {
						$("#txtLEnd").focus();
					}
				});
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtLStart").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			if (!/^\d{4}-\d{2}-\d{2}$/u.test($("#txtLEnd").val())) {
				bootAlert("날짜 형식을 확인해주세요.");
				return false;
			}

			bootConfirm("저장하시겠습니까?", function () {

				ajaxHelper.CallAjaxPost("/LecInfo/MoocSave", $("#mainForm").serialize(), "fnCompleteMoocSave");
			});

			fnPrevent();
		})

		function fnCompleteMoocSave() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert("저장되었습니다.", function () {

					location.reload();
				});

			} else {

				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 차시 삭제 --%>
		function fnDelete(inningNo) {

			$("#hdnInningNo").val(inningNo);
			ajaxHelper.CallAjaxPost("/Course/StudyLogChk", { inningNo: inningNo }, "fnCompleteDelete");
		}

		function fnCompleteDelete() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("이미 수강데이터가 생성되어 차시를 삭제할 수 없습니다.");
			}
			else {

				bootConfirm("삭제하시겠습니까?", fnInningDelete);
			}
		}

		function fnInningDelete() {

			ajaxHelper.CallAjaxPost("/Course/InningDeleteAjax", { inningNo: $("#hdnInningNo").val() }, "fnCompleteInningDeleteAjax");
		}

		function fnCompleteInningDeleteAjax() {

			var result = ajaxHelper.CallAjaxResult();
			if (result > 0) {
				bootAlert("차시를 삭제했습니다.", function () {
					window.location.reload();
				});
			} else {

				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 차시 관리 팝업 --%>
		function fnInningSave(inningNo) {
			$("#hdnInningNo").val(inningNo);

			if (inningNo == 0) {

				ajaxHelper.CallAjaxPost("/Course/StudyLogChk", { inningNo: inningNo }, "fnCompleteLectureCountChk", inningNo);
			} else {

				fnOpenPopup("/Course/WriteWeekAdmin/" + <%:Model.Course.CourseNo %> + "/" + inningNo, "WriteWeekAdmin", 1000, 800, 0, 0, "auto");
			}
		}

		function fnCompleteLectureCountChk(inningNo) {
			
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert("이미 수강데이터가 생성되어 차시를 추가할 수 없습니다.");
			} else {

				fnOpenPopup("/Course/WriteWeekAdmin/" + <%:Model.Course.CourseNo %> + "/" + inningNo, "WriteWeekAdmin", 1000, 800, 0, 0, "auto");
			}
		}

		<%-- 강의계획복사 --%>
		function fnCourseCopy() {

			$("#tbodyCourseCopyList tr.data").remove();
			$("#divCopyAll").html("");

			ajaxHelper.CallAjaxPost("/LecInfo/CourseCopyList", { courseNo: <%:Model.Course.CourseNo %>, subjectNo: <%:Model.Course.SubjectNo %> }, "fnCompleteCourseCopyList");
		}

		function fnCompleteCourseCopyList() {
			var classNo = 0;
			var nowCourseInningCount = 0;
			var result = ajaxHelper.CallAjaxResult();

			var innerHtmlSub = "";
			innerHtmlSub += "<div class='text-right'>";
			innerHtmlSub += "	<span style='vertical-align: middle;'>전체 복사할 분반 : </span>";
			innerHtmlSub += "	<select id='selClassNo' class='form-control d-inline' style='width: auto; vertical-align: middle;'>";
			innerHtmlSub += "		<option value='0'>선택</option>";

			if (result.length > 0) {

				for (var i = 0; i < result.length; i++) {

					var innerHTML = "";
					innerHTML += "<tr class=\"data\">";
					innerHTML += "	<td class=\"text-center\">" + result[i].ClassNo + "</td>";
					innerHTML += "	<td class=\"text-center\">" + result[i].Week + "</td>";
					innerHTML += "	<td class=\"text-center\">" + result[i].CompareCourseInningCount + "</td>";
					innerHTML += "	<td class=\"text-center\">" + result[i].CompareCourseEnroll + "</td>";
					innerHTML += "	<td class=\"text-center\">" + result[i].NowCourseEnroll + "</td>";
					innerHTML += "	<td class=\"alink text-center\">";
					if (result[i].NowCourseEnroll == 0 && result[i].CompareCourseEnroll > 0) {
						innerHTML += "	<button type=\"button\" title=\"선택\" class=\"btn btn-sm btn-outline-primary\" onclick=\"fnCourseCopySave(" + result[i].CourseNo + ", " + result[i].ClassNo + ", " + result[i].Week + ");\">복사</button>";
					}
					innerHTML += "	</td>";
					innerHTML += "</tr>";

					$("#tbodyCourseCopyList").append(innerHTML);

					nowCourseInningCount += result[i].NowCourseEnroll;

					if (classNo != result[i].ClassNo) {
						innerHtmlSub += "		<option value=" + result[i].CourseNo + ">" + result[i].ClassNo + "</option>";
						classNo = result[i].ClassNo;
					}
				}

			innerHtmlSub += "	</select>";
			innerHtmlSub += "	<button type='button' class='btn btn-primary' onclick='fnCourseCopyAll();'>복사</button><br/>";
			innerHtmlSub += "</div>";

			}

			$("#divCopyAll").append(innerHtmlSub);

			if (nowCourseInningCount > 0) {
				$("#divCopyAll").attr("class", "d-none");
			}

			if (classNo == 0) {
				$("#divCopyAll").attr("class", "d-none");

				bootAlert("복사 가능한 강의가 없습니다.", function () {
					$("#divCourseCopy").modal("hide");
				});
			}
		}

		function fnCourseCopySave(courseNo, classNo, week) {

			var strWeek = "";

			if (courseNo == 0) {
				bootAlert("복사할 분반을 선택해주세요.");
				return false;
			}

			if (week == 0) {
				strWeek = "전체";
			} else {
				strWeek = week + "";
			}

			if (courseNo != 0) {
				bootConfirm(classNo + "분반의 " + strWeek + "주차 정보를 복사하시겠습니까?\n복사 시 강의계획, OCW, 강의자료 항목이 복사됩니다.\n단, OCW 또는 강의자료가 1건 이상 등록되어 있는 경우에는 해당 자료는 복사되지 않습니다.", function () {

					ajaxHelper.CallAjaxPost("/LecInfo/CourseCopySave", { courseNo: <%:Model.Course.CourseNo %>, copyCourseNo: courseNo, week: week }, "fnCompleteCourseCopySave");
				});
			}
		}

		function fnCourseCopyAll() {

			fnCourseCopySave($("#selClassNo :selected").val(), $("#selClassNo :selected").text(), 0);
		}

		function fnCompleteCourseCopySave() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("해당 주차의 강의계획이 복사되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}


	</script>
</asp:Content>