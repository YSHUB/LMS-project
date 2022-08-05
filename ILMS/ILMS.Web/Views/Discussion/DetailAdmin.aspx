<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.DiscussionViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
  <form action="/Discussion/DetailAdmin/<%:Model.Course.CourseNo %>" id="mainForm" method="post">
		<div id="content">
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
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>학습기간</dt>
						<dd class="col-9 col-md-5 pl-4"><%:DateTime.Parse(Model.Course.TermStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(Model.Course.TermEndDay).ToString("yyyy-MM-dd") %></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>강좌</dt>
						<dd class="col-9 col-md-2 pl-4"><%:Model.Course.CampusName %> / <%:Model.Course.ClassNo %></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>학년</dt>
						<dd class="col-9 col-md-2 pl-4"><%:Model.Course.TargetGradeName %></dd>
					</dl>
					<dl class="row dl-style02">						
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>이수구분</dt>
						<dd class="col-9 col-md-5 pl-4"><%:Model.Course.ClassificationName %></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>학점</dt>
						<dd class="col-9 col-md-2 pl-4"><%:Model.Course.Credit %></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-2 pl-4"><%:Model.Course.StudentCount %>명</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-7 pl-4"><%:Model.Course.HangulName %></dd>

					</dl>
				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
					
					<%
						if (Model.DiscussionList.Count > 0)
						{
					%>
							<h3 class="title04">토론 리스트<strong class="text-primary">(<%:Model.DiscussionList.Count() %>건)</strong></h3>
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
										<table class="table table-hover table-sm table-striped table-horizontal" summary="토론 제출 정보 목록">
											<thead>
												<tr>
													<th scope="col">토론제목</th>
													<th scope="col" class="d-none d-md-table-cell">개설자</th>
													<th scope="col">참여글수</th>
													<th scope="col" class="d-none d-lg-table-cell">토론기간</th>
													<th scope="col">상태</th>
													<th scope="col">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.DiscussionList)
													{
												%>
														<tr>
															<td><%:item.DiscussionSubject %></td>
															<td class="d-none text-center d-md-table-cell"><%:item.CreateUserName %></td>
															<td><%:item.OpinionCount %></td>
															<td class="d-none text-center d-md-table-cell"><%:DateTime.Parse(item.DiscussionStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(item.DiscussionEndDay).ToString("yyyy-MM-dd") %></td>
															<td><%:item.DiscussionSituation %></td>
															<td class="text-center"><button type="button" class="font-size-20 text-primary" onclick="fnView(<%:item.DiscussionNo %>);" title="상세보기"><i class="bi bi-card-list"></i></button></td>
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
						else 
						{
					%>
							<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 토론이 없습니다.</div>
					<%
						}
					%>
					</div>
				<div class="col-12 mt-2 d-none" id="divDetailList">				
					<h3 class="title04">참여 대상 리스트<strong class="text-primary" id="strOpinionCnt">(0건)</strong></h3>
					<div class="card card-style01 mt-2" id="divOpinionList">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto">
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
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover" id="personalTable">
									<caption>토론 참여자 리스트</caption>
									<thead>
										<tr>
											<th scope="row"><input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
											<th scope="row">번호</th>												
											<th scope="row" class="d-none" id="thTeamName">팀명</th>												
											<th scope="row" class="text-nowrap text-left d-none d-md-table-cell" >소속</th>
											<th scope="row">성명</th>
											<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
											<th scope="row" class="d-none d-md-table-cell">학적</th>
											<th scope="row" class="d-none d-md-table-cell">참여글</th>
											<th scope="row" class="d-none d-md-table-cell">인정글</th>
											<th scope="row" class="text-nowrap">인정점수</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 alert bg-light alert-light rounded text-center mt-2 d-none" id="emptyDiv"><i class="bi bi-info-circle-fill"></i> 참여자가 없습니다.</div>
			</div>
			<div class="row">
				<div class="col-6">
				</div>
				<div class="col-6">
					<div class="text-right">
						<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" id="hdnDiscussionNo" name="Discussion.DiscussionNo" value="<%:Model.Discussion != null ? Model.Discussion.DiscussionNo : 0 %>"/>
		<input type="hidden" name="SortType" id="hdnSortType" value="<%:Model.SortType %>">
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 정렬 타입 --%>
		$(document).ready(function () {

			$('#btnSort').click(function () {
				var sortGubun = "";
				var sortGubunTxt = "";

				sortGubun = ($("#hdnSortType").val().trim() == "UserID") ? "HangulName" : "UserID";
				sortGubunTxt = ($("#hdnSortType").val().trim() == "UserID") ? "<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순" : "성명순";

				$("#hdnSortType").val(sortGubun);
				$("#btnSort").text("");
				$("#btnSort").text(sortGubunTxt);

				fnOpinionList();
			});

		});

		<%-- 토론 참여자 리스트 조회 --%>
		function fnView(discussionNo) {

			$("#hdnDiscussionNo").val(discussionNo);
			$("#divDetailList").removeClass("d-none");
			fnOpinionList();
		}

		<%-- 토론 참여자 리스트 조회 --%>
		function fnOpinionList() {

			ajaxHelper.CallAjaxPost("/Discussion/OpinionList", { courseNo: <%:Model.Course.CourseNo %>, discussionNo: $("#hdnDiscussionNo").val(), sortType: $("#hdnSortType").val() }, "fnCompleteOpinionList", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteOpinionList() {

			var result = ajaxHelper.CallAjaxResult();
			var htmlStr = "";

			$("#strOpinionCnt").html("");
			$("#strOpinionCnt").html("(" + result.DiscussionOpinionList.length + "건)");
			
			if (result.DiscussionOpinionList.length > 0) {

				$("#personalTable > tbody").empty();
				$("#divOpinionList").removeClass("d-none");
				$("#emptyDiv").addClass("d-none");

				for (var i = 0; i < result.DiscussionOpinionList.length; i++) {

					if (result.DiscussionOpinionList[i].TeamName != null) {
						$("#thTeamName").removeClass("d-none");
					} else {
						$("#thTeamName").addClass("d-none");
					}

					htmlStr += "<tr>";
					htmlStr += "<th scope='row'><input type='checkbox' name='chkSel' id='chkSel' value='" + result.DiscussionOpinionList[i].UserNo + "' class='checkbox'><input type='hidden' value='" + result.DiscussionOpinionList[i].UserNo + "'><input type='hidden' value='" + result.DiscussionOpinionList[i].HangulName + "(" + result.DiscussionOpinionList[i].UserID + ")'></th>";
					htmlStr += "<td>" + (i+1) + "</td>";
					if (result.DiscussionOpinionList[i].TeamName != null)
					{
						htmlStr += "<td class=''>" + result.DiscussionOpinionList[i].TeamName + "</td>";
					}
					htmlStr += "<td class='text-nowrap text-left d-none d-md-table-cell'>" + result.DiscussionOpinionList[i].AssignName + "</td>";
					htmlStr += "<td><span class='text-nowrap text-dark d-block'>" + result.DiscussionOpinionList[i].HangulName + "</span></td>";
					htmlStr += "<td><span class='text-nowrap text-secondary font-size-15'>" + result.DiscussionOpinionList[i].UserID + "</span></td>";
					htmlStr += "<td class='d-none d-md-table-cell'>" + result.DiscussionOpinionList[i].HakjeokGubunName + "</td>";
					htmlStr += "<td class='d-none d-md-table-cell'>" + result.DiscussionOpinionList[i].OpinionCount + "</td>";
					htmlStr += "<td class='d-none d-md-table-cell'>" + result.DiscussionOpinionList[i].ParticipationCount + "</td>";
					htmlStr += "<td class='text-right'>" + result.DiscussionOpinionList[i].ParticipationRateScore + "</td>";
					htmlStr += "</tr>";
				}

				$("#personalTable > tbody").html(htmlStr);

			} else {
				$("#thTeamName").removeClass("d-none");
				$("#divOpinionList").addClass("d-none");
				$("#emptyDiv").removeClass("d-none");
			}
		}

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {

			if (<%:Model.DiscussionList.Count%> > 0) {
				var param1 = <%:Model.Course.CourseNo %>;

				window.location = "/Discussion/DetailAdminExcel/" + param1.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function fnGo() {
			
			window.location.href = "/Discussion/ListAdmin/" + <%:Model.Course.ProgramNo %> + "?ProgramNo=" + '<%:Model.Course.ProgramNo %>' + "&TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}
	</script>
</asp:Content>
