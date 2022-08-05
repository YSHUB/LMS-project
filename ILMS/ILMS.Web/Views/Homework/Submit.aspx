<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04">과제 정보</h3>
	<div class="card card-style01">
		<div class="card-header">
			<div class="row no-gutters align-items-center">
				<div class="col">
					<div class="row">
						<div class="col-md">
							<div class="text-primary font-size-14">
								<strong class="text-danger bar-vertical"><%:Model.Homework.Week %>주 <%:Model.Homework.InningSeqNo %>차시</strong>
							</div>
						</div>
					</div>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#colHomework" aria-expanded="false" aria-controls="colHomework">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<a class="card-title01 text-dark"><%:Model.Homework.HomeworkTitle %></a>
		</div>
		<div class="card-body collapse d-md-block" id="colHomework">
			<div class="row mt-2 align-items-end">
				<div class="col-md">
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>과제종류</dt>
						<dd class="col-8 col-md"><%:Model.Homework.HomeworkKindName %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>과제유형</dt>
						<dd class="col-8 col-md"><%:Model.Homework.HomeworkTypeName %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>제출기간</dt>
						<dd class="col-8 col-md"><%:DateTime.Parse(Model.Homework.SubmitStartDay).ToString("yyyy-MM-dd HH:mm") %> ~ <%:DateTime.Parse(Model.Homework.SubmitEndDay).ToString("yyyy-MM-dd HH:mm") %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>추가제출기간</dt>
						<dd class="col-8 col-md"><%:Model.Homework.AddSubmitPeriodUseYesNo == "Y" ? DateTime.Parse(Model.Homework.AddSubmitStartDay).ToString("yyyy-MM-dd HH:mm") + " ~ " + DateTime.Parse(Model.Homework.AddSubmitEndDay).ToString("yyyy-MM-dd HH:mm") : "없음" %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>내용</dt>
						<dd class="col">
							<%:Model.Homework.HomeworkContents %>
						</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>만점기준</dt>
						<dd class="col-8 col-md"><%:Model.Homework.Weighting %>점</dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>첨부파일</dt>
						<dd class="col">
							<%
								if (Model.HomeworkfileList != null)
								{
									if(Model.HomeworkfileList.Count > 0)
									{
								%>
								<button title="첨부파일 다운로드" id="btnDownload" class="btn btn-lg"><i class="bi bi-download"></i></button>
								<%
									}
									else
									{
								%>
								없음
								<%}
								}
								else 
								{
								%>
								없음
								<%
								}
								%>
						</dd>
					</dl>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-12">
			<%
				if (Model.HomeworkSubmit.Score != null && Model.HomeworkSubmit.Feedback != null)
				{
			%>
			<h3 class="title04">결과(피드백)</h3>
			<div class="card card-style01">
				<%
					if (Model.HomeworkSubmit.Score !=  null && Model.Homework.EstimationOpenYesNo == "Y")
					{ 
				%>
						<div class="card-header">
							<%:Model.HomeworkSubmit.Score %>점
						</div>
				<%
					}
					else
					{
				%>
						<div class="card-header">
							<div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i> 점수가 없거나 점수공개여부가 비공개입니다.</div>
						</div>

				<%	
					}
				%>
				
				<div class="card-body">
					<%:Model.HomeworkSubmit.Feedback%>
				</div>
			</div>
			<%
				}
			%>
			<form action="/Homework/AddContents/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
				<h3 class="title04">제출정보</h3>
					<div class="card card-style01">
						<div class="card-header <%: (Convert.ToDateTime(Model.Homework.SubmitEndDay) < DateTime.Now) || (Model.Homework.AddSubmitPeriodUseYesNo.Equals("Y") && (Convert.ToDateTime(Model.Homework.AddSubmitStartDay) < DateTime.Now || DateTime.Now < Convert.ToDateTime(Model.Homework.AddSubmitEndDay))) ? "" : "d-none" %>">
							<div class="row align-items-center">
								<div class="col-12 col-lg">
									<p class="card-title02">
										<input type="hidden" name="HomeworkSubmit.HomeworkNo" value="<%: Model.HomeworkSubmit.HomeworkNo %>" />
										<input type="hidden" name="HomeworkSubmit.SubmitNo" value="<%: Model.HomeworkSubmit.SubmitNo %>" />
									</p>
								</div>
								<div class="col-auto text-right text-danger">
									<%
										if (Convert.ToDateTime(Model.Homework.SubmitEndDay) < DateTime.Now)
										{
											if ((Model.Homework.AddSubmitPeriodUseYesNo.Equals("Y") && (Convert.ToDateTime(Model.Homework.AddSubmitStartDay) < DateTime.Now || DateTime.Now < Convert.ToDateTime(Model.Homework.AddSubmitEndDay)))) {
											}else
											{
										%>
												과제  제출 기간이 지났습니다.
										<%
											}
										}
									%>
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="row">
								<div class="col-12">
									<div class="form-row">
										<div class="form-group col-12">
											<label for="txtSubmitContents" class="form-label">제출 내용 </label>
											<div class="input-group">
												<textarea class="form-control" id="txtSubmitContents" name="HomeworkSubmit.SubmitContents" rows="5"><%:Model.HomeworkSubmit.HomeworkType != "CHWT004" ? Model.HomeworkSubmit.SubmitContents != null ? Model.HomeworkSubmit.SubmitContents : "" : Model.HomeworkSubmit.LeaderContents != null ? Model.HomeworkSubmit.LeaderContents : "" %></textarea>
											</div>
										</div>
									</div>
								</div>
								<div class="col-12">
									<div class="form-row">
										<div class="form-group col-12">
											<label for="file" class="form-label">첨부파일</label>
											<% Html.RenderPartial("./Common/File"
												, Model.FileList
												, new ViewDataDictionary {
												{ "name", "FileGroupNo" },
												{ "fname", "SubmitFile" },
												//{ "value", ViewBag.FileGroup == null ? 0 : ViewBag.FileGroup },
												{ "value", 0 },
												{ "fileDirType", "Submit"},
												{ "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
										</div>
									</div>
								</div>
							</div>
						</div>
					<div class="card-footer">
						<div class="row">
							<div class="col-6">
								<p class="font-size-14 text-info font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 제출내용 입력 또는 첨부파일 선택 중 한 가지만 하셔도 저장 가능합니다.</p>
							</div>
							<div class="col-6">
								<div class="text-right">
									<%
										if (Convert.ToDateTime(Model.Homework.SubmitEndDay) > DateTime.Now || (Model.Homework.AddSubmitPeriodUseYesNo.Equals("Y") && (Convert.ToDateTime(Model.Homework.AddSubmitStartDay) < DateTime.Now || DateTime.Now < Convert.ToDateTime(Model.Homework.AddSubmitEndDay))))
										{
									%>
										<button type="button" class="btn btn-primary" id="btnSave">저장</button>
									<%
										}
									%>
									<a href="/Homework/ListStudent/<%:ViewBag.Course.CourseNo %>" class="btn btn-secondary">취소</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</form>
			<%
				if (Model.HomeworkSubmitList.Where(x => x.IsGood == 1).Count() > 0)
				{
			%>
			<h3 class="title04">추천 과제목록 <small class="text-small text-muted"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 종료전까지 다운로드 할 수 있습니다.</small></h3>
			<ul class="list-group">
				<%
					foreach (var item in Model.HomeworkSubmitList.Where(x => x.IsGood == 1))
					{
				%>
				<li class="list-group-item">
					#<%:item.HangulName %> <a href="/Common/FileDownLoad/<%:item.FileGroupNo %>" class="font-size-20 text-primary"><i class="bi bi-download"></i></a>
				</li>
				<%
					}
				}
				%>
			</ul>
		</div>
	</div>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();

		$(document).ready(function () {

			$("#btnSave").click(function () {
				bootConfirm("저장하시겠습니까?", fnSave);
			});

			function fnSave() {
				if ($("input[name*=SubmitFile]").attr("data-empty") == 1 && $("#txtSubmitContents").val() == "") {
					bootAlert("제출내용을 입력하세요");
					return false;
				}

				if ($("input[name*=SubmitFile]").attr("data-empty") == 0 && $("#txtSubmitContents").val() == "") {
					$("#txtSubmitContents").val("[파일 제출]");
				}
				document.forms["mainForm"].submit();
			}


			$("#btnCancel").click(function () {
				window.location = "/Homework/ListStudent/<%:ViewBag.Course.CourseNo%>";
			});

			$("#btnDownload").click(function () {
				var filegroupno = '<%:Model.Homework.FileGroupNo%>';

				_ajax.CallAjaxPost("/Common/DownloadFileZip", { param1: filegroupno, param2: "<%:Model.Homework.HomeworkTitle.Replace("\"", "")%>", param3: "CourseHomework", param4: "" }, "fnFilezip");
			});

		});

		function fnFilezip() {
			var result = _ajax.CallAjaxResult();
			if (result != "") {
				window.location.href = result;
			}
			else {
				bootAlert("일괄 다운 받을 파일이 없습니다.");
			}
		}

	</script>
</asp:Content>
