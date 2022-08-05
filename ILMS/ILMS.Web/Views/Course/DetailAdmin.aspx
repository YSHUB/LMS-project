<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	
	<div id="content">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a class="nav-link active" href="javascript:void(0);" role="tab" onclick="fnChgTab(this, 0)">기본정보</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnChgTab(this, 1)">분반설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('ListWeekAdmin')">주차 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('EstimationWriteAdmin')">평가기준 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('OcwAdmin')">콘텐츠 설정</a>
			</li>
		</ul>

		<!-- 기본정보 -->
		<div class="row" id="divInfo">
			<div class="col-12">
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
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>개설처</dt>
							<dd class="col-9 col-md-3"><%:Model.Course.AssignName %></dd>
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
							<dd class="col-9 col-md-3"><%:Model.Course.TermName %></dd>
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>학점</dt>
							<dd class="col-9 col-md-3"><%:(int)Model.Course.Credit %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>대상학년</dt>
							<dd class="col-9 col-md-3"><%:Model.Course.TargetGradeName %></dd>
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i>강의형태</dt>
							<dd class="col-9 col-md-3">
								<div class="input-group">
									<label for="ddlStudyType" class="sr-only">강의형태</label>
									<select class="form-control" id="ddlStudyType" name="Course.StudyType">
										<%
											foreach (var item in Model.BaseCode.Where(w => w.ClassCode.Equals("CSTD")).ToList()) 
											{
										%>
												<option value="<%:item.CodeValue %>" <% if (item.CodeValue.Equals(Model.Course != null ? Model.Course.StudyType : "")) { %> selected="selected" <% } %>><%:item.CodeName %></option>
										<%
											}
										%>
									</select>
									<span class="input-group-append">
										<button type="button" id="btnStudyTypeChange" class="btn btn-primary">변경</button>
									</span>
								</div>
							</dd>
						</dl>
					</div>
				</div>
				<h3 class="title04">수업계획</h3>
				<div class="card">
					<%--<div class="card-header"></div>--%>
					<div class="card-body">
						<div class="row align-items-end">
							<div class="col-md">
								<dl class="row dl-style02">
									<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>강좌상태</dt>
									<dd class="col-sm pl-4"><%:Model.Course.CourseOpenStatusName %></dd>
								</dl>
								<dl class="row dl-style02">
									<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>수업개요 및 목표</dt>
									<dd class="col-sm pl-4"><%:Model.Course.SubjectSummary %></dd>
								</dl>
								<dl class="row dl-style02">
									<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>교재 및 자료</dt>
									<dd class="col-sm pl-4"><%:Model.Course.LessonProgressType %></dd>
								</dl>
								<dl class="row dl-style02">
									<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>수업진행방법</dt>
									<dd class="col-sm pl-4"><%:Model.Course.TextbookData %></dd>
								</dl>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-12 text-right">
						<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
						<%--<a href="/Course/ListAdmin?AssignNo=<%:ViewBag.AssignNo %>&TermNo=<%:Model.Course.TermNo %>&SearchText=<%:Model.SearchText%>&SearchProf=<%:Model.SearchProf %>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>" class="btn btn-secondary" role="button">목록</a>--%>
					</div>
				</div>
			</div>
		</div>
		<!-- 기본정보 -->

		<!-- 분반설정 -->
		<div class="row" id="divClass">
			<div class="col-12">
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
							<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>강좌 카테고리</dt>
							<dd class="col-9 col-md-5"><%:Model.Course.AssignName %></dd>
							<dt class="col-3 col-md-1 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
							<dd class="col-9 col-md-2"><%:Model.Course.TermName %></dd>
						</dl>
					</div>
				</div>
					
				<h3 class="title04 mt-2">분반 리스트</h3>
				<%
					if (Model.CourseList.Count.Equals(0))
					{
				%>
						<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 결과가 없습니다.</div>
				<%
					}
					else 
					{
				%>
						<div class="card mt-2">
							<div class="card-body py-0">
								<div class="table-responsive">
									<table class="table">
										<caption>개인별 평가 현황 리스트</caption>
										<thead>
											<tr>
												<th scope="row">분반</th>
												<th scope="row">인원제한</th>
												<th scope="row">강좌상태</th>
												<th scope="row"><%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></th>
											</tr>
										</thead>
										<tbody>
										<%
											foreach (var item in Model.CourseList) 
											{
										%>
												<tr>
													<td><%:item.ClassNo %></td>
													<td><%:item.MaxPersonsLimit %></td>
													<td><%:item.CourseOpenStatusName %></td>
													<td><%:item.ProfessorName %></td>
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
					<div class="col-12 text-right">
						<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
					</div>
				</div>
			</div>
		</div>
		<!-- 분반설정 -->
	</div>	
	
	<input type="hidden" id="hdnViewOption" value="<%:ViewBag.viewOption %>"/>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();
		var isSelected = false;


		$(document).ready(function () {

			$("#divInfo").show();
			$("#divClass").hide();

			if ($("#hdnViewOption").val() == "0") {

				var obj = $("a", ".nav");
				fnChgTab(obj[0], 0);
			} else if ($("#hdnViewOption").val() == "1") {

				var obj = $("a", ".nav");
				fnChgTab(obj[1], 1);
			}

		});

		<%-- 탭 이동 --%>
		function fnChgTab(obj, index) {

			$("a", ".nav").removeClass("active show");
			var tabs = $("a", ".nav");
			$(tabs[index]).addClass("active show");
			if (index == 0) {
				$("#divInfo").show();
				$("#divClass").hide();
			}
			else if (index == 1) {
				$("#divInfo").hide();
				$("#divClass").show();
			}
		}

		function fnGoTab(pageName) {

			location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> + "?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		<%-- 강의형태 변경 --%>
		$("#btnStudyTypeChange").click(function () {

			ajaxHelper.CallAjaxPost("/Course/StudyTypeChange", { courseNo: <%:Model.Course.CourseNo %>, studyType: $("#ddlStudyType").val() }, "fnCompleteStudyTypeChange");
		});

		function fnCompleteStudyTypeChange() {

			var result = ajaxHelper.CallAjaxResult();

			if (result <= 0) {

				bootAlert("다시 시도해주세요.");
				return false;
			} else {

				bootAlert("강의형태가 변경되었습니다.");
				return false;
			}
		}

		function fnGo() {

			window.location.href = "/Course/ListAdmin/?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + decodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>