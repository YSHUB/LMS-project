<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.SystemViewModel>" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <link href="/site/resource/www/css/contents.css" rel="stylesheet">
    <form action="/System/TermWrite/<%: Model.Term != null ? Model.Term.TermNo : 0%>" id="mainForm" method="post" onsubmit="return Confirm('저장하시겠습니까?')">
        <div class="row">
            <div class="col-12 mt-2">
                <h3 class="title04"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 등록 및 수정</h3>
            </div>
        </div>

        <div class="card d-md-block">
		<div class="card-body">
			<div class="row" >
				<div class="col-12 col-md-6">
					<div class="form-row">
					<%
					if(Model.Term != null)
					{
					%>
						<div class="form-group col-6">
							<label for="txtTermYear" class="form-label">년도 <strong class="text-danger">*</strong></label>
							<input class="form-control" name="Term.TermYear" id="txtTermYear" title="TermYear"  type="text" readonly=""  value="<%: Model.Term != null ? Model.Term.TermYear : ""%>">
						</div>
						<%
						if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
						%>
						<div class="form-group col-6">
							<label for="txtTermName" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
							<input class="form-control" name="Term.TermName" id="txtTermName" title="TermName"  type="text" readonly=""  value="<%: Model.Term != null ? Model.Term.TermName : ""%>">
						</div>
						<%
						}
					}
					else
					{
					%>
						<div class="form-group col-6">
							<label for="ddlTermYear" class="form-label">년도 <strong class="text-danger">*</strong></label>
							<select  name="term.TermYear" id="ddlTermYear" class="form-control">
							<%
							for (int i = 0; i < 3; i++)
							{
							%>
								<option value="<%: (DateTime.Now.Year) + i %>"><%: (DateTime.Now.Year) + i %> </option>
							<%
							}
							%>
							</select>
						</div>
						<%
						if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
						%>
						<div class="form-group col-6">
							<label for="ddlTermGubun" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
							<select  name="term.TermGubunName" id="ddlTermGubun" class="form-control">
							<%
							foreach (var code in Model.BaseCode.Where(w => w.ClassCode.ToString() == "CTRM"))
							{
							%>
								<option value ="<%: code.CodeValue %>" > <%: code.CodeName %></option>
							<%
							}
							%>
							</select>
						</div>
					<%
						}
					}
					%>

						<%
						if (!ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
						%>
						<div class="form-group col-6">
							<label for="txtTermRound" class="form-label">회차 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-right" name="Term.TermRound" id="txtTermRound" title="TermRound" type="text" <%: Model.Term != null ? "readonly=''" : "" %> value="<%: Model.Term != null ? Model.Term.TermRound : ""%>" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text">회차</span>
								</div>
							</div>
						</div>
						<%
						}
						%>

						<div class="form-group col-6 col-md-6">
							<label for="txtTermStartDay" class="form-label">운영시작일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.TermStartDay" id="txtTermStartDay" title="TermStartDay"  type="text" autocomplete="off" >
								<div class="input-group-append">
                                    <span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group col-6 col-md-6">
							<label for="txtTermEndDay" class="form-label">운영종료일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.TermEndDay" id="txtTermEndDay" title="TermStartDay"  type="text" autocomplete="off" >
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>

						<div class="form-group col-6 col-md-6">
							<label for="txtLectureStartDay" class="form-label">수강시작일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.LectureStartDay" id="txtLectureStartDay" title="LectureStartDay"  type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group col-6 col-md-6">
							<label for="txtLectureEndDay" class="form-label">수강종료일자 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.LectureEndDay" id="txtLectureEndDay" title="LectureEndDay"  type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>

						<div class="form-group col-6 col-md-6 <%: ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<label for="txtLectureRequestStartDay" class="form-label">수강신청 시작일자 <a href="#mdlLectureRequestStart" title="수강신청 시작일자 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlLectureRequestStart" role="button"><i class="bi bi-question-circle"></i></a></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.LectureRequestStartDay" id="txtLectureRequestStartDay" title="LectureRequestStartDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group col-6 col-md-6 <%: ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
							<label for="txtLectureRequestEndDay" class="form-label">수강신청 종료일자 <a href="#mdlLectureRequestEnd" title="수강신청 종료일자 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlLectureRequestEnd" role="button"><i class="bi bi-question-circle"></i></a></label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.LectureRequestEndDay" id="txtLectureRequestEndDay" title="LectureRequestEndDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>

                        <div class="form-group col-6 col-md-6">
                            <label for="txtAccessRestrictionStartDay" class="form-label">접속제한 시작일자 <a href="#mdlAccessRestrictionStart" title="접속제한 시작일자 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlAccessRestrictionStart" role="button"><i class="bi bi-question-circle"></i></a></label>
                            <div class="input-group">
                                <input class="form-control text-center" name="Term.AccessRestrictionStartDay" id="txtAccessRestrictionStartDay" title="LectureStartDay" type="text" autocomplete="off">
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
                                </div>
                            </div>
                        </div>
						<div class="form-row align-items-end col-6 col-md-6">
							<div class="form-group col-md">
								<label for="ddlStartHour" class="sr-only">시작시간 <strong class="text-danger">*</strong></label>
								<div class="input-group">
									<select id="ddlStartHour" name="term.AddSubmitStartHour" class="form-control">
									</select>
									<div class="input-group-append">
										<span class="input-group-text">시</span>
									</div>
								</div>
							</div>
							<div class="form-group col-md">
								<label for="ddlStartMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
								<div class="input-group">
									<select id="ddlStartMin" name="term.AddSubmitStartMinute" class="form-control">
									</select>
									<div class="input-group-append">
										<span class="input-group-text">분</span>
									</div>
								</div>
							</div>
						</div>
						<div class="form-group col-6 col-md-6">
							<label for="txtAccessRestrictionEndDay" class="form-label">접속제한 종료일자 <a href="#mdlAccessRestrictionEnd" title="접속제한 시작일자 도움말" class="font-weight-bold text-info" data-toggle="modal" data-target="#mdlAccessRestrictionEnd" role="button"><i class="bi bi-question-circle"></i></a> </label>
							<div class="input-group">
								<input class="form-control text-center" name="Term.AccessRestrictionEndDay" id="txtAccessRestrictionEndDay" title="AccessRestrictionEndDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text"><i class="bi bi-calendar4-event"></i></span>
								</div>
							</div>
						</div>
						<div class="form-row align-items-end col-6 col-md-6">
							<div class="form-group col-md">
								<label for="ddlEndHour" class="sr-only">종료시간 <strong class="text-danger">*</strong></label>
								<div class="input-group">
									<select id="ddlEndHour" name="term.SubmitEndHour" class="form-control">
									</select>
									<div class="input-group-append">
										<span class="input-group-text">시</span>
									</div>
								</div>
							</div>
							<div class="form-group col-md">
								<label for="ddlEndMin" class="sr-only">분 <strong class="text-danger">*</strong></label>
								<div class="input-group">
									<select id="ddlEndMin" name="term.SubmitEndMinute" class="form-control">
									</select>
									<div class="input-group-append">
										<span class="input-group-text">분</span>
									</div>
								</div>
							</div>
						</div>
                        <div class="form-group col-12">
                            <label for="txtAccessRestrictionName" class="form-label">접속제한명 </label>
                            <div class="input-group">
                               <input class="form-control" name="Term.AccessRestrictionName" id="txtAccessRestrictionName" title="AccessRestrictionName"  type="text"  value="<%: Model.Term != null ? Model.Term.AccessRestrictionName : ""%>">
                            </div>
                        </div>
						<div class="form-group col-12">
							<label for="txtLatenessSetupDay" class="form-label">지각설정 </label>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text">주차별 학습종료일 이후</span>
								</div>
								<input class="form-control text-right" name="Term.LatenessSetupDay" id="txtLatenessSetupDay" title="LatenessSetupDay"  type="text" value="<%: Model.Term != null ? Model.Term.LatenessSetupDay.ToString() : ""%>">
								<div class="input-group-append">
									<span class="input-group-text">일</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-md-6">
					<div class="form-row">
						<div class="form-group col-12 mb-md-1">
							<label for="txtautodate" class="form-label">온라인강의 학습주차 <strong class="text-danger">*</strong></label>
							<div class="input-group">
								<input id="txtautodate" type="text" class="datepicker text-center form-control"  autocomplete="off" />
								<div class="input-group-append input-group-prepend">
									<span class="input-group-text">부터</span>
								</div>
								<label for="txtautopn" class="form-label"></label>
								<input id="txtautopn" type="text" class="form-control isNumeric text-right" value="7"   />
								<div class="input-group-append input-group-prepend">
									<span class="input-group-text">간격</span>
								</div>
								<div class="input-group-append">
									<input type="button" class="btn btn-secondary" id="btnAutoDate" value="자동설정"/>
								</div>
							</div>
						</div>
						<%
						for (int i = 0; i < 16; i++)
						{
						%>
						<div class="form-group col-12 mb-md-1">
						<label for="ExamStartDay" class="form-label sr-only"><%:i + 1 %>주차 <strong class="text-danger">*</strong></label>
							<div class="input-group input-group-sm">
								<div class="input-group-prepend">
									<span class="input-group-text"><%:i + 1 %>주차</span>
								</div>
								<input type="hidden"  name="<%:"TermWeekList[" + i.ToString() + "].WeekStartDay" %>"  id="hdn<%: "WeekStartDay_" + i.ToString() %>" title="WeekStartDay" value="<%: Model.TermWeekList != null && Model.TermWeekList.Count() > i ? Model.TermWeekList[i].WeekStartDay : ""%>" />
								<input class="datepicker text-center weekend week form-control" name="<%:"TermWeekList[" + i.ToString() + "].WeekStartDay" %>"  id="<%: "txtWeekStartDay_" + i.ToString() %>" title="WeekStartDay" type="text" autocomplete="off">
								<div class="input-group-append input-group-prepend">
									<span class="input-group-text">부터</span>
								</div>
								<input type="hidden"  name="<%:"TermWeekList[" + i.ToString() + "].WeekEndDay" %>"  id="hdn<%: "WeekEndDay_" + i.ToString() %>" title="WeekEndDay" value="<%: Model.TermWeekList != null && Model.TermWeekList.Count() > i ? Model.TermWeekList[i].WeekEndDay : ""%>" />
								<input class="datepicker text-center weekend week form-control" name="<%:"TermWeekList[" + i.ToString() + "].WeekEndDay" %>"   id="<%: "txtWeekEndDay_" + i.ToString() %>"  title="WeekEndDay" type="text" autocomplete="off">
								<div class="input-group-append">
									<span class="input-group-text">까지</span>
								</div>
							</div>
						</div>
						<%
						}
						%>
					</div>
				</div>
			</div>
        </div>
    </div>
    <input type="hidden" id="hdnTermNo" name="Term.TermNo" value="<%: Model.Term != null ? Model.Term.TermNo : 0%>" title="년도" />
    <input type="hidden" id="hdnTermQuarter" name="Term.TermQuarter" value="<%: Model.Term != null ? Model.Term.TermQuarter : ""%>" title="<%:ConfigurationManager.AppSettings["TermText"].ToString() %>" />
	<div class="row align-items-center">
		<div class="col-6">
			<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
		</div>
		<div class="col-6 text-right">
			<button type="button" id="btnSave" class="btn <%: Model.Term != null ? "btn-warning" : "btn-primary"%>"><%: Model.Term != null ? "수정" : "저장"%></button>
			<button type="button"  class="btn btn-secondary" id="btnCancel" onclick="fnCancel()" >취소</button>
		</div>
	</div>
	<div class="modal fade show" id="mdlLectureRequestStart" tabindex="-1" aria-labelledby="mdlLectureRequestStart" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="lblModalTip">도움말</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14 text-danger font-weight-bold mb-0">
						<i class="bi bi-info-circle-fill"></i>기간 설정 시 안내사항
					</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-8">수강신청 시작기간 설정시 사이트 접근이 제한됩니다.
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade show" id="mdlLectureRequestEnd" tabindex="-1" aria-labelledby="mdlLectureRequestEnd" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="lblModalTip2">도움말</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p class="font-size-14 text-danger font-weight-bold mb-0">
						<i class="bi bi-info-circle-fill"></i> 기간 설정 시 안내사항
					</p>
					<ul class="list-style03 mb-0">
						<li class="font-size-8"> 수강신청 종료기간 설정시 사이트 접근이 제한됩니다.
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
		<div class="modal fade show" id="mdlAccessRestrictionStart" tabindex="-1" aria-labelledby="mdlAccessRestrictionStart" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="lblModalTip3">도움말</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<p class="font-size-14 text-danger font-weight-bold mb-0">
							<i class="bi bi-info-circle-fill"></i> 기간 설정 시 안내사항
						</p>
						<ul class="list-style03 mb-0">
							<li class="font-size-8"> 접속제한기간 설정시 사이트 접근이 제한됩니다.
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade show" id="mdlAccessRestrictionEnd" tabindex="-1" aria-labelledby="mdlAccessRestrictionEnd" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title h4" id="lblModalTip4">도움말</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<p class="font-size-14 text-danger font-weight-bold mb-0">
							<i class="bi bi-info-circle-fill"></i> 기간 설정 시 안내사항
						</p>
						<ul class="list-style03 mb-0">
							<li class="font-size-8"> 접속제한기간 설정시 사이트 접근이 제한됩니다.
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>

