<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>

<%
	string Gubun = Model.PageGubun.Equals("StudentStatusList") ? "교수" : "관리자";
%>

<!-- 검색 조건 -->
<div class="card">
	<div class="card-body pb-1">
		<div class="form-row align-items-end">
			<div class="form-group col-6 col-md-3 col-lg-2">
				<label for="ddlSearchOption" class="sr-only">상세검색</label>
				<select id="ddlSearchOption" name="SearchOption" class="form-control">
					<option value="ALL" <%:Model.SearchOption.Equals("ALL") ? "selected" : "" %>>전체학습자</option>
					<option value="Absence" <%:Model.SearchOption.Equals("Absence") ? "selected" : "" %>>1/3 결석자</option>
					<% 
					if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
					{
					%>
						<option value="Foriegn" <%:Model.SearchOption.Equals("Foriegn") ? "selected" : "" %>>외국인<%:ConfigurationManager.AppSettings["StudentText"].ToString() %></option>
					<%
					}	
					%>
				</select>
			</div>
			<div class="form-group col-6 col-md-3 col-lg-2">
				<label for="ddlSearchGbn" class="sr-only">검색구분</label>
				<select id="ddlSearchGbn" name="SearchGbn" class="form-control">
					<option value="N" <%: Model.SearchGbn.Equals("N") ? "selected" : ""%>>이름</option>
					<option value="I" <%: Model.SearchGbn.Equals("I") ? "selected" : ""%>><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></option>
				</select>
			</div>
			<div class="form-group col-12 col-md-10 col-lg-2">
				<label for="SearchStud" class="sr-only">검색어</label>
				<input type="text" class="form-control" name="SearchStud" id="SearchStud" placeholder="검색어" value="<%:Model.SearchStud%>"/>
			</div>
			<div class="form-group col-auto text-right">
				<button type="button" id="btnSearch" class="btn btn-secondary">
					<span class="icon search">검색</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!--학습진도현황 리스트-->
