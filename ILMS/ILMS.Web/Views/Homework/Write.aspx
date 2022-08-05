<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Homework/Write/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
	<h3 class="title04">과제 정보</h3>
	<div class="card d-md-block">
		<div class="card-body">
			<div class="form-row">
				<div class="form-group col-md-12">
					<label for="HomeworkTitle" class="form-label">과제 제목 <strong class="text-danger">*</strong></label>
					<input type="text" id="txtHomeworkTitle" name="Homework.HomeworkTitle" class="form-control" value="<%: Model.Homework != null ? Model.Homework.HomeworkTitle : "" %>">
					<input type="hidden" id="hdnCourseNo" name="Homework.CourseNo" value="<%:ViewBag.Course.CourseNo %>"/>
					<input type="hidden" id="hdnHomeworkNo" name="Homework.HomeworkNo" value="<%:Model.Homework != null ? Model.Homework.HomeworkNo : 0 %>"/>
					<input type="hidden" id="hdnFileGroupNo" name="Homework.FileGroupNo" value="<%:Model.Homework != null ? Model.Homework.FileGroupNo : 0 %>"/>
					<input type="hidden" id="hdnIsOutput" name="Homework.IsOutput" value="<%:Model.IsOutput %>"/>
				</div>
				<div class="form-group col-6 col-md-3 <%:Model.IsOutput == 1 ? "d-none" : "" %>">
					<label for="ddlHomeworkKind" class="form-label">과제 종류 <strong class="text-danger">*</strong></label>
					<select class="form-control" id="ddlHomeworkKind" name="Homework.HomeworkKind">
						<% 
							foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CHWK")).ToList())
							{ 
						%>
						<option value="<%:item.CodeValue %>" <%:item.CodeValue.Equals(Model.Homework == null ? "" : Model.Homework.HomeworkKind) ? "selected=\"selected\"" : "" %>> <%:item.CodeName%></option>
						<%
							}
						%>
					</select>
				</div>
				<div class="form-group col-6 col-md-3 <%:Model.IsOutput == 1 ? "d-none" : "" %>">
					<label for="ddlHomeworkType" class="form-label">
						과제 유형 <strong class="text-danger">*</strong>
						<a href="#mdlTypeTip" title="과제유형 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlTypeTip" role="button"><i class="bi bi-question-circle"></i></a>
					</label>
					<select class="form-control" id="ddlHomeworkType" name="Homework.HomeworkType" onchange="fnReadyHomeworkType(this.value);">
						<% 
							foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CHWT")).OrderBy(y => y.SortNo).ToList())
							{ 
						%>
						<option value="<%:item.CodeValue %>" <%:item.CodeValue.Equals(Model.Homework == null ? "" : Model.Homework.HomeworkType) ? "selected=\"selected\"" : "" %>><%:item.CodeName%></option>
						<%
							}
						%>
					</select>
	            </div>
				<div class="form-group col-6 col-md-3 <%:Model.IsOutput == 1 ? "d-none" : "" %>" id="divWeek">
					<label for="ddlWeek" class="form-label">주차 <strong class="text-danger">*</strong></label>
					<select class="form-control" id="ddlWeek" name="Homework.Week">
						<option value="">선택</option>
						<% 
                            string reqWeek = !string.IsNullOrEmpty(Request["week"]) ? Request["week"].ToString() : "-1";
							
                            foreach (var item in Model.WeekList)
                            {
						%>
							<option value="<%:item.Week %>" <%if (item.Week.Equals(Model.Homework == null ? Model.Output == null ? 0 : Model.Output.Week : Model.Homework.Week) || item.Week.Equals(Convert.ToInt32(reqWeek))){ %> selected="selected"<%} %>><%:item.WeekName %></option>
						<%
							}
						%>
					</select>
	            </div>
	            <div class="form-group col-6 col-md-3 <%:Model.IsOutput == 1 ? "d-none" : "" %>" id="divInning">
					<label for="ddlInning" class="form-label">차시 <strong class="text-danger">*</strong></label>
					<select class="form-control" id="ddlInning" name="Homework.InningNo">
						<option value="">선택</option>
						<% 
							string reqInningNo = !string.IsNullOrEmpty(Request["inningNo"]) ? Request["inningNo"].ToString() : "-1";
							
							foreach (var item in Model.InningList)
							{
						%>
							<option value="<%:item.InningNo %>" <%if (item.InningNo.Equals(Model.Homework == null ? Model.Output == null ? 0 : Model.Output.InningNo : Model.Homework.InningNo) || item.InningNo.Equals(Convert.ToInt32(reqInningNo))){ %> selected="selected"<%} %>><%:item.InningSeqNo %>차시</option>
						<%
							}
						%>
					</select>
	            </div>
	            <div class="form-group col-8 col-md-4" id="divGroup" style="display: none;">
					<label for="ddlHomeworkGroup" class="form-label">팀 편성 <strong class="text-danger">*</strong></label>
					<div class="input-group">
						<select class="form-control" id="ddlHomeworkGroup" name="Homework.OrgGroupNo">
							<option value="">그룹선택</option>
							<%
								foreach (var item in Model.GroupList)
								{
							%>
							<option value="<%:item.GroupNo %>" <%if (item.GroupName.Equals(Model.Homework == null ? "" : Model.Homework.GroupName)){ %> selected="selected"<%} %>><%:item.GroupName %></option>
							<%
								}
							%>
						</select>
						<span class="input-group-append">
							<input type="button" class="btn btn-primary" id="btnGroupTeamMember" data-toggle="modal" data-target="#divGroupTeamMember" value="팀 편성 보기" />
							<input type="hidden" name="Homework.OrgGroupNo" value="<%:Model.Homework == null ? 0 : Model.Homework.GroupNo %>" />
						</span>
					</div>
	            </div>
	            <div class="form-group col-12 col-md-6" id="divExam" style="display: none;">
					<label for="ddlExamKind" class="form-label">시험 <strong class="text-danger">*</strong></label>
					<select class="form-control" id="ddlExamKind" name="Homework.ExamKind">
						<option value="">선택할 시험이 없습니다.</option>
					</select>
					<input type="hidden" id="hdnExamVal" />
	            </div>
	            <div class="form-group col-12 col-md-4" id="divMember" style="display:none;">
					<label for="txtGroupCnt" class="form-label">대상인원 <strong class="text-danger">*</strong></label>
					<a href="#mdlExamTip" title="대상인원 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlExamTip" role="button"><i class="bi bi-question-circle"></i></a>
					<div class="input-group">
						<input type="text" class="form-control text-right" value="<%: Model.HomeworkSubmitList != null ? Model.HomeworkSubmitList != null && (Model.Homework != null ? Model.Homework.HomeworkType : "").Equals("CHWT003") ? Model.HomeworkSubmitList.Where(x => x.TargetYesNo == "Y").Count() : 0 : 0 %>" id="txtGroupCnt" readonly="readonly">
						<div class="input-group-append">
							<span class="input-group-text">명</span>
							<input type="button" id="btnMemberPopup" class="btn btn-secondary" value="인원편집">
						</div>
						<input type="hidden" id="hdnMemberYesList" name="Homework.MemberYesList"/>
						<input type="hidden" id="hdnMemberNoList" name="Homework.MemberNoList"/>
					</div>
	            </div>
	            <div class="form-group col-12 col-md-auto <%:Model.IsOutput == 1 ? "d-none" : "" %>">
					<label for="HomeworkWeighting" class="form-label">
						만점기준 <strong class="text-danger">*</strong>
						<a href="#mdlScoreTip" title="만점기준 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlScoreTip" role="button"><i class="bi bi-question-circle"></i></a>
					</label>
					<div class="input-group">
						<input type="number" class="form-control text-right" <%:Model.SubmitYesNo == true ? "readonly=readonly" : "" %> name="Homework.Weighting" id="HomeworkWeighting" value="<%: Model.Homework != null ? Model.Homework.Weighting : 0 %>">
						<span class="input-group-append">
							<span class="input-group-text">점</span>
						</span>
					</div>
	            </div>
	            <div class="form-group col-auto <%:Model.IsOutput == 1 ? "d-none" : "" %>">
					<label for="OpenYesNo" class="form-label">공개여부</label>
					<label class="switch">
						<input type="checkbox" id="OpenYesNo" name="Homework.OpenYesNo" <%:Model.Homework != null ? (Model.Homework.OpenYesNo == "Y" ? "checked='checked'" : "") : "checked='checked'" %>  value="Y" >
						<span class="slider round"></span>
					</label>
					<small class="text-muted"> 비공개를 선택하면 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 목록에 표시되지 않습니다. </small>
	            </div>
				<div class="form-group col-12" style="display:none;">
					<label for="ddlSubmitType" class="form-label">제출방법 <strong class="text-danger">*</strong></label>
					<select class="form-control" id="ddlSubmitType" name="Homework.SubmitType">
						<% 
							foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CHST")).ToList())
							{ 
						%>
						<option value="<%:item.CodeValue %>" <%if (item.CodeValue.Equals(Model.Homework == null ? "" : Model.Homework.SubmitType)){ %> selected="selected"<%} %>> <%:item.CodeName%></option>
						<%
							}
						%>
					</select>
				</div>
	            <div class="form-group col-md-12">
					<label for="HomeworkContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
					<textarea id="HomeworkContents" name="Homework.HomeworkContents" rows="3" class="form-control" title=""><%: Model.Homework != null ? Model.Homework.HomeworkContents : "" %></textarea>
	            </div>
	            <div class="form-row align-items-end col-12 col-md-6">
					<div class="form-group col-md-5">
						<label for="txtHomeworkStartDay" class="form-label">제출시작일시 <strong class="text-danger">*</strong></label>
						<input type="hidden" id="hdnHomeworkStartDay" name="Homework.SubmitStartDay">
						<div class="input-group">
							<input class="form-control datepicker text-center" id="txtHomeworkStartDay" type="text">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlStartHour" class="sr-only">시작시간 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlStartHour" name="Homework.SubmitStartHour" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 시</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlStartMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlStartMin" name="Homework.SubmitStartMinute" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 분</span>
							</div>
						</div>
					</div>
				</div>
	            <div class="form-row align-items-end col-12 col-md-6">
					<div class="form-group col-md-5">
						<label for="txtHomeworkEndDay" class="form-label">제출종료일시 <strong class="text-danger">*</strong></label>
						<input type="hidden" id="hdnHomeworkEndDay" name="Homework.SubmitEndDay">
						<div class="input-group">
							<input class="form-control datepicker text-center" id="txtHomeworkEndDay" type="text">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlEndHour" class="sr-only">종료시간 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlEndHour" name="Homework.SubmitEndHour" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 시</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlStartMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlEndMin" name="Homework.SubmitEndMinute" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 분</span>
							</div>
						</div>
					</div>
				</div>
	            <%
					if (Model.IsOutput == 0)
					{
				%>
	            <div class="form-group col-12">
					<label for="AddSubmitPeriodUseYesNo" class="form-label">추가 제출일정 사용여부</label>
					<label class="switch">
						<input type="checkbox" class="form-check-input" id="AddSubmitPeriodUseYesNo" name="Homework.AddSubmitPeriodUseYesNo" <%if(Model.Homework != null && Model.Homework.AddSubmitPeriodUseYesNo == "Y"){ %> checked="checked" <%} %>>
						<span class="slider round"></span>
					</label>
	            </div>
	            <div class="form-row align-items-end col-12 col-md-6 d-none"  id="divAddSubmitStartDay" runat="server">
					<div class="form-group col-md-5">
						<label for="txtHomeworkAddStartDay" class="form-label">추가 제출시작일시</label>
						<input type="hidden" id="hdnHomeworkAddStartDay" name="Homework.AddSubmitStartDay">
						<div class="input-group">
							<input class="form-control datepicker text-center" id="txtHomeworkAddStartDay" type="text">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlAddStartHour" class="sr-only">시작시간 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlAddStartHour" name="Homework.AddSubmitStartHour" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 시</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlAddStartMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlAddStartMin" name="Homework.AddSubmitStartMinute" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 분</span>
							</div>
						</div>
					</div>
				</div>
	            <div class="form-row align-items-end col-12 col-md-6 d-none" id="divAddSubmitEndDay" runat="server">
					<div class="form-group col-md-5">
						<label for="txtHomeworkAddEndDay" class="form-label">추가 제출종료일시</label>
						<input type="hidden" id="hdnHomeworkAddEndDay" name="Homework.AddSubmitEndDay">
						<div class="input-group">
							<input class="form-control datepicker text-center" id="txtHomeworkAddEndDay" type="text">
							<div class="input-group-append">
								<span class="input-group-text">
									<i class="bi bi-calendar4-event"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlAddEndHour" class="sr-only">종료시간 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlAddEndHour" name="Homework.AddSubmitEndHour" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 시</span>
							</div>
						</div>
					</div>
					<div class="form-group col-md">
						<label for="ddlAddEndMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
						<div class="input-group">
							<select id="ddlAddEndMin" name="Homework.AddSubmitEndMinute" class="form-control">
							</select>
							<div class="input-group-append">
								<span class="input-group-text"> 분</span>
							</div>
						</div>
					</div>
				</div>
	            <%
					}
				%>
				<div class="form-group col-12 col-md-6">
					<label for="files" class="form-label">첨부파일</label>
					<% Html.RenderPartial("./Common/File"
						, Model.FileList
						, new ViewDataDictionary {
						{ "name", "FileGroupNo" },
						{ "fname", "HomeworkFile" },
					    //{ "value", ViewBag.FileGroup == null ? 0 : ViewBag.FileGroup },
					    { "value", 0 },
						{ "fileDirType", "Homework"},
						{ "filecount", 10 }, { "width", "100" }, {"isimage", 0 } }); %>
				</div>
			</div>
	    </div>
	    <div class="card-footer">
			<div class="row align-items-center">
				<div class="col-6">
					<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
				</div>
				<div class="col-6 text-right">
					<button type="button" class="btn btn-primary" id="btnSave">저장</button>
					<button type="button" class="btn btn-secondary" id="btnCancel">취소</button>
				</div>
			</div>
	    </div>
	</div>
	<div class="modal fade show" id="mdlTypeTip" tabindex="-1" aria-labelledby="mdlTypeTip" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="lblModalTypeTip">도움말</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14 text-danger font-weight-bold mb-0">
						<i class="bi bi-info-circle-fill"></i> 과제유형 선택 시 안내사항
					</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-8">
							과제형시험 : <%:ConfigurationManager.AppSettings["ExamText"].ToString() %>을 과제물로 대체하는 경우 부과하는 과제
						</li>
						<li class="mb-0 font-size-8">
							시험대체형 : <%:ConfigurationManager.AppSettings["ExamText"].ToString() %>에 미응시한 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>들을 대상으로 부과하는 과제(선택사항) - 시험종료 후 선택가능 필히 오프라인 시험을 치룬 경우에만 출제
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade show" id="mdlScoreTip" tabindex="-1" aria-labelledby="mdlScoreTip" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="lblModalScoreTip">도움말</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 만점기준 입력 시 안내사항</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-8">성적평가방법 (100점 만점처리) : 100점 입력
						</li>
						<li class="font-size-8">성적평가방법 ( 비율 만점처리 ) : 과제비율 입력 ex) 만점기준(점) = 과제비율(%) / 과제(횟수)
						</li>
						<li class="mb-0 font-size-8">이미 제출한 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 있을 경우 만점기준을 수정할 수 없습니다.
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade show" id="mdlExamTip" tabindex="-1" aria-labelledby="mdlExamTip" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
				    <h5 class="modal-title h4">도움말</h5>
				    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14 text-danger font-weight-bold mb-0">
						<i class="bi bi-info-circle-fill"></i> 시험대체형 과제 대상인원 도움말
					</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-8">
							시험대체형 과제는 <%:ConfigurationManager.AppSettings["ExamText"].ToString() %>에 응시하지 못한 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 대상으로 출제하는 과제입니다.
						</li>
						<li class="mb-0 font-size-8">
							시험대체형 과제는 전체 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %> 중 일부 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 선택하여 출제할 수 있습니다.
						</li>
						<li class="mb-0 font-size-8">
							대상인원 선택 및 수정
							<ol class="list-style01">
								<li class="font-size-8">‘인원편집’ 또는 ‘시험대체형과제’를 선택하세요.</li>
								<li class="font-size-8">‘대상자 선택’ 창에서 대상 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 선택합니다.</li>
								<li class="font-size-8">대상자를 모두 선택한 후 목록 하단의 ‘등록’ 버튼을 누릅니다.</li>
								<li class="font-size-8">대상인원이 맞는지 확인한 후 ‘닫기’ 버튼을 이용해 ‘대상자 선택’ 창을 닫습니다.</li>
								<li class="font-size-8">대상 인원의 추가 또는 삭제를 위해서는 다시 ‘인원편집’ 기능을 이용합니다.</li>
							</ol>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<% Html.RenderPartial("./Team/GroupTeamMemberList"); %>
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();
		
		$(document).ready(function () {
			if (<%:Model.WeekList.Count%> == 0) {
				bootAlert("강의계획설정 등록 후 과제 등록이 가능합니다.", function () {
					location.href = "/Homework/ListTeacher/<%:Model.CourseNo %>";
				});
			}

			fnAppendHour("ddlStartHour", "00");
			fnAppendMin("ddlStartMin", "00", 1);
			fnAppendHour("ddlEndHour", "23");
			fnAppendMin("ddlEndMin", "59", 1);
			fnAppendHour("ddlAddStartHour", "00");
			fnAppendMin("ddlAddStartMin", "00", 1);
			fnAppendHour("ddlAddEndHour", "23");
			fnAppendMin("ddlAddEndMin", "59", 1);
			
			fnFromToCalendar("txtHomeworkStartDay", "txtHomeworkEndDay", "<%:Model.Homework != null ? Model.Homework.SubmitStartDay : "TODAY"%>");
			fnFromToCalendar("txtHomeworkAddStartDay", "txtHomeworkAddEndDay", "<%:Model.Homework != null ? Model.Homework.AddSubmitStartDay : "TODAY"%>");
			
			<%
				if (Model.Homework != null)
				{
					if(Model.Homework.HomeworkType != null)
					{
				%>
			$("#hdnExamVal").val('<%: string.IsNullOrEmpty(Model.Homework.ExamKind) ? "" : Model.Homework.ExamKind%>')

				fnReadyHomeworkType('<%:Model.Homework.HomeworkType%>');
				if( '<%: Model.Homework.HomeworkType%>' == 'CHWT003'){
					var yesUser = "";
					var noUser = "";
							
					<%
						if (Model.HomeworkSubmitList != null) 
						{
							foreach (var item in Model.HomeworkSubmitList.Where(x => x.TargetYesNo == "Y"))
							{
					%>

								if (yesUser == "") {
									yesUser += '<%: item.UserNo%>';
								}
								else {
									yesUser += "|" + '<%: item.UserNo%>';
								}

					<%
							}
						}
					%>
							
					<%
						if (Model.HomeworkSubmitList != null) 
						{
							foreach (var item in Model.HomeworkSubmitList.Where(x => x.TargetYesNo == "N"))
							{
					%>
							if (noUser == "") {
								noUser += '<%: item.UserNo%>';
							}
							else {
								noUser += "|" + '<%: item.UserNo%>';
							}
					<%
							}
						}
					%>
							
					$("#hdnMemberYesList").val(yesUser);
					$("#hdnMemberNoList").val(noUser);
				}
						
					<%
						if (Model.Homework.SubmitStartDay != null)
						{ 
					%>
					$("#txtHomeworkStartDay").val('<%:DateTime.Parse(Model.Homework.SubmitStartDay).Date.ToString("yyyy-MM-dd")%>');
					$("#ddlStartHour").val('<%:DateTime.Parse(Model.Homework.SubmitStartDay).Hour.ToString("00")%>');
					$("#ddlStartMin").val('<%:DateTime.Parse(Model.Homework.SubmitStartDay).Minute.ToString("00")%>');
					<%
						}
						if (Model.Homework.SubmitEndDay != null)
						{ 
					%>
					$("#txtHomeworkEndDay").val('<%:DateTime.Parse(Model.Homework.SubmitEndDay).Date.ToString("yyyy-MM-dd")%>');
					$("#ddlEndHour").val('<%:DateTime.Parse(Model.Homework.SubmitEndDay).Hour.ToString("00")%>')
					$("#ddlEndMin").val('<%:DateTime.Parse(Model.Homework.SubmitEndDay).Minute.ToString("00")%>')
					<%
						}
						if(Model.Homework.AddSubmitStartDay != null)
						{
					%>
				$("#txtHomeworkAddStartDay").val('<%:DateTime.Parse(Model.Homework.AddSubmitStartDay).Date.ToString("yyyy-MM-dd")%>');
				$("#ddlAddStartHour").val('<%:DateTime.Parse(Model.Homework.AddSubmitStartDay).Hour.ToString("00")%>');
				$("#ddlAddStartMin").val('<%:DateTime.Parse(Model.Homework.AddSubmitStartDay).Minute.ToString("00")%>');
					<%
						}
						if(Model.Homework.AddSubmitEndDay != null)
						{
					%>
				$("#txtHomeworkAddEndDay").val('<%:DateTime.Parse(Model.Homework.AddSubmitEndDay).Date.ToString("yyyy-MM-dd")%>');
				$("#ddlAddEndHour").val('<%:DateTime.Parse(Model.Homework.AddSubmitEndDay).Hour.ToString("00")%>');
				$("#ddlAddEndMin").val('<%:DateTime.Parse(Model.Homework.AddSubmitEndDay).Minute.ToString("00")%>');
					<%
						}
					}
				}
			%>
			
			$("#btnCancel").click(function () {
				window.location = "<%:Model.IsOutput == 0 ? "/Homework/ListTeacher/" : "/Report/List/" %><%:ViewBag.Course.CourseNo%>"
			});
			
			$("#btnSave").click(function () {
				fnHomeworkSave();
			});


			if (document.getElementById("AddSubmitPeriodUseYesNo").checked) {
				$("#ContentBlock_divAddSubmitStartDay").removeClass("d-none");
				$("#ContentBlock_divAddSubmitEndDay").removeClass("d-none");
			}

			$("#AddSubmitPeriodUseYesNo").change(function () {
				if (document.getElementById("AddSubmitPeriodUseYesNo").checked) {
					$("#ContentBlock_divAddSubmitStartDay").removeClass("d-none");
					$("#ContentBlock_divAddSubmitEndDay").removeClass("d-none");
				}
				else {
					$("#ContentBlock_divAddSubmitStartDay").addClass("d-none");
					$("#ContentBlock_divAddSubmitEndDay").addClass("d-none");
				}
			});
			
			$("#btnMemberPopup").click(function () {
				if ($("#ddlExamKind").val() == "") {
					bootAlert("시험을 선택해주세요.");
					return;
				}
				fnOpenPopup("/Homework/MemberList/" + <%:Model.CourseNo%> + "/" + $("#ddlWeek").val() + "/" + <%:Model.Homework != null ? Model.Homework.HomeworkNo : 0%>, "ExamStudent", 700, 600, 0, 0, "auto");
			})
			
			$("#ddlWeek").change(function () {
				_ajax.CallAjaxPost("/Homework/InningList", { courseno: <%:Model.CourseNo%>, weekno: $(this).val() }, "fnCompleteInningList");
			});
			
			$("#btnGroupTeamMember").click(function () {
				var courseNo = <%:ViewBag.Course.CourseNo%>;
				var groupNo = $("#ddlHomeworkGroup").val();
				var isTeamProject = 0;

				if (<%:Model.GroupList.Count%> == 0) {
					bootAlert("팀편성관리에서 그룹/팀을 등록 후 진행해주세요.");
					return false;
				}
				else
				{
					if ($("#ddlHomeworkGroup").val() == "") {
						bootAlert("그룹을 선택해주세요", function () {
							$("#ddlHomeworkGroup").focus();
						});
						return false;
					} else {
						fnGroupTeam(courseNo, groupNo, isTeamProject);
					}
				}				
			});
		});
	
		function fnCompleteInningList() {
			var result = _ajax.CallAjaxResult();
			var option = "<option value=''>선택</option>";
			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					var value = "<option value='" + result[i].InningNo + "'>" + result[i].InningSeqNo + "차시</option>";
					option += value;
				}
			} else {
				option = "<option value=''>선택</option>";
			}
			$("#ddlInning").html(option);
	    };
	
		function fnCompleteExamInningList() {
			debugger;
			var result = _ajax.CallAjaxResult();
			var objDDL = null;
			objDDL = $("#ddlExamKind");
			objDDL.find("option").remove().end();
			var ExamValue = $("#hdnExamVal").val();
			var option;
			$("#ddlWeek").val("");
			if (result != null) {
				if (result.length > 0) {
					objDDL.append("<option value=''>시험을 선택해 주세요.</option>\r\n");
					for (var i = 0; i < result.length; i++) { 
						if (ExamValue == result[i].ExamType) {
							objDDL.append("<option value='" + result[i].ExamType + "|" + result[i].InningNo + "' selected='selected' >" + result[i].Title + "</option>\r\n");
							option = "<option value='" + result[i].ExamType + "|" + result[i].InningNo + "'>" + result[i].Title +"</option>";
							$("#ddlWeek").val(result[i].Week);
							$("#hdnExamVal").val("");
						}
						else {
							objDDL.append("<option value='" + result[i].ExamType + "|" + result[i].InningNo + "'>" + result[i].Title + "</option>\r\n");
						}
					}
				}
				else {
					objDDL.append("<option value=''>선택할 시험이 없습니다.</option>\r\n");
					option = "<option value=''>선택</option>";
				}
				$("#ddlInning").html(option);
			}
	    }
	
		function fnReadyHomeworkType(ctlval) {
			debugger;
			if (ctlval == 'CHWT001' || ctlval == 'CHWT004') {
				$("#divGroup").hide();
				$("#divExam").hide();
				$("#divMember").hide();
				$("#divWeek").show();
				$("#divInning").show();
				
				if (ctlval == 'CHWT004') {
					$("#divGroup").show();
				}
			}
			else {
			    $("#divGroup").hide();
			    if (ctlval == 'CHWT002') {
					$("#divExam").show();
					$("#divMember").hide();
					$("#divWeek").hide();
					$("#divInning").hide();
			    }
			    else {
					$("#divExam").show();
					$("#divMember").show();
					$("#divWeek").hide();
					$("#divInning").hide();
			    }
			
				var examtype = (ctlval == 'CHWT002') ? "1" : "2";
			
				_ajax = new AjaxHelper();
				_ajax.CallAjaxPost("/Homework/ExamInningList", { courseno: <%:Model.CourseNo%>, examtype: examtype, homeworkNo: <%:Model.Homework != null ? Model.Homework.HomeworkNo : 0%>, homeworkType: ctlval }, "fnCompleteExamInningList");
			}
	    }
	
		function fnHomeworkSave() {

			if ($("#hdnIsOutput").val() == 1 && $("#ddlInning").val() == 0) {
				bootAlert("강의가 1건 이상 등록되어야 수업활동일지 등록이 가능합니다.");
				return false;
			}

			if ($("#txtHomeworkTitle").val() == "") {
				bootAlert("제목을 입력해주세요.", function () {
					$("#txtHomeworkTitle").focus();
				});
				return;
			}
			
			if ($("#ddlHomeworkType").val() == "CHWT001" || $("#ddlHomeworkType").val() == "CHWT004") { //개인과제 or 팀과제일경우
				if ($("#ddlWeek").val() == "") {
					bootAlert("주차를 선택해주세요.", function () {
						$("#ddlWeek").focus();
					});
					return;
				}
				if ($("#ddlInning").val() == "") {
					bootAlert("차시를 선택해주세요.", function () {
						$("#ddlInning").focus();
					});
					return;
				}
				if ($("#ddlHomeworkType").val() == "CHWT004") {
					if ($("#ddlHomeworkGroup").val() == "") {
						bootAlert("그룹을 선택해주세요", function () {
							$("#ddlHomeworkGroup").focus();
						});
						return;
				    }
				}
			}
			else if ($("#ddlHomeworkType").val() == "CHWT002" || $("#ddlHomeworkType").val() == "CHWT003") {
				if ($("#ddlExamKind").val() == "") {
					bootAlert("시험을 선택해주세요.", function () {
						$("ddlExamKind").focus();
					});
					return;
				}
				if ($("#ddlHomeworkType").val() == "CHWT003") {
					if ($("#txtGroupCnt").val() == 0) {
						bootAlert("과제 대상인원이 없습니다.", function () {
							$("#txtGroupCnt").focus();
						});
						return;
					}
				}
			}
			<%
				if (Model.IsOutput == 0)
				{
			%>
			if ($("#HomeworkWeighting").val() == "") {
				bootAlert("만점기준 점수를 입력하세요.", function () {
					$("#HomeworkWeighting").focus();
				});
			    return;
			}
			<%
				}
			%>
			
			if ($("#HomeworkContents").val() == "") {
				bootAlert("내용을 입력해주세요.", function () {
					$("#HomeworkContents").focus();
				});
				return;
			}
			
			if ($("#txtHomeworkStartDay").val() == "") {
				bootAlert("과제 제출기간 시작일을 입력해주세요.", function () {
					$("#txtHomeworkStartDay").focus();
				});
			    return;
			}
			
			if ($("#txtHomeworkEndDay").val() == "") {
				bootAlert("과제 제출기간 종료일을 입력해주세요.", function () {
					$("#txtHomeworkEndDay").focus();
				});
				return;
			}
			
			var hdnHomeworkStartDay = new Date($("#txtHomeworkStartDay").val().substring(0, 4), $("#txtHomeworkStartDay").val().substring(5, 7), $("#txtHomeworkStartDay").val().substring(8, 10), $("#ddlStartHour").val(), $("#ddlStartMin").val(), "00");
			var hdnHomeworkEndDay = new Date($("#txtHomeworkEndDay").val().substring(0, 4), $("#txtHomeworkEndDay").val().substring(5, 7), $("#txtHomeworkEndDay").val().substring(8, 10), $("#ddlEndHour").val(), $("#ddlEndMin").val(), "59");
			
			if (hdnHomeworkStartDay > hdnHomeworkEndDay) {
				bootAlert("과제 제출 종료 날짜가 시작 날짜 이전입니다.", function () {
					$("#txtHomeworkEndDay").focus();
				});
				return;
			}
			
			$("#hdnHomeworkStartDay").val($("#txtHomeworkStartDay").val() + " " + $("#ddlStartHour").val() + ":" + $("#ddlStartMin").val() + ":00");
			$("#hdnHomeworkEndDay").val($("#txtHomeworkEndDay").val() + " " + $("#ddlEndHour").val() + ":" + $("#ddlEndMin").val() + ":59");
			$("#hdnHomeworkAddStartDay").val("");
			$("#hdnHomeworkAddEndDay").val("");

			if ($("input[id='AddSubmitPeriodUseYesNo']:checked").length != 0) {
				var hdnHomeworkAddStartDay = new Date($("#txtHomeworkAddStartDay").val().substring(0, 4), $("#txtHomeworkAddStartDay").val().substring(5, 7), $("#txtHomeworkAddStartDay").val().substring(8, 10), $("#ddlAddStartHour").val(), $("#ddlAddStartMin").val(), "00");
				var hdnHomeworkAddEndDay = new Date($("#txtHomeworkAddEndDay").val().substring(0, 4), $("#txtHomeworkAddEndDay").val().substring(5, 7), $("#txtHomeworkAddEndDay").val().substring(8, 10), $("#ddlAddEndHour").val(), $("#ddlAddEndMin").val(), "59");
				
				if ($("#txtHomeworkAddStartDay").val() == "") {
					bootAlert("과제 제출기간 시작일을 입력해주세요.", function () {
						$("#txtHomeworkAddStartDay").focus();
					});
					return;
				}
				
				if ($("#txtHomeworkAddEndDay").val() == "") {
					bootAlert("과제 제출기간 종료일을 입력해주세요.", function () {
						$("#txtHomeworkAddEndDay").focus();
					});
					return;
				}
				
				if (hdnHomeworkEndDay > hdnHomeworkAddStartDay) {
					bootAlert("과제 추가 제출 시작일이 제출일 종료일 이전입니다", function () {
						$("#txtHomeworkAddStartDay").focus();
					});
					return;
				}
				
				if (hdnHomeworkAddStartDay > hdnHomeworkAddEndDay) {
					bootAlert("추가 과제 제출 종료 날짜가 추가 과제 제출 시작 날짜 이전입니다", function () {
						$("#txtHomeworkAddEndDay").focus();
					});
					return;
				}
				
				$("#hdnHomeworkAddStartDay").val($("#txtHomeworkAddStartDay").val() + " " + $("#ddlAddStartHour").val() + ":" + $("#ddlAddStartMin").val() + ":00");
				$("#hdnHomeworkAddEndDay").val($("#txtHomeworkAddEndDay").val() + " " + $("#ddlAddEndHour").val() + ":" + $("#ddlAddEndMin").val() + ":59");
				
			}
			document.forms["mainForm"].submit();
		}

	</script>
</asp:Content>