<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.TeamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Team/List/<%:ViewBag.Course.CourseNo %>" id="mainForm" method="post">
		<div id="content">
			<div class="alert alert-light bg-light">
				<p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i> 팀편성 주의사항</p>
				<ul class="list-style03 mb-0">
					<li class="font-size-14">과제, 토론 등에서 사용될 팀을 편성할 수 있습니다.</li>
					<li class="font-size-14">팀편성이 안된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>은 과제, 토론 등에 참여할 수 없으니, 누락된 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>이 없도록 주의하세요.</li>
					<li class="font-size-14">자동 팀편성을 사용하시면 <%:ConfigurationManager.AppSettings["StudentText"].ToString() %>을 설정한 조건에 따라 랜덤으로 편성합니다.</li>
					<li class="font-size-14">수동으로 팀편성을 하시려면 그룹관리 탭을 눌러 그룹 및 팀 편성을 진행해 주세요.</li>
				</ul>
			</div>
			<ul class="nav nav-tabs mt-4" id="teamTab" role="tablist">
				<li class="nav-item" role="presentation">
					<a class="nav-link active" id="teamListTab" href="/Team/List/<%:ViewBag.Course.CourseNo %>" role="tab">팀 리스트</a>
				</li>
				<li class="nav-item" role="presentation">
					<a class="nav-link" id="groupTab" href="/Team/Write/<%:ViewBag.Course.CourseNo %>" role="tab">그룹 관리</a>
				</li>
			</ul>
				<div class="row">
					<div class="col-12 mt-2">
						<h3 class="title04 mt-2">팀편성 리스트<strong class="text-primary">(<%:Model.GroupTeamMemberList.Count() %>건)</strong></h3>
						<div class="card mt-4">
							<div class="card-body pb-1">
								<div class="form-row align-items-end">
									<div class="form-group col-6 col-md-3 ">
										<label for="ddlGroup" class="sr-only">그룹</label>
										<select class="form-control" id="ddlGroup" name="Group.GroupNo">
											<%
												if (Model.GroupList == null)
												{
											%>
													<option value="">등록된 그룹이 없습니다.</option>
											<%
												}
												else 
												{
											%>
													<%
													foreach (var item in Model.GroupList) 
													{ 
													%>
														<option value="<%:item.GroupNo %>" <%: item.GroupNo == Model.GroupNo ? "selected" : "" %>><%:item.GroupName %></option>
													<%
													}
													%>
											<%
												}
											%>
										</select>
									</div>
									<div class="form-group col-6 col-md-3">
										<label for="ddlTeam" class="sr-only">팀선택</label>
										<select class="form-control" id="ddlTeam" name="GroupTeam.TeamNo" >
											<%
											foreach (var item in Model.GroupTeamList)
											{
											%>
												<option value="<%:item.TeamNo %>" <%:Model.GroupTeam != null ? item.TeamNo == Model.GroupTeam.TeamNo ? "selected" : "" : ""%>><%:item.TeamName %></option>
											<%
											}

											if (Model.GroupTeamList.Count() == 0) {
											%>
												<option value=''>등록된 팀이 없습니다..</option>
											<%
											}
											%>
										</select>
									</div>
									<div class="form-group col-sm-auto text-right">
										<button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch()">
											<span class="icon search">
												검색
											</span>
										</button>
									</div>
								</div>
							</div>
						</div>
						<%
							if (Model.GroupTeamMemberList.Count() == 0)
							{
						%>
								<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 팀원이 없습니다.</div>
						<%
							}
							else 
							{
						%>
								<div class="card mt-2">
									<div class="card-body py-0">
										<div class="table-responsive">
											<table class="table" id="personalTable">
												<caption>개인별 평가 현황 리스트</caption>
												<thead>
													<tr>
														<th scope="row">번호</th>
														<th scope="row">그룹</th>
														<th scope="row">팀</th>
														<th scope="row"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>														
														<th scope="row">성명</th>
														<%
															if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
															{
														%>
															<th scope="row">학년</th>
															<th scope="row">소속</th>
															<th scope="row" class="text-nowrap">학적</th>
														<%
															}
															else
															{
														%>
															<th scope="row">이메일</th>
															<th scope="row">구분</th>
															<th scope="row" class="text-nowrap">생년월일</th>															
														<%
															}
														%>
													</tr>
												</thead>
												<tbody>
													<%
														foreach (var item in Model.GroupTeamMemberList) 
														{
													%>
															<tr class="data">
																<td><%:Model.GroupTeamMemberList.IndexOf(item) + 1 %></td>
																<td><%:item.GroupName %></td>
																<td class="text-nowrap text-left"><%:item.TeamName %></td>
																<td>
																	<span class="text-nowrap text-secondary font-size-15">
																	<%:item.UserID %>
																	</span>
																</td>
																<td>
																	<span class="text-nowrap text-dark d-block">
																		<i class="bi bi-gender-<%:item.SexGubun.Equals("M") ? "male text-primary" : "female text-danger"%>" title="<%:item.SexGubun.Equals("M") ? "남" : "여" %>"></i>
																		<%:item.HangulName %>
																		<%
																			if (item.TeamLeaderYesNo.Equals("Y")) 
																			{
																		%>
																				<i class="bi bi-patch-check-fill text-success" title="팀장"></i>
																		<%
																			}
																		%>
																	</span>
																</td>
																<%
																	if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
																	{
																%>
																	<td><%:item.GradeName %></td>
																	<td><%:item.AssignName %></td>
																	<td><%:item.HakjeokGubunName %></td>
																<%
																	}
																	else
																	{
																%>
																	<td><%:item.Email %></td>
																	<td><%:item.GeneralUserCode %></td>
																	<td><%:item.ResidentNo %></td>
																<%
																	}
																%>
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
							<button type="button"  class="btn btn-point" data-toggle="modal" data-target="#divAutoTeamAdd">자동 팀편성</button>
						</div>
					</div>
				</div>
				<div class="modal fade show" id="divAutoTeamAdd" tabindex="-1" aria-labelledby="autoTeamAdd" aria-modal="true" role="dialog">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title h4" id="autoTeamAdd">자동 팀편성</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<div class="alert bg-light alert-light rounded mt-2">
									<p class="font-size-14 text-danger font-weight-bold mb-0">
										<i class="bi bi-info-circle-fill"></i> 
										인원현황 (총
										<label id="lblStudentCnt" class="form-label"><%:Model.CourseLectureStudentList.Count() %></label> 
										명)
									</p>
									<ul class="list-style03 mb-0">
										<li>
											성별인원
											( 남 : <%:Model.CourseLectureStudentList.Where(w => w.SexGubun == "M").Count() %>명
											, 여 : <%:Model.CourseLectureStudentList.Where(w => w.SexGubun == "F").Count() %>명 )
										</li>
										<%
										if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
										{
										%>
										<li>
											학년인원 
											( 1학년 : <%:Model.CourseLectureStudentList.Where(w => w.GradeName == "1학년").Count() %>명
											, 2학년 : <%:Model.CourseLectureStudentList.Where(w => w.GradeName == "2학년").Count() %>명
											, 3학년 : <%:Model.CourseLectureStudentList.Where(w => w.GradeName == "3학년").Count() %>명
											, 4학년 : <%:Model.CourseLectureStudentList.Where(w => w.GradeName == "4학년").Count() %>명 )
										</li>
										<li>
											소속별 인원
											<ul class="list-style03 mb-0">
												<%
													foreach (var item in Model.CourseLectureStudentList.GroupBy(g => g.AssignName).Select(s => new { AssignName = s.First().AssignName, AssignCount = s.Count() }).OrderBy(o => o.AssignName))
													{
												%>
														<li><%:item.AssignName %> : <%:item.AssignCount %>명</li>
												<%
													}
												%>
											</ul>
										</li>
										<%
										}
										%>
									</ul>
								</div>
								<div class="card">
									<div class="card-body">
										<div class="row">
											<div class="col-12">
												<div class="form-row">
													<div class="form-group col-12 col-lg-3">
														<label for="txtGroupName" class="form-label">그룹명 <strong class="text-danger">*</strong></label>
														<input type="text" class="form-control text-right" id="txtGroupName" />
													</div>
													<div class="form-group col-6 col-lg-2">
														<label for="txtTeamMemberCnt" class="form-label">팀원 수 <strong class="text-danger">*</strong></label>
														<div class="input-group">
															<input type="text" class="form-control text-right" id="txtTeamMemberCnt"/>
															<div class="input-group-append">
																<div class="input-group-text">명</div>
															</div>
														</div>
													</div>
													<div class="form-group col-6 col-lg-3">
														<label for="ddlGroupType" class="form-label">배정방식 <strong class="text-danger">*</strong></label>
														<select class="form-control" onchange="fnGroupType()" name="Group.GroupType" id="ddlGroupType">
															<%
																foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CGCT")).ToList())
																{
															%>
																	<option value="<%:item.CodeValue %>"><%:item.CodeName %></option>
															<%
																}
															%>
														</select>
													</div>
													<div class="form-group col-6 col-lg-2">
														<label for="txtTeamCnt" class="form-label">생성 팀</label>
														<div class="input-group">
															<input type="text" class="form-control text-right" id="txtTeamCnt" readonly="readonly"/>
															<div class="input-group-append">
																<div class="input-group-text">팀</div>
															</div>
														</div>
													</div>
													<div class="form-group col-6 col-lg-2" id="divLastTeamMemberCnt">
														<label for="txtLastTeamMemberCnt" class="form-label">마지막 팀원 수</label>
														<div class="input-group">
															<input type="text" class="form-control text-right" id="txtLastTeamMemberCnt" readonly="readonly"/>
															<div class="input-group-append">
																<div class="input-group-text">명</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>									
									</div>
								</div>
								<div class="card" id="divSortType" style="display:none;">
									<div class="card-body">
										<div class="row">
											<div class="col-12">
												<label for="ddlSortType" class="form-label">우선순위(정렬)</label>
												<div class="form-row">
													<div class="form-group col-6 col-md-3">														
														<select class="form-control" id="ddlSortType1" name="ddlSortType1">
															<option value="">1순위</option>
															<%
																foreach (var item in ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).ToList() : Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).Where(x=>x.CodeValue.Equals("CGST001") || x.CodeValue.Equals("CGST004")).ToList())
																{
															%>
																	<option value="<%:item.CodeValue.Equals("CGST001") ? "HangulName" : item.CodeValue.Equals("CGST002") ? "AssignName" : item.CodeValue.Equals("CGST003") ? "GradeName DESC" : item.CodeValue.Equals("CGST004") ? "SexGubun DESC" : ""%>">
																		<%:item.CodeName %>
																	</option>
															<%
																}
															%>
														</select>
													</div>
													<div class="form-group col-6 col-md-3">
														<select class="form-control" id="ddlSortType2" name="ddlSortType2">
															<option value="">2순위</option>
															<%
																foreach (var item in ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).ToList() : Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).Where(x=>x.CodeValue.Equals("CGST001") || x.CodeValue.Equals("CGST004")).ToList())
																{
															%>
																	<option value="<%:item.CodeValue.Equals("CGST001") ? "HangulName" : item.CodeValue.Equals("CGST002") ? "AssignName" : item.CodeValue.Equals("CGST003") ? "GradeName DESC" : item.CodeValue.Equals("CGST004") ? "SexGubun DESC" : ""%>">
																		<%:item.CodeName %>
																	</option>
															<%
																}
															%>
														</select>
													</div>
													<%
														if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
														{
													%>
													<div class="form-group col-6 col-md-3">
														<select class="form-control" id="ddlSortType3" name="ddlSortType3">
															<option value="">3순위</option>
															<%
																foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).ToList())
																{
															%>
																	<option value="<%:item.CodeValue.Equals("CGST001") ? "HangulName" : item.CodeValue.Equals("CGST002") ? "AssignName" : item.CodeValue.Equals("CGST003") ? "GradeName DESC" : item.CodeValue.Equals("CGST004") ? "SexGubun DESC" : ""%>">
																		<%:item.CodeName %>
																	</option>
															<%
																}
															%>
														</select>
													</div>
													<div class="form-group col-6 col-md-3">
														<select class="form-control" id="ddlSortType4" name="ddlSortType4">
															<option value="">4순위</option>
															<%
																foreach (var item in Model.BaseCode.Where(x => x.ClassCode.Equals("CGST")).ToList())
																{
															%>
																	<option value="<%:item.CodeValue.Equals("CGST001") ? "HangulName" : item.CodeValue.Equals("CGST002") ? "AssignName" : item.CodeValue.Equals("CGST003") ? "GradeName DESC" : item.CodeValue.Equals("CGST004") ? "SexGubun DESC" : ""%>">
																		<%:item.CodeName %>
																	</option>
															<%
																}
															%>
														</select>
													</div>
													<%
														}
													%>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-12">
										<div class="alert bg-light alert-light rounded mt-2">
											<p class="font-size-14 text-info font-weight-bold">
												<i class="bi bi-info-circle-fill"></i> 
												마지막팀에는 남은 팀원 수가 배정되오니 확인하여 생성팀을 조정하세요.
											</p>
											<p class="font-size-14 text-info font-weight-bold">
												<i class="bi bi-info-circle-fill"></i> 
												배정방식 설명
												<ul class="list-style03">
													<li>무작위배정 : 무작위로 팀별 팀원이 배정</li>
													<li>순차균등배정 : 이름 등 지정하는 선택조건에 의해 팀 별로 균등하게 배정</li>
													<li>동일집단 우선배정 : 이름 등 지정하는 선택조건에 의해 첫번째 팀부터 순차적으로 배정</li>
												</ul>
											</p>
											<p class="font-size-14 text-info font-weight-bold">
												<i class="bi bi-info-circle-fill"></i> 
												각 선택조건별 정렬조건은 다음과 같습니다.
												<ul class="list-style03">
													<li>이름 : 가나다순</li>
													<li class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none"%>">소속 : 가나다순</li>
													<li class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none"%>">학년 : 4학년→1학년</li>
													<li>성별 : 남 → 여</li>
												</ul>
											</p>
											<p class="font-size-14 text-info font-weight-bold">
												<i class="bi bi-info-circle-fill"></i> 
												첫번째 수강생이 팀장으로 지정이 되며, 팀편성 후 그룹관리에서 변경하실 수 있습니다.
											</p>
										</div>
									</div>
									<div class="col-12 text-right">
										<input type="button" class="btn btn-primary" id="btnAutoTeamAddSave" value="저장" />
										<input type="button" class="btn btn-secondary" data-dismiss="modal" aria-label="Close" id="btnAutoTeamAddCancel" value="취소" />
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
		</div>

		<input type="hidden" title="hdnViewGroupNo" id="hdnViewGroupNo" name ="GroupNo" value="<%:Model.GroupNo %>">
		<input type="hidden" title="hdnGroupNo" id="hdnGroupNo" name ="Group.GroupNo" value="<%:Model.Group != null ? Model.Group.GroupNo : 0 %>">
		<input type="hidden" title="hdnTeamNo" id="hdnTeamNo" name ="GroupTeam.TeamNo" value="<%:Model.GroupTeam != null ? Model.GroupTeam.TeamNo : 0 %>">

	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

		var ajaxHelper = new AjaxHelper();
		
		<%-- 그룹 선택 > 팀 조회 --%>
		$("#ddlGroup").change(function () {
			ajaxHelper.CallAjaxPost("/Team/TeamList", { courseNo: <%:ViewBag.Course.CourseNo %>, groupNo: $("#ddlGroup").val() }, "fnCompleteTeamList");

		});

		function fnCompleteTeamList() {
			var result = ajaxHelper.CallAjaxResult();
			var value = "";
			
			value += "<option value=''>팀 선택</option>";

			if (result.length > 0) {

				for (var i = 0; i < result.length; i++) {
					value += "<option value='" + result[i].TeamNo + "'>";

					value += result[i].TeamName;
				}
				value += "</option>";
			}
			else {
				value += "<option value=''>" + "등록된 팀이 없습니다." + "</option>"
			}
			$("#ddlTeam").html(value);
		}

		<%-- 검색 --%>
		function fnSearch() {
			
			$("#mainForm").submit();
			fnPrevent();
		}

		<%-- 팀원 수 등록 시 생성 팀/마지막팀원 수 자동 변경 --%>
		$("#txtTeamMemberCnt").keyup(function () {
			fnCalculate();
		});

		function fnCalculate() {
			var groupType = $("#ddlGroupType option:selected").val();

			if ($("#txtTeamMemberCnt").val() != "") {

				var teamCnt = parseInt($("#lblStudentCnt").text() / $("#txtTeamMemberCnt").val());

				if (groupType != "CGCT002" && $("#lblStudentCnt").text() % $("#txtTeamMemberCnt").val() > 0) {
					teamCnt += 1;
				}

				if ($("#txtTeamMemberCnt").val() == 0) {
					$("#txtTeamCnt").val(0);
					$("#txtLastTeamMemberCnt").val(0);
				} else {
					$("#txtTeamCnt").val(teamCnt);
					$("#txtLastTeamMemberCnt").val(Number($("#lblStudentCnt").text()) % Number($("#txtTeamMemberCnt").val()));
				}

			} else {
				$("#txtTeamCnt").val(0);
				$("#txtLastTeamMemberCnt").val(0);
			}
		}

		<%-- 우선순위(정렬) 조회 --%>
		function fnGroupType() {

			var selectBox = event.target;
			var groupType = selectBox.value;

			if (groupType == 'CGCT002' || groupType == 'CGCT003') {
				$("#divSortType").show();
			} else {
				$("#divSortType").hide();
			}

			if (groupType == "CGCT002") {
				$("#divLastTeamMemberCnt").hide();
			} else {
				$("#divLastTeamMemberCnt").show();
			}
		}

		<%-- 자동팀편성 저장 --%>
		$("#btnAutoTeamAddSave").click(function () {

			if ($("#txtGroupName").val() == "") {
				bootAlert("그룹명을 입력하세요.", function () {
					$("#txtGroupName").focus();
				});
				return false;
			}

			if ($("#txtTeamMemberCnt").val() == "") {
				bootAlert("생성할 팀 인원을 입력하세요.", function () {
					$("#txtTeamMemberCnt").focus();
				});
				return false;
			}

			if ($("#txtTeamMemberCnt").val() == 0) {
				bootAlert("생성할 수 없는 팀입니다.", function () {
					$("#txtTeamMemberCnt").focus();
				});
				return false;
			}

			var groupType = $("#ddlGroupType option:selected").val();
			var orderBy;

			if (groupType != "CGCT001") {
				if ($("#ddlSortType1").val() == "" || $("#ddlSortType2").val() == "" || $("#ddlSortType3").val() == "" || $("#ddlSortType4").val() == "") {
					bootAlert("우선순위를 입력해주세요.");
					return false;
				}

				orderBy = $("#ddlSortType1").val() + ', ' + $("#ddlSortType2").val() <%if(ConfigurationManager.AppSettings["UnivYN"].Equals("Y")){ %> + ', ' + $("#ddlSortType3").val() + ', ' + $("#ddlSortType4").val()<%} %>;
			}

			ajaxHelper.CallAjaxPost("/Team/AutoTeamAddSave", { courseNo: <%:ViewBag.Course.CourseNo %>, groupName: $("#txtGroupName").val(), teamMemberCnt: $("#txtTeamMemberCnt").val(), groupType: groupType, orderBy: orderBy }, "fnCompleteAutoTeamAddSave");
		});

		function fnCompleteAutoTeamAddSave() {

			var result = ajaxHelper.CallAjaxResult();
			if (result > 0) {
				bootAlert("저장되었습니다.", function () {
					location.reload();
				});
			} else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		$("#btnAutoTeamAddCancel").click(function () {

			$("#txtGroupName").val("");
			$("#txtTeamMemberCnt").val("");
			$("#txtTeamCnt").val("");
			$("#txtLastTeamMemberCnt").val("");
		});

	</script>
</asp:Content>