<%
	if (Model.StudentList.Count() == 0)
	{
%>
	<div class="alert bg-light alert-light rounded text-center mt-2">
		<i class="bi bi-info-circle-fill"></i> 검색 결과가 없습니다.
	</div>
<%
	}
	else
	{
%>
	<div class="card">
		<div class="card-header">
		<%
			if (Model.PageGubun.Equals("StudentStatusList"))
			{
		%>
				<div class="row justify-content-between">
					<div class="col-auto">
						<button type="button" id="btnSort" class="btn btn-sm btn-secondary">
						<%
							if (Model.SearchSort == "USERNAME")
							{
						%>
								<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순 정렬
						<%
							}
							else
							{
						%>
								이름순 정렬
							<%
								}
							%>
						</button>
					</div>
					<input type="hidden" id="sortType" name="SearchSort" value="<%:Model.SearchSort %>"/>
					<div class="col-auto text-right">
						<div class="dropdown d-inline-block">
							<button type="button" class="btn btn-sm btn-secondary dropdown-toggle" <%:Model.StudentList.Count.Equals(0) ? "d-none" : "" %>" id="dropdown1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									메세지발송
							</button>
							<ul class="dropdown-menu" aria-labelledby="dropdown1">
								<%
									if (ConfigurationManager.AppSettings["MailYN"].ToString().Equals("Y"))
									{
								%>
								<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerMail', 'chkSel');">메일발송</button></li>
								<%
									}
								%>
								<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerNote', 'chkSel');">쪽지발송</button></li>
								<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerSMS', 'chkSel');">SMS발송</button></li>
							</ul>
						</div>
						<div class="dropdown d-inline-block">
							<button type="button" class="btn btn-sm btn-secondary dropdown-toggle" id="dropdown2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									엑셀다운로드
							</button>
							<ul class="dropdown-menu" aria-labelledby="dropdown2">
								<li><button class="dropdown-item btn_excelAttendance" type="button">출석/성적부</button></li>
								<li><button class="dropdown-item btn_excelProgress" type="button">학습진도현황</button></li>
							</ul>
						</div>
					</div>
				</div>
		
		<%
			}
			else
			{
		%>
			<div class="row justify-content-between">
				<div class="col-auto">
					<button type="button" id="btnSort" class="btn btn-secondary">
					<%
						if (Model.SearchSort == "USERNAME")
						{
					%>
						<%:ConfigurationManager.AppSettings["StudIDText"].ToString() %>순 정렬
					<%
						}
						else
						{
					%>
						이름순 정렬
					<%
						}
					%>
					</button>
					<input type="hidden" id="sortType" name="SearchSort" value="<%:Model.SearchSort %>"/>
				</div>
				<div class="col-auto text-right">
					<div class="dropdown d-inline-block">
						<button type="button" class="btn btn-secondary dropdown-toggle" <%:Model.StudentList.Count.Equals(0) ? "d-none" : "" %>" id="dropdown1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								메세지발송
						</button>
						<ul class="dropdown-menu" aria-labelledby="dropdown1">
							<%
								if (ConfigurationManager.AppSettings["MailYN"].ToString().Equals("Y"))
								{
							%>
							<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerMail', 'chkSel');">메일발송</button></li>
							<%
								}
							%>
							<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerNote', 'chkSel');">쪽지발송</button></li>
							<li><button class="dropdown-item" type="button" onclick="fnLayerPopup('LayerSMS', 'chkSel');">SMS발송</button></li>
						</ul>
					</div>
				</div>
			</div>

		<%
			}
		%>
		</div>
		<div class="card-body py-0">
			<div class="table-responsive">
				<table class="table table-hover table-horizontal" summary="학습상황관리 - 학습진도현황">
				<caption>학습상황관리 - 학습진도현황 리스트</caption>
					<thead>
						<tr>
							<th scope = "col">
								<label for="chkAll" class="sr-only">전체선택</label>
								<input type="checkbox" id="chkAll" name="chkAll"/>
							</th>
							<th scope = "col" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>">소속</th>					
							<th scope = "col"><%:ConfigurationManager.AppSettings["StudIDText"].ToString() %></th>
							<th scope = "col">이름</th>
							<th scope = "col" class="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>">구분</th>
							<%
							if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
							{
							%>
							<th scope = "col">학년</th>
							<th scope = "col">학적</th>
							<%
							}
							else
							{
							%>
							<th scope = "col">이메일</th>
							<th scope = "col">생년월일</th>
							<%
							}
							%>
							<th scope = "col">출석</th>
							<th scope = "col">지각</th>
							<th scope = "col">결석</th>
							<th scope = "col">학습진도</th>
							<th scope = "col">상세보기</th>
						</tr>
					</thead>
					<tbody>
					<%
						foreach (var item in Model.StudentList)
						{
					%>
						<tr>
							<td class="text-center">
								<label for="chkSel<%:Model.StudentList.IndexOf(item) %>" class="sr-only">선택</label>
								<input type="checkbox" name="checkbox" id="chkSel<%:Model.StudentList.IndexOf(item) %>" value="<%:item.UserNo %>"/>
								<input type="hidden" value="<%:item.UserNo %>">
								<input type="hidden" value="<%:item.HangulName %>(<%:item.UserID %>)">
								<input type="hidden" value="<%:item.UserID %>">
								<!-- -->
								<input type="hidden" id="" name="" value=""/>
							</td>
						
							<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"><%:item.AssignName %></td>					
							<td class="text-center"><%:item.UserID%></td>
							<td class="text-center"><%:item.HangulName %></td>
							<td class="text-center <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>"><%:item.GeneralUserCode %></td>
							<%
							if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
							{
							%>
							<td class="text-center"><%:item.Grade%></td>
							<td class="text-center"><%:item.HakjeokGubunName %></td>
							<%
							}
							else
							{
							%>
							<td class="text-center"><%:item.Email%></td>
							<td class="text-center"><%:item.ResidentNo %></td>
							<%
							}
							%>
						
							<td class="text-center"><%:item.TotalAttendance %></td>
							<td class="text-center"><%:item.TotalLateness %></td>
							<td class="text-center"><%:item.TotalAbsence %></td>
							<td class="text-center"><%:item.TotalAttendance %>/<%:item.LectureInningCount %></td>

							<%if (Model.PageGubun.Equals("StudentStatusList"))
								{
							%>
								<td class="text-center"><a class="font-size-20 text-primary" href="#" onclick="javascript:fnOpenPopup('/LecInfo/StudentStatusDetail/<%:Model.CourseNo%>/<%:item.UserNo %>', 'UserDetail', 1100, 1200, 0, 0, 'auto');" title="상세보기"><i class="bi bi-card-list"></i></a></td>

							<%
							}
							else
							{
							%>

								<td class="text-center"><a class="font-size-20 text-primary" href="#" onclick="javascript:fnOpenPopup('/Lecture/ProgressUser/<%:Model.CourseNo%>/<%:item.UserNo %>', 'UserDetail', 900, 1200, 0, 0, 'auto');" title="상세보기"><i class="bi bi-card-list"></i></a></td>

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
		<div class="card-footer" id="btnList">
			<div class="row">
				<div class="col-12 text-right">
					<button type="button" class="btn btn-secondary">목록</button>
				</div>
			</div>
		</div>
	</div>
<%
	}
%>

<script>

	$(document).ready(function () {
		if (<%: Gubun.ToString() == "교수" ? "true" : "false" %>) {
			$('#btnList').hide();
		} else {

		}
	});


	$("#btnSort").click(function () {
		if ($("#sortType").val() != "USERID") {
			$("#sortType").val("USERID");
			if (<%: Gubun.ToString() == "교수" ? "true" : "false" %>) {
				$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Progress").submit();
			}
			else {
				$("#mainForm").attr("action", "/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Progress").submit();
			}
		}
		else {
			$("#sortType").val("USERNAME");
			if (<%: Gubun.ToString() == "교수" ? "true" : "false" %>) {
				$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Progress").submit();
			}
			else {
				$("#mainForm").attr("action", "/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Progress").submit();
			}

		}
	});

	$("#btnSearch").click(function () {
		if (<%: Gubun.ToString() == "교수" ? "true" : "false" %>) {
			<%--$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/<%:Model.TermNo%>/Progress").submit();--%>
			$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Progress").submit();
		} else {
			$("#mainForm").attr("action", "/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Progress").submit();
		}
	});

	$("#btnList").click(function () {
		var CourseNo = <%:Model.CourseNo%>;
		var TermNo = <%:Model.TermNo%>;
		var ProgramNo = <%:Model.ProgramNo%>;
		var SearchText = "<%:Model.SearchText%>";
		var PageRowSize = <%:Model.PageRowSize%>;
		var PageNum = <%:Model.PageNum%>;

		location.href = "/Lecture/ProgressListAdmin?CourseNo=" + CourseNo + "&TermNo=" + TermNo + "&ProgramNo=" + ProgramNo + "&SearchText=" + SearchText + "&PageRowSize=" + PageRowSize + "&PageNum=" + PageNum;
	});

	$("#chkAll").click(function () {
		fnSetCheckBoxAll(this, "chkSel");
	});

</script>