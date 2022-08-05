<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

<form action="/Course/EstimationWriteAdmin" method="post" id="mainForm">
	<div id="content">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdmin')">기본정보</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('DetailAdminViewOption')">분반설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('ListWeekAdmin')">주차 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link active" href="javascript:void(0);" role="tab" onclick="fnGoTab('EstimationWriteAdmin')">평가기준 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" role="tab" onclick="fnGoTab('OcwAdmin')">콘텐츠 설정</a>
			</li>
		</ul>
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
		<h3 class="title04">평가항목기준</h3>
		<div class="card mt-2">
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table table-hover" summary="평가항목기준">
						<caption>평가항목기준</caption>
						<thead>
							<tr>
								<th scope="col">평가항목</th>
								<%
									foreach (var item in Model.EstimationItemBasis)
									{
								%>
										<th scope="col" class="text-nowrap"><%:item.EstimationItemGubunName%></th>
								<%
									}
								%>
								<th scope="col">참여도</th>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row">비율(%)</th>
								<%
									foreach (var item in Model.EstimationItemBasis)
									{
								%>
										<td class="text-center">
											<div class="item">
												<%:Model.EstimationItemBasis != null ? item.RateScore : 0 %>
											</div>
										</td>
								<%
									}
								%>
								<td class="text-center">
									<div class="item">
										<span id="spanParticipationRateScore"><%:Model.ParticipationEstimationItemBasis != null ? Model.ParticipationEstimationItemBasis.Sum(s => s.RateScore) : 0 %></span>
									</div>
								</td>
								<td class="text-center">
									<div class="item">
										<span><%: Model.EstimationItemBasis != null ? Model.EstimationItemBasis.Sum(s => s.RateScore) : 0 %></span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="card-footer">
				<div class="row align-items-center">
					<div class="col">
						<small class="text-secondary">※ "평가항목 점수"의 합계는 100%가 되어야 합니다.</small>
					</div>
				</div>
			</div>			
		</div>
			
		<%
			if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N"))
			{
		%>
		<h3 class="title04">참여도항목 세부기준</h3>
		<div class="card">
			<div class="card-body py-0">
				<div class="table-responsive">
					<table class="table" summary="참여도항목 세부기준">
						<caption>참여도항목 세부기준</caption>
						<thead>
							<tr>
								<th scope="col">참여도</th>
								<%
									foreach (var item in Model.ParticipationEstimationItemBasis)
									{
								%>
										<input type="hidden" id="hdnParticipationItemGubun" name="ParticipationItemGubun" value="<%:item.ParticipationItemGubun %>"/>
										<th scope="col" class="text-nowrap text-center"><%:item.ParticipationItemGubunName%></th>
								<%
									}
								%>
								<th scope="col">합계</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th scope="row">비율(점수)</th>
									<%
										foreach (var item in Model.ParticipationEstimationItemBasis)
										{
									%>
											<td>
												<label for="txtParticipationRateScore" class="sr-only">비율(점수)</label>
												<div class="input-group">
													<input type="text" id="txtParticipationRateScore<%:Model.ParticipationEstimationItemBasis.IndexOf(item) + 1 %>" name="ParticipationRateScore" onkeyup="fnScoreSum()" class="form-control text-center" maxlength="3" value="<%:Model.ParticipationEstimationItemBasis != null ? item.RateScore : 0 %>">
													<div class="input-group-append">
														<span class="input-group-text">%</span>
													</div>
												</div>
											</td>
									<%
										}
									%>
								<td>
									<label for="spanParticipationRateScoreSum" class="sr-only">비율(합계)</label>
									<div class="input-group">
										<input type="text" id="txtParticipationRateScoreSum" class="form-control text-center" readonly="readonly" value="<%:Model.ParticipationEstimationItemBasis != null ? Model.ParticipationEstimationItemBasis.Sum(s => s.RateScore) : 0 %>">
										<div class="input-group-append">
											<span class="input-group-text">%</span>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">1회당 점수</th>
								<%
									foreach (var item in Model.ParticipationEstimationItemBasis)
									{
								%>
										<td>
											<label for="txtParticipationBasisScore" class="sr-only">1회당 점수</label>
											<div class="input-group">
												<input type="text" id="txtParticipationBasisScore" name="ParticipationBasisScore" class="form-control text-center" maxlength="3" value="<%:Model.ParticipationEstimationItemBasis != null ? item.BasisScore : 0 %>">
												<div class="input-group-append">
													<span class="input-group-text">점</span>
												</div>
											</div>
										</td>
								<%
									}
								%>
								<td></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div class="card-footer">
				<div class="row align-items-center">
					<div class="col">
						<small class="text-secondary">※ "참여도항목 세부점수 기준"의 합계는 "평가항목 점수 기준"에서 "참여도 비율"과 같아야 합니다.</small><br/>
						<small class="text-secondary">※ 1회당 점수는 100점 만점을 기준으로 합니다. 참여수가 많아도 100점 이상은 점수로 인정되지 않습니다.</small><br/>
						<small class="text-secondary">예시) 1회당 점수를 50점으로 설정하면, <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 2번 이상 참여하면 100점을 받을 수 있습니다.</small>
					</div>
				</div>
			</div>
			<div class="card-footer">
				<div class="text-right">
					<button type="button" id="btnSave" class="btn btn-primary">저장</button>
					<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
				</div>
			</div>
		</div>
		<%
			}
		%>
	</div>

	<input type="hidden" id="hdnCourseNo" name="ParticipationEstimationBasis.CourseNo" value="<%:Model.Course.CourseNo %>" />

</form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 참여도항목 비율(점수) 입력 시 합계 자동 입력 --%>
		function fnScoreSum() {
			var total = 0;

			// 초기화
			$("#txtParticipationRateScoreSum").val("");

			// 합계
			$("input[name=ParticipationRateScore]").each(function (index, item) {

				total += parseInt(($(item).val() != "") ? $(item).val() : "0");
			});

			// 참여도 비율점수 합계
			$("#txtParticipationRateScoreSum").val(fnAddCommas("B", total.toString()));
		}

		$("#btnSave").click(function () {

			if ($("#spanParticipationRateScore").text() != $("#txtParticipationRateScoreSum").val()) {

				bootAlert("참여도 세부기준의 비율은 참여도 비율과 같아야합니다.");
				return false;
			}

			bootConfirm("저장하시겠습니까?", function () {

				ajaxHelper.CallAjaxPost("/Course/EstimationWriteAdmin", $("#mainForm").serialize(), "fnCompleteEstimationSave");
			});
		})

		function fnCompleteEstimationSave() {

			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {

				bootAlert("저장되었습니다.", function () {

					location.reload();
				});
				
			} else {

				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 탭 이동 --%>
		function fnGoTab(pageName) {

			if (pageName == 'DetailAdminViewOption') {
				location.href = "/Course/DetailAdmin/" + <%:Model.Course.CourseNo%> + "?viewOption=1&AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			} else {
				location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> + "?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + encodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
			}
		}

		function fnGo() {

			window.location.href = "/Course/ListAdmin/?AssignNo=" + '<%:ViewBag.AssignNo %>' + "&TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&SearchProf=" + decodeURIComponent('<%:Model.SearchProf%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>