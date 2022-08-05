<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.BoardViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form id="mainForm" action="/Board/List/<%= Model.CourseNo%>/<%= Model.MasterNo%>" method="post">
		<div class="card search-form mb-3">
			<div class="card-body pb-1">
				<div class="form-row">
					<div class="form-group col-md-2">
						<select id="ddlSearchType" name="SearchType" class="form-control">
							<option <%: (Model.SearchType.Equals("BoardTitle")) ? "selected='selected'" : ""%> value="BoardTitle">제목</option>
							<option <%: (Model.SearchType.Equals("Contents")) ? "selected='selected'" : ""%> value="Contents">내용</option>
							<option <%: (Model.SearchType.Equals("HangulName")) ? "selected='selected'" : ""%> value="HangulName">작성자</option>
						</select>
					</div>
					<div class="form-group col-md">
						<label for="Search_Text" class="sr-only">검색어 입력</label>
						<input class="form-control" title="검색어 입력" name="searchText" id="txtSearchText" value="<%:Model.SearchText%>" type="text">
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch();">
                            <span class="icon search">검색</span>
                        </button>
					</div>
				</div>
			</div>
		</div>

		<!--테이블-->
		<div class="card">
			<div class="card-header pb-0">
				<div class="text-right">
					<div class="form-group form-inline">
						<div class="col-6 form-inline p-0">
							<%
								if (Model.BoardMaster.IsNotice.Equals("Y"))
								{
							%>
							<label for="chkOpenYesNo" class="form-label mr-2">공지숨기기</label>
							<label class="switch">
								<input type="checkbox" name="HighFixHide" id="chkHighFixHide" value="<%:Model.HighFixHide %>" <%:Model.HighFixHide == "Y"? "checked":"" %> class="checkbox">
								<span class="slider round"></span>
							</label>
							<%
								}
							%>
						</div>
						<div class="col-6 p-0 text-right">
							<select name="pageRowSize" id="ddlPageRowSize" class="form-control form-control-sm">
								<option value="5" <%= Model.PageRowSize.Equals(5) ? "selected='selected'" : ""%>>5건</option>
								<option value="10" <%= Model.PageRowSize.Equals(10) ? "selected='selected'" : ""%>>10건</option>
								<option value="50" <%= Model.PageRowSize.Equals(50) ? "selected='selected'" : ""%>>50건</option>
								<option value="100" <%= Model.PageRowSize.Equals(100) ? "selected='selected'" : ""%>>100건</option>
							</select>
						</div>
					</div>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="table-responsive-lg mt-3">
					<table class="table table-board" summary="공지사항입니다.">
						<caption>공지사항</caption>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<%-- 게시판 마스터 읽음여부 사용시 --%>
								<% if (ViewBag.User.UserNo > 0 && Model.BoardMaster.IsRead.Equals("Y")) { %>
									<th scope="col" class="d-none d-md-table-cell">읽음</th>
								<%	} %>
								<th scope="col">제목</th>
								<%-- 게시판 마스터 파일첨부 사용시 --%>
								<% if (Model.BoardMaster.BoardIsUseFileYesNo.Equals("Y")) { %>
									<th scope="col" class="d-none d-md-table-cell">첨부</th>
								<%	} %>
								<th scope="col" class="d-none d-md-table-cell">작성자</th>
								<th scope="col">등록일</th>
								<th scope="col" class="d-none d-md-table-cell">조회</th>
								<%-- 게시판 마스터 이벤트 사용시 좋아요 수, 궁금해요 수 표시 --%>
								<% if (Model.BoardMaster.IsEvent.Equals("Y")) { %>
									<th scope="col" class="d-none d-md-table-cell">좋아요</th>
									<th scope="col" class="d-none d-md-table-cell">궁금해요</th>
								<%	} %>
							</tr>
						</thead>
						<tbody>
							<%
								string strReadYN = string.Empty;
								string strFileYN = string.Empty;

								if (Model.BoardMaster.IsNotice.Equals("Y") && Model.HighestFixList != null)
								{
									foreach (var item in Model.HighestFixList)
									{
										strReadYN = item.InquiryUserNo == 0 ? "" : "<i class='bi bi-check-lg text-success'></i>";
										if(item.FileNo > 0)
										{
											if (item.IsSecret == 0 || item.CreateUserNo == ViewBag.User.UserNo || ViewBag.User.UserNo == item.ProfessorNo || true.Equals(ViewBag.IsAdmin) || true.Equals(ViewBag.IsProfessor))
											{
												strFileYN = "<button type=\"button\" onclick='fnFileDownload(" + item.FileNo + ")'><i class='bi bi-paperclip'></i><span class='sr-only'>다운로드</span></button>";
											}
											else
											{
												strFileYN = "<i class='bi bi-paperclip'></i>";
											}
										}
										else
										{
											strFileYN = "";
										}
							%>
										<tr>
											<% 
												if (item.IsNewContents.Equals("Y")) //신규게시글인지 확인
												{
											%>
													<th><div class="icon new"><span class="sr-only">신규</span></div></th>
											<%
												}
												else
												{
											%>
													<td class="text-center text-nowrap"><strong class="text-point">공지</strong></td> <%-- 공지 표시 --%>
											<%	
												}
											%>
											<%
												if(ViewBag.User.UserNo > 0 && Model.BoardMaster.IsRead.Equals("Y"))
												{ 
											%>
													<td class="text-center d-none d-md-table-cell"><%=strReadYN %></td>
											<%
												}
											%>
											<td class="text-left">
												<a href="javascript:void(0);" onclick="fnGoDetail('<%:item.BoardNo%>')"><%:item.BoardTitle %></a>
											</td>
											<%
												if(Model.BoardMaster.BoardIsUseFileYesNo.Equals("Y"))
												{
											%>
													<td class="text-center d-none d-md-table-cell"><%=strFileYN %></td>
											<%
												}
											%>
											<% 
												if (item.IsAnonymous == 0)
												{
											%>
													<td class="text-center d-none d-md-table-cell"><%:item.HangulName %></td>
											<%
												}
												else
												{
											%>
													<td class="text-center d-none d-md-table-cell"><span>- 익명 -</span></td>
											<%
												}
											%>
											<td class="text-center text-nowrap"><%:item.CreateDateTime%></td>
											<td class="text-right d-none d-md-table-cell"><%:item.ReadCount.ToString("#,##0") %></td>
											<%-- 이벤트 사용여부에 따라 좋아요 수, 궁금해요 수 표시 --%>
											<% if (Model.BoardMaster.IsEvent.Equals("Y")) { %>
												<td class="text-center d-none d-md-table-cell"><%:item.LikeCount%></td>
												<td class="text-center d-none d-md-table-cell"><%:item.WonderCount%></td>
											<%	} %>
										</tr>
							<%
									}
								}
							%>

							<%
								foreach (var item in Model.BoardList)
								{
									strReadYN = item.InquiryUserNo == 0 ? "" : "<i class='bi bi-check-lg text-success'>";
									if(item.FileNo > 0)
									{
										if (item.IsSecret == 0 || item.CreateUserNo == ViewBag.User.UserNo || ViewBag.User.UserNo == item.ProfessorNo || true.Equals(ViewBag.IsAdmin) || true.Equals(ViewBag.IsProfessor))
										{
											strFileYN = "<button type=\"button\" onclick='fnFileDownload(" + item.FileNo + ")'><i class='bi bi-paperclip'></i><span class='sr-only'>다운로드</span></button>";
										}
										else
										{
											strFileYN = "<i class='bi bi-paperclip'></i>";
										}
									}
									else
									{
										strFileYN = "";
									}
							%>
								<tr>
							
									<% 
										if (item.IsNewContents.Equals("Y")) //신규게시글인지 확인
										{
									%>
											<th><div class="icon new"><span class="sr-only">신규</span></div></th>
									<%
										}
										else
										{
									%>
											<td class="text-center"><%:item.Row %></td> <%-- 줄번호 표시--%>
									<%	
										}
									%>
									<%
										if(ViewBag.User.UserNo > 0 && Model.BoardMaster.IsRead.Equals("Y"))
										{ 
									%>
											<td class="text-center d-none d-md-table-cell"><%=strReadYN %></td>
									<%
										}
									%>
									<td class="text-left">
										<%
											if (item.Depth > 0)
											{
												for(int i=1; i<=item.Depth; i++)
												{
													if(item.BoardTitle.Length > 5)
													{
														string replyCheck = item.BoardTitle.Substring(0,5);
														if(replyCheck == "[RE] ")
														{
															item.BoardTitle = item.BoardTitle.Substring(5);
														}
													}
												}
										%>
											<div class="d-inline ml-<%:2*(item.Depth - 1)%>">
												<i class="bi bi-arrow-return-right"></i>
												<strong class="text-primary">[답변]</strong>
											</div>
										<%  
											}
										%>
										<% 
											if (Model.BoardMaster.BoardIsSecretYesNo.Equals("Y") && Model.BoardMaster.Equals(2)) //2: HelpDeskQA(Q&A 게시판)
											{
												if (ViewBag.User.UserNo == item.CreateUserNo || ViewBag.User.UserNo == item.ParentUserNo)
												{
										%>
													<a href="javascript:void(0);" onclick="fnGoDetail('<%:item.BoardNo%>')"><%:item.BoardTitle %><%:item.ReplyCount > 0 ? string.Format("({0})", item.ReplyCount) : "" %></a>
										<%
												}
												else
												{
										%>
													<span><%:item.BoardTitle %><%:item.ReplyCount > 0 ? string.Format("({0})", item.ReplyCount) : "" %></span>
										<%
												}
											}
											else
											{
												if (item.IsSecret == 0 || item.CreateUserNo == ViewBag.User.UserNo || ViewBag.User.UserNo == item.ProfessorNo || true.Equals(ViewBag.IsAdmin) || true.Equals(ViewBag.IsProfessor))
												{
										%>
													<strong class="text-danger"><%:item.IsFinish == 1 ? "[마감]" : "" %></strong>
													<a href="javascript:void(0);" onclick="fnGoDetail('<%:item.BoardNo%>')"><%:item.BoardTitle %><%:item.ReplyCount > 0 ? string.Format("({0})", item.ReplyCount) : "" %></a>
										<%
												}
												else
												{
										%>
													<strong class="text-danger"><%:item.IsFinish == 1 ? "[마감]" : "" %></strong>
													- 비밀글 - 
										<%
												}

												if (item.IsSecret == 1)
												{
										%>
													<i class="bi bi-lock-fill" title="비밀글"></i>
													<span class="sr-only">비밀글</span>
										<%
												}
										%>
										
										<%
											}
										%>
									</td>
									<%
										if(Model.BoardMaster.BoardIsUseFileYesNo.Equals("Y"))
										{
									%>
											<td class="text-center d-none d-md-table-cell"><%=strFileYN %></td>
									<%
										}
									%>
									<% 
										if (item.IsAnonymous == 0) 
										{
									%>
											<td class="text-center d-none d-md-table-cell"><%:item.HangulName %></td>
									<%
										} 
										else 
										{
									%>
											<td class="text-center d-none d-md-table-cell"><span>- 익명 -</span></td>
									<%
										} 
									%>
									<td class="text-center"><%:item.CreateDateTime%></td>
									<td class="text-center d-none d-md-table-cell"><%:item.ReadCount.ToString("#,##0") %></td>
									<%-- 이벤트 사용여부에 따라 좋아요 수, 궁금해요 수 표시 --%>
									<% if (Model.BoardMaster.IsEvent.Equals("Y")) { %>
										<td class="text-center d-none d-md-table-cell"><%:item.LikeCount%></td>
										<td class="text-center d-none d-md-table-cell"><%:item.WonderCount%></td>
									<%	} %>
								</tr>
							<%
								}
							%>
							<%
								if(Model.BoardList != null && Model.HighestFixList != null)
								{
									if (Model.BoardList.Count() < 1 && Model.HighestFixList.Count() < 1)
									{
							%>
								<tr>
									<td colspan="<%: Model.BoardMaster.IsEvent.Equals("Y") ? "7" : "6" %>" class="text-center">검색된 게시글이 없습니다.</td>
								</tr>
							<%	
									}
								}
								else
								{
									if (Model.BoardList.Count() < 1)
									{
							%>
									<tr>
										<td colspan="<%: Model.BoardMaster.IsEvent.Equals("Y") ? "7" : "6" %>" class="text-center">검색된 게시글이 없습니다.</td>
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
		<!--//테이블-->

		<%
			if (Model.BoardAuthority.IsWrite.Equals("Y"))
			{
		%>
		<div class="row">
			<div class="col-12 mt-2 text-right">
				<a  href="/Board/Write/<%:Model.CourseNo %>/<%:Model.MasterNo%>/C" class="btn btn-primary">등록</a>
			</div>
		</div>
		<%
			}
		%>

		<!-- paginate-->
		<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
		<!--//paginate-->
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		//페이지 로드될때 새로고침 (디테일 화면에서 돌아올때, 조회수 및 읽음 확인 보여주기 위함.)
		$(document).on("pageload", function () {
			window.location.reload(true);
		});

		$(document).ready(function () {
            $("#ddlPageRowSize").change(function () {
                $('form[id=mainForm]').submit();
			});

			$("#chkHighFixHide").change(function () {
				$(this).val("N");
				if ($(this).prop("checked")) {
					$(this).val("Y");
				}
				$('form[id=mainForm]').submit();
			});

        });

        //검색
		function fnSearch() {
            $('form[id=mainForm]').submit();
            return false;
		}

		function fnGoDetail(boardNo) {
			window.location = "/Board/Detail/" + <%:Model.CourseNo %> + "/" + <%:Model.MasterNo%> + "/" + boardNo + "?SearchType=" + '<%:Model.SearchType%>' + "&HighFixHide=" + '<%:Model.HighFixHide%>' + "&SearchText=" + encodeURI(encodeURIComponent($("#txtSearchText").val())) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PublicGubun=" + <%:Model.PublicGubun%> + "&PageNum=" + <%:Model.PageNum%>;
		}
	</script>
</asp:Content>