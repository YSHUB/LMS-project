<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server"> 
	<div id="content">			
		<h3 class="title04">팀프로젝트 정보</h3>
		<div class="card card-style01">
			<div class="card-header">
				<div class="row no-gutters align-items-center">
					<div class="col">
						<div class="row">
							<div class="col-md">
								<div class="text-primary font-size-14">
									<strong class="text-<%:Model.TeamProject.ProjectSituation == "진행예정" ? "info" : Model.TeamProject.ProjectSituation == "종료" ? "dark" : "danger" %> bar-vertical"><%:Model.TeamProject.ProjectSituation %></strong>			
									<strong class="text-primary">
										<%:Model.TeamProject.LeaderYesNo.Equals("Y") ? "팀장제출" : "개별제출"%>
									</strong>
								</div>
							</div>
							<div class="col-md-auto text-right">
								<dl class="row dl-style01">
									<dt class="col-auto">제출인원</dt>
									<dd class="col-auto"><%:Model.TeamProject.SubmitCount %>명</dd>
									<dt class="col-auto">평가인원</dt>
									<dd class="col-auto"><%:Model.TeamProject.FeedbackCount %>명/<%:Model.TeamProject.StudentCount %>명</dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="col-auto text-right d-md-none">
						<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divReportDetail" aria-expanded="false" aria-controls="divReportDetail">
							<span class="sr-only">더 보기</span>
						</button>
					</div>
				</div>
				<a href="/Report/Detail/<%:ViewBag.Course.CourseNo %>/<%:Model.TeamProject.ProjectNo %>" class="card-title01 text-dark"> <%:Model.TeamProject.ProjectTitle %></a>
			</div>
			<div class="card-body collapse d-md-block" id="divReportDetail">
				<div class="row mt-2 align-items-end">
					<div class="col-md">
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem">
								<i class="bi bi-dot"></i> 
								제출방식
							</dt>
							<dd class="col-8 col-md">
								<%: Model.TeamProject.LeaderYesNo.Equals("Y") ? "팀장 제출":"개별 제출" %>
							</dd>
							<dt class="col-4 col-md-auto w-7rem <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">
								<i class="bi bi-dot"></i> 
								평가공개여부
							</dt>
							<dd class="col-8 col-md <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">
								<%: Model.TeamProject.EstimationOpenYesNo.Equals("Y") ? "공개":"비공개" %> 
								<input type="button" id="btnEstimation" class="btn btn-sm btn-outline-primary" value="<%:Model.TeamProject.EstimationOpenYesNo == "Y" ? "비공개" : "공개" %>로 변경" />
							</dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem">
								<i class="bi bi-dot"></i> 
								제출기간
							</dt>
							<dd class="col-8 col-md">
								<%:DateTime.Parse(Model.TeamProject.SubmitStartDay).ToString("yyyy-MM-dd HH:mm")%> ~ <%:DateTime.Parse(Model.TeamProject.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %>
							</dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem">
								<i class="bi bi-dot"></i> 
								<%:Model.TeamProject.IsOutput == 0 ? "내용" : "수업내용" %>
							</dt>
							<dd class="col">
								<%:Model.TeamProject.ProjectContents %>
							</dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">
								<i class="bi bi-dot"></i> 
								평가인원
							</dt>
							<dd class="col-8 col-md <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">
								<%:Model.TeamProject.FeedbackCount %>명/<%:Model.TeamProject.StudentCount %>명
							</dd>
							<dt class="col-4 col-md-auto w-7rem">
								<i class="bi bi-dot"></i> 
								팀편성
							</dt>
							<dd class="col-8 col-md">
								<%:Model.TeamProject.GroupName %> 
								<button type="button" id="btnGroupTeamMember" class="text-primary font-size-20" data-toggle="modal" data-target="#divGroupTeamMember" title="팀원보기" >
									<i class="bi bi bi-people-fill"></i>
								</button>
								<!-- 팀편성보기 ascx 호출 -->
								<% Html.RenderPartial("./Team/GroupTeamMemberList"); %>	
								<!-- 팀편성보기 ascx 호출 -->
							</dd>
						</dl>
						<%
							if (Model.FileList != null)
							{
								foreach (var item in Model.FileList)
								{
						%>
									<dl class="row dl-style02">
										<dt class="col-auto w-7rem">
											<i class="bi bi-dot"></i> 
											첨부파일
										</dt>
										<dd class="col-8 col-md">
											<button type="button" title="다운로드" onclick="fnFileDownload(<%:item.FileNo %>)">
												<i class="bi bi-paperclip"></i>
												<span><%:item.OriginFileName%></span>
											</button>
										</dd>
									</dl>
						<%
								}
							}
						%>
					</div>
					<div class="col-md-auto mt-2 mt-md-0 text-right">
						<div class="btn-group btn-group-lg">
							<a class="btn btn-lg btn-outline-warning w-100 w-md-auto" href="/Report/Write/<%:Model.TeamProject.CourseNo %>/<%:Model.TeamProject.IsOutput %>/<%:Model.TeamProject.ProjectNo %>">수정</a>
							<a class="btn btn-lg btn-outline-danger w-100 w-md-auto" id="btnDelete">삭제</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--학생/수강생 리스트-->
		<div class="row">
			<div class="col-12 mt-2">
				<h3 class="title04">제출 대상 리스트<strong class="text-primary">(<%:Model.TeamProjectSubmitList.Count() %>건)</strong></h3>
				<%
					if(Model.TeamProjectSubmitList.Count() == 0)
					{ 
				%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 제출 대상이 없습니다.</div>
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
											<%
												if (Model.SortType != null)
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
												<%
													}
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
										<div class="dropdown <%:Model.TeamProject.IsOutput == 0 ? "d-inline-block" : "d-none" %>">
											<button type="button" class="btn btn-sm btn-point" data-toggle="modal" data-target="#divAllFeedback" aria-haspopup="true" aria-expanded="false">
												팀프로젝트 평가
											</button>
										</div>
									</div>
								</div>
							</div>
							<div class="card-body py-0">
								<div class="table-responsive">
									<table class="table" id="personalTable">
										<caption>개인별 평가 현황 리스트</caption>
										<thead>
											<tr>
												<th scope="row">
													<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');">
												</th>
												<th scope="row">번호</th>
												<th scope="row" class="d-none d-md-table-cell">상태</th>
												<th scope="row" class="d-none d-md-table-cell">팀</th>
												<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
												<th scope="row">성명</th>
												
												<th scope="row" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none" %>">학적</th>
												<th scope="row" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : "" %>">생년월일</th>
												
												<th scope="row" class="d-none d-md-table-cell">제출일시</th>
												<th scope="row" class="text-nowrap">제출파일</th>
												<th scope="row" class="text-nowrap">제출정보</th>
												<th scope="row" class="text-nowrap <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">점수<span class="d-none d-md-inline">(100점 만점)</span></th>
											</tr>
										</thead>
										<tbody id="tbodySubmitList">
											<%
												foreach (var item in Model.TeamProjectSubmitList)
												{
											%>
													<tr class="data">
														<th scope="row">
															<!--  문자 관련 소스  학생/수강생 선택 -->
															<input type="checkbox" name="TeamProject.UserNo" id="chkSel" value="<%:item.UserNo %>" class="checkbox">
															<input type="hidden" value="<%:item.UserNo %>">
															<input type="hidden" value="<%:item.HangulName %>(<%:item.UserID %>)">
															<input type="hidden" value="<%:item.UserID %>">
														</th>
														<td><%:Model.TeamProjectSubmitList.IndexOf(item) + 1%></td>				
														<td class="d-none d-md-table-cell">
															<%= Model.TeamProject.LeaderYesNo.Equals("Y") && item.TeamLeaderYesNo.Equals("N") ? "-" : item.SubmitContents != null ? "<span class='text-primary'>제출</span>" : "<span class='text-danger'>미제출</span>"%>
														</td>
														<td class="text-nowrap text-left d-none d-md-table-cell"><%:item.TeamName %></td>
														<td>
															<span class="text-nowrap text-secondary font-size-15"><%:item.UserID %></span>
														</td>
														<td>
															<span class="text-nowrap text-dark d-block">
																<%:item.HangulName %>
																<%if (item.TeamLeaderYesNo.Equals("Y")) {%>
																	<i class="bi bi-patch-check-fill text-success" title="팀장"></i>
																<%}%>
															</span>
														</td>

														<%
														if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
														{
														%>
														<td class="d-none d-md-table-cell">												
															<%:item.HakjeokGubunName %>													
														</td>
														<%
														}
														else
														{
														%>
														<td class="d-none d-md-table-cell">												
															<%:item.Email %>													
														</td>
														<%
														}
														%>
														<td class="d-none d-md-table-cell">
															<span class="text-nowrap text-dark d-block"><%:string.IsNullOrEmpty(item.SubmitContents) && !(item.FileGroupNo > 0) ? "" : DateTime.Parse(item.CreateDateTime).ToString("yyyy-MM-dd") %></span>
															<span class="text-nowrap text-secondary font-size-15"><%:string.IsNullOrEmpty(item.SubmitContents) && !(item.FileGroupNo > 0) ? "-" : DateTime.Parse(item.CreateDateTime).TimeOfDay.ToString() %></span>
														</td>
														<td>
															<%
																if (item.FileGroupNo > 0)
																{
															%>	
																	<button type="button" title="다운로드" onclick="fnFileDownload(<%:item.FileNo %>)">
																		<i class="bi bi-file-earmark-arrow-down"></i>
																	</button>		
															<%
																}
																else 
																{
															%>
																	-
															<%
																}
															%>
														</td>
														<td>
															<%
																if (item.SubmitContents != null)
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
														</td>
														<td class="text-right <%:Model.TeamProject.IsOutput == 0 ? "" : "d-none" %>">
															<input type="text" class="form-control form-control-sm text-right listscore" id="txtScores" data-saveno="<%: item.TeamNo %>:<%: item.SubmitNo %>:<%: item.UserNo %>" value="<%:item.Score %>"/>
															<input type="hidden" title="hdnTeamNo" id="hdnTeamNo" value="<%:item.TeamNo %>">
															<input type="hidden" title="hdnSubmitNo" id="hdnSubmitNo" value="<%:item.SubmitNo %>">
															<input type="hidden" title="hdnUserNo" id="hdnUserNo" value="<%:item.UserNo %>">
														</td>
														<td>
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
			<div class="col-6">
			</div>
			<div class="col-6">
				<div class="text-right">
					<%
						if(Model.TeamProject.IsOutput == 0)
						{
					%>
							<input type="button" class="btn btn-primary" value="저장" id="btnFeedbackSave"/>
					<%
						}
					%>
					<a href="<%:Model.TeamProject.IsOutput == 0 ? "/TeamProject/ListTeacher/" + ViewBag.Course.CourseNo : "/Report/List/" + ViewBag.Course.CourseNo %>" class="btn btn-primary">목록</a>
				</div>
			</div>
		</div>
		<!-- 팀프로젝트 평가-->
		<div class="modal fade show" id="divAllFeedback" tabindex="-1" aria-labelledby="feedback" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="feedback">일괄평가</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="card">
							<div class="card-body p-0">
								<div class="table-responsive" id="divAllFeedbackList">
									<table class="table table-hover" summary="조관리">
										<caption>팀프로젝트 평가</caption>
										<thead>
											<tr>
												<th scope="col">팀명</th>
												<th scope="col">평가점수 (100점만점)</th>
												<th scope="col">코멘트</th>
											</tr>
										</thead>
										<tbody id="tbodyFeedback">
										<%
											foreach (var item in Model.TeamProjectSubmitList.Select(s => s.TeamNo).Distinct().ToList()) 
											{
												var t = Model.TeamProjectSubmitList.Where(w => w.TeamNo == item).First();
										%>
												<tr class="data" data-tno="<%:t.TeamNo %>">
													<td>
														<%:t.TeamName %>
													</td>
													<td class="text-right">
														<input type="text" class="form-control text-right score" id="txtScore" name="teamProjectSubmit.Score"/>
													</td>
													<td class="text-right">
														<input type="text" class="form-control text-right feedback" id="txtFeedback" name="teamProjectSubmit.Feedback"/>
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
						<div class="row">
							<div class="col-12 text-right">
								<input type="button" class="btn btn-primary" value="저장" id="btnAllFeedbackSave"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 팀프로젝트 평가-->

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
	</div>

	<input type="hidden" title="hdnCourseNo" id="hdnCourseNo" name ="TeamProject.CourseNo" value="<%: ViewBag.Course.CourseNo %>">
	<input type="hidden" title="hdnGroupNo" id="hdnGroupNo" name ="TeamProject.GroupNo" value="<%:Model.TeamProject.GroupNo%>">
	<input type="hidden" title="hdnIsOutput" id="hdnIsOutput" value="<%:Model.TeamProject.IsOutput%>" />
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 평가공개여부 변경(공개/비공개) --%>
		$("#btnEstimation").click(function () {

			bootConfirm("팀프로젝트 평가를" + '<%:Model.TeamProject.EstimationOpenYesNo.Equals("Y") ? " 비공개" : " 공개"%>' + "하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Report/EstimationEdit", { courseNo: <%:Model.TeamProject.CourseNo%>, projectNo: <%:Model.TeamProject.ProjectNo%> }, "fnCompleteEstimationEdit");
			});
		});

		function fnCompleteEstimationEdit() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("변경되었습니다.", function () {
					location.reload();
				});
			}
		}

		<%-- 팀원보기 --%>
		$("#btnGroupTeamMember").click(function () {

			var courseNo = $("#hdnCourseNo").val();
			var groupNo = <%:Model.TeamProject.GroupNo%>;
			var isTeamProject = 1;

			fnGroupTeam(courseNo, groupNo, isTeamProject);
		});

		<%-- 학번순 / 성명순 정렬 --%>
		$("#btnSort").click(function () {
			window.location = '/Report/Detail/<%:Model.TeamProject.CourseNo%>/<%:Model.TeamProject.ProjectNo%>/<%:Model.SortType != null ? Model.SortType : "UserID"%>';
		});

		<%-- 팀프로젝트 삭제 --%>
		$("#btnDelete").click(function () {
			if ("<%:Model.TeamProjectSubmitList.Where(x=>x.SubmitContents != null || x.FileGroupNo > 0).Count()%>" > "0") {

				bootConfirm("팀프로젝트를 제출한 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 존재합니다. 삭제된 정보는 복구할 수 없습니다. 그래도 삭제하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Report/Delete", { courseNo: <%:Model.TeamProject.CourseNo%>, projectNo: <%:Model.TeamProject.ProjectNo%> }, "fnCompleteDelete");
				});
			}
			else {

				bootConfirm("팀프로젝트를 삭제하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Report/Delete", { courseNo: <%:Model.TeamProject.CourseNo%>, projectNo: <%:Model.TeamProject.ProjectNo%> }, "fnCompleteDelete");
				});
			}
		});

		function fnCompleteDelete() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {

					if ($("#hdnIsOutput").val() == 0) {
						location.href = "/TeamProject/ListTeacher/<%:ViewBag.Course.CourseNo %>";
					} else {
						location.href = "/Report/List/<%:ViewBag.Course.CourseNo %>";
					}
				});
			}
		}

		<%-- 팀프로젝트 일괄 평가 --%>
		$("#btnAllFeedbackSave").click(function () {

			var isZero = false;
			var feedback = "";

			$.each($("#tbodyFeedback tr.data"), function (i, r) {
				if (parseInt($("#txtScore").val()) > 100 || parseInt($("#txtScore").val()) < 1) {
					isZero = true;
				}
				feedback += ";" + $(r).attr("data-tno") + ":" + $(r).find("input.score").val() + ":" + $(r).find("input.feedback").val().replace(/;/gi, '').replace(/:/gi, '');
			});

			feedback = feedback == "" ? "" : feedback.substr(1);
			if (feedback == "") {
				bootAlert("저장할 데이터가 없습니다.");
			}
			else {

				bootConfirm((isZero ? "0점인 팀이 있습니다. \n" : "") + "팀별 점수를 부여하시겠습니까?", function () {
					ajaxHelper.CallAjaxPost("/Report/AllFeedback", { projectNo: <%:Model.TeamProject.ProjectNo%>, feedback: feedback }, "fnCompleteFeedback");
				});
			}
		});

		<%-- 팀프로젝트 개별 평가 --%>
		$("#btnFeedbackSave").click(function () {

			if ($("#tbodySubmitList tr.data").length < 1) {
				bootAlert("저장할 데이터가 없습니다.");
			}
			else
			{
				var feedback = "";
				$.each($("#tbodySubmitList tr.data input.listscore"), function (i, r) {

					feedback += ";" + $(r).attr("data-saveno") + ":" + $(r).val();
				});

				if (feedback == "") {
					bootAlert("저장할 데이터가 없습니다.");
				}
				else
				{
					feedback = feedback.substr(1);
					bootConfirm("점수를 저장하시겠습니까?", function () {
						ajaxHelper.CallAjaxPost("/Report/Feedback", { projectNo: <%:Model.TeamProject.ProjectNo%>, feedback: feedback }, "fnCompleteFeedback");
					});
				}
			}
		});

		function fnCompleteFeedback() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("오류가 발생했습니다.", function () {
					location.reload();
				});
			}
		}

		<%-- 제출내용 상세보기 --%>
		function fnSubmitDetail(submitContents) {

			$("#lblSubmitContents").text(submitContents);
		}

	</script>
</asp:Content>
