<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Team/Write/<%:ViewBag.Course.CourseNo %>" method="post" id="mainForm" enctype="multipart/form-data">
		<div id="content">
			<div class="alert alert-light bg-light">
				<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 팀편성 주의사항</p>
				<ul class="list-style03 mb-0">
					<li class="font-size-14">토론, 팀프로젝트에서 사용될 팀을 편성할 수 있습니다.</li>
					<li class="font-size-14">팀편성이 안된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>은 토론, 팀프로젝트에 참여할 수 없으니, 누락된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없도록 주의하세요.</li>
					<li class="font-size-14">자동 팀편성을 사용하시면 수강생을 랜덤으로 편성합니다.</li>
					<li class="font-size-14">수동으로 팀편성을 하시려면 그룹관리 버튼을 눌러주세요.</li>
				</ul>
			</div>
			<ul class="nav nav-tabs mt-4" id="teamTab" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link" id="teamListTab" href="/Team/List/<%:ViewBag.Course.CourseNo %>" role="tab">팀 리스트</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link active" id="groupTab" href="/Team/Write/<%:ViewBag.Course.CourseNo %>" role="tab">그룹 관리</a>
				</li>
			</ul>
			<div class="row">
				<div class="col-12 mt-2">
					<h3 class="title04">그룹 리스트<strong class="text-primary">(<%:Model.GroupList.Count() %>건)</strong></h3>
					<%
						if (Model.GroupList.Count() == 0) 
						{ 
					%>
							<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 그룹이 없습니다.</div>
					<%
						} 
						else
						{
					%>
							<div class="card mt-2">
								<div class="card-body py-0">
									<div class="table-responsive">
										<table class="table" id="tblGroupList">
											<caption>그룹 리스트</caption>
											<thead>
												<tr>
													<th scope="row" style="width:40%">그룹명</th>
													<th scope="row" style="width:40%">생성팀</th>
													<th scope="row">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.GroupList) 
													{
												%>
														<tr>
															
															<td class="text-left">
																<%:item.GroupName %>
															</td>
															<td class="text-center">
																<%:item.TeamCnt %>팀
															</td>
															<td class="text-left">
																<button type="button" class="text-primary" title="수정" data-toggle="modal" data-target="#divGroupSave" role="button" onclick="fnGroupUpdate('<%:item.GroupName %>','<%:item.GroupNo %>')"><i class="bi bi-pencil"></i></button>
																<button type="button" class="text-danger" title="삭제" onclick="fnGroupDelete('<%:item.GroupNo %>')"><i class="bi bi-trash"></i></button>
																<button type="button" class="text-primary" title="복제" onclick="fnGroupCopy('<%:item.GroupNo %>')"><i class="bi bi-files"></i></button>
																<button type="button" class="text-primary" title="팀편성" data-toggle="modal" data-target="#divTeamSave" role="button" onclick="fnTeam('<%:item.GroupNo %>', '<%:item.GroupName %>')"><i class="bi bi-people-fill"></i></button>
																<%
																	if (item.TeamCnt == 0) 
																	{
																%>
																		<button type="button" class="text-primary" title="엑셀업로드" data-toggle="modal" data-target="#divExcelUpload" role="button" onclick="fnExcelUpload('<%:item.GroupNo %>', '<%:item.GroupName %>')"><i class="bi bi-download"></i> </button>
																<%
																	}
																%>
															</td>
														</tr>
												<%
													}
												%>

											</tbody>
										</table>
									</div>
								</div>
							</div>
					<%
						}
					%>
				</div>
			</div>
			<div class="row">
				<div class="col-6">
				</div>
				<div class="col-6">
					<div class="text-right">
						<button type="button" class="btn btn-point" data-toggle="modal" data-target="#divGroupSave" id="btnGroupSave">그룹 추가</button>
					</div>
				</div>
			</div>

			<%-- 그룹 추가 및 수정 모달 --%>
			<div class="modal fade show" id="divGroupSave" tabindex="-1" aria-labelledby="groupSave" aria-modal="true" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="groupSave">그룹 추가</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<div class="form-row">
												<div class="form-group col-12">
													<label for="txtGroupName" class="form-label">그룹명 <strong class="text-danger">*</strong></label>
													<input type="text" class="form-control" id="txtGroupName" name="Group.GroupName"/>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-12 text-right">
									<input type="button" class="btn btn-primary" value="저장" onclick="fnGroupSave()"/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%-- 그룹 추가 및 수정 모달 --%>

			<%-- 엑셀업로드 모달 --%>
			<div class="modal fade show" id="divExcelUpload" tabindex="-1" aria-labelledby="excelUpload" aria-modal="true" role="dialog">
				<div class="modal-dialog modal-lg">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="excelUpload">
								<label id="lblExcelUploadGroupName"></label>. 팀편성 업로드
							</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<div class="form-row">
												<div class="form-group col-12">
													<label class="form-label">엑셀 업로드 양식</label>
													<div>
														<a href="/Download/TeamMemberUploadExcel<%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "_N" %>.xls" class="btn btn-outline-primary">다운로드</a>
													</div>
												</div>
												<div class="form-group col-12">
													<label class="form-label">팀편성 업로드</label>
													<div>
														<% Html.RenderPartial("./Common/File"
														  , Model.newFileList
														  , new ViewDataDictionary {
														 { "id", "excelUpload" },
														 { "name", "FileGroupNo" },
														 { "fname", "ExcelUpload" },
														 { "value", 0 },
														 { "fileDirType", "Team/excelUpload"},
														 { "filecount", 1 }, { "width", "100" }, {"isimage", 0 } }); %>
													</div>
												</div>
											</div>
											<p class="font-size-14 text-danger font-weight-bold mb-0">
												<i class="bi bi-info-circle-fill"></i> * 업로드시 반드시 다운로드 받은 엑셀의 필독 시트를 읽은 후
												해당 내용을 준수하여 업로드하여 주시기 바랍니다.
											</p>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-12 text-right">
									<input type="button" class="btn btn-primary" value="저장" onclick="fnExcelSubmit()"/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%-- 엑셀업로드 모달 --%>

			<%-- 팀편성 모달 --%>
			<div class="modal fade show" id="divTeamSave" tabindex="-1" aria-labelledby="teamSave" aria-modal="true" role="dialog">
				<div class="modal-dialog modal-xl">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="teamSave">
								<label id="lblTeamSaveGroupName"></label>. 팀편성</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-4">
									<div class="card">
										<div class="card-header"><h4 class="card-title02">팀 리스트</h4></div>
										<div class="card-body">
											<div class="form-row">
												<div class="form-group col-12">
													<div class="input-group">
														<span class="input-group-prepend">
															<span class="input-group-text">팀명</span>
														</span>
														<input type="text" class="form-control" id="txtTeamName" />
														<span class="input-group-append">
															<input type="button" class="btn btn-primary" value="저장" id="btnTeamSave"/>
														</span>
													</div>
												</div>
											</div>
										</div>
											<div class="card-body p-0 border-top">
												<table class="table" id="tblTeamList">
													<caption>팀 리스트</caption>
													<thead>
														<tr>
															<th scope="row">팀명</th>
															<th scope="row">관리</th>
														</tr>
													</thead>
													<tbody id="tbdTeamList">
													</tbody>
												</table>
											</div>
										</div>
									</div>
								<div class="col-4">
									<div class="card">
										<div class="card-header"><h4 class="card-title02">팀원 리스트</h4></div>
										<div class="card-body py-0">
											<div class="table-responsive overflow-auto" style="max-height: 400px">
												<table class="table" id="tblTeamMemberList">
													<caption>팀원 리스트</caption>
													<thead>
														<tr>
															<th scope="row">성명</th>
															<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
															<th scope="row">팀장</th>
															<th scope="row">관리</th>
														</tr>
													</thead>
													<tbody id="tbdTeamMemberList">
														<tr>
															<td colspan="4">선택된 팀이 없습니다</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</div>
								<div class="col-4">
									<div class="card">
										<div class="card-header">
											<div class="row">
												<div class="col-8">
													<h4 class="card-title02">수강생 리스트</h4>
												</div>
												<div class="col-4">
													<select class="form-control form-control-sm" id="ddlSort">
														<option value="UserID"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순</option>
														<option value="HangulName">성명순</option>
														<option value="AssignName" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : "" %>">소속순</option>
													</select>
												</div>
											</div>
										</div>
										<div class="card-body py-0">
											<div class="table-responsive overflow-auto" style="max-height: 400px">
												<table class="table" id="tblTeamNotMemberList">
													<caption>팀원 리스트</caption>
													<thead>
														<tr>
															<th scope="row">성명</th>
															<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
															<th scope="row">관리</th>
														</tr>
													</thead>
													<tbody id="tbdTeamNotMemberList">
														<tr>
															<td colspan="3">선택된 팀이 없습니다</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%-- 팀편성 모달 --%>

			<%-- 팀 수정 모달 --%>
			<div class="modal fade show" id="divTeamUpdate" tabindex="-1" aria-labelledby="teamSave" aria-modal="true" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title h4" id="teamUpdate">팀 수정</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12">
											<div class="form-row">
												<div class="form-group col-12">
													<label for="txtTeamNameUpdate" class="form-label">팀명 <strong class="text-danger">*</strong></label>
													<input type="text" class="form-control" id="txtTeamNameUpdate" name="GroupTeam.TeamName"/>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-12 text-right">
									<input type="button" class="btn btn-primary" value="저장" id="btnTeamUpdate"/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%-- 팀 수정 모달 --%>

		</div>
			
	<input type="hidden" id="hdnCourseNo" name="Group.CourseNo" value="<%:ViewBag.Course.CourseNo %>"/>
	<input type="hidden" id="hdnRowState" name="Group.RowState" value=""/>
	<input type="hidden" id="hdnGroupNo" name="Group.GroupNo" value=""/>
	<input type="hidden" id="hdnTeamRowState" name="GroupTeam.RowState" value=""/>
	<input type="hidden" id="hdnTeamNo" name="GroupTeam.TeamNo" value=""/>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		var ajaxHelper = new AjaxHelper();

		<%-- 그룹 추가 --%>
		$("#btnGroupSave").click(function () {
			$("#txtGroupName").val('');
			$("#hdnRowState").val("C");
		});

		<%-- 그룹 수정 --%>
		function fnGroupUpdate(groupName, groupNo) {
			$("#txtGroupName").val(groupName);
			$("#hdnGroupNo").val(groupNo);
			$("#hdnRowState").val("U");
		}

		function fnGroupSave() {

			if ($("#txtGroupName").val() == "") {
				bootAlert("그룹명을 입력해주세요.", function () {
					$("#txtGroupName").focus();
				});
				return false;
			}

			window.document.forms["mainForm"].action = "/Team/GroupSave/<%:ViewBag.Course.CourseNo %>";
			window.document.forms["mainForm"].method = "post";
			window.document.forms["mainForm"].submit();

			fnPrevent();
		}
		
		<%-- 그룹 삭제 --%>
		function fnGroupDelete(groupNo) {

			bootConfirm("삭제하시겠습니까 ?", function () {
				ajaxHelper.CallAjaxPost("/Team/GroupDelete", { "groupNo": groupNo }, "fnCompleteGroupDelete");
			});
		}

		function fnCompleteGroupDelete() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 그룹 복제 --%>
		function fnGroupCopy(orgGroupNo) {

			bootConfirm("그룹을 복제하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Team/GroupCopy", { "orgGroupNo": orgGroupNo }, "fnCompleteGroupCopy");
			});
		}

		function fnCompleteGroupCopy() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("그룹이 복제되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("그룹복제에 실패하였습니다.\n 관리자에 문의해주세요.");
			}
		}

		<%-- 엑셀 업로드 --%>
		function fnExcelUpload(groupNo, groupName) {
			
			$("#lblExcelUploadGroupName").text(groupName);
			$("#hdnGroupNo").val(groupNo);
		}
		 
		$("body").on("change", "input[type=file]", function (e) {
			$(this).parent().find("input.file_input_textbox").val($(this).val());

			if ($(this).val() != "") {
				_filecontrol = $(this);
				var fname = $(this).val().toUpperCase();
				var fext = fname.split('.')[fname.split('.').length - 1].toUpperCase();

				if (this.id == "excelUpload") {
					if (fext != "XLS" && fext != "XLSX") {
						$(this).val("");
						bootAlert("엑셀파일만 첨부해주세요.");
					}
				}
			}
		});

		function fnExcelSubmit() {

			document.forms[0].action = "/Team/ExcelUpload";
			document.forms[0].enctype = "multipart/form-data"
			document.forms[0].submit();
		}

		<%-- 팀 편성 > 팀 저장 --%>
		$("#btnTeamSave").click(function () {
			if ($("#txtTeamName").val() == "") {
				bootAlert("팀명을 입력하세요.", function () {
					$("#txtTeamName").focus();
				});
				return false;
			}

			$("#hdnTeamRowState").val("C");
			fnTeamSave();
		})

		<%-- 팀 편성 > 팀 수정 --%>
		function fnTeamNameUpdate(teamName, teamNo) {
			$("#txtTeamNameUpdate").val(teamName);
			$("#hdnTeamNo").val(teamNo);
			$("#hdnTeamRowState").val("U");
		}

		$("#btnTeamUpdate").click(function () {

			if ($("#txtTeamNameUpdate").val() == "") {
				bootAlert("팀명을 입력하세요.", function () {
					$("#txtTeamNameUpdate").focus();
				});
				return false;
			}
			
			fnTeamSave();
		})

		function fnTeamSave() {

			ajaxHelper.CallAjaxPost("/Team/TeamSave", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val(), teamNo: $("#hdnTeamNo").val(), teamName: $("#hdnTeamRowState").val() == "C" ? $("#txtTeamName").val() : $("#txtTeamNameUpdate").val(), rowState: $("#hdnTeamRowState").val() }, "fnCompleteTeamSave");
			$("#txtTeamName").val('');
		}

		function fnCompleteTeamSave() {
			bootAlert($("#hdnTeamRowState").val() == "C" ? "해당 팀이 등록되었습니다." : "해당 팀이 수정되었습니다.", 1);

			$("#divTeamUpdate").modal('hide');
			fnTeamList();
		}

		<%-- 팀 편성 > 팀 삭제 --%>
		function fnTeamDelete(teamNo) {

			bootConfirm("삭제하시겠습니까?", function () {
				ajaxHelper.CallAjaxPost("/Team/TeamDelete", { teamNo: teamNo }, "fnCompleteTeamDelete");
			});
		}

		function fnCompleteTeamDelete() {
			var result = ajaxHelper.CallAjaxResult();

			if (result > 0) {
				bootAlert("삭제되었습니다.", function () {
					fnTeamList();
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		<%-- 팀 편성 > 팀 조회 --%>
		function fnTeam(groupNo, groupName) {

			$("#lblTeamSaveGroupName").text(groupName);
			$("#hdnGroupNo").val(groupNo);

			fnTeamList();
		}

		function fnTeamList() {
			ajaxHelper.CallAjaxPost("/Team/TeamList", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val() }, "fnCompleteTeamList");
		}

		function fnCompleteTeamList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";

			if (result.length > 0) {

				for (var i = 0; i < result.length; i++) {

					value += '	<tr>';
					value += '		<td class="text-left">' + result[i].TeamName + '</td>';
					value += '		<td class="text-center">';					
					value += '			<button type="button" title="수정" class="text-primary" data-toggle="modal" data-target="#divTeamUpdate" onclick="fnTeamNameUpdate(`' + result[i].TeamName + '`' + ',' + result[i].TeamNo + ')"><i class="bi bi-pencil"></i></button>';
					value += '			<button type="button" title="삭제" class="text-danger"><i class="bi bi-trash" onclick="fnTeamDelete(' + result[i].TeamNo + ')"></i></button>';
					value += '			<button type="button" title="팀원 관리" class="text-primary" onclick="fnMemberList(' + result[i].TeamNo + ')"><i class="bi bi-people-fill"></i></button>';
					value += '		</td>';
					value += '	</tr>';
				}
			}
			else {
				value += '	<tr>';
				value += '		<td colspan="2">' + "등록된 팀이 없습니다." + '</td>';
				value += '	</tr>';
			}

			$("#tbdTeamList").html(value);
		}

		<%-- 팀 편성 > 팀원 조회 --%>
		function fnMemberList(teamNo) {
			$("#hdnTeamNo").val(teamNo);

			fnTeamMemberList();
			fnTeamNotMemberList();	
		}

		<%-- 팀 편성 > 팀원 조회 --%>
		function fnTeamMemberList() {
			ajaxHelper.CallAjaxPost("/Team/TeamMemberList", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val(), teamNo: $("#hdnTeamNo").val() }, "fnCompleteTeamMemberList");
		}

		function fnCompleteTeamMemberList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					value += '	<tr>';
					value += '		<td>';
					value += '			<span class="text-nowrap text-dark d-block">';
					if (result[i].SexGubun == 'F') {
					value += '			<i class="bi bi-gender-female text-danger" title="여"></i>';
					} else {
					value += '			<i class="bi bi-gender-male text-primary" title="남"></i>';
					}
					value += '			' + result[i].HangulName + '';
					value += '			</span>';
					value += '		</td>';
					value += '		<td><span class="text-nowrap text-secondary font-size-15">' + result[i].UserID + '</span></td>';
					value += '		<td>';
					if (result[i].TeamLeaderYesNo == 'Y') {
					value += '			<input type="radio" name="GroupTeamMember.TeamLeaderYesNo" checked="checked"/>';
					} else {
						value += '			<input type="radio" name="GroupTeamMember.TeamLeaderYesNo" onclick="fnTeamLeaderUpdate(' + result[i].TeamMemberNo + ')"/>';
					}
					value += '		</td>';
					value += '		<td><button type="button" title="제외" class="text-danger" onclick="fnTeamMemberDelete(' + result[i].TeamMemberNo + ')"><i class="bi bi-trash"></i></button></td>';
					value += '	</tr>';
				}
			} else {
				value += '	<tr>';
				value += '		<td colspan="4">' + "등록된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다." + '</td>';
				value += '	</tr>';
			}

			$("#tbdTeamMemberList").html(value);
		}

		<%-- 팀 편성 > 미배정된 학생/수강생 조회 --%>
		function fnTeamNotMemberList() {
			ajaxHelper.CallAjaxPost("/Team/TeamNotMemberList", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val() }, "fnCompleteTeamNotMemberList");
		}

		function fnCompleteTeamNotMemberList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";

			if (result.length > 0) {
				for (var i = 0; i < result.length; i++) {

					value += '	<tr>';
					value += '		<td>';
					value += '			<span class="text-nowrap text-dark d-block">';
					if (result[i].SexGubun == 'F') {
						value += '			<i class="bi bi-gender-female text-danger" title="여"></i>';
					} else {
						value += '			<i class="bi bi-gender-male text-primary" title="남"></i>';
					}
					value += '			' + result[i].HangulName + '';
					value += '			</span>';
					value += '		</td>';
					value += '		<td><span class="text-nowrap text-secondary font-size-15">' + result[i].UserID + '</span></td>';
					value += '		<td>';
					value += '			<button type="button" class="text-primary" title="추가" onclick="fnTeamMemberSave(' + result[i].UserNo + ')"><i class="bi bi-plus"></i></button>';
					value += '		</td>';
					value += '	</tr>';
				}
			} else {
				value += '	<tr>';
				value += '		<td colspan="3">' + "등록된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없습니다." + '</td>';
				value += '	</tr>';
			}

			$("#tbdTeamNotMemberList").html(value);
		}

		<%-- 팀 편성 > 미배정된 학생/수강생 정렬 타입(학번순/성명순/소속순) --%>
		$("#ddlSort").change(function () {
			ajaxHelper.CallAjaxPost("/Team/TeamNotMemberList", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val(), sortType: $("#ddlSort").val() }, "fnCompleteTeamNotMemberList");
		})

		<%-- 팀 편성 > 팀원 삭제 --%>
		function fnTeamMemberDelete(teamMemberNo) {
			ajaxHelper.CallAjaxPost("/Team/TeamMemberDelete", { teamMemberNo: teamMemberNo }, "fnCompleteTeamMember");
		}

		<%-- 팀 편성 > 팀원 리더 변경 --%>
		function fnTeamLeaderUpdate(teamMemberNo) {
			ajaxHelper.CallAjaxPost("/Team/TeamLeaderUpdate", { teamNo: $("#hdnTeamNo").val(), teamMemberNo: teamMemberNo }, "fnCompleteTeamMember");
		}

		<%-- 팀 편성 > 미배정 학생/수강생 팀원 추가 --%>
		function fnTeamMemberSave(teamMemberUserNo) {
			ajaxHelper.CallAjaxPost("/Team/TeamMemberSave", { courseNo: $("#hdnCourseNo").val(), groupNo: $("#hdnGroupNo").val(), teamNo: $("#hdnTeamNo").val(), teamMemberUserNo: teamMemberUserNo }, "fnCompleteTeamMember");
		}

		function fnCompleteTeamMember() {
			fnTeamMemberList();
			fnTeamNotMemberList();
		}

	</script>
</asp:Content>
