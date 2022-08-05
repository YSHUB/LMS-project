<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>
<!--sstitle-->
<%
	if(Model.GradeList.Count > 0)
	{
%>
<div id="sub_content" class="mt-2" >
	<div class="alert alert-warning">
        <ul class="mb-0">
            <li>
		        <span class="text-warning font-weight-bold">
					제목 열의 평가항목을 클릭하면 상세 점수를 확인할 수 있습니다.
		        </span>
            </li>
            <li>
		        <span class="text-primary font-weight-bold">
			        총 강의일자 중 1/3이상 결석했을 경우 출석점수와 총점은 0점이 됩니다.
		        </span>
            </li>
            <li>
		        <span class="text-primary font-weight-bold">
			        총점은 점수를 모두 합한 후 반올림값이 됩니다. 총점은 계속해서 변경될 수 있으며 수료처리 당시 점수는 수료점수로 확인가능합니다.
		        </span>
            </li>
		</ul>
	</div>
</div>
<div id="content">
	<div class="card">
		<div class="card-header">
			<div class="col-auto mt-1">
				수강생 <span class="text-primary font-weight-bold"><%:Model.GradeList.Count %></span>명
			</div>
		</div>
	<div class="card-body p-0">
			<%
				//중간고사비율
				decimal MidtermExamRatio = Model.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT001")).FirstOrDefault().RateScore;
				//기말시험비율
				decimal FinalExamRatio = Model.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT002")).FirstOrDefault().RateScore;
				//출석비율
				decimal AttendanceRatio = Model.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT006")).FirstOrDefault().RateScore;
				//퀴즈비율
				decimal QuizRatio = Model.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT003")).FirstOrDefault().RateScore;
				//과제비율
				decimal HomeworkRatio = Model.EstimationItemBasis.Where(c => c.EstimationItemGubun.Equals("CEIT004")).FirstOrDefault().RateScore;
			%>
				<div class="table-responsive">
					<table class="table table-hover" summary="성적정보">
						<tbody>
							<tr>
								<th class="text-nowrap text-center" rowspan="2" >No</th>
								<%
								if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
								{
								%>
								<th class="text-center" rowspan="2">소속</th>
								<%
								}
								%>
								<th class="text-nowrap text-center" rowspan="2">아이디</th>
								<th class="text-nowrap text-center" rowspan="2">이름</th>
								<%: Html.Raw(AttendanceRatio > 0 ? "<th class=\"text-center col-1\"><a href=\"#\" onclick=\"showDetail('"+ Model.ListType +"', 'Attendance')\">출석</a><br /></th>" : "") %>
								<%: Html.Raw(MidtermExamRatio > 0 ? "<th class=\"text-center col-1\"><a href=\"#\" onclick=\"showDetail('"+ Model.ListType +"', 'MidtermExam')\">중간</a><br /></th>" : "")%>
								<%: Html.Raw(FinalExamRatio > 0 ? "<th class=\"text-center col-1\"><a href=\"#\" onclick=\"showDetail('" + Model.ListType + "', 'FinalExam')\">기말</a><br /></th>" : "")%>
								<%: Html.Raw(QuizRatio > 0 ? "<th class=\"text-center col-1\"><a href=\"#\" onclick=\"showDetail('" + Model.ListType + "', 'Quiz')\">퀴즈</a><br /></th>" : "")%>
								<%: Html.Raw(HomeworkRatio > 0 ? "<th class=\"text-center col-1\"><a href=\"#\" onclick=\"showDetail('"+ Model.ListType +"', 'HomeWork')\">과제</a><br /></th>" : "") %>
								<th class="text-nowrap text-center" rowspan="2" >총점<br />
								</th>
								<th class="text-nowrap text-center" rowspan="2" >수료여부</th>
								<%if (Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")).ToArray()[0].IsPass != null)
								{%>
								<th class="text-nowrap text-center" rowspan="2" >수료점수</th>
								<%} %>
							</tr>
							<tr>
								<%: Html.Raw(AttendanceRatio > 0 ? "<th class=\"text-center\">" + Model.EstimationBasis.AttendanceRatio + "%</th>" : "") %>
								<%: Html.Raw(MidtermExamRatio > 0 ? "<th class=\"text-center\">" + Model.EstimationBasis.MidtermExamRatio + "%</th>" : "")%>
								<%: Html.Raw(FinalExamRatio > 0 ? "<th class=\"text-center\">"+Model.EstimationBasis.FinalExamRatio+"%</th>" : "") %>
								<%: Html.Raw(QuizRatio > 0 ? "<th class=\"text-center\">"+Model.EstimationBasis.QuizRatio+"%</th>" : "") %>
								<%: Html.Raw(HomeworkRatio > 0 ? "<th class=\"text-center\">"+Model.EstimationBasis.HomeworkRatio+"%</th>" : "") %>
							</tr>
							<%
								foreach (var item in Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")))
								{
									string css = item.TotalScore < Model.Course.PassPoint ? "text-danger" : "";
							%>
							<tr class="data">
								<td class="text-center"><%:Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")).ToList().IndexOf(item) + 1%></td>
								<%
								if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
								{
								%>
								<td class="text-center"><%: item.AssignName %></td>
								<%
								}
								%>
								<td class="text-center"><%: item.UserID %></td>
								<td class="text-center"><%: item.HangulName %></td>
								<%: Html.Raw(AttendanceRatio > 0 ?      "<td class=\"text-center\">"+ item.Attendance.ToString("F2")    +"</td>" : "") %>
								<%: Html.Raw(MidtermExamRatio > 0 ?     "<td class=\"text-center\">"+ item.MidtermExam.ToString("F2")   + (Model.EstimationBasis.PerfectionHandleBasis == "CPHB001" ? " / " + item.MidtermExam.ToString("F2")   : "")+"</td>" : "") %>
								<%: Html.Raw(FinalExamRatio > 0 ?       "<td class=\"text-center\">"+ item.FinalExam.ToString("F2")     + (Model.EstimationBasis.PerfectionHandleBasis == "CPHB001" ? " / " + item.FinalExam.ToString("F2")     : "")+"</td>" : "") %>
								<%: Html.Raw(QuizRatio > 0 ?            "<td class=\"text-center\">"+ item.Quiz.ToString("F2")           + (Model.EstimationBasis.PerfectionHandleBasis == "CPHB001" ? " / " + item.Quiz.ToString("F2")          : "")+"</td>" : "") %>
								<%: Html.Raw(HomeworkRatio > 0 ?        "<td class=\"text-center\">"+ item.HomeWork.ToString("F2")      + (Model.EstimationBasis.PerfectionHandleBasis == "CPHB001" ? " / " + item.HomeWork.ToString("F2")      : "")+"</td>" : "") %>
								<%if(!item.TotalScore.ToString("0").Equals(item.CompleteScore.ToString("0")))
									{%>
									<td class="text-center text-bold">
									<%}else {%>
									<td class="text-center">
									<%}%>
								<%: item.TotalScore.ToString("0")%></td>
								<td class="text-center <%: css%>">
									<%: item.IsPass == null ? "처리전" : item.IsPass == 1 ? "수료" : "미수료" %>
								</td>
								<%if (Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")).ToArray()[0].IsPass != null)
								{%>
									<td class="text-center"><%: item.CompleteScore.ToString("0")%></td>
								<%}%>
							</tr>
							<%
								}%>
						</tbody>
					</table>
				</div>
			</div>
		<div class="card-footer text-right">
			<%if (Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")).ToArray()[0].PrintNum != 1){
				if (Model.GradeList.Where(c => c.EstimationType.Equals("CEST002")).ToArray()[0].IsPass != null)
				{%>
				<button type="button" class="btn btn-primary" id="btn_AbsoluteEvaluationDelete">수료초기화</button>
				<%} else { %>
				<button type="button" class="btn btn-primary" id="btn_AbsoluteEvaluation">수료처리</button>
				<%}
			}%>
		</div>
	</div>
</div>
<%
	}
	else
	{
%>
	<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 평가항목이 없습니다.</div>
<%
	 }
%>