<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomeworkViewModel>" %>

<asp:Content ID="ContentTitle" ContentPlaceHolderID="Title" runat="server">과제가져오기</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<%:"" %>
	<form action="/Homework/Copy" name="mainForm" id="mainForm" method="post">
		<div class="p-4">
			<h4 class="title04">과제(개인) 가져오기</h4>
			<div class="card">
				<div class="card-body p-1">
					<ul class="list-style01 mb-0">
						<li>가져오려는 과제명을 클릭하면 이전에 등록한 동일 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>의 과제정보를 그대로 가져옵니다.</li>
						<li>단, 현재 강좌에서 생성했던 과제정보는 가져오지 않습니다.</li>
						<li>개인 과제 외의 과제는 가져올 수 없습니다.</li>
					</ul>
				</div>
			</div>
			<div class="card">
				<div class="card-body">
					<div class="form-row">
						<div class="form-group col-12 col-md-3">
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
			</div>
			<h4 class="title04">과제 리스트</h4>
			<div class="card">
				<div class="card-body py-0">
					<table class="table table-hover" summary="과제 리스트">
						<caption>과제 리스트</caption>
						<thead>
							<tr>
								<th>학년도</th>
								<th><%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
								<th>과제명</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (Model.HomeworkList.Count > 0)
								{
									foreach (var item in Model.HomeworkList)
									{
								%>
								<tr>
									<td><%:item.TermYear %>년도</td>
									<td><%:item.TermQuarter %><%:ConfigurationManager.AppSettings["TermText"].ToString() %></td>
									<td><%:item.HomeworkTitle %></td>
									<td><input type="button" class="btn btn-sm btn-primary" onclick="fnCopyHomework(<%:item.CourseNo%>, <%:item.HomeworkNo%>);" value="선택" /></td>
								</tr>
								<%
									}
								} 
								else
								 {
							%>
							<tr>
								<td colspan="5" class="text-center">등록된 과제가 없습니다. </td>
							</tr>
							<%
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<div class="text-right">
				<button type="button" class="btn btn-sm btn-secondary" id="btnCancel" onclick="window.close()">닫기</button>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="ScriptContent" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var _ajax = new AjaxHelper();

		$(document).ready(function () {
			fnCalendar("getDate", "TODAY");

			$("#ddlTerm").change(function () {
				window.location = '/Homework/Copy/<%:ViewBag.Course.CourseNo%>/' + $("#ddlTerm").val();
			});

			$("#ddlTerm option[value=" + "<%:Model.TermNo%>" + "]").attr("selected", "selected");

		});

		function fnCopyHomework (CourseNo, HomeworkNo) {
			if (confirm("저장하시겠습니까?")) {
				_ajax.CallAjaxPost("/Homework/CopyHomework", { param1: CourseNo, param2: HomeworkNo }, "fnCopyresult");
			}
		}

		function fnCopyresult() {
			var result = _ajax.CallAjaxResult();

			if (result > 0) {
				alert("가져오기가 완료되었습니다.");
			}
			else {
				alert("실행 중 오류가 발생하였습니다.");
			}

			setTimeout("fnReload()", 1000);
		}

		function fnReload() {
			window.opener.location.reload();
			window.close();
		}

	</script>
</asp:Content>
