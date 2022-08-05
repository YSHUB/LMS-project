<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">


		<div id="content">
			<ul class="nav nav-tabs mt-4" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdmin')">기본정보</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdminViewOption')">분반설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link active" href="javascript:void(0);" role="tab" onclick="fnGoTab('ListWeekAdmin')">주차 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('EstimationWriteAdmin')">평가기준 설정</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('OcwAdmin')">콘텐츠 설정</a>
				</li>
			</ul>
			<div class="card card-style02">
				<div class="card-header">
					<div>
						<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
						<span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
					</div>
					<span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
				</div>
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>개설학과</dt>
						<dd class="col-9 col-md-5"><%:Model.Course.AssignName %></dd>
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TermName %></dd>
					</dl>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (Model.Inning.Count.Equals(0))
						{
					%>
							<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 주차가 없습니다.</div>
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
													<th scope="col" class="d-none d-md-table-cell">수업형태</th>
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
															<td class="d-none text-center d-md-table-cell"><%:item.LectureTypeName %></td>
															<td class="d-none text-center d-md-table-cell"><%:item.LessonFormName %></td>
															<td class="text-left"><%: Html.Raw(item.Title) %></td>
															<td class="text-center">
																<button type="button" class="font-size-20 text-primary" onclick="fnInningSave(<%:item.InningNo %>);" title="상세보기"><i class="bi bi-card-list"></i></button>
																<button type="button" class="font-size-20 text-danger" onclick="fnDelete(<%:item.InningNo %>, <%:item.Week %>, <%:item.InningSeqNo %>);" title="삭제"><i class="bi bi-trash"></i></button>
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
							<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
						</div>		
					</div>
				</div>
			</div>
		</div>

	<input type="hidden" id="hdnCourseNo" value="<%:Model.Course.CourseNo %>"/>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var ajaxHelper = new AjaxHelper();

		<%-- 차시 삭제 --%>
		function fnDelete(inningNo, week, inningSeqNo) {
			var warningText1 = "";
			warningText1 += "해당 차시를 삭제할 경우 아래의 항목이 로그를 포함하여 모두 삭제되며 복구할 수 없습니다.";
			warningText1 += "\n\n[기본 삭제 항목]";
			warningText1 += "\n- 기본정보";
			warningText1 += "\n- 과제 정보(제출된 과제 및 평가 등 포함)";
			warningText1 += "\n- " + <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> + " 접속 정보(출석 변경 사유 등 포함)";
			warningText1 += "\n- " + <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> + " 학습기간 이력(기간내 학습, 기간외 학습, 관련 로그 등 포함)";
			warningText1 += "\n\n[해당 주차의 차시가 1개인 경우 추가로 삭제되는 항목]";
			warningText1 += "\n- 주차별 " + <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> + " 접근 횟수";
			warningText1 += "\n- 주차별 의견";
			warningText1 += "\n- 주차별 퀴즈/시험 정보(" + <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> + " 응시내역 및 채점정보, 등록된 문제 등 포함)";
			
			var params = [];
			params.push({ "inningNo": inningNo, "week": week, "inningSeqNo": inningSeqNo });

			bootConfirm(warningText1, fnDeleteConfirm, params);

		}

		function fnDeleteConfirm(params) {
			
			var warningText2 = "※ 삭제한 데이터는 복구가 불가능합니다. ※";
			warningText2 += "\n\n정말 삭제하시겠습니까?";

			bootConfirm(warningText2, fnInningDelete, params);
		}

		function fnInningDelete(params) {
			
			ajaxHelper.CallAjaxPost("/Course/InningDelete", { courseNo: <%:Model.Course.CourseNo%>, inningNo: params[0].inningNo, week: params[0].week, inningSeqNo: params[0].inningSeqNo }, "fnCompleteInningDelete");
		}

		function fnCompleteInningDelete() {

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

			fnOpenPopup("/Course/WriteWeekAdmin/" + <%:Model.Course.CourseNo %> + "/" + inningNo, "WriteWeekAdmin", 1000, 800, 0, 0, "auto");
		}

		<%-- 탭 이동 --%>
		function fnGoTab(pageName) {

			if (pageName == 'DetailAdminViewOption') {
				location.href = "/Course/DetailAdmin/" + <%:Model.Course.CourseNo%> + "?viewOption=1&AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			} else {
				location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> + "?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			}
		}

		function fnGo() {

			window.location.href = "/Course/ListAdmin/?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + decodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>