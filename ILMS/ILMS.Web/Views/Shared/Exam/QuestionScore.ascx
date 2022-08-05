<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<h3 class="title04">주차별 문항수 및 배점 설정</h3>
<div class="card collapse show" id="collapseExample4">
	<div class="card-body py-0">
		<div class="table-responsive">
			<table class="table table-sm table-horizontal" id="scoreList" summary="주차별 문항수/배점 리스트">
				<caption>주차별 문항수/배점 리스트</caption>
				<thead>
					<tr>
						<th scope="col">주차</th>
						<% 
							foreach (var item in (Model.RandomList))
							{
						%>
						<th scope="col">
							<%:item.Week %>
							<input type="hidden" id="hdnRandomDiffCodes<%:item.Week %>" name="hdnRandomDiffCodes" value="<%:item.Difficulty %>" />
						</th>
						<%
							}
						%>
						<th scope="col">소계</th>
					</tr>
				</thead>
				<tbody>
					<tr class="q-count">
						<th scope="col">후보 문항수</th>
						<% 
							foreach (var item in (Model.RandomList))
							{
						%>
						<th scope="col">
							<span id="spanWeek<%:item.Week %>"><%:(item.QuestionCnt > 0) ? item.QuestionCnt : "" %></span>
							<input type="hidden" id="hdnQuestionCnt<%:item.Week %>" name="hdnQuestionCnt" value="<%:(item.QuestionCnt > 0) ? item.QuestionCnt : "" %>">
						</th>
						<%
							}
						%>
						<th id="totalWeek"></th>
					</tr>
					<tr>
						<th scope="col">출제 문항수</th>
						<%
							foreach (var item in (Model.RandomList))
							{
						%>
						<td class="text-right">
							<input type="text" id="txtRandomDiffCount<%:item.Week %>" name="txtRandomDiffCount" maxlength="3" value="<%:(item.ExamRowNum > 0) ? item.ExamRowNum : "" %>" class="form-control form-control-sm" <%:(item.QuestionCnt > 0) ? "" : "readonly" %> onkeyup="fnScoreSum(<%:item.Week %>)">
						</td>
						<%
							}
						%>
						<td class="text-right"><span id="spanTotalCounts">0</span></td>
					</tr>

					<tr>
						<th scope="col">문항당 배점</th>
						<% 
							foreach (var item in (Model.RandomList))
							{
						%>
						<td class="text-right"><input type="text" id="txtWeekPoint<%:item.Week %>" name="txtWeekPoint" value="<%:(item.EachPointDec > 0) ? decimal.Parse(item.EachPointDec.ToString()).ToString("G29") : "" %>" class="form-control form-control-sm" <%:(item.QuestionCnt > 0) ? "" : "readonly" %> onkeyup="fnScoreSum(<%:item.Week %>)"></td>
						<%
							}
						%>
						<td></td>
					</tr>

					<tr>
						<th scope="col">배점 소계</th>
						<% 
							foreach (var item in (Model.RandomList))
							{
						%>
						<td class="text-right">
							<span id="spanRandomDiffSumScore<%:item.Week %>"><%:(item.ExamRowNum * item.EachPointDec > 0) ? decimal.Parse((item.ExamRowNum * item.EachPointDec).ToString()).ToString("G29") : "" %></span>
							<input type="hidden" id="hdnRandomDiffSumScore<%:item.Week %>" name="hdnRandomDiffSumScore" value="<%:item.ExamRowNum * item.EachPointDec %>" />
						</td>
						<%
							}
						%>
						<td class="text-right"><span id="spanSumScores">0</span></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>

<script>
	function fnScoreSum(getWeek) {
		var QuestionCnt = parseFloat(($("#txtRandomDiffCount" + getWeek).val() != "") ? $("#txtRandomDiffCount" + getWeek).val() : "0");	// 출제 문항수
		var QuestionScore = parseFloat(($("#txtWeekPoint" + getWeek).val() != "") ? $("#txtWeekPoint" + getWeek).val() : "0");			// 문항당 배점

		var WeekSumScore = QuestionCnt * QuestionScore; // 주차별 배점 소계
		var TotWeekSumScore = 0; // 출제 문항수 소계
		var TotSumScore = 0; // 배점 소계

		// 초기화
		$("#spanTotalCounts").html("");
		$("#spanRandomDiffSumScore" + getWeek).html("");
		$("#hdnRandomDiffSumScore" + getWeek).val("");
		$("#spanSumScores").html("");

		// 출제 문항수 합산
		$("input[name=txtRandomDiffCount]").each(function (index, item) {
			TotWeekSumScore += parseFloat(($(item).val() != "") ? $(item).val() : "0");
		});

		// 출제 문항수 소계
		$("#spanTotalCounts").html(fnAddCommas("B", TotWeekSumScore.toString()));

		// 주차별 배점 소계
		if (WeekSumScore > 0) {
			$("#spanRandomDiffSumScore" + getWeek).html(fnAddCommas("B", WeekSumScore.toString()));
		}
		
		$("#hdnRandomDiffSumScore" + getWeek).val(WeekSumScore);

		// 배점 합산
		$("input[name=hdnRandomDiffSumScore]").each(function (index, item) {
			TotSumScore += parseFloat($(item).val());
		});
	
		$("#spanSumScores").html(fnAddCommas("B", parseFloat(TotSumScore.toFixed(3)).toString()));
	}
</script>