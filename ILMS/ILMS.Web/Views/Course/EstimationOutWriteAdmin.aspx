<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

<form action="/Course/EstimationOutWriteAdmin" method="post" id="mainForm">
	<div id="content">
		<ul class="nav nav-tabs mt-4" role="tablist">
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('WriteOutAdmin')" role="tab">기본정보</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('ListWeekOutAdmin')" role="tab">주차 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link active" href="javascript:void(0);" onclick="fnGoTab('EstimationOutWriteAdmin')" role="tab">평가기준 설정</a>
			</li>
			<li class="nav-item" role="presentation">
				<a class="nav-link" href="javascript:void(0);" onclick="fnGoTab('OcwOutAdmin')" role="tab">콘텐츠 설정</a>
			</li>
		</ul>
		
		<div class="row">
			<div class="col-12 mt-2">
				<div class="card card-style02">
					<div class="card-header">
						<div>
							<%if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
								{
							%>
							<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
							<%
								}
								if (ConfigurationManager.AppSettings["UnivYN"].Equals("N")) 
								{
							%>
								<span class="badge badge-1"><%:Model.Course.StudyTypeName %></span>
							<%
								}
							  else
								{
							%>
								<span class="badge badge-1"><%:Model.Course.ClassificationName %></span>
							<%
								}
							%>
						</div>
						<span class="card-title01 text-dark"><%:Model.Course.SubjectName %></span>
					</div>
					<div class="card-body">
						<dl class="row dl-style02">
							<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %></dt>
							<dd class="col-9 col-md-4"><%:Model.Course.AssignName %></dd>
							<dt class="col-3 col-md-auto w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>구분</dt>
							<dd class="col-9 col-md-5"><%:Model.Course.TermName %></dd>
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
												<input type="hidden" id="hdnEstimationItemGubun" name="EstimationItemGubun" value="<%:item.EstimationItemGubun %>"/>
												<th scope="col"><%:item.EstimationItemGubunName%></th>
										<%
											}
										%>
										<th scope="col" class="<%: ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">참여도</th>
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
														<input type="text" id="txtEstimationRateScore<%:Model.EstimationItemBasis.IndexOf(item) + 1 %>" name="EstimationRateScore" class="form-control text-center" maxlength="3" onkeyup="fnScoreSum()" value="<%:Model.EstimationItemBasis != null ? item.RateScore : 0 %>"/>		
													</div>
												</td>
										<%
											}
										%>
										<td class="text-center <%: ConfigurationManager.AppSettings["UnivYN"].Equals("N") ? "d-none" : "" %>">
											<div class="item">
												<input type="text" id="txtParticipationRateScore" readonly="readonly" class="form-control text-center" maxlength="3" value="<%:Model.ParticipationEstimationItemBasis != null ? Model.ParticipationEstimationItemBasis.Sum(s => s.RateScore) : 0 %>"/>		
											</div>
										</td>
										<td class="text-center">
											<div class="item">
												<input type="text" id="txtEstimationRateScoreSum" readonly="readonly" class="form-control text-center" maxlength="3" value="<%: Model.EstimationItemBasis != null ? Model.EstimationItemBasis.Sum(s => s.RateScore) + Model.ParticipationEstimationItemBasis.Sum(s => s.RateScore) : 0 %>"/>		
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
		

				<h3 class="title04 <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : "" %>">참여도항목 세부기준</h3>
				<div class="card <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : "" %>">
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
				</div>


				<h3 class="title04">수료기준</h3>
				<div class="card">
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-md-12 form-inline m-0">
								<label for="txtPassPoint col-md-3" class="form-label text-secondary w-10rem">수료기준 설정 총점</label>
								<div class="input-group col-md-9 p-0">
									<input type="text" id="txtPassPoint" name="Course.PassPoint" class="form-control text-right" value="<%:Model.Course != null ? Model.Course.PassPoint : 0 %>">
									<div class="input-group-append">
										<span class="input-group-text">점 이상</span>
									</div>
								</div>
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
			</div>
		</div>
	</div>

	<input type="hidden" id="hdnCourseNo" name="ParticipationEstimationBasis.CourseNo" value="<%:Model.Course.CourseNo %>" />

</form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 항목 비율(점수) 입력 시 합계 자동 입력 --%>
		function fnScoreSum() {
			var participationTotal = 0;
			var estimationTotal = 0;
			var totalScore = 0;

			<%-- 초기화 --%>
			$("#txtEstimationRateScoreSum").val("");
			$("#txtParticipationRateScoreSum").val(0);

			<%-- 합계 --%>
			$("input[name=EstimationRateScore]").each(function (index, item) {
				estimationTotal += parseInt(($(item).val() != "") ? $(item).val() : "0");
				estimationTotal = estimationTotal + parseInt($("#txtParticipationRateScore").val());
				totalScore = estimationTotal;
								
				if (estimationTotal > 100) {

					bootAlert("평가점수 합계는 100점(%)을 넘길 수 없습니다.");

					$(item).val(0);
					$(item).fucus();
					fnScoreSum();
					return false;

				} else {

					$("#txtEstimationRateScoreSum").val(fnAddCommas("B", estimationTotal.toString()));
				}

			});


			$("input[name=ParticipationRateScore]").each(function (index, item) {

				participationTotal += parseInt(($(item).val() != "") ? $(item).val() : "0");
			});

			$("#txtEstimationRateScoreSum").val(fnAddCommas("B", estimationTotal.toString()));
			$("#txtParticipationRateScoreSum").val(fnAddCommas("B", participationTotal.toString()));	
		}

		<%-- 저장 --%>
		$("#btnSave").click(function () {
			<% 
				if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
				{
			%>
			   if ($("#txtParticipationRateScore").val() != $("#txtParticipationRateScoreSum").val()) {
				   	bootAlert("참여도 세부기준의 비율은 참여도 비율과 같아야합니다.");
				   	return false;
			   }
			<%
				}
			%>
			
			var totalScore = 0;

			$("input[name=EstimationRateScore]").each(function (index, item) {
				totalScore += parseInt(($(item).val() != "") ? $(item).val() : "0");
				<% 
					if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
					{
				%>
				totalScore += parseInt($("#txtParticipationRateScore").val());
				<%
					}
				%>
			});

			if (totalScore < 100) {
				bootAlert("평가항목 점수의 합계는 100%가 되어야 합니다.");
				return false;
			}

			if (!($("#txtPassPoint").val() > 0)) {
				bootAlert("수료기준 총점을 설정해야합니다.");
				$("#txtPassPoint").focus();
				return false;
			}

			if ($("#txtPassPoint").val() > 100) {
				bootAlert("수료기준 총점은 100점을 넘을 수 없습니다.");
				$("#txtPassPoint").focus();
				return false;
			}

			bootConfirm("저장하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Course/EstimationOutWriteAdmin", $("#mainForm").serialize(), "fnCompleteEstimationSave");
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
			location.href = "/Course/" + pageName + "/" + <%:Model.Course.CourseNo%> +"?TermNo=" + <%:Model.Course.TermNo %> + "&SearchText=" + encodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

		function fnGo() {
            window.location.href = "/Course/ListOutAdmin/?TermNo=" + '<%:Model.Course.TermNo %>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
        }
	</script>
</asp:Content>