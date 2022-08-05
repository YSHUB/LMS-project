<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
	
	<!-- OcwView 관련-->
	<form id="frmpop">
		<input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
		<input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
	</form>

	<form action="/Ocw/Index/0" id="mainForm" method="post">
		<%: Html.HiddenFor(m => m.OcwSort) %>
		<!-- 검색 폼 -->
		<div class="card mt-4">
			<div class="card-body pb-1">
				<div class="form-row align-items-end">
					<div class="form-group col-md-3">
						<label for="OcwThemeSel" class="sr-only">테마전체</label>
						<input type="hidden" id="hdnUnivYN" value="<%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") ? "N" : "Y" %>"/>
						<select id="OcwThemeSel" name="OcwThemeSel" class="form-control">
							<option value="%">테마전체</option>
							<%
							string themeNo = string.Empty;
									foreach (var ocwTheme in Model.OcwThemeList)
									{
										themeNo = ocwTheme.ThemeNo.ToString();
							%>
							<option value="<%:themeNo %>" <%: themeNo == Model.OcwThemeSel ? "selected" : "" %>><%: ocwTheme.ThemeName %></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="form-group col-md-3" id="ddlAssignSel">
						<label for="AssignSel" class="sr-only">전공전체</label>
						<select id="AssignSel" name="AssignSel" class="form-control">
							<option value="%">전공전체</option>

							<%
								foreach (var assign in Model.AssignList.Where(w => w.HierarchyLevel >= 2))
								{
							%>
							<option value="<%: assign.AssignNo %>" <%: assign.AssignNo == Model.AssignSel ? "selected" : "" %>><%: assign.AssignName%></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="form-group col-md">
						<label for="SearchText" class="sr-only">검색어 입력</label>
						<input class="form-control" title="검색어 입력" name="SearchText" id="SearchText" value="<%:Model.SearchText %>" type="text" placeholder="작성자/제목으로 검색">
					</div>
					<div class="form-group col-sm-auto text-right">
						<button type="button" id="btnSearch" onclick="fnGoSearch();" class="btn btn-secondary">
							<span class="icon search">검색
							</span>
						</button>
					</div>
				</div>
			</div>
		</div>


		<%-- OCW 리스트 --%>
		<h4 class="title05 mt-3">총 <strong class="text-primary"><%: Model.PageTotalCount %> </strong>건</h4>
		<div class="card card-style01">
			<div class="card-header">
				<div class="text-right font-size-14">
					<%
						int cnt = 1;
						foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "SRTN"))
						{
							int length = Model.BaseCode.Where(w => w.ClassCode.ToString() == "SRTN").Count();
					%>
					<a href="#" onclick="fnGoTab('ocwSort', '<%: Model.OcwSort.Equals(baseCode.CodeValue) ? "block" : baseCode.CodeValue %>');"
						class="text-<%: Model.OcwSort.Equals(baseCode.CodeValue) ? "primary" : "secondary"%> <%:cnt == length ? "" : "bar-vertical"%> ">
						<i class="bi bi-funnel-fill <%: Model.OcwSort.Equals(baseCode.CodeValue) ?  "" : "d-none" %> "></i>
						<strong><%:baseCode.CodeName %></strong>
					</a>
					<%
							cnt++;
						}
					%>
				</div>
			</div>


			<div class="card-body">


				<%
					if (Model.OcwList.Count < 1)
					{
				%>
				<div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i>조회된 게시물이 없습니다.</div>
				<%
					}
					else
					{

						foreach (var ocw in Model.OcwList)
						{
				%>
				<div class="card-item01">
					<div class="row no-gutters align-items-md-stretch">
						<div class="col-md-4 col-lg-3 mb-2 mb-md-0">
							<%
								if (!string.IsNullOrEmpty(ocw.ThumFileName))
								{
							%>
							<!-- image type -->
							<div class="thumb-wrap">
								<div class="thumb">
									<img src="<%: ocw.FileExtension %>">
								</div>
							</div>

							<%
								}
								else
								{
							%>
							<!-- icon type -->
							<div class="thumb-wrap icon">
								<div class="thumb">
									<i class="<%: ocw.FileExtension %>"></i>
								</div>
							</div>
							<%
								}
							%>
						</div>

						<div class="col-md-8 col-lg-9 pl-md-4">
							<div class="text-secondary d-flex flex-wrap align-items-center">
								<strong class="font-size-14 bar-vertical"><span><%: string.Join(", ", Model.OcwThemeList.Where(w=>(ocw.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></span></strong>
								<strong class="font-size-14 bar-vertical"><span><%: ocw.AssignNamePath %></span></strong>
								<strong class="font-size-14 bar-vertical"><%: ocw.CreateDateTime %></strong>
								<strong class="font-size-14 bar-vertical">조회(<%: ocw.UsingCount %>)</strong>
								<a href="javascript:void(0);" onclick="fnOcwView(<%: ocw.OcwNo%>
                                                            , <%: ocw.OcwType %>
                                                            , <%: ocw.OcwSourceType %>
                                                            , '<%: ocw.OcwType == 1 || (ocw.OcwType == 0 && ocw.OcwSourceType == 0) ? (ocw.OcwData ?? "") : "" %>'
                                                            , <%: ocw.OcwFileNo %>
                                                            , <%: ocw.OcwWidth %>
                                                            , <%: ocw.OcwHeight %>
                                                            , 'frmpop');"
									title="강의 바로보기" class="font-size-20 text-point <%:ocw.OcwType == 2 ? "d-none" : ""%>">
									<i class="bi bi-eye-fill"></i>
								</a>
							</div>
							<div class="my-1 text-truncate">
								<a href="/Ocw/Detail/<%: ocw.OcwNo %>" class="text-dark">
									<strong class="font-size-22"><%: ocw.OcwName %></strong>
								</a>
							</div>
							<div class="text-secondary text-truncate">
								<%: ocw.DescText %>
							</div>
							<div class="mt-2 ">
								<i class="bi bi-tags text-dark mr-2"></i>
								<%: Html.Raw(string.Join("", (ocw.KWord ?? "").Split(',').
                                                    Select(s => "<a href='javascript: void();' onclick='fnSetTag(this);' class='mr-1 badge badge-1-light'>" + s + "</a>"))) %>
							</div>
						</div>
					</div>
				</div>
				<!-- card-item01 -->
				<%
						}
					}
				%>
			</div>

		</div>

		<%-- 페이징 --%>
		<%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
	</form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		$(document).ready(function () {

			if ($("#hdnUnivYN").val() == "N") {
				$("#ddlAssignSel").addClass("d-none");
			}
		});

		// ajax 객체 생성
		var ajaxHelper = new AjaxHelper();

		function fnGoTab(id, tid) {
			if (id == "ocwSort") {
				if (tid != "block") {
					$("#OcwSort").val(tid);
					fnSubmit();
				}
			}
			fnPrevent();
		}

		function fnGoSearch() {
			$("#OcwThemeSel").val($("#OcwThemeSel option:selected").val());
			$("#AssignSel").val($("#AssignSel option:selected").val());

			fnSubmit();
		}

		function fnSetTag(obj) {
			$("#SearchText").val($(obj).text());
			fnSubmit();
			fnPrevent();
		}


		/*
		function viewOcw(dn, dt, dst, dd, df, dw, dh, fid, inningno) {
			let ocwNo = dn;
			let ocwType = dt;
			let ocwSourceType = dst;
			let ocwData = dd;
			let ocwFileNo = df;
			let ocwWidth = dw;
			let ocwHeight = dh;

			ocwData = decodeURIComponent(ocwData);
			fid = fid || "formPop"; //form태그 id
			inningno = inningno || 0;

			if (inningno > 0 && ocwNo == 0) {
				alert("강의컨텐츠가 없습니다.", 1);
			}
			else if (inningno > 0 && (ocwType != 0 || (ocwSourceType != 1 && ocwSourceType != 2 && ocwSourceType != 3 && ocwSourceType != 4))) {
				alert("출석인정용 콘텐츠가 아닙니다.\n관리자에게 문의바랍니다.");
			}
			else {
				if (ocwType == 0) {
					$("#ocwViewOcwNo").val(ocwNo);

					//if ($("#ocwviewInningNo").length > 0) {
					//    $("#ocwviewInningNo").val(inningno);
					//}

					if (ocwSourceType == 0) {

						ajaxHelper.CallAjaxPost("/Ocw/OcwViewHistory", { OcwNo: ocwNo }, "cbEmpty");
						if ($("#textOcwData").length < 1 || ($("#textOcwData").text() || "") == "") {
							window.open(ocwData);
						}
						else {
							window.open($("#textOcwData").text());
						}
					}
					else {
						OcwPopup("/Ocw/OcwView", "OcwView", ocwWidth + 50, ocwHeight + 70, fid);
					}
				}
				else {

					if (ocwSourceType == 0) {
						window.open(ocwData);
					}
					else if (ocwSourceType == 5) {

						commondownload(ocwFileNo);
					}
					ajaxHelper.CallAjaxPost("/Ocw/OcwViewHistory", { OcwNo: ocwNo }, "cbEmpty");
				}
			}

			fnPrevent();
		}

		function cbEmpty() {

		}
		*/

	</script>
</asp:Content>
