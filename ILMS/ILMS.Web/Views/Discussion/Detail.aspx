<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>"%>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Discussion/Detail/<%:ViewBag.Course.CourseNo%>/<%:Model.Discussion.DiscussionNo %>" method="post" id="mainForm" enctype="multipart/form-data">
		<div id="content">
			<h3 class="title04">토론 정보</h3>
			<div class="card card-style01">
				<div class="card-header">
					<div class="row no-gutters align-items-center">
						<div class="col">
							<div class="row">
								<div class="col-md">
									<div class="text-primary font-size-14">
                                        <strong class="text-<%:Model.Discussion.DiscussionSituation == "진행예정" ? "info" : Model.Discussion.DiscussionSituation == "종료" ? "dark" : "danger" %> bar-vertical"><%:Model.Discussion.DiscussionSituation %></strong>
										<strong class=""><%:Model.Discussion.DiscussionAttributeName %></strong>
									</div>
								</div>
							</div>
						</div>
						<div class="col-auto text-right d-md-none">
							<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divDiscussionDetail" aria-expanded="false" aria-controls="divDiscussionDetail">
								<span class="sr-only">더 보기</span>
							</button>
						</div>
					</div>
					<a class="card-title01 text-dark"><%:Model.Discussion.DiscussionSubject %> </a>
				</div>
				<div class="card-body collapse d-md-block" id="divDiscussionDetail">
					<div class="row mt-2 align-items-end">
						<div class="col-md">
							<dl class="row dl-style02">
								<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 토론기간</dt>
								<dd class="col"><%:Model.Discussion.DiscussionStartDay %> ~ <%:Model.Discussion.DiscussionEndDay %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 개요</dt>
								<dd class="col"><%:Model.Discussion.DiscussionSummary %>
								</dd>
							</dl>
								<%
									if (Model.FileList != null)
									{
										foreach (var item in Model.FileList)
										{
								%>
											<dl class="row dl-style02">
												<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 첨부파일</dt>
													<dd class="col">
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
						<%
							if (ViewBag.Course.IsProf == 1) 
							{
						%>
								<div class="col-md-auto mt-2 mt-md-0 text-right">
									<div class="btn-group btn-group-lg">
										<button type="button" class="btn btn-lg btn-outline-warning w-100 w-md-auto" onclick="fnUpdate()">수정</button>
										<button type="button" class="btn btn-lg btn-outline-danger w-100 w-md-auto" onclick="fnDelete()">삭제</button>
									</div>
								</div>
						<%
							}
						%>
					</div>
				</div>
			</div>

			<%if (Model.Discussion.DiscussionAttribute.Equals("CDAB002"))
			  {
			%>
				<!--조별 토론일 때-->
				<div class="row">
					<div class="col-12 col-md-3">
						<h3 class="title04">팀 편성 현황<strong class="text-primary">(<%:Model.DiscussionGroupList.Count %>팀)</strong></h3>
						<div class="card">
							<div class="card-body p-0">
								<ul class="list-group list-group-flush">
									<%
										foreach (var item in Model.DiscussionGroupList)
										{
									%>		
											<li class="list-group-item font-size-14 <%:Model.TeamNo.Equals(item.TeamNo) ? "font-weight-bold" : "" %>">
											<%
												if (ViewBag.Course.IsProf == 1)
												{
											%>
													<a href="/Discussion/Detail/<%:item.CourseNo %>/<%:item.DiscussionNo %>/<%:item.TeamNo %>" class="<%:Model.TeamNo.Equals(item.TeamNo) ? "text-primary" : "" %>">
														<%:item.TeamName %>
													</a>
											<%
												}
												else 
												{ 
											%>
													<%
														if (Model.Discussion.OpenYesNo.Equals("Y"))
														{ 
													%>
															<a href="/Discussion/Detail/<%:item.CourseNo %>/<%:item.DiscussionNo %>/<%:item.TeamNo %>" class="<%:Model.TeamNo.Equals(item.TeamNo) ? "text-primary" : "" %>">
																<%:item.TeamName %>
															</a> 
													<%
														}else
														{
													%>

															<%
																if (item.IsMember.Equals("Y"))
																{
															%>
																	<a href="/Discussion/Detail/<%:item.CourseNo %>/<%:item.DiscussionNo %>/<%:item.TeamNo %>" class="<%:Model.TeamNo.Equals(item.TeamNo) ? "text-primary" : "" %>">
																		<%:item.TeamName %>
																	</a>
															<%
																}
																else 
																{ 
															%>
																	<a href="#" role="button" onclick="alert('비공개설정으로 다른 조의 내용을 확인할 수 없습니다.');" class="<%:Model.TeamNo.Equals(item.TeamNo) ? "text-primary" : "" %>">
																		<%:item.TeamName %>
																	</a>
															<%
																}
															%>
													<%
														}
													%>
											<%
												}
											%>
											<span class="badge badge-<%:Model.TeamNo.Equals(item.TeamNo) ? "primary" : "dark" %>"><%:item.OpinionCount %></span>					
											<%
												if (Model.TeamNo.Equals(item.TeamNo)) 
												{
											%>
													<button type="button" onclick="fnOpinionTeamMemberList(<%:item.GroupNo %>,<%:item.TeamNo %>,'<%:item.TeamName %>')" class="text-primary" data-toggle="modal" data-target="#divOpinionTeamMemberList" title="팀원보기">
														<i class="bi bi-people-fill"></i>
													</button>
											<%
												}
											%>
											</li>
									<%
										}
									%>
								</ul>
							</div>
						</div>
					</div>
					<div class="col-12 col-md-9 mt-2">
						<h3 class="title04">의견 리스트<strong class="text-primary">(<%:Model.DiscussionOpinionList.Count %>건)</strong></h3>
						<%
							if (Model.DiscussionOpinionList.Count.Equals(0))
							{
						%>
								<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 아직 등록된 의견이 없습니다.</div>
						<%
							}
							else
							{
						%>
								<%
									foreach (var item in Model.DiscussionOpinionList)
									{
								%>
										<div class="card card-style01">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-12 col-md">
														<p class="card-title02">
														<%
															if (ViewBag.Course.IsProf == 1) 
															{
														%>
																<input type="checkbox" title="점수인정" name="chkOpinionNo" class="checkbox mr-1" value="<%:item.OpinionNo %>" />
														<%
															}
														%>
														<a href="/Discussion/OpinionView/<%:item.CourseNo %>/<%:item.DiscussionNo %>/<%:item.OpinionNo %>" class="text-nowrap">
														<%
															if (item.TopOpinionYesNo.Equals("Y"))
															{
														%>
																<strong class="badge badge-warning">공지사항</strong>
														<%
															}
														%>
														<%
															if (item.ParticipationYesNo.Equals("Y"))
															{
														%>
																<strong class="badge badge-success">점수인정</strong>
														<%
															}
														%>
														<%:item.OpinionTitle %>
														</a>
														</p>
													</div>
													<div class="col-auto text-right">
														<dl class="row dl-style01">
															<dt class="col-auto text-dark">작성일자</dt>
															<dd class="col-auto mb-0"><%:item.CreateDateTime %></dd>
															<dt class="col-auto d-none">관리</dt>
															<dd class="col-auto mb-0">
																<button type="button" class="btn btn-sm btn-<%:item.IsUserYesNo.Equals(1) && item.YesNoCode.Equals("Y") ? "" : "outline-" %>success" onclick="fnOpinionYesNo(<%:item.OpinionNo %>, 'Y')"><i class="bi bi-hand-thumbs-up"></i> <%:item.YesCount %></button>
																<button type="button" class="btn btn-sm btn-<%:item.IsUserYesNo.Equals(1) && item.YesNoCode.Equals("N") ? "" : "outline-" %>danger" onclick="fnOpinionYesNo(<%:item.OpinionNo %>, 'N')"><i class="bi bi-hand-thumbs-down"></i> <%:item.NoCount %></button>
															</dd>
														</dl>
													</div>
												</div>
											</div>
											<div class="card-body">
												<p><%:item.OpinionContents %></p>
											</div>
											<div class="card-footer">
												<div class="row align-items-center">
													<div class="col-md">
														<dl class="row dl-style01">
															<dt class="col-auto text-dark">작성자</dt>
															<dd class="col-auto mb-0"><%:item.HangulName %>(<%:item.UserID %>)</dd>
															<dt class="col-auto text-dark">조회수</dt>
															<dd class="col-auto mb-0"><%:item.ReadCount %></dd>
															<dt class="col-auto text-dark">한줄 의견수</dt>
															<dd class="col-auto mb-0"><%:item.ReplyCount %></dd>
														</dl>
													</div>
												</div>
											</div>
										</div>
								<%
									}
							}
						%>
						<div class="row">
							<%
								if (ViewBag.Course.IsProf == 1) 
								{
							%>
									<div class="col-6">
										<div class="dropdown d-inline-block">
											<button type="button" class="btn btn-outline-primary dropdown-toggle" id="btnParticipation" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
												참여도 점수 관리
											</button>
											<ul class="dropdown-menu" aria-labelledby="btnParticipation" style="will-change: transform;">
												<li><button type="button" class="dropdown-item" id="btnParticipationY">선택 글 인정처리</button></li>
												<li><button type="button" class="dropdown-item" id="btnParticipationN">선택 글 인정취소</button></li>
											</ul>
										</div>
									</div>
									<div class="col-6">
										<div class="text-right">
											<a href="/Discussion/List/<%:Model.Discussion.CourseNo %>" class="btn btn-primary">목록</a>
										</div>
									</div>
							<%
								}
							%>

							<%
								if (ViewBag.Course.IsProf == 0) 
								{
							%>
									<div class="col-12">
										<div class="text-right">
											<%
												if (Model.Discussion.DiscussionSituation.Equals("진행중"))
												{
													if (Model.DiscussionGroup.IsMember.Equals("Y")) 
													{
											%>
														<button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#divNewOpinion">새 의견 쓰기</button>
											<%			
													}
												}
											%>
											<a href="/Discussion/List/<%:Model.Discussion.CourseNo %>" class="btn btn-primary">목록</a>
										</div>
									</div>
							<%
								}
							%>
						</div>
					</div>
				</div>
			<%
			  } else
			  {
			%>
				<!--개별 토론일 때-->
				<div class="row">
					<div class="col-12 mt-2">
						<h3 class="title04">의견 리스트<strong class="text-primary">(<%:Model.DiscussionOpinionList.Count %>건)</strong></h3>
						<%
							if (Model.DiscussionOpinionList.Count.Equals(0))
							{
						%>
								<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 아직 등록된 의견이 없습니다.</div>
						<%
							}
							else
							{
						%>
								<%
									foreach (var item in Model.DiscussionOpinionList)
									{
								%>
										<div class="card card-style01">
											<div class="card-header">
												<div class="row align-items-center">
													<div class="col-12 col-md">
														<p class="card-title02">
															<%
																if (ViewBag.Course.IsProf == 1) 
																{
															%>
																	<input type="checkbox" title="점수인정" name="chkOpinionNo" class="checkbox mr-1" value="<%:item.OpinionNo %>" />
															<%
																}
															%>
															<a href="/Discussion/OpinionView/<%:item.CourseNo %>/<%:item.DiscussionNo %>/<%:item.OpinionNo %>">
															<%
																if (item.TopOpinionYesNo.Equals("Y"))
																{
															%>
																	<strong class="badge badge-warning">공지사항</strong>
															<%
																}
															%>
															<%
																if (item.ParticipationYesNo.Equals("Y"))
																{
															%>
																	<strong class="badge badge-success">점수인정</strong>
															<%
																}
															%>
															<%:item.OpinionTitle %>
															</a>
														</p>
													</div>
													<div class="col-auto text-right">
														<dl class="row dl-style01">
															<dt class="col-auto text-dark">작성일자</dt>
															<dd class="col-auto mb-0"><%:item.CreateDateTime %></dd>
															<dt class="col-auto d-none">관리</dt>
															<dd class="col-auto mb-0">
																<button type="button" class="btn btn-sm btn-<%:item.IsUserYesNo.Equals(1) && item.YesNoCode.Equals("Y") ? "" : "outline-" %>success" onclick="fnOpinionYesNo(<%:item.OpinionNo %>, 'Y')"><i class="bi bi-hand-thumbs-up"></i> <%:item.YesCount %></button>
																<button type="button" class="btn btn-sm btn-<%:item.IsUserYesNo.Equals(1) && item.YesNoCode.Equals("N") ? "" : "outline-" %>danger" onclick="fnOpinionYesNo(<%:item.OpinionNo %>, 'N')"><i class="bi bi-hand-thumbs-down"></i> <%:item.NoCount %></button>
															</dd>
														</dl>
													</div>
												</div>
											</div>
											<div class="card-body">
												<p><%:item.OpinionContents %></p>
											</div>
											<div class="card-footer">
												<div class="row align-items-center">
													<div class="col-md">
														<dl class="row dl-style01">
															<dt class="col-auto text-dark">작성자</dt>
															<dd class="col-auto mb-0"><%:item.HangulName %>(<%:item.UserID %>)</dd>
															<dt class="col-auto text-dark">조회수</dt>
															<dd class="col-auto mb-0"><%:item.ReadCount %></dd>
															<dt class="col-auto text-dark">한줄 의견수</dt>
															<dd class="col-auto mb-0"><%:item.ReplyCount %></dd>
														</dl>
													</div>
												</div>
											</div>
										</div>
								<%
									}
							}
						%>
						<div class="row">
							<%
								if (ViewBag.Course.IsProf == 1) 
								{
							%>
									<div class="col-6">
										<div class="dropdown d-inline-block">
											<button type="button" class="btn btn-outline-primary dropdown-toggle" id="btnParticipation" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
												참여도 점수 관리
											</button>
											<ul class="dropdown-menu" aria-labelledby="btnParticipation" style="will-change: transform;">
												<li><button type="button" class="dropdown-item" id="btnParticipationY">선택 글 인정처리</button></li>
												<li><button type="button" class="dropdown-item" id="btnParticipationN">선택 글 인정취소</button></li>
											</ul>
										</div>
									</div>
									<div class="col-6">
										<div class="text-right">
											<a href="/Discussion/List/<%:Model.Discussion.CourseNo %>" class="btn btn-primary">목록</a>
										</div>
									</div>
							<%
								}
							%>

							<%
								if (ViewBag.Course.IsProf == 0) 
								{
							%>
									<div class="col-12">
										<div class="text-right">
											<%
												if (Model.Discussion.DiscussionSituation.Equals("진행중")) 
												{
											%>
													<button type="button" class="btn btn-outline-primary" data-toggle="modal" data-target="#divNewOpinion">새 의견 쓰기</button>
											<%
												}
											%>
											<a href="/Discussion/List/<%:Model.Discussion.CourseNo %>" class="btn btn-primary">목록</a>
										</div>
									</div>
							<%
								}
							%>	
						</div>
					</div>
				</div>
			<%
			  }
			%>

			<!-- 팀원보기 -->
			<div class="modal fade show" id="divOpinionTeamMemberList" tabindex="-1" aria-labelledby="OpinionTeamMemberList" aria-modal="true" role="dialog">
				<div class="modal-dialog modal-lg">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="OpinionTeamMemberList">팀원보기</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card">
								<div class="card-header">
									<div class="row no-gutters">
										<div class="col align-items-baseline" id="divTeamName">
											<strong class="text-dark font-size-20 bar-vertical">
												<label id="lblTeamName"></label>
											</strong>
										</div>
									</div>
								</div>
								<div class="card-body p-0">
									<div class="table-responsive" id="divOpinionTeamMemberDetailList">
										<table class="table table-hover" summary="조관리" id="tblOpinionTeamMemberDetailList">
											<caption>OpinionTeamMemberList</caption>
											<thead>
												<tr>
													<th scope="col" class= "<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">소속</th>
													<th scope="col" class="d-none d-md-table-cell"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
													<th scope="col">이름</th>
													<th scope="col" class= "<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>">구분</th>
													<th scope="col" class= "<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">학년</th>
													<th scope="col" class= "<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "d-none" : ""%>">생년월일</th>
													<th scope="col" class="d-none d-md-table-cell">이메일</th>
												</tr>
											</thead>
											<tbody id="tbdOpinionTeamMemberDetailList">
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 팀원보기 -->

			<!-- 새 의견쓰기 -->
			<div class="modal fade show" id="divNewOpinion" tabindex="-1" aria-labelledby="newOpinion" aria-modal="true" role="dialog">
				<div class="modal-dialog modal-md">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="newOpinion">의견 쓰기</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card">
								<div class="card-body">
									<div class="form-row">
										<div class="form-group col-md-12">
											<label for="txtOpinionTitle" class="form-label">제목 <strong class="text-danger">*</strong></label>
											<input type="text" id="txtOpinionTitle" name="discussionOpinion.OpinionTitle" class="form-control" value="">
										</div>
										<div class="form-group col-md-12">
											<label for="txtOpinionContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
											<textarea class="form-control" id="txtOpinionContents" name="discussionOpinion.OpinionContents" rows="10"></textarea>
										</div>
										<div class="form-group col-12 col-md-6">
											<label for="DiscussionOpinionFileUpload" class="form-label">첨부파일</label>
											<% Html.RenderPartial("./Common/File"
												, Model.FileCopyList
												, new ViewDataDictionary {
												{ "name", "FileGroupNo" },
												{ "fname", "DiscussionOpinionFile" },
												{ "value", Model.FileGroupNo },
												{ "readmode", (Model.DiscussionOpinion != null ? 0 : 1) },
												{ "fileDirType", "DiscussionOpinion"},
												{ "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
										</div>
									</div>
								</div>
								<div class="card-footer">
									<div class="row align-items-center">
										<div class="col-md">
											<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
										</div>
										<div class="col-md-auto text-right">
											<button type="button" class="btn btn-primary" id="btnSave">저장</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 새 의견쓰기 -->

			<input type="hidden" id="hdnCourseNo" name ="DiscussionOpinion.CourseNo" value="<%: Model.Discussion.CourseNo %>">
			<input type="hidden" id="hdnDiscussionNo" name ="DiscussionOpinion.DiscussionNo" value="<%: Model.Discussion.DiscussionNo %>">
			<input type="hidden" id="hdnTeamNo" name ="TeamNo" value="<%: Model.TeamNo %>">
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
		var ajaxHelper = new AjaxHelper();

		<%-- 조별토론 팀원 조회 --%>
		function fnOpinionTeamMemberList(groupNo, teamNo, teamName) {
			$("#lblTeamName").text(teamName);
			ajaxHelper.CallAjaxPost("/Discussion/OpinionTeamMemberList", { groupNo: groupNo, teamNo: teamNo }, "fnCompleteOpinionTeamMemberList");
		}

		<%-- 조별토론 팀원 조회 --%>
		function fnCompleteOpinionTeamMemberList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					
					value += '	<tr>';
					value += '		<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">' + result[i].AssignName + '</td>';
					value += '		<td class="text-center d-none d-md-table-cell">' + result[i].UserID + '</td>';
					value += '		<td class="text-left">' + result[i].HangulName + '</td>';
					value += '		<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>">' + result[i].GeneralUserCode + '</td>';
					value += '		<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">' + result[i].GradeName + '</td>';
					value += '		<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>">' + result[i].ResidentNo + '</td>';
					value += '		<td class="text-center d-none d-md-table-cell">' + result[i].Email + '</td>';
					value += '	</tr>';
				}
			}
			$("#tbdOpinionTeamMemberDetailList").html(value);
		}

		<%-- 토론 수정 --%>
		function fnUpdate() {
			location.href = "/Discussion/Write/<%:Model.Discussion.CourseNo %>/<%:Model.Discussion.DiscussionNo %>";
		}

		<%-- 토론 삭제 --%>
        function fnDelete() {

			bootConfirm("삭제하시겠습니까 ?", function () {

				ajaxHelper.CallAjaxPost("/Discussion/Delete", { courseNo: <%:Model.Discussion.CourseNo %>, discussionNo: <%:Model.Discussion.DiscussionNo %> }, "fnCompleteDelete");
			});
		}

		function fnCompleteDelete() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {

					location.href = "/Discussion/List/" + <%:Model.Discussion.CourseNo %>;
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 새 의견 저장 --%>
		$("#btnSave").click(function () {

			if ($("#txtOpinionTitle").val() == "") {

				bootAlert("의견 제목을 입력하세요", function () {
					$("#txtOpinionTitle").focus();
				});
				return false;
			}

			if ($("#txtOpinionContents").val() == "") {
				bootAlert("의견 내용을 입력하세요", function () {
					$("#txtOpinionContents").focus();
				});
				return false;
			}

			$("#mainForm").submit();
		})

		<%-- 참여도 인정/취소 함수 --%>
		$("#btnParticipationY").click(function () {
			fnParticipationYesNo("Y");
        });

        $("#btnParticipationN").click(function () {
			fnParticipationYesNo("N");
		});

		var chkOpinionNo;

		function fnParticipationYesNo(yesNo) {
			chkOpinionNo = "";

			if ($("input[name='chkOpinionNo']:checked").length == 0) {
				bootAlert("선택된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다.");
				return;
			}

			$("input[name='chkOpinionNo']:checked").each(function () {
				chkOpinionNo = chkOpinionNo + '|' + $(this).val();
			});

			ajaxHelper.CallAjaxPost("/Discussion/ParticipationYesNo", { opinionNo: chkOpinionNo, yesNo: yesNo }, "fnCompleteParticipationYesNo");
		}

		function fnCompleteParticipationYesNo() {
			location.reload();
		}

		<%-- 의견 좋아요 / 싫어요 함수 --%>
		function fnOpinionYesNo(opinionNo, yesNo) {
			ajaxHelper.CallAjaxPost("/Discussion/OpinionYesNo", { opinionNo: opinionNo, yesNo: yesNo }, "fnCompleteOpinionYesNo");
		}

		function fnCompleteOpinionYesNo() {
			var result = ajaxHelper.CallAjaxResult();

			bootAlert(result, function () {
				location.reload();
			});
		}
	</script>
</asp:Content>
