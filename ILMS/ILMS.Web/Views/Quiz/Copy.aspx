<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			$("#ddlTerm").val(<%:Model.TermNo%>).prop("selected", true);

			// 학기 변경
			$("#ddlTerm").change(function () {
				window.location = '/Quiz/Copy/<%:Model.CourseNo%>/' + $("#ddlTerm").val();
            });
		})

		function fnCopyQuiz(getExamNo) {
			var params = [];
			params.push({ "ExamNo": getExamNo });

			bootConfirm("복제하시겠습니까?", fnCopyProgress, params);
		}

		function fnCopyProgress(param) {
			ajaxHelper.CallAjaxPost("/Quiz/CopyQuiz", { courseno: <%:Model.CourseNo%>, examno: param[0].ExamNo }, "fnCompleteCopy", "", "오류가 발생하였습니다.  \n새로고침 후 다시 이용해주세요.");
		}

		function fnCompleteCopy() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("가져오기가 완료되었습니다.", function () {
					window.opener.location.reload();
					window.close();
				});
			}
			else {
				bootAlert("실행 중 오류가 발생하였습니다.", function () {
					window.opener.location.reload();
					window.close();
				});
			}
		}
	</script>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="p-4">
		<h4 class="title04">퀴즈 가져오기</h4>
		<div class="card">
			<div class="card-body p-1">
				<ul class="list-style01">
					<li>가져오려는 퀴즈명을 클릭하면 등록된 퀴즈정보를 그대로 가져옵니다.</li>
					<li>단, 현재 강좌에서 생성했던 퀴즈정보는 가져오지 않습니다.</li>
					<li>선택한 퀴즈의 주차-차시가 생성되어 있지 않은 경우, 주차-차시 정보가 제대로 입력되지 않습니다.</li>
					<li>주차-차시가 제대로 입력되지 않는 경우 퀴즈를 복사하신 후 주차-차시를 직접 변경하셔야 정상적으로 적용됩니다.</li>
				</ul>
			</div>
		</div>
		<div class="card">
			<div class="card-body">
				<div class="form-group">
					<label class="form-label" for=""><%:ConfigurationManager.AppSettings["TermText"].ToString() %> 선택 <span class="text-danger">*</span></label>
					<select class="form-control" id="ddlTerm">
					<%
						foreach (var item in Model.TermList)
						{
					%>
						<option value="<%:item.TermNo %>"><%:item.TermName %></option>
					<%
						} 
					%>
					</select>
				</div>
			</div>
		</div>
		<h4 class="title04">과제 리스트</h4>
		<div class="card">
			<div class="card-body py-0">
				<table class="table table-hover" summary="과제 리스트">
					<caption>과제 리스트</caption>
					<thead>
						<tr>
							<th>주차</th>
							<th>차시</th>
							<th><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>명</th>
							<th>퀴즈명</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<%
							if(Model.QuizList.Count < 1)
							{
						%>
						<tr>
							<td colspan="5" class="text-center">등록된 퀴즈가 없습니다. </td>
						</tr>
						<%
							}

							foreach (var item in Model.QuizList)
							{
						%>
						<tr>
							<td><%:item.Week %></td>
							<td><%:item.InningNo %></td>
							<td><%:item.SubjectName %></td>
							<td><%:item.ExamTitle %></td>
							<td><button type="button" class="btn btn-primary" onclick="fnCopyQuiz(<%:item.ExamNo%>)">선택</button></td>
						</tr>
						<%
							} 
					
						%>
					</tbody>
				</table>
			</div>
		</div>
		<div class="text-right">
			<button type="button" class="btn btn-secondary" id="btnCancelTwin" onclick="window.close()">닫기</button>
		</div>
	</div>
	
</asp:Content>