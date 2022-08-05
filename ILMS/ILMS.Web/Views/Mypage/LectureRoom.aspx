<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<ul class="nav nav-tabs mt-4" role="tablist" id="liCourse">
		<li class="nav-item" role="presentation">
			<a id="tab1" class="nav-link active show" data-toggle="tab" href="#tabRegular" role="tab" aria-controls="tabRegular" aria-selected="true" onclick="fnSetTab(1);">정규과정</a>
		</li>
		<li class="nav-item" role="presentation">
			<a id="tab2" class="nav-link" data-toggle="tab" href="#tabIregular" role="tab" aria-controls="tabIregular" aria-selected="false" onclick="fnSetTab(2);">MOOC</a>
		</li>
	</ul>

	<form id="mainForm" action="/Mypage/LectureRoom" method="post">
		<div class="card search-form mb-3">
			<div class="card-body pb-1">
				<div class="form-row">
					<div class="form-group col-12 col-md-4">
						<input type="hidden" id="hdnProgramNo" name="Course.ProgramNo" value="<%:Model.Course.ProgramNo %>" />
						<label for="ddlTermNo" class="sr-only"><%:ConfigurationManager.AppSettings["TermText"].ToString() %>선택</label>
						<select id="ddlTermNo" name="TermNo" class="form-control">
							<%
								if(Model.TermList == null)
								{
							%>
							<option value="">등록된 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>가 없습니다.</option>
							<%
								}
								else
								{
									foreach(var item in Model.TermList)
									{
							%>
							<option value="<%:item.TermNo %>" <%:Model.TermNo == item.TermNo ? "selected" : "" %>><%:item.TermName.ToString() %></option>
							<%
									}
								}
							%>
						</select>
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="submit" id="btnSearch" class="btn btn-secondary">
							<span class="icon search">조회</span>
						</button>
					</div>
					<%
						if (ViewBag.IsLecturer && Model.CourseList.Count > 0) {
					%>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnExcel" class="btn btn-secondary" onclick="fnDownloadExcel();">
							<i class="bi bi-download"></i> 엑셀저장
						</button>
					</div>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</form>

	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane fade show active" id="tabRegular" role="tabpanel" aria-labelledby="tabRegular-tab">
			<h3 class="title03 sr-only">정규과정</h3>
				<%
					if (Model.CourseList.Where(c => c.ProgramNo == 1).Count() > 0)
					{
				%>
			<div class="row">
				<%
						foreach (var item in Model.CourseList.Where(c => c.ProgramNo == 1).OrderBy(c => c.SubjectName).ToList())
						{
				%>
				<div class="col-md-6">
					<div class="card card-style02 regular">
						<div class="card-header">
							<div>
								<span class="badge badge-1"><%:item.ClassificationName %></span>
							</div>
							<div class="card-title01 text-dark d-inline-block"><%:item.SubjectName %></div>
						</div>
						<div class="card-body">
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>분반</dt>
								<dd class="col"><%:item.ClassNo %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>강의형태</dt>
								<dd class="col"><%:item.StudyTypeName %></dd>
							</dl>
							<%
								if (item.IsProf == 1) {
									decimal lectureProgress = 0;
									decimal studentProgress = 0;
									if(item.InningCount > 0)
									{
										lectureProgress = Math.Round((Convert.ToDecimal(item.CurrentInningCount) / Convert.ToDecimal(item.InningCount)) * 100, 2);
									}
									if(item.LectureInningCount > 0 && item.StudentCount > 0)
									{
										studentProgress = Math.Round((Convert.ToDecimal(item.AttendanceCount) / Convert.ToDecimal(item.LectureInningCount * item.StudentCount)) * 100, 2);
									}
							%>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>수강생 수</dt>
								<dd class="col"><%:item.StudentCount %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>개설학과</dt>
								<dd class="col"><%:item.AssignName %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>개설학년</dt>
								<dd class="col"><%:item.TargetGradeName %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>나의 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:lectureProgress %>%" aria-valuenow="<%:lectureProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:lectureProgress %>%"></div>
									</div>
								</dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>전체 수강생 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:studentProgress %>%" aria-valuenow="<%:studentProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:studentProgress %>%"></div>
									</div>
								</dd>
							</dl>
							<%
								}
								else
								{
									decimal studentProgress = 0;
									if(item.LectureInningCount > 0)
									{
										studentProgress = Math.Round((Convert.ToDecimal(item.AttendanceCount) / Convert.ToDecimal(item.LectureInningCount)) * 100, 2);
									}
							%>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
								<dd class="col"><%:item.HangulName %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>나의 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:studentProgress %>%" aria-valuenow="<%:studentProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:studentProgress %>%"></div>
									</div>
								</dd>
							</dl>
							<%
								}
							%>
						</div>
						<div class="card-footer">
							<div class="text-right">
								<a class="btn btn-lg btn-point" href="/LectureRoom/Index/<%:item.CourseNo %>">강의실 입장</a>
							</div>
						</div>
					</div>
				</div>
				<%
						}
				%>
			</div>
				<%
					} else {
				%>
			<div class="alert alert-danger text-center">
				해당 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>에 등록된 강의가 없습니다.
			</div>
				<%
					}
				%>
		</div>

		<div class="tab-pane fade" id="tabIregular" role="tabpanel" aria-labelledby="tabIregular-tab">
			<h3 class="title03 sr-only">MOOC</h3>
				<%
					if (Model.CourseList.Where(c => c.ProgramNo == 2).Count() > 0)
					{
				%>
			<div class="row">
				<%
					foreach(var item in Model.CourseList.Where(c => c.ProgramNo == 2).OrderBy(c => c.SubjectName).ToList())
					{
				%>
				<div class="col-md-6">
					<div class="card card-style02 irregular">
						<div class="card-header">
							<div class="card-title01 text-dark d-inline-block"><%:item.SubjectName %></div>
						</div>
						<div class="card-body">
							<%
								if(item.IsProf == 1) {
									decimal lectureProgress = 0;
									decimal studentProgress = 0;
									if(item.InningCount > 0)
									{
										lectureProgress = Math.Round((Convert.ToDecimal(item.CurrentInningCount) / Convert.ToDecimal(item.InningCount)) * 100, 2);
									}
									if(item.LectureInningCount > 0 && item.StudentCount > 0)
									{
										studentProgress = Math.Round((Convert.ToDecimal(item.AttendanceCount) / Convert.ToDecimal(item.LectureInningCount * item.StudentCount)) * 100, 2);
									}
							%>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>상태</dt>
								<dd class="col">강의</dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>수강생 수</dt>
								<dd class="col"><%:item.StudentCount %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>나의 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:lectureProgress %>%" aria-valuenow="<%:lectureProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:lectureProgress %>%"></div>
									</div>
								</dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>전체 수강생 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:studentProgress %>%" aria-valuenow="<%:studentProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:studentProgress %>%"></div>
									</div>
								</dd>
							</dl>
							<%
								}
								else
								{
									decimal studentProgress = 0;
									if(item.LectureInningCount > 0)
									{
										studentProgress = Math.Round((Convert.ToDecimal(item.AttendanceCount) / Convert.ToDecimal(item.LectureInningCount)) * 100, 2);
									}
							%>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>상태</dt>
								<dd class="col">수강</dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
								<dd class="col"><%:item.HangulName %></dd>
							</dl>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>나의 진행률</dt>
								<dd class="col">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: <%:studentProgress %>%" aria-valuenow="<%:studentProgress %>" aria-valuemin="0" aria-valuemax="100" title="<%:studentProgress%>"></div>
									</div>
								</dd>
							</dl>
							<%
								}
							%>
							<dl class="row dl-style02">
								<dt class="col-auto w-9rem text-dark"><i class="bi bi-dot"></i>학습기간</dt>
								<dd class="col-sm"><%:item.LStart %> ~ <%:item.LEnd %></dd>
							</dl>
						</div>
						<div class="card-footer">
							<div class="text-right">
								<%
									if(item.IsProf == 0 && Convert.ToDateTime(DateTime.ParseExact(item.REnd, "yyyy-MM-dd", null).AddDays(1)).Ticks > DateTime.Now.Ticks) {
								%>
								<button type="button" class="btn btn-lg btn-primary" onclick="fnCancelLecture(<%:item.CourseNo %>, '<%:item.SubjectName %>');">수강취소</button>
								<%
									}
								%>
								<a class="btn btn-lg btn-point" href="/LectureRoom/Index/<%:item.CourseNo %>">강의실 입장</a>
							</div>
						</div>
					</div>
				</div>
				<%
						}
				%>
			</div>
				<%
					} else {
				%>
			<div class="alert alert-danger text-center">
				등록된 <%:ConfigurationManager.AppSettings["SUBJECTTEXT"].ToString() %>이 없습니다.
			</div>
				<%
					}
				%>
		</div>
	</div>

	<form id="excelForm" method="post" action="/Mypage/QnaExcel">
		<input type="hidden" name="tNo" id="tNo" />
		<input type="hidden" name="pNo" id="pNo" />
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script>
		var ajaxHelper;

		$(document).ready(function () {
			<%
				if (Model.Course.ProgramNo == 2)
				{
			%>
			$("#tab1").attr("class", "nav-link");
			$("#tab2").attr("class", "nav-link active");
			$("#tab1").attr("aria-selected", "false");
			$("#tab2").attr("aria-selected", "true");
			$("#tabRegular").attr("class", "tab-pane fade");
			$("#tabIregular").attr("class", "tab-pane fade active show");
			<%
				}
			%>
			<%
				if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N"))
				{
			%>
			$("#liCourse").attr("class", "d-none");
			$("#tab2").attr("class", "nav-link active show");
			$("#hdnProgramNo").val(2);
			<%
				}
			%>
		});

		function fnSetTab(no) {
			$("#hdnProgramNo").val(no);
		}

		function fnCancelLecture(cNo, sNm) {
			if (bootConfirm("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명 : " + sNm + "\n수강 취소 하시겠습니까?")) {
				ajaxHelper = new AjaxHelper();
				ajaxHelper.CallAjaxPost("/Mypage/CancelLecture", { courseNo : cNo }, "fnCompleteCancel", "'" + sNm + "'");
			}
		}

		function fnCompleteCancel(sNm) {
			var data = ajaxHelper.CallAjaxResult();

			if (data > 0) {
				bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명 : " + sNm + "\n수강 취소 처리되었습니다.");
				location.reload();
			} else {
				bootAlert("수강 취소에 실패하였습니다. 다시 시도해 주세요.");
			}
		}

		function fnDownloadExcel() {
			var form = $("#excelForm");
			$("#tNo").val($("#ddlTermNo").val());
			$("#pNo").val($("#hdnProgramNo").val());

			form.serialize();
			form.submit();
		}
	</script>
</asp:Content>