</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="/common/jquery.ui/jquery-1.12.4.js"></script>
    <script src="/common/jquery.ui/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript">
        var ajaxHelper = new AjaxHelper();
        var resultAjax;
        
        <%=""%> 

		$(document).ready(function () {
			fnCalendar("txtautodate", null);
			fnFromToCalendar("txtTermStartDay", "txtTermEndDay", $("#txtTermStartDay").val() ? $("#txtTermStartDay").val() : null);
            fnFromToCalendar("txtLectureRequestStartDay", "txtLectureRequestEndDay", $("#txtLectureRequestStartDay").val() ? $("#txtLectureRequestStartDay").val() : null);
            fnFromToCalendar("txtLectureStartDay", "txtLectureEndDay", $("#txtLectureStartDay").val() ? $("#txtLectureStartDay").val() : null);
            fnFromToCalendar("txtAccessRestrictionStartDay", "txtAccessRestrictionEndDay", $("#txtAccessRestrictionStartDay").val() ? $("#txtAccessRestrictionStartDay").val() : null);

			fnAppendHour("ddlStartHour", "00");
			fnAppendMin("ddlStartMin", "00", 1);
			fnAppendHour("ddlEndHour", "23");
			fnAppendMin("ddlEndMin", "59", 1);


			for (var i = 0; i < 17; i++) {
				if ($("#hdnTermNo").val() != 0 && $("#hdnTermNo").val() != null) {
                    fnFromToCalendar("txtWeekStartDay_" + i, "txtWeekEndDay_" + i, $("#txtWeekStartDay_" + i).val() ? $("#txtWeekStartDay_" + i).val() : null );
				}
				else {
                    fnFromToCalendar("txtWeekStartDay_" + i, "txtWeekEndDay_" + i, null);
				}
			}

            $("#txtTermStartDay").val("<%: Model.Term != null ? Model.Term.TermStartDay : ""%>");
            $("#txtTermEndDay").val("<%: Model.Term != null ? Model.Term.TermEndDay : ""%>");
            $("#txtLectureRequestStartDay").val("<%: Model.Term != null ? Model.Term.LectureRequestStartDay : ""%>");
            $("#txtLectureRequestEndDay").val("<%: Model.Term != null ? Model.Term.LectureRequestEndDay : ""%>");
            $("#txtLectureStartDay").val("<%: Model.Term != null ? Model.Term.LectureStartDay : ""%>");
			$("#txtLectureEndDay").val("<%: Model.Term != null ? Model.Term.LectureEndDay : ""%>");

			<%
			if (Model.Term != null)
			{
			%>
				$("#txtAccessRestrictionStartDay").val("<%: Model.Term.AccessRestrictionStartDay != null ? DateTime.Parse(Model.Term.AccessRestrictionStartDay).ToString("yyyy-MM-dd") : ""%>");
				$("#txtAccessRestrictionEndDay").val("<%: Model.Term.AccessRestrictionStartDay != null ? DateTime.Parse(Model.Term.AccessRestrictionEndDay).ToString("yyyy-MM-dd") : ""%>");
				$("#ddlStartHour").val("<%: Model.Term.AccessRestrictionStartDay != null && DateTime.Parse(Model.Term.AccessRestrictionStartDay).ToString("HH") != null  ? DateTime.Parse(Model.Term.AccessRestrictionStartDay).ToString("HH") : "00"%>");
				$("#ddlStartMin").val("<%: Model.Term.AccessRestrictionStartDay != null &&  DateTime.Parse(Model.Term.AccessRestrictionStartDay).ToString("mm") != null  ? DateTime.Parse(Model.Term.AccessRestrictionStartDay).ToString("mm") : "00"%>");
				$("#ddlEndHour").val("<%: Model.Term.AccessRestrictionStartDay != null && DateTime.Parse(Model.Term.AccessRestrictionEndDay).ToString("HH") != null  ? DateTime.Parse(Model.Term.AccessRestrictionEndDay).ToString("HH") : "23"%>");
				$("#ddlEndMin").val("<%: Model.Term.AccessRestrictionStartDay != null && DateTime.Parse(Model.Term.AccessRestrictionEndDay).ToString("mm") != null ?  DateTime.Parse(Model.Term.AccessRestrictionEndDay).ToString("mm") : "59"%>");
			<%
			}
			%>
		            
			for (var i = 0; i < 17; i++) {
				if ($("#hdnTermNo").val() != 0 && $("#hdnTermNo").val() != null) {
					$("#txtautodate").val($("#hdnWeekStartDay_0").val());
					$("#txtWeekStartDay_" + i).val($("#hdnWeekStartDay_" + i).val());
                    $("#txtWeekEndDay_" + i).val($("#hdnWeekEndDay_" + i).val());
				}
				else {
                    $("#txtWeekStartDay_" + i).val("");
                    $("#txtWeekEndDay_" + i).val("");
                }
            }
		});


        $("#btnAutoDate").on("click", function () {
            if ($("#txtautodate").val() == "") {
                $("#txtautodate").focus();
                bootAlert("기준일자를 입력해주세요.");
            } else {
                ajaxHelper.CallAjaxPost("/System/GetWeekDay", { sd: $("#txtautodate").val(), pd: $("#txtautopn").val() }, "cbWeekly");
            }
        });

		function cbWeekly() {
			var result = ajaxHelper.CallAjaxResult();
			
            $.each($(result.split(';')), function (i, d) {
				$("input.datepicker.week").eq(i).val(d);
			});
			setTimeout(function () {
                bootAlert("저장해야 반영이 됩니다.")
			}, 100);
		};

		$("#btnSave").click(function () {

			var date = /[0-9]{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])/;

			if ("<%:ConfigurationManager.AppSettings["UnivYN"].ToString()%>" == "N") {
				if ($("#txtTermRound").val() == "") {
					bootAlert("회차는 필수입력입니다.", 1);
					$("#txtTermRound").focus();
					return false;
				}
			}

			if ($("#txtTermStartDay").val() == "") {
                bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>운영 시작일자는 필수입력입니다.", 1);
				$("#txtTermStartDay").focus();
				return false;
			}
			if (!date.test($("#txtTermStartDay").val())) {
				bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
				$("#txtTermStartDay").focus();
				return false;
			}

            if ($("#txtTermEndDay").val() == "") {
                bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>운영 종료일자는 필수입력입니다.", 1);
                $("#txtTermEndDay").focus();
                return false;
			}
			if (!date.test($("#txtTermEndDay").val())) {
				bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
				$("#txtTermEndDay").focus();
				return false;
			}

             if ($("#txtLectureStartDay").val() == "") {
                bootAlert("수강시작일자는 필수입력입니다.", 1);
                $("#txtLectureStartDay").focus();
                return false;
			}
			if (!date.test($("#txtLectureStartDay").val())) {
				bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
				$("#txtLectureStartDay").focus();
				return false;
			}

            if ($("#txtLectureEndDay").val() == "") {
                bootAlert("수강종료일자는 필수입력입니다.", 1);
                $("#txtLectureEndDay").focus();
                return false;
			}
			if (!date.test($("#txtLectureEndDay").val())) {
				bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
				$("#txtLectureStartDay").focus();
				return false;
			}


			if ($("#txtLectureRequestStartDay").val() != "") {
				if (!date.test($("#txtLectureRequestStartDay").val())) {
					bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
					$("#txtLectureRequestStartDay").focus();
					return false;
				}
			}

			if ($("#txtLectureRequestEndDay").val() != "") {
				if (!date.test($("#txtLectureRequestEndDay").val())) {
					bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
					$("#txtLectureRequestEndDay").focus();
					return false;
				}
			}

			if ($("#txtautodate").val() == "") {
				bootAlert("온라인강의 학습주차는 필수입력입니다.", 1);
				return false;
			}
			if (!date.test($("#txtautodate").val())) {
				bootAlert("날짜는 yyyy-mm-dd 형식으로 입력해주세요.", 1);
				$("#txtautodate").focus();
				return false;
			}

			for (var i = 0; i < 16; i++) {
				$("#hdnWeekStartDay_" + i).val($("#txtWeekStartDay_" + i).val());
				$("#hdnWeekEndDay_" + i).val($("#txtWeekEndDay_" + i).val());

				if ($("#hdnWeekStartDay_" + i).val() == "") {
					bootAlert((i+1) + "주차가 시작일이 미입력입니다.", 1);
					return false;
				}
				if (!date.test($("#hdnWeekStartDay_" + i).val())) {
					bootAlert((i + 1) + "주차 시작일 날짜는 yyyy-mm-dd 형식으로 입력해주세요", 1);
					return false;
				}

				if ($("#hdnWeekEndDay_" + i).val() == "") {
					bootAlert((i + 1) + "주차가 종료일이 미입력입니다.", 1);
					return false;
				}
				if (!date.test($("#hdnWeekEndDay_" + i).val())) {
					bootAlert((i + 1) + "주차 종료일 날짜는 yyyy-mm-dd 형식으로 입력해주세요", 1);
					return false;
				}

			}
	

			if ($("#txtAccessRestrictionStartDay").val() != "") {
				$("#txtAccessRestrictionStartDay").val($("#txtAccessRestrictionStartDay").val() + " " + $("#ddlStartHour").val() + ":" + $("#ddlStartMin").val() + ":00");
			}

			if ($("#txtAccessRestrictionEndDay").val() != "") {
				$("#txtAccessRestrictionEndDay").val($("#txtAccessRestrictionEndDay").val() + " " + $("#ddlEndHour").val() + ":" + $("#ddlEndMin").val() + ":59");
			}
			if ($("#hdnTermNo").val() == 0) {
				$("#hdnTermYear").val($("#ddlTermYear").val());
				$("#hdnTermQuarter").val($("#ddlTermGubun").val());
			}

			bootAlert("저장했습니다.", function () {
				document.forms["mainForm"].submit();
			});
		});

		function fnCancel() {
			location.href = "/System/TermList";
        }

	</script>
</asp:Content>