<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.BoardViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form id="mainForm" action="/Board/Detail" method="post">
        <div class="card card-style01 mt-4">
			<div class="card-header">
				<div class="row align-items-center">
					<div class="col-md">
						<%
							if (Model.BoardMaster.BoardIsUseAcceptYesNo.Equals("Y")) //참여도 점수 반영여부
							{
								if (ViewBag.IsAdmin || ViewBag.Course.IsProf == 1)
								{
						%>
										<div class="form-group">
											<div class="form-check pl-0">
												<input type="checkbox" name="input" id="chkAcceptYes" class="checkbox" <%:Model.Board.ParticipationAcceptYesNo == "Y"? "checked":"" %> > <%-- <%: Convert.ToBoolean(ViewBag.IsCurrentTerm) ? "" : "style=\"display:none;\"" %> --%>
												<label class="form-check-label text-danger" for="chkAcceptYes">참여도 점수반영</label>
											</div>
										</div>
						<%
								}
							}
						%>
					</div>
					<div class="col-md-auto text-right">												
						<dl class="row dl-style01">
							<dt class="col-auto text-dark">작성자</dt>
							<dd class="col-auto"><button type="button" onclick="fnStudentInfo(<%:Model.Board.CreateUserNo %>);"><%:Model.Board.HangulName%></button></dd>
							<dt class="col-auto text-dark">등록일</dt>
							<dd class="col-auto"><%:Model.Board.CreateDateTime%></dd>
							<dt class="col-auto text-dark">조회</dt>
							<dd class="col-auto"><%:Model.Board.ReadCount%></dd>
						</dl>
					</div>
				</div>
				<a href="#" class="card-title01 text-dark mb-0 d-block text-truncate"><%:Model.Board.BoardTitle%></a>
			</div>
			<div class="card-body">
			    <div class="">
					<%: Html.Raw(Server.UrlDecode(Model.Board.HtmlContents ?? "").Replace(System.Environment.NewLine, "<br />")) %>
				</div>
			</div>
		    <div class="card-footer <%: ( Model.FileList != null && Model.FileList.Count > 0 ) ? "" : "d-none" %>">
                <%
                    if (Model.FileList != null)
                    {
                        foreach (var item in Model.FileList)
                        {
                %>
                            <div class="font-size-15">
				                <button type="button" onclick="fileDownLoad(<%:item.FileNo %>)" title="다운로드" class="text-left">
					                <i class="bi bi-paperclip"></i>
				                    <span><%:item.OriginFileName%></span>
					            </button>
					            <button type="button" class="btn btn-sm btn-danger ml-2 d-none" onclick="fnFileDeleteNew(<%:item.FileNo %>, this);" title="삭제">삭제</button>
				            </div>
                <%
                        }
                    }
                %>
				<%
					if (Model.BoardMaster.IsEvent.Equals("Y"))
					{
				%>
						<div class="text-right mt-2">
							<button type="button" class="btn btn-sm <%: Model.BoardEvent.LikeParticipationFlag == 1 ? "btn-primary" : "btn-outline-primary"  %>" onclick="fnEventChange('BENT001', '<%: Model.BoardEvent.LikeParticipationFlag == 0 ? "C" : "D" %>');" <%: Model.BoardEvent.LikeParticipationFlag == 0 ? "" : "class=on" %>><span class="badge badge-primary"><%:Model.BoardEvent.LikeCount %></span> 좋아요 <i class="bi bi-hand-thumbs-up"></i> </button>
							<button type="button" class="btn btn-sm <%: Model.BoardEvent.WonderParticipationFlag == 1 ? "btn-info" : "btn-outline-info"  %>" onclick="fnEventChange('BENT002', '<%: Model.BoardEvent.WonderParticipationFlag == 0 ? "C" : "D" %>');" <%: Model.BoardEvent.WonderParticipationFlag == 0 ? "" : "class=on" %>><span class="badge badge-info"><%:Model.BoardEvent.WonderCount %></span>  궁금해요 <i class="bi bi-patch-question"></i> </button>
						</div>
				<%
					}
				%>
			</div>
        </div>

		<%-- 목록버튼 --%>
        <div class="text-right mt-4">
			<button class="btn btn-secondary" type="button" onclick="fnGoList()">목록</button>
			<% 
				if (ViewBag.User.UserNo == Model.Board.CreateUserNo || ViewBag.IsAdmin)
                {
			%>
					<%:Html.ActionLink("수정", "Write", new { param1 = Model.CourseNo, param2 = Model.MasterNo, param3 = "U", param4 = Model.Board.BoardNo },new {@class="btn btn-warning" })%>
					<button type="button" id="btnDelete" class="btn btn-danger">삭제</button>
			<%
				}
			%>					
	    </div>

		<%-- 한줄 의견 등록 --%>
		<%
			if (Model.BoardMaster.BoardIsUseReplyYesNo.Equals("Y"))
			{
		%>
			<%  
				if (ViewBag.IsAdmin || ViewBag.Course.IsProf == 1)
				{
			%>
				<div class="card card-style03 rounded mt-4 border-white">
					<div class="card-body pb-2">
						<div class="form">
							<div class="form-group mb-0">
								<label for="txtReplyContent" class="form-label">댓글 <span>(<strong><%:Model.BoardReplyCount%></strong>)</span></label> <%-- 한줄의견 괄호 안 숫자 확인 필요 --%>
								<textarea id="txtReplyContent" name="replyContent" rows="2" class="form-control" placeholder="댓글을 입력해주세요."></textarea>
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="text-right">
									<button type="button" id="btnReplySave" class="btn btn-sm btn-primary">등록</button>
						</div>
					</div>
				</div>
			<%
				}
			%>

				<%
					foreach (var item in Model.BoardContentReplyList)
					{
				%>
						<div class="card card-style03 rounded mt-4 border-white">
							<div class="card-header border-bottom-0 bg-light">
								<div class="row align-items-center font-size-14">
									<div class="col-auto">
										<strong><%:item.UserName%></strong>
										<span class=""><%:item.CreateDateTime%></span>
									</div>
									<%
										if (Model.BoardMaster.BoardIsUseAcceptYesNo.Equals("Y"))
										{
											if (item.AnswerYesNo.Equals("Y")) //정답채택댓글
											{
									%>
												<div class="col-auto">
													<div class="font-weight-bold text-primary">
														<i class="bi bi-patch-check-fill"></i> 정답채택댓글
													</div>
												</div>
									<%
											}
									%>
									<%
											if (ViewBag.IsAdmin)
											{
									%>
												<div class="col-lg">
													<div class="form-check pl-0">
														<input type="checkbox" name="replyAcceptYes" id="chkReplyAcceptYes_<%:item.ReplyNo %>" value="<%:item.ReplyNo %>" <%:item.ParticipationAcceptYesNo.Equals("Y") ? "checked" : "" %> class="checkbox">
														<label class="form-check-label text-danger font-weight-bold ml-md-1" for="chkReplyAcceptYes_<%:item.ReplyNo %>">해당 댓글을 참여도 점수에 반영</label>
													</div>
												</div>
									<%
											}
										}
									%>
									<div class="col-lg-auto text-right">
										<%
											if (Model.BoardMaster.BoardIsUseAcceptYesNo.Equals("Y"))
											{
												if (ViewBag.IsAdmin)
												{
										%>
													<button type="button" onclick="fnReplyAnswer(<%:item.ReplyNo %>, '<%:item.AnswerYesNo.Equals("Y") ? "N" : "Y" %>');" class="btn btn-sm btn-primary">정답선택</button>
										<%
													if (item.AnswerYesNo.Equals("Y"))
													{
										%>
														<a href="/Board/Write/<%:Model.CourseNo %>/<%:Model.MasterNo %>/R/<%:Model.Board.BoardNo%>?AnswerRepleNo=<%:item.ReplyNo %>" class="btn btn-sm btn-info">답글로 연결</a>
										<%
													}
												}
											}
										%>
										
										
										<% 
											if (ViewBag.User.UserNo == item.CreateUserNo)
											{
										%>
												<button type="button" onclick="fnReplyUpdate(this, <%:item.ReplyNo %>);" class="btn btn-sm btn-warning">수정</button>
												<button type="button" onclick="fnReplyDelete(<%:item.ReplyNo %>);" class="btn btn-sm btn-danger">삭제</button>
										<%
											}
										%>
									</div>
								</div>
							</div>
							<div class="card-body py-0 pb-2">
								<div class="form">
									<div class="form-group mb-0">
										<label for="txtReplyContents_<%:item.ReplyNo %>" class="sr-only">댓글 <span>(<strong>0</strong>)</span></label>
										<textarea id="txtReplyContents_<%:item.ReplyNo %>" name="" readonly rows="2" class="form-control"><%:Html.Raw(Server.UrlDecode(item.Contents)) %></textarea>
									</div>
								</div>
							</div>
							<div class="card-footer">
								<% 
									if (ViewBag.User.UserNo == item.CreateUserNo)
									{
								%>
										<div class="text-right">
											<button type="button" id="btnAplySave_<%:item.ReplyNo %>" onclick="fnReplyUpdateSave(<%:item.ReplyNo %>);" style="display:none" class="btn btn-sm btn-primary">등록</button>
										</div>
								<%
									}
								%>
							</div>
						</div>
				<%
					}
				%>
		<%
			} 
		%>

		<%-- 페이징 처리 --%>
		<%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.BoardReplyCount, Model.Dic)%>

		<%-- 이전글/다음글 --%>
        <div class="row mt-2">
			<div class="col-12 col-md-6">
            <%
				foreach (var item in Model.PrevNextList)
				{
                    string url = string.Empty;
                    url = "/Board/Detail/" + Model.CourseNo + "/" + Model.MasterNo + "/" + item.BoardNo;
					if (item.ListType == "이전")
					{
            %>
                        <button type="button" class="btn text-primary text-left d-inline-block text-truncate" style="max-width:350px" onclick="fnMove('<%:url%>');" >
                            <i class="bi bi-chevron-left"></i>
                            <span><%:item.BoardTitle %></span>
                        </button>
            <%
				    }
				}
            %>
			</div>
            <div class="col-12 text-right col-md-6">
            <%
				foreach (var item in Model.PrevNextList)
				{
                    string url = string.Empty;
                    url = "/Board/Detail/" + Model.CourseNo + "/" + Model.MasterNo + "/" + item.BoardNo;
					if (item.ListType == "다음")
				    {
            %>
                        <button type="button" class="btn text-primary text-left d-inline-block text-truncate" style="max-width:350px" onclick="fnMove('<%:url%>');" >
                            <span><%:item.BoardTitle %></span>
                            <i class="bi bi-chevron-right"></i>
                        </button>
            <%
					}
				}
            %>
			</div>
        </div>
    <input type="hidden" id="hdnMasterNo"   name="MasterNo" value="<%:Model.MasterNo %>" />
    <input type="hidden" id="hdnCourseNo"   name="CourseNo" value="<%:Model.CourseNo %>" />
    <input type="hidden" id="hdnBoardNo"   name="Board.BoardNo" value="<%:Model.Board.BoardNo %>" />
	<input type="hidden" id="hdnSearchText" value="<%:Model.SearchText %>"/>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

		var ajax = new AjaxHelper();

		$(document).ready(function () {
			<%
				if (!Model.BoardAuthority.IsRead.Equals("Y"))
				{
			%>
			bootAlert("읽기 권한이 없습니다.", function () {
				history.back();
			});
			<%
				}
			%>
		});

        //리스트이동
        function fnMove(url) {
			location.href = url;
            return false;
		}

		//게시물삭제
		$("#btnDelete").click(function () {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;

			bootConfirm("해당 게시물을 삭제 하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Board/Delete", { param1: <%:Model.CourseNo %>, param2: <%:Model.MasterNo %>, param3: <%:Model.Board.BoardNo %> }, "fnCompleteDelete");
			});
		});

		function fnCompleteDelete() {
			bootAlert("삭제되었습니다", function () {
				location.href = "/Board/List/<%:Model.CourseNo %>/<%:Model.MasterNo %>";
			});
		}

		function fnCompleteEstimationEdit() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("변경되었습니다.", function () {
					location.reload();
				});
			}
		}


		//한줄의견등록
		$("#btnReplySave").click(function () {
			$("#ApealOKYN").val($("input[name='ApealOKYNVALUE']:checked").first().val());
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			if ($("#txtReplyContent").val() == "") {
				bootAlert("내용을 입력하세요", 1);
				return false;
			}
			window.document.forms["mainForm"].action = "/Board/ReplyCreate/<%:Model.CourseNo %>";
			window.document.forms["mainForm"].method = "post";
			window.document.forms["mainForm"].submit();

		});

		function fnEventChange(EventCode, EventFlag) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;

			ajax.CallAjaxPost("/Board/EventChange", { paramRowState: EventFlag, paramBoardNo: <%:Model.Board.BoardNo %>, paramEventCode: EventCode }, "fnCompleteEventChange");
			return false;
		}

		function fnCompleteEventChange() {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			var result = ajax.CallAjaxResult();
			if (result > 0) {
				window.location.reload();
			}
		}

		$("#chkAcceptYes").click(function () {
			var strYeseNo = "";

			if ($(this).is(":checked") == true) { strYeseNo = "Y"; }
			else { strYeseNo = "N"; }

			ajax.CallAjaxPost("/Board/SetParticipationAcceptYesNo", { paramBoardNo: <%:Model.Board.BoardNo%>, paramYesNo: strYeseNo }, "fnCompleteAcceptYesNo", "'" + strYeseNo + "'");

		});

		$("input[name=replyAcceptYes]").click(function () {

			var strYeseNo = "";

			if ($(this).is(":checked") == true) { strYeseNo = "Y"; }
			else { strYeseNo = "N"; }

			ajax.CallAjaxPost("/Board/SetReplyParticipationAcceptYesNo", { paramReplyNo: $(this).val(), paramYesNo: strYeseNo }, "fnCompleteAcceptYesNo", "'" + strYeseNo + "'");

		});

		function fnCompleteAcceptYesNo(type) {
			var msg = "";
			if (type == "Y") {
				msg = "참여도를 반영했습니다.";
			}
			else {
				msg = "참여도를 반영을 취소했습니다.";
			}

			var result = ajax.CallAjaxResult();
			if (result > 0)
				bootAlert(msg);
			else
				bootAlert("참여도를 반영에 실패했습니다.");
		}

		function fnReplyAnswer(replyNo, answerYN) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			ajax.CallAjaxPost("/Board/ReplyAnswerUpdate", { paramReplyNo: replyNo, paramYesNo: answerYN }, "fnCompleteReplyUpdate");
			return false;
		}

		function fnCompleteReplyUpdate() {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			var result = ajax.CallAjaxResult();
			if (result > 0) {
				window.location.reload();
			}
		}

		function fnReplyUpdate(obj, replyNo) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			$(obj).parent().parent().parent().find("#btnAplySave").show();
			$("#btnAplySave_" + replyNo).show();
			$("#txtReplyContents_" + replyNo).attr("readonly", false);
			return false;
		}

		function fnReplyUpdateSave(replyNo) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			ajax.CallAjaxPost("/Board/ReplyUpdate", { paramReplyNo: replyNo, paramContent: $("#txtReplyContents_" + replyNo).val() }, "fnCompleteReplyUpdate");
			return false;
		}

		function fnReplyDelete(replyNo) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			if (confirm("해당 게시물 댓글을 삭제합니다.")) {
				ajax.CallAjaxPost("/Board/ReplyDelete", { paramReplyNo: replyNo }, "fnCompleteReplyDelete");
			}
			return false;
		}

		function fnCompleteReplyDelete() {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
			var result = ajax.CallAjaxResult();
			if (result > 0) {
				bootAlert("해당 게시물을 삭제했습니다.");
				window.location.reload();
			}
		}

		function fileDownLoad(fileNo) {
			location.href = '/Common/FileDownLoad/' + fileNo;
		}

		function fnGoList() {
			
			window.location = "/Board/List/" + <%:Model.CourseNo %> + "/" + <%:Model.MasterNo%> + "?SearchType=" + '<%:Model.SearchType%>' + "&HighFixHide=" + '<%:Model.HighFixHide%>' + "&SearchText=" + encodeURIComponent($("#hdnSearchText").val()) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PublicGubun=" + <%:Model.PublicGubun%>+ "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>

