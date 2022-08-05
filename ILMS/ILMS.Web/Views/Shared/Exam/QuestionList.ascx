<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
	string GubunNm = Model.ExamDetail.Gubun.Equals("Q") ? "퀴즈" : "시험";
	string GubunCd = Model.ExamDetail.Gubun.Equals("Q") ? "Quiz" : "Exam";
%>

<h3 class="title04">문제 설정</h3>
<div class="card card-style01">
	<div class="card-header">
		<div class="row">
			<div class="col">
				<button type="button" id="btnDelete" class="btn btn-sm btn-danger" onclick="fnQuestionDelete()">선택삭제</button>
			</div>
			<div class="col-auto text-right">
				<button type="button" id="btnAdd" class="btn btn-sm btn-point" onclick="fnOpenPopup('/QuestionBank/List' , 'CopyQuiz', 1800, 900, 0, 0, 'auto')" title="새창열림">문제추가</button>
			</div>
		</div>
	</div>
	<div class="card-body py-0">
		<div class="table-responsive-lg">
			<table class="table table-hover" summary="문제 설정" id="questionList">
				<caption>문제 설정</caption>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" class="checkbox" id="AllCheck" onclick="fnSetCheckBoxAll(this, 'chkSel');"></th>
						<th scope="col">번호</th>
						<th scope="col">문제유형</th>
						<th scope="col">문제</th>
						<th scope="col">주차</th>
					</tr>
				</thead>

				<tbody>
					<%
						if(Model.QuestionList.Count > 0)
						{
							foreach (var item in (Model.QuestionList))
							{
					%>
					<tr>
						<td class="text-center">
							<input type="checkbox" name="chkQuestionNos" id="chkSel" value="<%:item.QuestionNo %>">
							<input type="hidden" name="hdnQuestionBankNos" value="<%:item.QuestionBankNo %>">
							<input type="hidden" name="hdnDifficulty" value="<%:item.Difficulty %>">
							<input type="hidden" name="hdnDifficultySeq" value="<%:item.DifficultySeq %>">
							<input type="hidden" class="<%:item.Difficulty %>" name="hdnQuestionScores" value="<%:item.EachScore %>">
						</td>
						<td><span id="span<%:item.Week %>RowIndex" class="spanRowIndex"><%:item.RowIndex %></span></td>
						<td><%:item.QuestionTypeNm %></td>
						<td class="text-left"><%=item.Question %></td>
						<td><%:item.DifficultyNm %></td>
					</tr>
					<%
							}
						}
						else
						{
					%>
					<tr id="zeroTr">
						<td colspan="6">조회된 데이터가 없습니다.</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>

	<div class="card-footer">
		<div class="row">
			<div class="col">
				<button type="button" id="btnDeleteTwin" class="btn btn-sm btn-danger" onclick="fnQuestionDelete()">선택삭제</button>
			</div>
			<div class="col-auto text-right">
				<button type="button" id="btnAddTwin" class="btn btn-sm btn-point" onclick="fnOpenPopup('/QuestionBank/List' , 'QuestionBankList', 1800, 900, 0, 0, 'auto')" title="새창열림">문제추가</button>
			</div>
		</div>
	</div>
	<div class="card-footer">
		<div class="row align-items-center">
			<div class="col-6">
				<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
			</div>
			<div class="col-6 text-right">
				<button type="button" class="btn btn-primary" onclick="fnSave()">저장</button>
				<a href="<%:Model.ExamNo.Equals(0) ? "/" + GubunCd + "/ListTeacher/" + Model.CourseNo : "/" + GubunCd + "/DetailTeacher/" + Model.CourseNo + "/" + Model.ExamNo %>" class="btn btn-secondary">취소</a>
			</div>
		</div>
	</div>
</div>