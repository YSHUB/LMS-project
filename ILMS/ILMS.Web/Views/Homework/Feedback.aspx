<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Homework/Feedback/<%:Model.Homework.CourseNo %>" method="post" id="mainForm">
		<h3 class="title04">과제 정보</h3>
		<div class="card card-style01">
			<div class="card-header">
				<div class="row no-gutters align-items-center">
					<div class="col">
						<div class="row">
							<div class="col-md">
								<div class="text-primary font-size-14">
									<strong class="text-danger bar-vertical"><%:Model.Homework.Week %>주 <%:Model.Homework.InningSeqNo %>차시</strong>
									<strong class="text-success bar-vertical"><%:Model.Homework.SubmitTypeName %></strong>

									<strong class="text-danger"><%:Model.Homework.OpenYesNo == "Y" ? "공개" : "비공개" %></strong>
								</div>
								<input type="hidden" name="Homework.HomeworkNo" value="<%: Model.Homework.HomeworkNo %>" />
								<input type="hidden" name="Homework.CourseNo" value="<%: ViewBag.Course.CourseNo %>" />
								<input type="hidden" id="hdnRefreshUserNo" name="RefreshUserNo" />
							</div>
							<div class="col-md-auto text-right">
								<dl class="row dl-style01">
									<dt class="col-auto">제출인원</dt>
									<dd class="col-auto"><%:Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.SubmitContents) && x.FileGroupNo > 0).Count() %>명</dd>
									<dt class="col-auto">평가인원</dt>
									<dd class="col-auto"><%:Model.HomeworkSubmitList.Where(x => x.Score != null).Count() %>명/<%:Model.HomeworkSubmitList.Where(x => !string.IsNullOrEmpty(x.TargetYesNo) && x.TargetYesNo.Equals("Y")).Count() %>명</dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="col-auto text-right d-md-none">
						<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#colHomework" aria-expanded="false" aria-controls="colHomework">
							<span class="sr-only">더 보기</span>
						</button>
					</div>
				</div>
				<a href="/Homework/Detail/<%:ViewBag.Course.CourseNo %>/<%:Model.Homework.HomeworkNo %>" class="card-title01 text-dark"><%:Model.Homework.HomeworkTitle %>   </a>
			</div>
			<div class="card-body collapse d-md-block" id="colHomework">
				<div class="row mt-2 align-items-end">
					<div class="col-md">
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>과제유형</dt>
							<dd class="col-8 col-md"><%:Model.Homework.HomeworkTypeName %></dd>
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>평가공개여부</dt>
							<dd class="col-8 col-md"><%:Model.Homework.EstimationOpenYesNo == "Y" ? "공개" : "비공개" %>
								<input type="button" id="btnEstimation" class="btn btn-sm btn-outline-primary" value="<%:Model.Homework.EstimationOpenYesNo == "Y" ? "비공개" : "공개" %>로 변경" /></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출기간</dt>
							<dd class="col-8 col-md"><%:DateTime.Parse(Model.Homework.SubmitStartDay).ToString("yyyy-MM-dd HH:mm") %> ~ <%:DateTime.Parse(Model.Homework.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>추가제출기간</dt>
							<dd class="col-8 col-md"><%if (Model.Homework.AddSubmitPeriodUseYesNo.Equals("Y")) {%><%:DateTime.Parse(Model.Homework.AddSubmitStartDay).ToString("yyyy-MM-dd HH:mm") %> ~ <%:DateTime.Parse(Model.Homework.AddSubmitEndDay).ToString("yyyy-MM-dd HH:mm") %><%} else {%>사용안함<%} %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>내용</dt>
							<dd class="col"><%:Model.Homework.HomeworkContents %>
							</dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>만점기준</dt>
							<dd class="col-8 col-md"><%:Model.Homework.Weighting %>점</dd>
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>평균점수</dt>
							<dd class="col-8 col-md"><%:Model.HomeworkSubmitList.Where(c => c.Score != null).Count().Equals(0) ? "0" : Model.HomeworkSubmitList.Where(c => c.Score != null).Average(c => c.Score.Value).ToString("##.##") %>점</dd>
						</dl>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-12 mt-2">
				<h3 class="title04">제출자 정보</h3>
				<div class="card">
					<div class="card-body">
						<ul class="list-inline-style03">
							<li class="list-inline-item">
								<strong class="pr-2"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></strong>
								<span><%:Model.HomeworkSubmit.UserID %></span>
							</li>
							<li class="list-inline-item bar-vertical"></li>
							<li class="list-inline-item">
								<strong class="pr-2">이름</strong>
								<span><%:Model.HomeworkSubmit.HangulName %></span>
							</li>
							<li class="list-inline-item bar-vertical"></li>
							<li class="list-inline-item">
							<%
								if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
								{
							%>
								<strong class="pr-2">학년</strong>
								<span><%:Model.HomeworkSubmit.Grade %></span>
							<%
								}
								else
								{
							%>
								<strong class="pr-2">이메일</strong>
								<span><%:Model.HomeworkSubmit.Email %></span>
							<%
								}
							%>
							</li>
							<li class="list-inline-item bar-vertical"></li>
							<li class="list-inline-item">
							<%
								if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
								{
							%>
								<strong class="pr-2">소속</strong>
								<span><%:Model.HomeworkSubmit.AssignName %></span>
							<%
								}
								else
								{
							%>
								<strong class="pr-2">구분</strong>
								<span><%:Model.HomeworkSubmit.GeneralUserCode %></span>
							<%
								}
							%>
							</li>
						</ul>
					</div>
				</div>
				<h3 class="title04">제출과제 정보</h3>
				<div class="card card-style01">
					<div class="card-header">
						<div class="row align-items-center">
							<div class="col-12 col-lg">
								<p class="card-title02">
									<%:Model.HomeworkSubmit.HomeworkTitle %>
								</p>
								<input type="hidden" name="HomeworkSubmit.SubmitNo" value="<%: Model.HomeworkSubmit.SubmitNo %>" />
								<input type="hidden" name="HomeworkSubmit.SubmitUserNo" value="<%: Model.HomeworkSubmit.SubmitUserNo %>" />
							</div>
							<div class="col-auto text-right">
								<dl class="row dl-style01">
									<dt class="col-auto text-dark">첨부파일</dt>
									<dd class="col-auto mb-0"><%:Model.FileList != null ? (Model.FileList.Count > 0 ? Model.FileList.Count.ToString() + "개" : "없음") : "없음" %></dd>
									<dt class="col-auto text-dark">제출일시</dt>
									<dd class="col-auto mb-0"><%:Model.HomeworkSubmit.SubmitContents != null || Model.HomeworkSubmit.FileGroupNo > 0 ?  Model.HomeworkSubmit.UpdateDateTime : "없음"%></dd>
								</dl>
							</div>
						</div>
					</div>
					<div class="card-body">
						<p>
							<%:string.IsNullOrEmpty(Model.HomeworkSubmit.SubmitContents) ? Model.HomeworkSubmit.FileGroupNo > 0 ? Model.HomeworkSubmit.SubmitContents : "제출 시 입력한 내용이 표시됩니다." : Model.HomeworkSubmit.SubmitContents%>
						</p>
						<div class="row align-items-center">
							<div class="col-md">
							<% 
								if (Model.FileList != null)
								{
									if(Model.FileList.Count > 0)
									{
								%>
								<dl class="row dl-style01">
									<dt class="col-auto text-dark">제출파일</dt>
									<dd class="col-auto mb-0">
										<%
											foreach (var item in Model.FileList)
											{
										%>
											<div class="font-size-15">
												<a href="/Common/FileDownLoad/<%:item.FileNo %>" title="다운로드">
													<i class="bi bi-paperclip"></i>
													<span><%:item.OriginFileName%></span>
												</a>
												<a class="btn btn-sm btn-danger ml-2 d-none" role="button" onclick="fnFileDeleteNew(<%:item.FileNo %>, this);" title="삭제">삭제</a>
											</div>
										<%
											}
										%>
									</dd>
								</dl>
								<%
									}
								}
							%>
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="row">
							<div class="col-12">
								<div class="form-row">
									<div class="form-group col-8 col-md-3">
										<label for="txtScore" class="form-label">평가점수 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<input type="text" class="form-control text-right" id="txtScore" name="HomeworkSubmit.Score" value="<%:Model.HomeworkSubmit.Score != null ? Convert.ToInt32(Model.HomeworkSubmit.Score) : 0 %>" />
											<div class="input-group-append">
												<div class="input-group-text">점/<%:Model.Homework.Weighting %>점</div>
											</div>
										</div>
									</div>
								</div>
								<div class="form-row">
									<div class="form-group col-12">
										<label for="txtFeedback" class="form-label">코멘트 <strong class="text-danger">*</strong></label>
										<div class="input-group">
											<textarea class="form-control" rows="5" id="txtFeedback" name="HomeworkSubmit.Feedback"><%:Model.HomeworkSubmit.Feedback != null ? Model.HomeworkSubmit.Feedback.ToString() : "" %></textarea>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-6">
				<div class="dropdown d-inline-block">
					<button type="button" class="btn btn-secondary dropdown-toggle" id="ddlSend" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						저장옵션 선택
					</button>
					<ul class="dropdown-menu" aria-labelledby="ddlSend">
						<li>
							<button class="dropdown-item" type="button" onclick="fnFeedbackSave(<%:Model.HomeworkSubmit.SubmitUserNo %>);">저장하기</button></li>
						<li>
							<button class="dropdown-item" type="button" onclick="fnFeedbackSave(<%:Model.PrevUserNo %>);">저장하고 이전 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %></button></li>
						<li>
							<button class="dropdown-item" type="button" onclick="fnFeedbackSave(<%:Model.NextUserNo %>);">저장하고 다음 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %></button></li>
					</ul>
					<button type="button" class="btn btn-primary" id="btnCertificate">자격취득등록</button>
				</div>
			</div>
			<div class="col-6">
				<div class="text-right">
					<a href="/Homework/Detail/<%:ViewBag.Course.CourseNo %>/<%:Model.Homework.HomeworkNo %>" class="btn btn-primary">목록</a>
				</div>
			</div>
		</div>
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {

			$("#btnEstimation").click(function () {
				if (confirm("과제 평가를 " + '<%:Model.Homework.EstimationOpenYesNo.Equals("Y") ? "비공개" : "공개"%>' + "하시겠습니까?")) {
					window.location = '/Homework/DetailEstimationEdit/<%:Model.Homework.CourseNo%>/<%:Model.Homework.HomeworkNo%>/<%:Model.HomeworkSubmit.SubmitUserNo%>';
				}
			});

			$("#btnCertificate").click(function () {
				fnOpenPopup('/Homework/RegisterLicense/<%:ViewBag.Course.CourseNo%>/<%:Model.Homework.HomeworkNo%>/<%:Model.HomeworkSubmit.SubmitUserNo%>', 700, 800, 0, 0, "auto");
			})

		});

		function fnFeedbackSave(userno) {
			$("#hdnRefreshUserNo").val(userno);
			if ($("#txtScore").val() == "") {
				bootAlert("평가점수를 입력해주세요.");
				return false;
			}

			if ($("#txtFeedback").val() == "") {
				bootAlert("코멘트를 입력해주세요.");

				return false;
			}

			if (parseInt($("#txtScore").val()) > parseInt(<%:Model.Homework.Weighting%>)) {
				bootAlert("평가점수를 만점기준 점수보다 크게 입력했습니다.");

				return false;
			}

			if ("<%:Model.Homework.HomeworkType%>" == "CHWT003" && (parseInt($("#txtScore").val()) > parseInt(<%:Model.Homework.Weighting%>) * 0.89)) {
				bootAlert("시험대체형 과제는 만점대비 89%를 초과하여 배점할 수 없습니다.", function () {
					$("#txtScore").val(parseInt(<%:Model.Homework.Weighting%>) * 0.89);
				});

				return false;
			}

			document.forms["mainForm"].submit();
		}
	</script>
</asp:Content>
