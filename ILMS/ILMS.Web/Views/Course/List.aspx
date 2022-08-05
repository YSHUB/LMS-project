<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <form action="/Course/List/" id="mainForm" method="post">
        <input type="hidden" name="CourseNo" id="cno"/>
        <div id="content">
			<%="" %>
            <div class="card mt-4">
                    <%
					if(ConfigurationManager.AppSettings["UnivCode"].ToString().Equals("KIRIA") && (Model.CategoryNo.Equals(0) || string.IsNullOrEmpty(Model.CategoryNo.ToString())))
					{
					%>
                    <div class="card-body pb-1">
                        <div class="form-row align-items-end">
                            <div class="form-group col-4 col-md-auto">
                                <label for="ddlYear" class="sr-only">년도</label>
                                <select id="ddlYear" name="Year" class="form-control">
                                </select>
                            </div>
                            <div class="form-group col-4 col-md-auto">
                                <label for="ddlMonth" class="sr-only">월</label>
                                <select id="ddlMonth" name="Month" class="form-control">
                                </select>
                            </div>
					
						    <div class="form-group col-4 col-md-auto">
							    <label for="ddlStudyType" class="sr-only">강의형태</label>
							    <select id="ddlStudyType" name="SearchGbn" class="form-control">
								    <option value="%">전체</option>
                                    <%
								        foreach (var item in Model.BaseCode.Where(w => w.ClassCode.Equals("CSTD")).ToList())
								        {
							        %>
								    <option value="<%:item.CodeValue%>" <%if (item.CodeValue.Equals(Model.SearchGbn))
									    { %> selected = "selected" <% }%>><%:item.CodeName %></option>
							        <%
								        }
							        %>
							    </select>
						    </div>

                    
                            <div class="form-group col col-md">
                                <label for="searchText" class="sr-only">검색어 입력</label>
                                <input class="form-control" title="검색어 입력" placeholder="과정명 또는 <%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>명으로 검색" name="searchText" id="searchText" value="" type="text">
                            </div>
                            <div class="form-group col-auto">
                                <button type="submit" class="btn btn-secondary">
                                    <span class="icon search">검색
                                    </span>
                                </button>
                            </div>
                            <div class="form-group col-md-auto">
                                <label for="pageRowSize" class="sr-only">조회 조건</label>
                                <select name="pageRowSize" id="pageRowSize" class="form-control">
					        	    <option value="5" <%= Model.PageRowSize.Equals(5) ? "selected='selected'" : ""%>>5건</option>
					        	    <option value="10" <%= Model.PageRowSize.Equals(10) ? "selected='selected'" : ""%>>10건</option>
					        	    <option value="50" <%= Model.PageRowSize.Equals(50) ? "selected='selected'" : ""%>>50건</option>
					        	    <option value="100" <%= Model.PageRowSize.Equals(100) ? "selected='selected'" : ""%>>100건</option>
					            </select>
                            </div>
                        </div>
                    </div>
                <%
					}
				%>


            </div>

            <%
                if (Model.CourseList.Count.Equals(0))
                {

            %>
            <div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i>신청 가능한 강의가 없습니다.</div>
            <%
            }
            else
            {
            %>
			<div class="card card-style01 mt-4">
                <div class="card-body">
            <%
                foreach (var item in Model.CourseList)
                {
            %>
                    <div class="card-item01">
                        <div class="row no-gutters align-items-md-stretch">
                            <div class="col-md-4 col-lg-3 mb-2 mb-md-0">
                                <!-- icon type -->
                                <div class="thumb-wrap icon">
                                    <div class="thumb">
										<%
											if (!string.IsNullOrEmpty(item.SaveFileName))
											{
										%>
										<img src="/Files<%:item.SaveFileName %>" alt="">
										<%
											}
											else
											{ 
										%>
                                        <i class="bi bi-folder-fill"></i>
										<%
											}
										%>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8 col-lg-9 pl-md-4">
                                <div class="text-secondary d-flex flex-wrap align-items-center">
									<div class="form-group mb-0">
										<span class="badge badge-<%: DateTime.ParseExact(item.RStart, "yyyy-MM-dd", null) < DateTime.Now && DateTime.ParseExact(item.REnd, "yyyy-MM-dd", null).AddDays(1) > DateTime.Now ? "success":"danger"%>">
											<%: DateTime.ParseExact(item.RStart, "yyyy-MM-dd", null) < DateTime.Now && DateTime.ParseExact(item.REnd, "yyyy-MM-dd", null).AddDays(1) > DateTime.Now ? "신청가능":"신청불가" %>
										</span>
										<span class="badge badge-1"><%:item.StudyTypeName %></span>
									</div>
                                </div>
                                <div class="my-1 text-truncate">
                                    <span class="text-dark">
                                        <strong class="font-size-22">
                                            <a href="#" onclick="fnGo(<%:item.CourseNo %>)"><%: item.SubjectName %></a></strong>
                                    </span>
                                </div>
								<div class="form-inline">
									<dl class="row dl-style02 col-6 p-0">
										<dt class="col-auto w-5rem"><i class="bi bi-dot"></i>신청기간</dt>
										<dd class="col font-sm"><%=item.RStart %> ~ <%=item.REnd %></dd>
									</dl>
									<dl class="row dl-style02 col-6 p-0">
										<dt class="col-auto w-5rem"><i class="bi bi-dot"></i>교육기간</dt>
										<dd class="col font-sm"><%=item.LStart %> ~ <%=item.LEnd %></dd>
									</dl>
								</div>
								<div class="form-inline">
									<dl class="row dl-style02 col-6 p-0">
										<dt class="col-auto w-5rem"><i class="bi bi-dot"></i>교육비</dt>
										<dd class="col font-sm"><%=item.CourseExpense.ToString("N0") %> 원</dd>
									</dl>
									<dl class="row dl-style02 col-6 p-0">
										<dt class="col-auto w-5rem"><i class="bi bi-dot"></i>교육시간</dt>
										<dd class="col font-sm"><%=item.ClassTime %></dd>
									</dl>
								</div>
                            </div>

                        </div>

                    </div>
            <%
                    }
			%>
				</div>
            </div>
			<%
                }
            %>
        </div>
        <input type="hidden" id="hdnCategoryNo" name="CategoryNo" value="<%:!Model.CategoryNo.Equals(0) ? Model.CategoryNo : 0 %>"/>
        <%-- 페이징 --%>
        <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>

    </form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //년도, 월 세팅
            fnAppendYear("ddlYear", "1");
            fnAppendMonth("ddlMonth");

            $("#ddlYear option[value=" + "<%:Model.Year%>" + "]").attr("selected", "selected");
            $("#ddlMonth option[value=" + "<%:Model.Month%>" + "]").attr("selected", "selected");

			$("#searchText").val(decodeURI(decodeURIComponent('<%:Model.SearchText%>')));
			
        });

        function fnGo(cno) {

			window.location.href = "/Course/Detail/" + cno + "?Year=" + '<%:Model.Year %>' + "&Month=" + '<%:Model.Month %>' + "&CategoryNo=" + '<%: Model.CategoryNo %>' + "&Searhtext=" + encodeURI(encodeURIComponent('<%:Model.SearchText%>')) + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
        }

	</script>
</asp:Content>
