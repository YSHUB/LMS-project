<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Facility/ListEquipment" id="mainForm" method="post">
		<div id="content">
			<%="" %>
			<div class="row align-items-center mt-4">
				<div class="col d-inline-flex d-md-none">
					<h3 class="title03">시설 검색</h3>
				</div>
				<div class="col-auto text-right d-md-none">
					<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample1" aria-expanded="false" aria-controls="collapseExample1">
						<span class="sr-only">더 보기</span>
					</button>
				</div>
			</div>
			<div class="card collapse d-md-block" id="collapseExample1">
				<div class="card-body pb-1">
					<div class="form-row align-items-end">
						<div class="form-group col-md-4">
							<label for="tno" class="form-label">카테고리 선택 <strong class="text-danger">*</strong></label>
							<select id="tno" name="Category" class="form-control">
								<option value="%">전체</option>
								<%
									foreach (var codes in Model.BaseCode)
									{
								%>
								<option value="<%:codes.CodeValue %>" <%if (codes.CodeValue.Equals(Model.Category)){ %>
									selected="selected" <%} %>><%:codes.CodeName %></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="form-group col-md">
							<label for="" class="form-label">검색어 입력 <strong class="text-danger">*</strong></label>
							<input id="Search_Text" title="장비명으로 검색" type="text" class="form-control" name="SearchText" value="<%:!string.IsNullOrEmpty(Model.SearchText) ? Model.SearchText : "" %>" placeholder="장비명으로 검색">
						</div>
						<div class="form-group col-sm-auto text-right">
							<button type="button" id="btnSearch" class="btn btn-secondary">
								<span class="icon search">검색</span>
							</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row mt-4">
				<%
					if (!(Model.FacilityList.Count > 0))
					{
				%>
				<div class="col-12 alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 장비가 없습니다.</div>
				<%
					}
					else
					{
						foreach (var item in Model.FacilityList)
						{
				%>
				<div class="col-md-4">
					<div class="card card-style04">
						<div class="card-body">
							<a href="/Facility/DetailEquipment/<%:item.FacilityNo %>?Category=<%:Model.Category %>&SearchText=<%:Model.SearchText %>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>">
								<div class="img-thumb">
									<%
										if (!string.IsNullOrEmpty(item.FileName))
										{
									%>
									<img src="/Files<%:item.FileName %>" alt="">
									<%
										}
										else
										{ 
									%>
									<img src="/Site/resource/www/images_kiria/favicon.ico" alt="">
									<%
										}
									%>
								</div>
								<div class="text text-truncate"><%:item.FacilityName %></div>
							</a>
						</div>
						<!-- card-body -->
					</div>
				</div>
				<%
						}
					}
				%>
			</div>
			<%= Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$("#ddlPageRowSize").change(function () {
				document.forms["mainForm"].submit();
			});

			$("#btnSearch").click(function () {
				document.forms["mainForm"].submit();
			});
		});
	</script>
</asp:Content>
