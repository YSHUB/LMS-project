<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<h3 class="title04">주차별 문항수/배점</h3>
<div class="card">
	<div class="card-body py-0">
		<div class="table-responsive">
			<table class="table table-hover" summary="주차별 문항수/배점"> 
				<caption>주차별 문항수/배점</caption>
				<thead>
					<tr>
						<th scope="col">주차</th>
						<th scope="col">문항수</th>
						<th scope="col" class="text-nowrap">문항당 배점</th>
						<th scope="col" class="text-nowrap">배점소계</th>
					</tr>
				</thead>			
				<tbody>
					<% 
						if(Model.RandomList.Count > 0)
						{
							int SumRowNum = 0;	// 문항수 합계
							decimal SumScore = 0; // 배점소계 합계

							foreach (var item in (Model.RandomList))
							{
								SumRowNum += item.ExamRowNum;
								SumScore += (item.ExamRowNum * item.EachPointDec);
					%>
					<tr>
						<th scope="row"><%:item.WeekName %></th>
						<td><%:item.ExamRowNum %></td>
						<td><%:decimal.Parse(item.EachPointDec.ToString()).ToString("G29") %></td>
						<td><%:decimal.Parse((item.ExamRowNum * item.EachPointDec).ToString()).ToString("G29") %></td>
					</tr>
					<%	
							}
					%>
					<tr>
						<th>소계</th>
						<td><%:SumRowNum %></td>
						<td></td>
						<td><%:decimal.Parse(SumScore.ToString()).ToString("G29") %></td>
					</tr>
					<%
						}
						else
						{
					%>			
					<tr>
						<td colspan="4">조회된 데이터가 없습니다.</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</div><!-- card -->