<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	

	<div id="content">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('WriteOutAdmin')" role="tab">기본정보</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link active" href="javascript:void(0);" onclick="fnGoTab('ListWeekOutAdmin')" role="tab">주차 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('EstimationOutWriteAdmin')" role="tab">평가기준 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('OcwOutAdmin')" role="tab">콘텐츠 설정</a>
			</li>
		</ul>
		<div class="row">
			<div class="col-12 mt-2">
				<div class="card card-style02">
					<div class="card-header">
						<div>
							<%if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
								{
							%>
							<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
							<%
								}
								if (ConfigurationManager.AppSettings["UnivYN"].Equals("N")) 
								{
							%>
								<span class="badge badge-1"><%:Model.Course.StudyTypeName %></span>
							<%
								}
							  else
								{
							%>
								<span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
							<%
								}
							%>
						</div>
						<span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
					</div>
					<div class="card-body">
						<dl class="row dl-style02">
							<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></dt>
							<dd class="col-9 col-md-4"><%:Model.Course.AssignName %></dd>
							<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
							<dd class="col-9 col-md-5"><%:Model.Course.TermName %></dd>
						</dl>
					</div>
				</div>
				<div class="row">
					<div class="col-12 mt-2">
						<%
							if (Model.Inning.Count.Equals(0))
							{
						%>
								<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 <%:ConfigurationManager.AppSettings["CourseText"].ToString() %>가 없습니다.</div>
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
														<th scope="col" class="d-none d-lg-table-cell">기간</th>
														<th scope="col" class="d-none d-md-table-cell">인정시간</th>
														<th scope="col" class="d-none d-md-table-cell">수업방식</th>
														<th scope="col">강의주제</th>
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
																<td class="d-none text-center d-md-table-cell"><%:item.InningStartDay %> ~ <%:item.InningEndDay %></td>
																<td class="d-none text-center d-md-table-cell"><%:item.LectureType.Equals("CINN001") && !item.LMSContentsNo.Equals(0) ? item.AttendanceAcceptTime + "분" : "-" %></td>
																<td class="d-none text-center d-md-table-cell"><%:item.LessonFormName %></td>
																<td class="text-left"><%:Html.Raw(item.Title) %></td>
																<td class="text-center text-nowrap">
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
								<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
							</div>
						</div>
					</div>
				</div>

				<input type="hidden" id="hdnInningNo" value=""/>
			</div>
		</div>
	</div>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

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

		<%-- 탭 이동 --%>
		function fnGoTab(pageName) {

			location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> +"?TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		function fnGo() {

			window.location.href = "/Course/ListOutAdmin/?TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>