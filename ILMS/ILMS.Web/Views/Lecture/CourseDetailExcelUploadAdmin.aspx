<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div class="row">
		<div class="col-12 mt-2">
			<div class="card card-style02">
				<div class="card-header">
					<div>
						<span class="badge badge-regular"><%:Model.Course.ProgramName %></span>
						<%if (ConfigurationManager.AppSettings["UnivYN"].Equals("N"))
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

					<% 
						if (Model.Course.ProgramNo.ToString() == "2")
						{
					%>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>년도</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TermYear %>년도</dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-2"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>강좌상태</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CourseOpenStatusName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.StudentCount %></dd>
					</dl>
					<%
						}
						else
						{
					%>

					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark "><i class="bi bi-dot"></i>개설처 / 분반</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.AssignName %> / <%:Model.Course.ClassNo %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %>(기간)</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.TermName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>학점</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.Credit %></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-2"><%:Model.Course.HangulName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>강좌상태</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.CourseOpenStatusName %></dd>
						<dt class="col-3 col-md-2 w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-2"><%:Model.Course.StudentCount %></dd>
					</dl>

					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
	<form action="/Lecture/CourseDetailAdmin/<%:Model.Course.CourseNo %>" id="mainForm" method="post">
		<input type="hidden" value="<%:Model.Course.CourseNo %>" name="CourseNo"/>
		<div class="row">
			<div class="col-12 mt-2">
				<!--탭 리스트-->
				<div class="tab-content" id="myTabContent">
					<ul class="nav nav-tabs mt-4" role="tablist">
						<li class="nav-item" role="presentation">
							<a href="javascript:fn_divShow(1);" class="nav-link active" id="excelUploadTab" role="tab">엑셀등록</a>
						</li>
						<li class="nav-item" role="presentation">
							<a href="javascript:fn_divShow(2);" class="nav-link" id="pieceSaveTab" role="tab">개별등록</a>
						</li>
					</ul>
				</div>

				<div class="card" id="divExcelUpload">
					<div class="card-body py-0">
						<div class="mt-2">
							<a href="/Download/StudentUploadExcel.xls" class="btn btn-sm btn-dark">샘플 다운로드</a>
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
							<div class="col-8">
								<span>※ 파일을 다시 업로드하는 경우 초기화 버튼을 누른 후 업로드 해주시길 바랍니다.</span>
							</div>
							<div class="col-4 text-right">
								<input type="button" id="btn업로드" class="btn btn-primary" value="엑셀 업로드" onclick="fnExcel()">
							</div>
						</div>
					</div>
				</div>

				<div class="card d-none" id="divpieceSave">
					<div class="card-body py-0">
						<div class="row">
							<div class="form-group col-12 col-md-4">
								<label for="addusername" class="form-label mt-2">이름 : </label>
								<input type="text" id="addusername" name="addusername" class="form-control">
							</div>
							<div class="form-group col-12 col-md-4 mt-2">
								<label for="adduserid" class="form-label">아이디 : </label>
								<input type="text" id="adduserid" name="adduserid" class="form-control">
							</div>
						</div>
					</div>
					<div class="card-footer">
						<div class="row">
							<div class="col pt-2">
								<span>※ 이름과 아이디(학번)이 일치해야 등록가능합니다. 추가 후에는 하단 목록 확인 후 등록 버튼을 눌러야 최종 등록됩니다.</span>
							</div>
							<div class="col-auto text-right">
								<button type="button" id="btnuseradd" class="btn btn-primary">추가</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-12 mt-2">
				<div class="card">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table table-hover table-sm" id="personalTable">
								<caption>수강생 리스트</caption>
								<thead>
									<tr>
										<th scope="row">성명</th>
										<th scope="row">아이디</th>
										<th scope="row" class="d-none d-md-table-cell">신청일</th>
										<th scope="row" class="d-none d-md-table-cell">승인여부</th>
										<th scope="row">내용</th>
										<th scope="row" class="text-nowrap">삭제</th>
									</tr>
								</thead>
								<tbody id="tbody" class="tbody">
									<tr id="nodata">
										<td colspan="10">등록된 회원이 없습니다.
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
								<button type="button" class="btn btn-primary" id="btn_save" >등록</button>
								<button type="button" class="btn btn-danger" id="btnClear">초기화</button>
								<a href="/Lecture/CourseDetailAdmin/<%: Model.Course.CourseNo %>" class="btn btn-secondary">목록</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var _ajax = new AjaxHelper();
		var rowNum = parseInt(0);

		$(document).ready(function () {
			document.getElementById("files").setAttribute('accept', '.xls,.xlsx')

			$("#btnuseradd").click(function () {
				if ($("#addusername").val() == "") {
					bootAlert("이름을 입력하세요.", 1);
					$("#addusername").focus();
					return;
				}
				if ($("#adduserid").val() == "") {
					bootAlert("아이디를 입력하세요.", 1);
					$("#adduserid").focus();
					return;
				}
				_ajax.CallAjaxPost("/Lecture/CourseStudentCheck", { id: <%:Model.Course.CourseNo %>, userid: $("#adduserid").val(), username: $("#addusername").val() }, "CourseUserSave");
			});


			$("#btn_save").click(function () {

				if ($(".tbody tr[class='trData']").length > 0) {

					bootConfirm("등록가능한 사용자만 등록됩니다.", function () {

						_ajax.CallAjaxPost("/Lecture/CourseLetureUpload", $("#mainForm").serialize(), "fnCompleteCourseLetureUploadSave");
					});
				} else {
					bootAlert("등록할 인원을 추가해주세요.");
				}
			});


		});

		function fnExcel() {

			if ($("input[name='AccountFile']").val() == "") {
				bootAlert("선택된 파일이 없습니다.");
				return false;
			}


			var formData = new FormData($("#mainForm")[0]);
			_ajax.CallAjaxPostFile("/Lecture/ExcelUploadChk", formData, "fnCompleteExcelUploadChk");
		}

		function fn_divShow(id) {
			if (id == 1) {
				$("#divExcelUpload").prop("class", "card");
				$("#divpieceSave").prop("class", "card d-none");
				$("#excelUploadTab").prop("class", "nav-link active");
				$("#pieceSaveTab").prop("class", "nav-link");

			}
			else {
				$("#divpieceSave").prop("class", "card");
				$("#divExcelUpload").prop("class", "card d-none");
				$("#excelUploadTab").prop("class", "nav-link");
				$("#pieceSaveTab").prop("class", "nav-link active");

			}
		}

		function fnCompleteExcelUploadChk() {
			var result = _ajax.CallAjaxResult();
			var tbodyHtml = "";

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					tbodyHtml += "<input type='hidden' id='hdnHangulNameArray" + rowNum + "' name='HangulNameArray' value='" + result[i].HangulName + "'>";
					tbodyHtml += "<input type='hidden' id='hdnUserIDArray" + rowNum + "' name='UserIDArray' value='" + result[i].UserID + "'>";
					tbodyHtml += "<input type='hidden' id='hdnUserNoArray" + rowNum + "' name='UserNoArray' value='" + result[i].UserNo + "'>";
					tbodyHtml += "<input type='hidden' id='hdnLectureRequestDayArray" + rowNum + "' name='LectureRequestDayArray' value='" + result[i].LectureRequestDay + "'>";
					tbodyHtml += "<input type='hidden' id='hdnLectureStatusNameArray" + rowNum + "' name='LectureStatusNameArray' value='" + result[i].LectureStatus + "'>";
					tbodyHtml += "<input type='hidden' id='hdnUploadGubunArray" + rowNum + "' name='UploadGubunArray' value='" + result[i].ApprovalGubun + "'>";

					tbodyHtml += "	<tr id='trData" + rowNum + "' class='trData'>";
					tbodyHtml += "		<td class='font-size-12 text-left'>" + result[i].HangulName + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-left'>" + result[i].UserID + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result[i].LectureRequestDay + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result[i].LectureStatus + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-left'>" + result[i].ApprovalGubun + "</td>";
					tbodyHtml += "		<td class='font-size-12 text-center'><button type='button' class='text-danger' onclick='fnRowDelete(" + rowNum++ + ");'><i class='bi bi-trash'></i></button></td>";
					tbodyHtml += "	</tr>";
				}
			} else {

				tbodyHtml += "	<tr>";
				tbodyHtml += "		<td colspan='8'> 등록된 회원이 없습니다.</td>";
				tbodyHtml += "	</tr>";
			}

			$("#tbody").html(tbodyHtml);
			$("#btn업로드").addClass("d-none");
		}

		function fnCompleteCourseLetureUploadSave() {
			var result = _ajax.CallAjaxResult();
			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					window.location.href = "/Lecture/CourseDetailAdmin/<%:Model.Course.CourseNo %>";
				});
			} else if (result == 0) {
				bootAlert("등록가능한 회원이 없습니다.");
			} else {
				bootAlert("실행 중 오류가 발생하였습니다.");
			}
			
		}

		function CourseUserSave() {
			var result = _ajax.CallAjaxResult();
			var tbodyHtml = "";

			if (result != null) {

				tbodyHtml += "<input type='hidden' id='hdnHangulNameArray" + rowNum + "' name='HangulNameArray' value='" + result.HangulName + "'>";
				tbodyHtml += "<input type='hidden' id='hdnUserIDArray" + rowNum + "' name='UserIDArray' value='" + result.UserID + "'>";
				tbodyHtml += "<input type='hidden' id='hdnUserNoArray" + rowNum + "' name='UserNoArray' value='" + result.UserNo + "'>";
				tbodyHtml += "<input type='hidden' id='hdnLectureRequestDayArray" + rowNum + "' name='LectureRequestDayArray' value='" + result.LectureRequestDay + "'>";
				tbodyHtml += "<input type='hidden' id='hdnLectureStatusNameArray" + rowNum + "' name='LectureStatusNameArray' value='" + result.LectureStatusName + "'>";
				tbodyHtml += "<input type='hidden' id='hdnUploadGubunArray" + rowNum + "' name='UploadGubunArray' value='" + result.ApprovalGubun + "'>";

				tbodyHtml += "		<td class='font-size-12 text-left'>" + result.HangulName + "</td>";
				tbodyHtml += "		<td class='font-size-12 text-left'>" + result.UserID + "</td>";
				tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result.LectureRequestDay + "</td>";
				tbodyHtml += "		<td class='font-size-12 text-center d-none d-md-table-cell'>" + result.LectureStatusName + "</td>";
				tbodyHtml += "		<td class='font-size-12 text-left'>" + result.ApprovalGubun + "</td>";
				tbodyHtml += "		<td class='font-size-12 text-center'><button type='button' class='text-danger' onclick='fnRowDelete(" + rowNum++ + ");'><i class='bi bi-trash'></i></button></td>";

			} else {

				tbodyHtml += "	<tr id='nodata'>";
				tbodyHtml += "		<td colspan='6'> 등록된 회원이 없습니다.</td>";
				tbodyHtml += "	</tr>";
			}
			if ($('#nodata').length) {

				$("#tbody").children().first().remove();

			}
			var tbody = document.getElementById('tbody');
			var para = document.createElement("tr");
			para.innerHTML = tbodyHtml;
			para.setAttribute("id", "trData" + (rowNum - 1));
			para.setAttribute("class", "trData");
			tbody.appendChild(para);
			
		}

		function fnRowDelete(rowNum) {
			
			var selectNum = rowNum;

			$("#trData" + selectNum).remove();
			$("#hdnHangulNameArray" + selectNum).remove();
			$("#hdnUserIDArray" + selectNum).remove();
			$("#hdnLectureRequestDayArray" + selectNum).remove();
			$("#hdnLectureStatusNameArray" + selectNum).remove();
			$("#hdnUploadGubunArray" + selectNum).remove();
		}

		$("#btnClear").click(function () {

			bootConfirm("입력한 신청정보가 초기화됩니다.", fnComplete, null);
		})

		function fnComplete() {
			location.reload();
		}

	</script>
</asp:Content>
