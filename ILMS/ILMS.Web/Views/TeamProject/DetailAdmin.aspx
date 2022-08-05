<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamProjectViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/TeamProject/DetailAdmin/<%:Model.Course.CourseNo %>" id="mainForm" method="post">
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
					<%
						if (Model.Course.ProgramNo.ToString() != "2")
						{
					%>

					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>학습기간</dt>
						<dd class="col-9 col-md-5"><%:DateTime.Parse(Model.Course.TermStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(Model.Course.TermEndDay).ToString("yyyy-MM-dd") %></dd>
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>강좌</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CampusName %> / <%:Model.Course.ClassNo %></dd>
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>학년</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TargetGradeName %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i>이수구분</dt>
						<dd class="col-9 col-md"><%:Model.Course.ClassificationName %></dd>
						<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i>학점</dt>
						<dd class="col-9 col-md"><%:Model.Course.Credit %></dd>
						<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md"><%:Model.Course.StudentCount %>명</dd>
					</dl>
					<%
						}
						else  
						{
					%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>학습기간</dt>
						<dd class="col-9 col-md-4"><%:DateTime.Parse(Model.Course.TermStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(Model.Course.TermEndDay).ToString("yyyy-MM-dd") %></dd>
						<dt class="col-3 col-md-auto text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md"><%:Model.Course.StudentCount %>명</dd>
					</dl>
					<%
						}
					%>


				</div>
			</div>
			<div class="row">
				<div class="col-12 mt-2">
				<%
					if (Model.TeamProjectList.Count > 0)
					{
				%>
						<h3 class="title04">팀프로젝트 리스트<strong class="text-primary">(<%:Model.TeamProjectList.Count() %>건)</strong></h3>
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
									<table class="table table-hover table-sm table-striped table-horizontal" summary="팀프로젝트 제출 정보 목록">
										<thead>
											<tr>
												<th scope="col">팀프로젝트제목</th>
												<th scope="col" class="d-none d-lg-table-cell">제출기간</th>
												<th scope="col" class="d-none d-md-table-cell">제출방식</th>
												<th scope="col">제출인원</th>
												<th scope="col">평가인원</th>
												<th scope="col">관리</th>
											</tr>
										</thead>
										<tbody>
										<%
											foreach (var item in Model.TeamProjectList) 
											{
										%>
												<tr>
													<td><%:item.ProjectTitle %></td>
													<td class="d-none text-center d-md-table-cell"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd") %></td>
													<td class="d-none text-center d-md-table-cell"><%:item.LeaderYesNo.Equals("Y") ? "팀장제출" : "개별제출" %></td>
													<td class="text-right"><%:item.SubmitCount %></td>
													<td class="text-center"><%:item.FeedbackCount %>/<%:item.StudentCount %></td>
													<td class="text-center"><a class="font-size-20 text-primary" onclick="fnView(<%:item.ProjectNo %>);" title="상세보기"><i class="bi bi-card-list"></i></a></td>
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
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>등록된 팀프로젝트가 없습니다.</div>
				<%
					}
				%>
				</div>

				<div class="col-12 mt-2 d-none" id="divDetailList">		
					<h3 class="title04">제출 대상 리스트<strong class="text-primary" id="strSubmitCnt">(0건)</strong></h3>
					<div class="card card-style01 mt-2" id="divSubmitList">
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
									<caption>팀프로젝트 제출 리스트</caption>
									<thead>
										<tr>
											<th scope="row"><input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
											<th scope="row">번호</th>
											<th scope="row" class="d-none d-md-table-cell">상태</th>
											<th scope="row" class="d-none d-md-table-cell">팀</th>
											<th scope="row">성명</th>
											<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
											<th scope="row" class="d-none" id="thHakjeok">학적</th>
											<th scope="row" class="d-none d-md-table-cell">제출일시</th>
											<th scope="row" class="text-nowrap">제출파일</th>
											<th scope="row" class="text-nowrap">점수</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="col-12 alert bg-light alert-light rounded text-center mt-2 d-none" id="emptyDiv"><i class="bi bi-info-circle-fill"></i> 참여자가 없습니다.</div>				
				</div>
			</div>
			<div class="row">
				<div class="col-6">
				</div>
				<div class="col-6">
					<div class="text-right">
						<a href="/TeamProject/ListAdmin/<%:Model.Course.ProgramNo %>?ProgramNo=<%:Model.Course.ProgramNo %>&TermNo=<%:Model.Course.TermNo %>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" class="btn btn-secondary">목록</a>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" id="hdnProjectNo" name="TeamProject.ProjectNo" value="<%:Model.TeamProject != null ? Model.TeamProject.ProjectNo : 0 %>"/>
		<input type="hidden" name="SortType" id="hdnSortType" value="<%:Model.SortType%>">
		<input type="hidden" id="hdnUnivYN" value="<%:ConfigurationManager.AppSettings["UnivYN"].ToString()%>">
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

				fnSubmitList();
			});

		});

		<%-- 프로젝트 제출자 리스트 조회 --%>
		function fnView(projectNo) {
			$("#hdnProjectNo").val(projectNo);
			$("#divDetailList").removeClass("d-none");
			fnSubmitList();
		}

		function fnSubmitList() {

			ajaxHelper.CallAjaxPost("/TeamProject/SubmitList", { courseNo: <%:Model.Course.CourseNo %>, projectNo: $("#hdnProjectNo").val(), sortType: $("#hdnSortType").val() }, "fnCompleteSubmitList", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteSubmitList() {

			var result = ajaxHelper.CallAjaxResult();
			var htmlStr = "";
			
			$("#strSubmitCnt").html("");
			$("#strSubmitCnt").html("(" + result.TeamProjectSubmitList.length + "건)");
			
			if (result.TeamProjectSubmitList.length > 0) {

				if ($("#hdnUnivYN").val() == "Y") {
					$("#thHakjeok").removeClass("d-none");
				} else {
					$("#thHakjeok").addClass("d-none");
				}

				$("#personalTable > tbody").empty();
				$("#divSubmitList").removeClass("d-none");
				$("#emptyDiv").addClass("d-none");
			
				for (var i = 0; i < result.TeamProjectSubmitList.length; i++) {

					htmlStr += "<tr>";
					htmlStr += "<th scope='row'><input type='checkbox' name='chkSel' id='chkSel' value='" + result.TeamProjectSubmitList[i].UserNo + "' class='checkbox'><input type='hidden' value='" + result.TeamProjectSubmitList[i].UserNo + "'><input type='hidden' value='" + result.TeamProjectSubmitList[i].HangulName + "(" + result.TeamProjectSubmitList[i].UserID + ")'></th>";
					htmlStr += "<td>" + (i + 1) + "</td>";
					htmlStr += "<td class='d-none d-md-table-cell'>";
					if ("<%:Model.TeamProjectList.FirstOrDefault().LeaderYesNo%>" == "Y" && result.TeamProjectSubmitList[i].TeamLeaderYesNo == "N") {
						htmlStr += "-";
					} else if (result.TeamProjectSubmitList[i].SubmitContents != null) {
						htmlStr += "<span class='text-primary'>제출</span>";
					} else {
						htmlStr += "<span class='text-danger'>미제출</span>";
					}
					htmlStr += "</td>";
					htmlStr += "<td class='d-none d-md-table-cell'>" + result.TeamProjectSubmitList[i].TeamName + "</td>";			
					htmlStr += "<td><span class='text-nowrap text-dark d-block'>" + result.TeamProjectSubmitList[i].HangulName;
					if (result.TeamProjectSubmitList[i].TeamLeaderYesNo == "Y")
					{
						htmlStr += "<i class='bi bi-patch-check-fill text-success' title='팀장'></i>";
					}					
					htmlStr += "</span></td>";
					htmlStr += "<td><span class='text-nowrap text-secondary font-size-15'>" + result.TeamProjectSubmitList[i].UserID + "</span></td>";
					if ($("#hdnUnivYN").val() == "Y")
					{
						htmlStr += "<td>" + result.TeamProjectSubmitList[i].HakjeokGubunName + "</td>";
					}

					htmlStr += "<td class='d-none d-md-table-cell'>";
					htmlStr += "<span class='text-nowrap text-dark d-block'>";
					if (result.TeamProjectSubmitList[i].SubmitContents == null && !result.TeamProjectSubmitList[i].FileGroupNo > 0) {
						htmlStr += "";
					} else {
						htmlStr += result.TeamProjectSubmitList[i].CreateDateTimeFormat;
					}
					htmlStr += "</span>";
					htmlStr += "<span class='text-nowrap text-secondary font-size-15'>"
					if (result.TeamProjectSubmitList[i].SubmitContents == null && !result.TeamProjectSubmitList[i].FileGroupNo > 0) {
						htmlStr += "-";
					} else {
						htmlStr += result.TeamProjectSubmitList[i].CreateTime;
					};
					htmlStr += "</span>";
					htmlStr += "</td>";
					htmlStr += "<td>";
					if (result.TeamProjectSubmitList[i].FileGroupNo > 0) {
						htmlStr += "<button type='button' title='다운로드' onclick='fnFileDownload(" + result.TeamProjectSubmitList[i].FileNo + ")'>";
						htmlStr += "<i class='bi bi-file-earmark-arrow-down'></i>";
						htmlStr += "</button>";
					} else {
						htmlStr += "-";
					}
					htmlStr += "</td>";
					htmlStr += "<td class='text-right'>" + result.TeamProjectSubmitList[i].Score + "</td>";
					htmlStr += "</tr>";
				}
			
				$("#personalTable > tbody").html(htmlStr);			
			}
			else {
				$("#thHakjeok").removeClass("d-none");
				$("#divSubmitList").addClass("d-none");
				$("#emptyDiv").removeClass("d-none");
			}
		}

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {

			if (<%:Model.TeamProjectList.Count %> > 0) {
				var param1 = <%:Model.Course.CourseNo %>;

				window.location = "/TeamProject/DetailAdminExcel/" + param1.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

	</script>
</asp:Content>