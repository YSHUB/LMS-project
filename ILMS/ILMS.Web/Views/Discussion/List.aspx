<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div id="content">					
		<h3 class="title04">토론 리스트</h3>
		<div class="card">
			<div class="card-body">
				<ul class="list-inline list-inline-style02 mb-0">
					<li class="list-inline-item bar-vertical">
                        진행예정
						<span class="ml-1 badge badge-secondary"><%: Model.DiscussionList.Where(t => DateTime.ParseExact(t.DiscussionStartDay, "yyyy-MM-dd", null) > DateTime.Now).Count()%>
                        </span>
					</li>
					<li class="list-inline-item bar-vertical">
                        진행중
                        <span class="ml-1 badge badge-secondary"><%: Model.DiscussionList.Where(t => (DateTime.ParseExact(t.DiscussionStartDay, "yyyy-MM-dd", null) < DateTime.Now && DateTime.ParseExact(t.DiscussionEndDay, "yyyy-MM-dd", null) > DateTime.Now)).Count() %>
                        </span>
					</li>
					<li class="list-inline-item bar-vertical">
                        종료
                        <span class="ml-1 badge badge-secondary"><%: Model.DiscussionList.Where(t => DateTime.ParseExact(t.DiscussionEndDay, "yyyy-MM-dd", null).AddDays(1) < DateTime.Now).Count()%>
                        </span>
					</li>
				</ul>
			</div>
		</div>
		<%
			if (Model.DiscussionList.Count.Equals(0))
			{
		%>
				<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 토론이 없습니다.</div>
		<%
			}
			else
			{
		%>
				<%
					foreach (var item in Model.DiscussionList)
					{
				%>
						<!-- 토론 리스트 -->
						<div class="card card-style01">
							<div class="card-header">
								<div class="row no-gutters align-items-center">
									<div class="col">
										<div class="row">
											<div class="col-md">
												<div class="text-primary font-size-14">
													<strong class="text-<%:item.DiscussionSituation == "진행예정" ? "info" : item.DiscussionSituation == "종료" ? "dark" : "danger" %> bar-vertical"><%:item.DiscussionSituation %></strong>
													<strong class=""><%:item.DiscussionAttributeName %></strong>
												</div>
											</div>
											<div class="col-md-auto text-right">
												<dl class="row dl-style01">
													<dt class="col-auto">참여글</dt>
													<dd class="col-auto">
														<%: item.OpinionCount %>개
													</dd>
													<dt class="col-auto">참여자</dt>
													<dd class="col-auto">
														<button type="button" class="btn btn-sm btn-outline-dark" onclick="fnParticipationMemberList(<%:item.CourseNo %>,<%:item.DiscussionNo %>, '<%:item.DiscussionSubject %>', <%:item.OpinionUserCount %>)" data-toggle="modal" data-target="#divParticipationMemberList">
															<i class="bi bi-person"></i> <%: item.OpinionUserCount %>명
														</button>
													</dd>
												</dl>
											</div>
										</div>
									</div>
									<div class="col-auto text-right d-md-none">
										<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#divDiscussionList" aria-expanded="false" aria-controls="divDiscussionList">
											<span class="sr-only">더 보기</span>
										</button>
									</div>
								</div>
								<a href="/Discussion/Detail/<%:item.CourseNo %>/<%:item.DiscussionNo %>" class="card-title01 text-dark"><%:item.DiscussionSubject %> </a>
							</div>
							<div class="card-body collapse d-md-block" id="divDiscussionList">
								<div class="row mt-2 align-items-end">
									<div class="col-md">
										<dl class="row dl-style02">
											<dt class="col-auto w-7rem"><i class="bi bi-dot"></i> 토론기간</dt>
											<dd class="col"><%:item.DiscussionStartDay %> ~ <%:item.DiscussionEndDay %></dd>
										</dl>
									</div>
									<div class="col-md-auto mt-2 mt-md-0 text-right">
										<a class="btn btn-lg btn-point w-100 w-md-auto" href="/Discussion/Detail/<%:item.CourseNo %>/<%:item.DiscussionNo %>">자세히</a>
									</div>
								</div>
							</div>
						</div><!-- 토론 리스트 -->
				<%
					}
				%>
		<%
			}
		%>
		<%
			if (ViewBag.Course.IsProf == 1)
			{
		%>
				<div class="text-right">
					<a href="/Discussion/Write/<%:ViewBag.Course.CourseNo%>" class="btn btn-primary">토론 등록</a>
				</div>
		<%
			}
		%>

        <!-- 참여자 보기 -->
		<div class="modal fade show" id="divParticipationMemberList" tabindex="-1" aria-labelledby="ParticipationMemberDetail" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="ParticipationMemberDetail">참여자 보기</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="card">
							<div class="card-header">
								<div class="row no-gutters">
									<div class="col align-items-baseline" id="divParticipationMemberDetailHeader">
										<strong class="text-dark font-size-20 bar-vertical">
											<label id="lblDiscussionSubject"></label>
										</strong>
										<span class="text-nowrap text-secondary font-size-14">참여자 
											<span class="text-success">
												<label id="lblOpinionUserCount"></label>
											</span>명
										</span>
									</div>
								</div>
							</div>
							<div class="card-body p-0">
								<div class="table-responsive" id="divParticipationMemberDetailList">
									<table class="table table-hover" summary="조관리" id="tblParticipationMemberDetailList">
										<caption>ParticipationMemberList</caption>
										<thead>
											<tr>
												<th scope="col" id ="thTeamName">팀명</th>
												<%
												if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
												{
												%>
												<th scope="col" class="d-none d-md-table-cell">소속</th>
												<%
												}
												%>
												<th scope="col" class="d-none d-md-table-cell"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
												<th scope="col">이름</th>
												<th scope="col">참여글</th>
												<th scope="col">인정글</th>
												<th scope="col">인정점수</th>
											</tr>
										</thead>
										<tbody id="tbdParticipationMemberDetailList">
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 참여자 보기 -->
		
	</div>

	<input type="hidden" id="hdnIsProf" value="<%:ViewBag.Course.IsProf %>"/>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 토론 참여자 조회 --%>
		function fnParticipationMemberList(courseNo, discussionNo, discussionSubject, opinionUserCount) {
			$("#lblDiscussionSubject").text(discussionSubject);
			$("#lblOpinionUserCount").text(opinionUserCount);
			ajaxHelper.CallAjaxPost("/Discussion/ParticipationMemberList", { courseNo: courseNo, discussionNo: discussionNo }, "fnCompleteParticipationMemberList");
		}

		<%-- 토론 참여자 조회 (참여자 정보) --%>
		function fnCompleteParticipationMemberList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";
			var UnivYN = "<%:ConfigurationManager.AppSettings["UnivYN"].ToString()%>";

		if (result.length > 0) {
			for (var i = 0; i < result.length; i++) {
				if (result[i].TeamName != null) {
						$("#thTeamName").show();
				} else {
						$("#thTeamName").hide();
				}

				value += '	<tr>';
				if (result[i].TeamName != null) {
					value += '		<td class="">' + result[i].TeamName + '</td>';
				}
				if (UnivYN == "Y") {
					value += '		<td class="text-left d-none d-md-table-cell">' + result[i].AssignName + '</td>';
				}
					value += '		<td class="text-center d-none d-md-table-cell">' + result[i].UserID + '</td>';
					value += '		<td>' + result[i].HangulName + '</td>';
					value += '		<td class="text-right">' + result[i].OpinionCount + '건</td>';
					value += '		<td class="text-right">' + result[i].ParticipationCount + '건</td>';
					value += '		<td class="text-right">' + result[i].ParticipationRateScore + '점</td>';
					value += '	</tr>';
				}
			} else {
				$("#thTeamName").show();
				value += '	<tr>';
				value += '		<td colspan="7">' + "참여자가 없습니다." + '</td>';
				value += '	</tr>';
			}

			$("#tbdParticipationMemberDetailList").html(value);
		}
	</script>
</asp:Content>
