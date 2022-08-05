<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>


<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Account/ListGeneral" id="mainForm" method="post">
		<div id="content">
			<div class="card mt-4">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-2">
							<label for="ddlApprovalGbn" class="sr-only">인증상태</label>
							<select id="ddlApprovalGbn" name="ApprovalGbn" class="form-control">
								<option value="">인증상태</option>
								<%
									foreach (var item in Model.BaseCode) 
									{
								%>
										<option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.ApprovalGbn)) { %> selected="selected" <% } %> ><%:item.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-2">
							<label for="ddlSearchGbn" class="sr-only">검색구분</label>
							<select id="ddlSearchGbn" name="SearchGbn" class="form-control">
								<option value="">검색구분</option>
								<option value="I" <%:Model.User == null ? "" : Model.SearchGbn == "I" ? "selected" : "" %>>아이디</option>
								<option value="N" <%:Model.User == null ? "" : Model.SearchGbn == "N" ? "selected" : "" %>>성명</option>
							</select>
						</div>
						<div class="form-group col-3">
							<label for="txtSearchText" class="sr-only">검색어</label>
							<input title="검색어" id="txtSearchText" name="SearchText" class="form-control" type="text" placeholder="검색어" value="<%:Model.SearchText%>" />
						</div>
						<div class="form-group col-auto text-right">
							<button type="submit" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
						<div class="form-group col-sm-auto">
							<button type="button" class="btn btn-secondary" onclick="fnExcel()">
								<i class="bi bi-download"></i> 엑셀 다운로드
							</button>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-12 mt-2">
					<%
						if (Model.UserList.Count.Equals(0))
						{
					%>
							<div class="alert bg-light alert-light rounded text-center"><i class="bi bi-info-circle-fill"></i> 아직 등록된 일반회원이 없습니다.</div>
					<%
						}
						else 
						{
					%>
							<div class="card">
								<div class="card-header">
									<div class="row justify-content-between">
										<div class="col-auto">
											<small class="d-inline-block">총 <span class="text-primary font-weight-bold"><%:Model.PageTotalCount %></span>건 </small>
										</div>
										<div class="col-auto text-right">
											<select class="form-control form-control-sm" id="ddlPageRowSize" name="PageRowSize">
												<option value="10" <%= Model.PageRowSize.Equals(10) ? "selected='selected'" : ""%>>10건</option>
												<option value="50" <%= Model.PageRowSize.Equals(50) ? "selected='selected'" : ""%>>50건</option>
												<option value="100" <%= Model.PageRowSize.Equals(100) ? "selected='selected'" : ""%>>100건</option>
												<option value="200" <%= Model.PageRowSize.Equals(200) ? "selected='selected'" : ""%>>200건</option>
											</select>
										</div>
									</div>
								</div>
								<div class="card-body py-0">
									<div class="table-responsive">
										<table class="table table-hover" id="tblUserList">
											<caption>일반회원 리스트</caption>
											<thead>
												<tr>
													<th scope="row">성명</th>
													<th scope="row">아이디</th>
													<th scope="row" class="d-none d-md-table-cell">생년월일</th>
													<th scope="row">성별</th>
													<th scope="row" class="d-none d-md-table-cell">연락처</th>
													<th scope="row" class="d-none d-md-table-cell">이메일</th>
													<th scope="row">인증상태</th>
													<th scope="row" class="text-nowrap">관리</th>
												</tr>
											</thead>
											<tbody>
												<%
													foreach (var item in Model.UserList) 
													{
												%>
														<tr>
															<td class="text-left"><%:item.HangulName %></td>
															<td class="text-left"><%:item.UserID %></td>
															<td class="text-center d-none d-md-table-cell"><%:string.IsNullOrEmpty(item.ResidentNo) ? "-" : item.ResidentNo %></td>
															<td class="text-center"><%:string.IsNullOrEmpty(item.SexGubun) ? "-" : item.SexGubun.Equals("M") ? "남" : "여"%></td>
															<td class="text-center d-none d-md-table-cell"><%:string.IsNullOrEmpty(item.Mobile) ? "-" : item.Mobile %></td>
															<td class="text-<%:string.IsNullOrEmpty(item.Email) ? "center" : "left" %> d-none d-md-table-cell">
																<%=string.IsNullOrEmpty(item.Email) ? "-" : "<a href='mailto:" + item.Email +"' class='btn btn-link btn-sm'>" + item.Email + "</a>"%>
															</td>
															<td class="text-center"><%:item.ApprovalGubunName %></td>
															<td class="text-center">
																<a onclick="fnGo('<%:item.UserNo%>')" href="#" class="font-size-20 text-primary">
																	<i class="bi bi-pencil"></i>
																</a>
															</td>
														</tr>
												<%
													}
												%>
											</tbody>
										</table>
									</div>
								</div>
								<div class="card-footer">
									<div class="text-right">
										<a href="/Account/ImportGeneral" class="btn btn-outline-primary">일괄 등록</a>
										<a href="#" onclick="fnGo(0)" class="btn btn-primary">등록</a>
									</div>


								</div>
							</div>
					<%
						}
					%>
				</div>
			</div>
			<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
		</div>
	</form>		
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		<%-- 검색 --%>
		$(document).ready(function () {

			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});

		});

		<%-- 엑셀 다운로드 --%>
		function fnExcel() {

			if (<%:Model.UserList.Count %> > 0) {
				var param1 = $("#ddlApprovalGbn").val();
				var param2 = $("#ddlSearchGbn").val();
				var param3 = $("#txtSearchText").val();

				window.location = "/Account/ListGeneralExcel/" + param1 + "/" + param2 + "/" + param3;
			}
			else {
				bootAlert("다운로드할 내용이 없습니다.");
			}
		}

		function fnGo(userNo) {

			var no = userNo == 0 ? "" : userNo;
			window.location = "/Account/WriteGeneral/" + no + "?SearchText=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&SearchGbn=" + '<%:Model.SearchGbn%>' + "&ApprovalGubun=" + '<%:Model.ApprovalGbn%>' + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>