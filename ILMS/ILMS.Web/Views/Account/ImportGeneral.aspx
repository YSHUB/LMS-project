<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
   <form action="/Account/ImportGeneral" method="post" id="mainForm" >
		<div id="content">
			<div class="row">
				<div class="col-12 mt-2">
					<h3 class="title04">일반회원 일괄등록</h3>
				</div>
			</div>
					
			<div class="card">
				<div class="card-body">
					<div class="alert alert-info p-2">
						1. 업로드시 아이디는 반드시 영문자로 시작하여야 합니다.<br />
						2. 양식의 모든 항목을 빠짐 없이 기입 후 업로드 하시기 바랍니다.<br />
						3. 생년월일, 연락처의 경우 셀 형식을 샘플의 경우와 같이 '일반'으로 하시기 바랍니다. ex 20220301, 010-0000-0000
						<div>
							<a href="/Download/GeneralUploadExcel.xls" class="btn btn-sm btn-dark">샘플 다운로드</a>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group col-6 col-md-3">
							<label for="AccountFileUpload" class="form-label">첨부파일</label>
							<% Html.RenderPartial("./Common/File"
								, Model.FileList
								, new ViewDataDictionary {
								{ "name", "FileGroupNo" },
								{ "fname", "AccountFile" },
								{ "value", Model.FileGroupNo },
								{ "readmode", 0 },
								{ "fileDirType", "Account"},
								{ "filecount", 1 }, { "width", "100" }, {"isimage", 0 } });							%>
						</div>
					</div>
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
							<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> * 필수입력 항목</p>
						</div>
						<div class="col-6 text-right">
							<input type="button" id="btn업로드" class="btn btn-primary" value="엑셀 업로드" onclick="fnExcel()">
						</div>
					</div>
				</div>
			</div>
			<div class="card">
				<div class="card-body py-0">
					<div class="table-responsive">
						<table class="table table-hover table-sm" id="personalTable">
							<caption>일반회원 리스트</caption>
							<thead>
								<tr>
									<th scope="row">성명</th>
									<th scope="row">아이디</th>
									<th scope="row" class="d-none d-md-table-cell">비밀번호</th>
									<th scope="row" class="d-none d-md-table-cell">생년월일</th>
									<th scope="row">소속</th>
									<th scope="row" class="d-none d-md-table-cell">연락처</th>
									<th scope="row" class="d-none d-md-table-cell">이메일</th>
									<th scope="row">성별</th>
									<th scope="row">내용</th>
									<th scope="row" class="text-nowrap">삭제</th>
								</tr>
							</thead>
							<tbody id="tbody" class="tbody">
								<tr>
									<td colspan="10">
										등록된 회원이 없습니다.
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="card-footer">
					<div class="row align-items-center">
						<div class="col-6">
						</div>
						<div class="col-6 text-right">
							<button type="button" class="btn btn-primary" onclick="fnSave()">등록</button>
							<button type="button" class="btn btn-danger" id="btnClear">초기화</button>
							<a href="/Account/ListGeneral" class="btn btn-secondary">목록</a>
						</div>
					</div>
				</div>
			</div>
		</div>

		<input type="hidden" id="hdnUserType" name="Student.UserType" value="USRT001"/>
	</form>	

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script>

		var ajaxHelper = new AjaxHelper();

		function fnExcel() {		
			var fileChk = document.getElementById("files").value;

			if (!fileChk) {

				bootAlert("업로드할 엑셀을 등록해주세요.");
			} else {
				
				var formData = new FormData($("#mainForm")[0]);
				ajaxHelper.CallAjaxPostFile("/Account/ImportGeneralChk", formData, "fnCompleteImportGeneralChk");
			}
		}

		function fnCompleteImportGeneralChk() {
			var result = ajaxHelper.CallAjaxResult();
			var tbodyHtml = "";
			var rowNum = parseInt(1);

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					tbodyHtml += "<input type='hidden' id='hdnHangulNameArray" + rowNum + "' name='HangulNameArray' value='" + result[i].HangulName + "'>";
					tbodyHtml += "<input type='hidden' id='hdnUserIDArray" + rowNum + "' name='UserIDArray' value='" + result[i].UserID + "'>";
					tbodyHtml += "<input type='hidden' id='hdnPasswordArray" + rowNum + "' name='PasswordArray' value='" + result[i].Password + "'>";
					tbodyHtml += "<input type='hidden' id='hdnResidentNoArray" + rowNum + "' name='ResidentNoArray' value='" + result[i].ResidentNo + "'>";
					tbodyHtml += "<input type='hidden' id='hdnAssignTextArray" + rowNum + "' name='AssignTextArray' value='" + result[i].AssignText + "'>";
					tbodyHtml += "<input type='hidden' id='hdnMobileArray" + rowNum + "' name='MobileArray' value='" + result[i].Mobile + "'>";
					tbodyHtml += "<input type='hidden' id='hdnEmailArray" + rowNum + "' name='EmailArray' value='" + result[i].Email + "'>";
					tbodyHtml += "<input type='hidden' id='hdnSexGubunArray" + rowNum + "' name='SexGubunArray' value='" + result[i].SexGubun + "'>";
					tbodyHtml += "<input type='hidden' id='hdnUploadGubunArray" + rowNum + "' name='UploadGubunArray' value='" + result[i].ApprovalGubun + "'>";

					tbodyHtml += "	<tr id='trData" + rowNum +"' class='trData'>";
					tbodyHtml += "		<td class='font-size-12 text-left'>" + result[i].HangulName + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-left'>" + result[i].UserID + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result[i].Password + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result[i].ResidentNo + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center'>" + result[i].AssignText + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result[i].Mobile + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-left d-none d-md-table-cell'>" + result[i].Email + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center'>" + result[i].SexGubun + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center'>" + result[i].ApprovalGubun + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center'><button type='button' class='text-danger' onclick='fnRowDelete(" + rowNum++ + ");'><i class='bi bi-trash'></i></button></td>";
					tbodyHtml += "	</tr>";		
				}
			} else {

				tbodyHtml += "	<tr>";
				tbodyHtml += "		<td colspan='10'> 등록된 회원이 없습니다.</td>";
				tbodyHtml += "	</tr>";
			}

			$("#tbody").html(tbodyHtml);
			$("#btn업로드").addClass("d-none");
		}

		$("#btnClear").click(function () {

			bootConfirm("작성된 입력폼이 모두 삭제됩니다.", fnComplete, null);
		})

		function fnComplete() {

			location.reload();
		}

		function fnRowDelete(rowNum) {

			$("#trData" + rowNum).remove();
			$("#hdnHangulNameArray" + rowNum).remove();
			$("#hdnUserIDArray" + rowNum).remove();
			$("#hdnPasswordArray" + rowNum).remove();
			$("#hdnResidentNoArray" + rowNum).remove();
			$("#hdnAssignTextArray" + rowNum).remove();
			$("#hdnMobileArray" + rowNum).remove();
			$("#hdnEmailArray" + rowNum).remove();
			$("#hdnSexGubunArray" + rowNum).remove();
			$("#hdnUploadGubunArray" + rowNum).remove();
		}

		function fnSave() {

			if ($(".tbody tr[class='trData']").length > 0) {

				bootConfirm("등록가능한 사용자만 등록됩니다.", function () {

					ajaxHelper.CallAjaxPost("/Account/ImportGeneralSave", $("#mainForm").serialize(), "fnCompleteImportGeneralSave");
				});
			} else {
				bootAlert("등록할 인원을 추가해주세요.");
			}
		}

		function fnCompleteImportGeneralSave() {

			var result = ajaxHelper.CallAjaxResult();
			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					window.location.href = "/Account/ListGeneral";
				});
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
		}

	</script>
</asp:Content>