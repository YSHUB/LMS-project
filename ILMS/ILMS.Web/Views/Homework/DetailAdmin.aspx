<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 정보</h3>
	<form action="/Homework/DetailAdmin/<%:Model.Course.CourseNo %>" id="LectureRoom" method="post">
		<div class="content">
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
						if (Model.Course.ProgramNo.ToString() == "2")
						{
					%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>학습기간</dt>
						<dd class="col-9 col-md-3"><%:DateTime.Parse(Model.Course.TermStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(Model.Course.TermEndDay).ToString("yyyy-MM-dd") %></dd>
						<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>강좌</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CampusName %> / <%:Model.Course.ClassNo %></dd>
						<dt class="col-3 col-md-auto w-6rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md"><%:Model.Course.HangulName %></dd>
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
					%>
				</div>
			</div>
			<input type="hidden" name="Homework.HomeworkNo" id="hdnHomeworkNo" value="<%:Model.Course.SortNo %>">
			<input type="hidden" name="SortType" id="hdnSortType" value="<%:Model.SortType%>">
			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (Model.HomeworkList.Count > 0)
						{
					%>
					<h3 class="title04">과제 리스트<strong class="text-primary">(<%:Model.HomeworkList.Count %>건)</strong></h3>
					<div class="card">
						<div class="card-header">
							<div class="row justify-content-between">
								<div class="col-auto">
									<input type="button" class="btn btn-sm btn-secondary" value="엑셀 다운로드" onclick="fnExcel();">
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover table-sm table-striped table-horizontal" summary="과제 제출 정보 목록">
									<thead>
										<tr>
											<th scope="col">주차</th>
											<th scope="col">차시</th>
											<th scope="col" class="d-none d-md-table-cell">과제유형</th>
											<th scope="col">과제제목</th>
											<th scope="col" class="d-none d-md-table-cell">제출방법</th>
											<th scope="col" class="d-none d-lg-table-cell">제출기간</th>
											<th scope="col" class="d-none d-md-table-cell">공개여부</th>
											<th scope="col">제출인원</th>
											<th scope="col">평가인원</th>
											<th scope="col">관리</th>
										</tr>
									</thead>
									<tbody>
										<% 
											foreach (var item in Model.HomeworkList)
											{
										%>
										<tr>
											<td><%:item.Week %>주차</td>
											<td><%:item.InningSeqNo %>차시</td>
											<td class="d-none text-center d-md-table-cell"><%:item.HomeworkTypeName%></td>
											<td><%:item.HomeworkTitle %></td>
											<td class="d-none text-center d-md-table-cell"><%:item.SubmitTypeName %></td>
											<td class="d-none text-center d-md-table-cell"><%:DateTime.Parse(item.SubmitStartDay).ToString("yyyy-MM-dd") %> ~ <%:DateTime.Parse(item.SubmitEndDay).ToString("yyyy-MM-dd") %></td>
											<td class="d-none text-center d-md-table-cell"><%:item.OpenYesNo.Equals("Y") ? "공개" : "비공개" %></td>
											<td class="text-right"><%:item.SubmitCnt %></td>
											<td class="text-center"><%:item.SubmitScoreCnt %>/<%:item.StudentCnt %></td>
											<td class="text-center"><a class="font-size-20 text-primary" href="#" onclick="fnView(<%:item.HomeworkNo %>);" title="상세보기"><i class="bi bi-card-list"></i></a></td>
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
					<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>과제가 없습니다.</div>
					<%}
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
								</div>
							</div>
						</div>
						<div class="card-body py-0">
							<div class="table-responsive">
								<table class="table table-hover" id="personalTable" summary="과제리스트">
									<caption>과제 리스트</caption>
									<thead>
										<tr>
											<th scope="row">
												<input type="checkbox" class="checkbox" id="chkAll" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
											<th scope="row">번호</th>
											<th scope="row" class="d-none d-md-table-cell">상태</th>
											<th scope="row" class="d-none d-md-table-cell">소속</th>
											<th scope="row">성명</th>
											<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
											<th scope="row" class="<%:ConfigurationManager.AppSettings["StudIDText"].Equals("학번") ? "" : "d-none" %>">학적</th>
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
					</div>
			</div>
			<div class="row">
				<div class="col-6">
				</div>
				<div class="col-6">
					<div class="text-right">
						<a href="/Homework/ListAdmin/1?ProgramNo=<%: ViewBag.ProgramNo %>&TermNo=<%:ViewBag.TermNo %>&SearchText=<%:ViewBag.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" class="btn btn-secondary">목록</a>
					</div>
				</div>
			</div>
		</div>
	</form>
	<input type="hidden" id="hdnUnivYN" value="<%:ConfigurationManager.AppSettings["UnivYN"].ToString()%>">
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

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

		function fnView(id) {
			$("#hdnHomeworkNo").val(id);
			$("#divDetailList").removeClass("d-none");
			fnSubmitList();
		}

		function fnSubmitList() {

			ajaxHelper.CallAjaxPost("/Homework/SubmitList", { courseNo: <%:Model.Course.CourseNo %>, homeworkNo: $("#hdnHomeworkNo").val(), sortType: $("#hdnSortType").val() }, "fnCompleteSubmitList", "", "오류가 발생하였습니다. \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteSubmitList() {

			var result = ajaxHelper.CallAjaxResult();
			var htmlStr = "";

			$("#strSubmitCnt").html("");
			$("#strSubmitCnt").html("(" + result.HomeworkSubmitList.length + "건)");

			if (result.HomeworkSubmitList.length > 0) {

				$("#personalTable > tbody").empty();
				$("#divSubmitList").removeClass("d-none");
				$("#emptyDiv").addClass("d-none");

				for (var i = 0; i < result.HomeworkSubmitList.length; i++) {

					htmlStr += "<tr>";
					htmlStr += "<th scope='row'><input type='checkbox' name='chkSel' id='chkSel' value='" + result.HomeworkSubmitList[i].UserNo + "' class='checkbox'><input type='hidden' value='" + result.HomeworkSubmitList[i].UserNo + "'><input type='hidden' value='" + result.HomeworkSubmitList[i].HangulName + "(" + result.HomeworkSubmitList[i].UserID + ")'></th>";
					htmlStr += "<td>" + (i + 1) + "</td>";
					htmlStr += "<td class='d-none d-md-table-cell'>";
					if ("<%:Model.HomeworkList.FirstOrDefault().HomeworkType%>" == "CHWT004" && result.HomeworkSubmitList[i].TeamLeaderYesNo == "N") {
						htmlStr += "-";
					} else if (result.HomeworkSubmitList[i].SubmitContents != null || result.HomeworkSubmitList[i].FileGroupNo > 0) {
						htmlStr += "<span class='text-primary'>제출</span>";
					} else {
						htmlStr += "<span class='text-danger'>미제출</span>";
					}
					htmlStr += "</td>";
					htmlStr += "<td class='text-nowrap text-left d-none d-md-table-cell'>" + result.HomeworkSubmitList[i].AssignName + "</td>";
					htmlStr += "<td><span class='text-nowrap text-dark d-block'>" + result.HomeworkSubmitList[i].HangulName;
					htmlStr += "<td><span class='text-nowrap text-secondary font-size-15'>" + result.HomeworkSubmitList[i].UserID + "</span></td>";
					if ($("#hdnUnivYN").val() == "Y") {
						htmlStr += "<td>" + result.HomeworkSubmitList[i].HakjeokGubunName + "</td>";
					}
					htmlStr += "<td class='d-none d-md-table-cell'>";
					htmlStr += "<span class='text-nowrap text-dark d-block'>";
					if (result.HomeworkSubmitList[i].UpdateDateTime == null || result.HomeworkSubmitList[i].SubmitContents == null && !result.HomeworkSubmitList[i].FileGroupNo > 0) {
						htmlStr += "";
					} else {
						htmlStr += result.HomeworkSubmitList[i].UpdateDateTimeFormat;
					}
					htmlStr += "</span>";
					htmlStr += "<span class='text-nowrap text-secondary font-size-15'>"
					if (result.HomeworkSubmitList[i].SubmitContents == null && !result.HomeworkSubmitList[i].FileGroupNo > 0) {
						htmlStr += "-";
					} else {
						htmlStr += result.HomeworkSubmitList[i].UpdateTime;
					};
					htmlStr += "</span>";
					htmlStr += "</td>";
					htmlStr += "<td>";
					if (result.HomeworkSubmitList[i].FileGroupNo > 0) {
						htmlStr += "<button type='button' title='다운로드' onclick='fnFileDownload(" + result.HomeworkSubmitList[i].FileNo + ")'>";
						htmlStr += "<i class='bi bi-file-earmark-arrow-down'></i>";
						htmlStr += "</button>";
					} else {
						htmlStr += "-";
					}
					htmlStr += "</td>";
					htmlStr += "<td class='text-right'>" + (result.HomeworkSubmitList[i].Score == null ? "없음" : result.HomeworkSubmitList[i].Score) + "</td>";
					htmlStr += "</tr>";
				}

				$("#personalTable > tbody").html(htmlStr);
			}
			else {
				$("#divSubmitList").addClass("d-none");
				$("#emptyDiv").removeClass("d-none");
			}
		}

		function fnExcel() {
			if (<%:Model.HomeworkList.Count%> > 0) {
				var param1 = <%:Model.Course.CourseNo %>;

				window.location = "/Homework/DetailAdminExcel/" + param1.toString();
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

	</script>
</asp:Content>
