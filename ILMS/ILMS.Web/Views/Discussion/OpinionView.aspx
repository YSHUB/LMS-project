<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Discussion/OpinionView/<%:ViewBag.Course.CourseNo %>/<%:Model.DiscussionOpinion.DiscussionNo %>/<%:Model.DiscussionOpinion.OpinionNo %>" method="post" id="mainForm" enctype="multipart/form-data">
		<h3 class="title04">토론 정보</h3>
		<!-- 토론 정보 -->
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
						<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#discussionOpinionView" aria-expanded="false" aria-controls="discussionOpinionView">
							<span class="sr-only">더 보기</span>
						</button>
					</div>
				</div>
				<a href="/Discussion/Detail/<%:Model.Discussion.CourseNo %>/<%:Model.Discussion.DiscussionNo %>" class="card-title01 text-dark"><%:Model.Discussion.DiscussionSubject %> </a>
			</div>
			<div class="card-body collapse d-md-block" id="discussionOpinionView">
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
				</div>
			</div>
		</div>
		<!-- 토론 정보 -->

		<!-- 의견 정보 -->
		<div class="row">
			<div class="col-12">
				<h3 class="title04">의견 정보</h3>
				<div class="card card-style01">
					<div class="card-header">
						<div class="row align-items-center">
							<div class="col-12 col-md">
								<p class="card-title02">
									<a href="/Discussion/OpinionView/<%:Model.DiscussionOpinion.CourseNo %>/<%:Model.DiscussionOpinion.DiscussionNo %>/<%:Model.DiscussionOpinion.OpinionNo %>" class="font-size-18 font-weight-bold">
										<%
											if (Model.DiscussionOpinion != null && Model.DiscussionOpinion.TopOpinionYesNo.Equals("Y"))
											{
										%>
												<strong class="badge badge-warning">공지사항</strong>
										<%
											}
										%>
										<%
											if (Model.DiscussionOpinion != null && Model.DiscussionOpinion.ParticipationYesNo.Equals("Y"))
											{
										%>
												<strong class="badge badge-success">점수인정</strong>
										<%
											}
										%>
									
										<%:Model.DiscussionOpinion.OpinionTitle %>
									</a>
								</p>
							</div>
							<div class="col-auto text-right">
								<dl class="row dl-style01">
									<dt class="col-auto text-dark">작성일자</dt>
									<dd class="col-auto mb-0"><%:Model.DiscussionOpinion.CreateDateTime %></dd>
									<dt class="col-auto d-none">관리</dt>
									<dd class="col-auto mb-0">
										<button type="button" class="btn btn-sm btn-<%:Model.DiscussionOpinion.IsUserYesNo.Equals(1) && Model.DiscussionOpinion.YesNoCode.Equals("Y") ? "" : "outline-" %>success" onclick="fnOpinionYesNo(<%:Model.DiscussionOpinion.OpinionNo %>, 'Y')"><i class="bi bi-hand-thumbs-up"></i> <%:Model.DiscussionOpinion.YesCount %></button>
										<button type="button" class="btn btn-sm btn-<%:Model.DiscussionOpinion.IsUserYesNo.Equals(1) && Model.DiscussionOpinion.YesNoCode.Equals("N") ? "" : "outline-" %>danger" onclick="fnOpinionYesNo(<%:Model.DiscussionOpinion.OpinionNo %>, 'N')"><i class="bi bi-hand-thumbs-down"></i> <%:Model.DiscussionOpinion.NoCount %></button>
									</dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="card-body">
						<p>
							<%:Model.DiscussionOpinion.OpinionContents %>
						</p>
						<%
							if (Model.FileCopyList != null)
							{
								foreach (var item in Model.FileCopyList)
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
					<div class="card-footer">
						<div class="row align-items-center">
							<div class="col-md">
								<dl class="row dl-style01">
									<dt class="col-auto text-dark">작성자</dt>
									<dd class="col-auto mb-0"><%:Model.DiscussionOpinion.HangulName %>(<%:Model.DiscussionOpinion.UserID %>)</dd>
									<dt class="col-auto text-dark">조회수</dt>
									<dd class="col-auto mb-0"><%:Model.DiscussionOpinion.ReadCount %></dd>
									<dt class="col-auto text-dark">한줄 의견수</dt>
									<dd class="col-auto mb-0"><%:Model.DiscussionOpinion.ReplyCount %></dd>
									<%
										if (ViewBag.Course.IsProf == 1) 
										{
									%>		
											<dt class="col-auto text-dark"><label for="chkTopOpinionYesNo" class="form-label">공지사항</label></dt>
											<dd class="col-auto mb-0 dropdown d-inline-block">
												<label class="switch">
													<input type="checkbox" id="chkTopOpinionYesNo" name="DiscussionOpinion.TopOpinionYesNo" onchange="fnTopOpinionYesNo()" <%if (Model.DiscussionOpinion == null || Model.DiscussionOpinion.TopOpinionYesNo.Equals("Y")){ %> checked="checked"<%} %> >
													<span class="slider round"></span>
												</label>
											</dd>
											<dd class="col-auto mb-0 dropdown d-inline-block">
												<button type="button" class="btn btn-sm btn-outline-primary dropdown-toggle" id="btnParticipationYesNo" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
													참여도 점수 관리
												</button>
												<ul class="dropdown-menu" aria-labelledby="btnParticipationYesNo" style="will-change: transform;">
													<li><button type="button" class="dropdown-item" id="btnParticipationY">선택 글 인정처리</button></li>
													<li><button type="button" class="dropdown-item" id="btnParticipationN">선택 글 인정취소</button></li>
												</ul>
											</dd>
											
									<%
										}
									%>
									
									<%
										if(Model.DiscussionOpinion.OpinionUserNo.Equals(ViewBag.User.UserNo))
										{
									%>
											<dd class="col-auto mb-0">
												<span>
													<button type="button" class="btn btn-sm btn-outline-warning" data-toggle="modal" data-target="#divOpinion"><i class="bi bi-pencil"></i></button>
													<button type="button" class="btn btn-sm btn-outline-danger" onclick="fnOpinionDelete()"><i class="bi bi-trash"></i></button>
												</span>
											</dd>
									<%
										}
									%>
								</dl>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
		<!-- 의견 정보 -->

		<!-- 한줄 의견 정보 -->
		<div class="row">
			<div class="col-12">
				<h3 class="title04">
					한줄 의견 정보
					<strong class="text-primary">
						(<%:Model.DiscussionReplyList.Count() %>건)
					</strong>
				</h3>
				<div class="card">
					<div class="card-body">
						<div class="input-group">
							<label for="txtDiscussionReplyReplyContents" class="sr-only">의견</label>
							<input type="text" class="form-control" id="txtDiscussionReplyReplyContents" name="DiscussionReply.ReplyContents"/>
							<span class="input-group-append">
							 <button type="button" class="btn btn-primary btn-lg" id="btnOpinionReplySave">등록</button>
							</span>
						</div>
					</div>
				</div>
				<%
					if (Model.DiscussionReplyList.Count > 0)
					{
				%>
						<%
							foreach (var item in Model.DiscussionReplyList)
							{
						%>
								<div class="card">
									<div class="card-body">
										<div class="row align-items-center">
											<div class="col-md">
												<div class="card-title02 text-nowrap">
													<%:item.ReplyContents %>
												</div>
											</div>
											<div class="col-md-auto text-right">
												<dl class="row dl-style01">
													<dt class="col-auto text-dark">작성자</dt>
													<dd class="col-auto mb-0"><%:item.HangulName %>(<%:item.UserID %>)</dd>
													<dt class="col-auto text-dark">작성일자</dt>
													<dd class="col-auto mb-0"><%:item.CreateDateTime %></dd>
													<%
														if(ViewBag.User.UserNo == item.ReplyUserNo)
														{
													%>
															<dt class="d-none">관리</dt>
																<dd class="col-auto mb-0">
																	<span>
																		<button type="button" class="btn btn-sm btn-outline-warning" data-toggle="modal" data-target="#divOpinionReply" onclick="fnOpinionReplyUpdate(<%:item.ReplyNo %>, '<%:item.ReplyContents %>')"><i class="bi bi-pencil"></i></button>
																		<button type="button" class="btn btn-sm btn-outline-danger" onclick="fnOpinionReplyDelete(<%:item.ReplyNo %>)"><i class="bi bi-trash"></i></button>
																	</span>
																</dd>
													<%
														}
													%>
												</dl>
											</div>
										</div>
									</div>
								</div>
						<%
							}
						%>
				<%
					}
					else 
					{
				%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 한줄 의견이 없습니다.</div>
				<%
					}
				%>
			</div>
		</div>
		<!-- 한줄 의견 정보 -->
		<div class="row">
			<div class="col-6">
			</div>
			<div class="col-6">
				<div class="text-right">
					<a href="<%:Model.Discussion.DiscussionAttribute.Equals("CDAB002") ? "/Discussion/Detail/" + Model.DiscussionOpinion.CourseNo + "/" + Model.DiscussionOpinion.DiscussionNo + "/" + Model.DiscussionOpinion.TeamNo : "/Discussion/Detail/" + Model.DiscussionOpinion.CourseNo + "/" + Model.DiscussionOpinion.DiscussionNo%>" class="btn btn-primary">목록</a>
				</div>
			</div>
		</div>
		<!-- 이전글 / 다음글 -->
		<div class="row mt-2">
			<%
				foreach (var item in Model.PrevNextList)
				{
					string url = string.Empty;
					url = "/Discussion/OpinionView/" + Model.DiscussionOpinion.CourseNo + "/" + Model.DiscussionOpinion.DiscussionNo + "/" + item.OpinionNo;
					if (item.ListType == "이전") 
					{ 
			%>
						<div class="col-12 col-md-6">
							<button type="button" class="btn text-primary text-left d-inline-block text-truncate" style="max-width:350px" onclick="fnMove('<%:url%>')">
								<i class="bi bi-chevron-left"></i>
								<span><%:item.OpinionTitle %></span>
							</button>
						</div>
			<%
					}
					else if (item.ListType == "다음") 
					{
			%>
						<div class="col-12 text-right col-auto">
							<button type="button" class="btn text-primary text-left d-inline-block text-truncate" style="max-width:350px" onclick="fnMove('<%:url%>')">
								<span><%:item.OpinionTitle %></span>
								<i class="bi bi-chevron-right"></i>
							</button>
						</div>
			<%
					}
				}
			%>
		</div>
		<!-- 의견 수정 -->
		<div class="modal fade show" id="divOpinion" tabindex="-1" aria-labelledby="Opinion" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-md">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="Opinion">의견 쓰기</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="card">
							<div class="card-body">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="txtOpinionTitle" class="form-label">
											제목 
											<strong class="text-danger">*</strong>
										</label>
										<input type="text" id="txtOpinionTitle" name="discussionOpinion.OpinionTitle" class="form-control" value="<%:Model.DiscussionOpinion.OpinionTitle%>">
									</div>
									<div class="form-group col-md-12">
										<label for="txtOpinionContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
										<textarea class="form-control" id="txtOpinionContents" name="discussionOpinion.OpinionContents" rows="10"><%:Model.DiscussionOpinion.OpinionContents %></textarea>
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
										<button type="button" class="btn btn-primary" id="btnOpinionSave">저장</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 의견 수정 -->

		<!-- 한줄 의견 수정 -->
		<div class="modal fade show" id="divOpinionReply" tabindex="-1" aria-labelledby="opinionReply" aria-modal="true" role="dialog">
			<div class="modal-dialog modal-md">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="opinionReply">한줄 의견 수정</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<div class="card">
							<div class="card-body">
								<div class="form-row">
									<div class="form-group col-md-12">
										<label for="txtDiscussionReplyUpdateReplyContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
										<input type="text" id="txtDiscussionReplyUpdateReplyContents" name="DiscussionReply.ReplyUpdateContents" class="form-control">
									</div>
								</div>
							</div>
							<div class="card-footer">
								<div class="row align-items-center">
									<div class="col">
										<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
									</div>
									<div class="col-auto text-right">
										<button type="button" class="btn btn-primary" id="btnOpinionReplyUpdate" onclick="fnOpinionReplySave()">저장</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 한줄 의견 수정 -->

		<input type="hidden" id="hdnCourseNo" name="DiscussionOpinion.CourseNo" value="<%:Model.DiscussionOpinion.CourseNo %>"/>
		<input type="hidden" id="hdnDiscussionNo" name="DiscussionOpinion.DiscussionNo" value="<%:Model.DiscussionOpinion.DiscussionNo %>"/>
		<input type="hidden" id="hdnOpinionNo" name="DiscussionOpinion.OpinionNo" value="<%:Model.DiscussionOpinion.OpinionNo %>"/>
		<input type="hidden" id="hdnOpinionReplyNo" name="DiscussionReply.ReplyNo"/>
		<input type="hidden" id="hdnRowState" name="DiscussionReply.RowState" value=""/>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 의견 수정 --%>
		$("#btnOpinionSave").click(function () {

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

			window.document.forms["mainForm"].action = "/Discussion/OpinionUpdate/<%:ViewBag.Course.CourseNo %>";
			window.document.forms["mainForm"].method = "post";
			window.document.forms["mainForm"].submit();

			fnPrevent();
		});

		<%-- 의견 삭제 --%>
		function fnOpinionDelete() {

			bootConfirm("삭제하시겠습니까 ?", function () {

				ajaxHelper.CallAjaxPost("/Discussion/OpinionDelete", { opinionNo: <%:Model.DiscussionOpinion.OpinionNo %> }, "fnCompleteOpinionDelete");
			});
		}

		function fnCompleteOpinionDelete() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {

					location.href = "/Discussion/Detail/" + <%:Model.DiscussionOpinion.CourseNo %> + "/" + <%:Model.DiscussionOpinion.DiscussionNo %>;
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 한줄의견 저장 --%>
		$("#btnOpinionReplySave").click(function () {
			$("#hdnRowState").val("C");

			fnOpinionReplySave();
		});

		<%-- 한줄의견 수정 --%>
		function fnOpinionReplyUpdate(replyNo, replyContents) {
			$("#txtDiscussionReplyUpdateReplyContents").val(replyContents);
			$("#hdnOpinionReplyNo").val(replyNo);
			$("#hdnRowState").val("U");

		}

		function fnOpinionReplySave() {

			if ($("#hdnRowState").val() == "C") {
				if ($("#txtDiscussionReplyReplyContents").val() == "") {
					bootAlert("한 줄 의견을 입력해주세요.", function () {
						$("#txtDiscussionReplyReplyContents").focus();
					});
					return false;
				}
			} else if ($("#hdnRowState").val() == "U") {
				if ($("#txtDiscussionReplyUpdateReplyContents").val() == "") {
					bootAlert("한 줄 의견을 입력해주세요.", function () {
						$("#txtDiscussionReplyUpdateReplyContents").focus();
					});
					return false;
				}
			}

			window.document.forms["mainForm"].action = "/Discussion/OpinionReplySave/<%:ViewBag.Course.CourseNo %>";
			window.document.forms["mainForm"].method = "post";
			window.document.forms["mainForm"].submit();

			fnPrevent();	
		}

		<%-- 한줄의견 삭제 --%>
		function fnOpinionReplyDelete(ReplyNo) {

			bootConfirm("삭제하시겠습니까 ?", function () {

				ajaxHelper.CallAjaxPost("/Discussion/OpinionReplyDelete", { replyNo: ReplyNo }, "fnCompleteOpinionReplyDelete");
			});
		}

		function fnCompleteOpinionReplyDelete() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {

					location.reload();
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 참여도 인정/취소 함수 --%>
		$("#btnParticipationY").click(function () {
			fnParticipationYesNo("Y");
		});

		$("#btnParticipationN").click(function () {
			fnParticipationYesNo("N");
		});

		var opinionNo;

		function fnParticipationYesNo(yesNo) {
			opinionNo = '|' + <%:Model.DiscussionOpinion.OpinionNo%> ;

			ajaxHelper.CallAjaxPost("/Discussion/ParticipationYesNo", { opinionNo: opinionNo, yesNo: yesNo }, "fnCompleteYesNo");
		}

		<%-- 공지사항 처리/취소 함수 --%>
		function fnTopOpinionYesNo() {
			ajaxHelper.CallAjaxPost("/Discussion/TopOpinionYesNo", { opinionNo: <%:Model.DiscussionOpinion.OpinionNo%>, yesNo: '<%:Model.DiscussionOpinion.TopOpinionYesNo%>' }, "fnCompleteYesNo");
		}

		function fnCompleteYesNo() {
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

		<%-- 리스트 이동 --%>
		function fnMove(url) {
			location.href = url;
			return false;
		}

	</script>
</asp:Content>
