﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>

<%
	string Gubun = Model.PageGubun.Equals("StudentStatusList") ? "교수" : "관리자";
%>


<!--콘텐츠활동현황 리스트-->
<div class="card card-style01">
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
				<div class="col-auto text-right <%:Model.ProgressDetailList.Count != 0 ?  "" : "d-none" %>">
					<button type="button" class="btn btn-sm btn-secondary dropdown-toggle" id="dropdown2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							엑셀다운로드
					</button>
					<ul class="dropdown-menu" aria-labelledby="dropdown2">
						<li><button class="dropdown-item btn_excelAttendance" type="button">출석/성적부</button></li>
					</ul>
				</div>
			</div>
		
	<%
		}
		else
		{
	%>
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

	<%
		}
	%>
	</div>
	<div class="card-body py-0">
		<div class="table-responsive">
			<table class="table table-hover table-horizontal" summary="학습상황관리 - 컨텐츠활동">
			<caption>학습상황관리 - 컨텐츠활동 리스트</caption>
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
						<th scope = "col">강의컨텐츠</th>
						<th scope = "col">접근횟수</th>
						<th scope = "col">학습의견</th>
						<th scope = "col">상세보기</th>
					</tr>
				</thead>
				<tbody>
				<%
				foreach (var item in Model.ProgressDetailList)
				{
				%>
					<tr>
						<td class="text-center">
							<label for="chkSel" class="sr-only">선택</label>
							<input type="checkbox" name="checkbox" id="chkSel" value=""/>
							<input type="hidden" id="" name="" value=""/>
						</td>
						<td class="text-left <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "d-none" : ""%>"><%:item["AssignName"] %></td>
						<td class="text-center"><%:item["UserID"] %></td>
						<td class="text-center"><%:item["HangulName"] %></td>
						<td class="text-cneter <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "" : "d-none"%>"><%:item["GeneralUserCode"] %></td>
						<%
						if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
						%>
						<td class="text-center"><%:item["Grade"] %></td>
						<td class="text-center"><%:item["HakjeokGubunName"] %></td>
						<%
						}
						else
						{
						%>
						<td class="text-center"><%:item["Email"] %></td>
						<td class="text-center"><%:item["ResidentNo"] %></td>
						<%
						}
						%>
						<td class="text-center"><%:item["OcwCreateCount"] %></td>
						<td class="text-center"><%:item["TotalViewCount"] %></td>
						<td class="text-center"><%:item["OcwOpinionCount"] %></td>

						<%if (Model.PageGubun.Equals("StudentStatusList"))
							{
						%>
							<td class="text-center"><a class="font-size-20 text-primary" href="#" onclick="javascript:fnOpenPopup('/LecInfo/StudentStatusDetail/<%:Model.CourseNo%>/<%:item["UserNo"] %>', 'UserDetail', 1100, 1200, 0, 0, 'auto');" title="상세보기"><i class="bi bi-card-list"></i></a></td>

						<%
						}
						else
						{
						%>

							<td class="text-center"><a class="font-size-20 text-primary" href="#" onclick="javascript:fnOpenPopup('/Lecture/OcwUser/<%:Model.CourseNo%>/<%:item["UserNo"] %>', 'UserDetail', 900, 1200, 0, 0, 'auto');" title="상세보기"><i class="bi bi-card-list"></i></a></td>

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
	<%
	if(Model.ProgressDetailList.Count() == 0)
	{
	%>
		<div class="alert bg-light alert-light rounded text-center mt-2">
			<i class="bi bi-info-circle-fill"></i> 검색 결과가 없습니다.
		</div>
	<%
	}
	%>
</div>

<%
	if (Model.PageGubun.Equals("ProgressDetailAdmin"))
	{
%>
			<div class="text-right">
				<button type="button" id="btnList" class="btn btn-secondary">목록</button>
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
		if ($("#sortType").val() != "USERID")
		{
			$("#sortType").val("USERID");
			$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Ocw").submit();
		}
		else
		{
			$("#sortType").val("USERNAME");
			$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Ocw").submit();
		}
	});

	$("#btnSearch").click(function () {
		if (<%: Gubun.ToString() == "교수" ? "true" : "false" %>) {
			$("#mainForm").attr("action", "/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Ocw").submit();
		} else {
			$("#mainForm").attr("action", "/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Progress").submit();
		}
	});

	$("#chkAll").click(function () {
		fnSetCheckBoxAll(this, "chkSel");
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

</script>