<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">

<form action="/Ocw/Member/0" id="mainForm" method="post">
    <%: Html.HiddenFor(m => m.UserCat) %>

    <!-- 검색 폼 -->
    <div class="card collapse d-md-block" id="collapseCourse">
        <div class="card-body bg-light pb-1">
            <div class="form-row align-items-end">
                <div class="form-group col-4 col-md-6" id="selectUser">
                    <label for="SearchText" class="sr-only">검색어 입력</label>
                    <input class="form-control" title="사용자 검색" name="SearchText" id="SearchText" readonly="readonly" value="<%:Model.Ocw.OcwUserNm %>" type="text" placeholder="OCW작성자를 선택하세요">
                    <input type="hidden" id="hdnUserNo" name="UserNo" value=<%: Model.UserNo%> />                
                </div>
                <div class="form-group col-sm-auto text-right">
                    <button type="button" id="btnSearch" onclick="fnOpenUserPopup('single', 'hdnUserNo', 'SearchText', 'mainForm');" class="btn btn-primary">
                        <span class="icon search">검색
                        </span>
                    </button>
                    <button type="button" class="d-none" onclick=""></button>
                </div>
            </div>
        </div>
    </div>

    <!-- 폴더 리스트 -->
    <div id="userCat" class="card <%: Model.UserNo < 1 ? "d-none" : "" %>">
        <div class="card-body bg-light">
            <ul class="list-inline list-inline-style02 mb-0">
                <li class="list-inline-item bar-vertical">
                    <a href="#" onclick="fnGoTab(-1);">전체<span class="ml-1 badge badge-<%:Convert.ToInt32( Model.UserCat) == -1 ? "primary" : "secondary" %>"><%: Model.OcwUserCatList.Sum(s => s.OcwCount).ToString("#,0") %></span></a>
                </li>

                <%
                    foreach (var ocwUserCat in Model.OcwUserCatList)
                    {
                %>
                <li class="list-inline-item bar-vertical">
                    <a href="#" onclick="fnGoTab(<%:ocwUserCat.CatCode %>);"><%: ocwUserCat.CatName %>
                        <span class="ml-1 badge badge-<%:Convert.ToInt32(Model.UserCat) == ocwUserCat.CatCode ? "primary" : "secondary" %>"><%: ocwUserCat.OcwCount.ToString("#,0") %></span>
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>


    <%-- OCW 리스트 --%>
    <div class="card card-style01 <%: Model.UserNo < 1 ? "d-none" : "" %>"">
        <div class="card-header">
        </div>

        <div class="card-body">            

            <%
                if (Model.OcwList.Count < 1)
                {                    
            %>            
                <div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i> 조회된 게시물이 없습니다.</div>
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

                            <!-- icon type -->
                            <div class="thumb-wrap icon">
                                <div class="thumb">
                                    <i class="<%: ocw.FileExtension %>"></i>
                                </div>
                            </div>
                        </div>


                            <%-- ocwDataType에 따라 제어 --%>
                            <!-- image type -->
                            <%--                                    <div class="thumb-wrap">
                                    <div class="thumb">
                                        <img src="./images/420by300.png">
                                    </div>
                                </div>--%>

                        <div class="col-md-8 col-lg-9 pl-md-4">
                            <div class="text-secondary d-flex flex-wrap align-items-center">
                                <strong class="font-size-14 bar-vertical"><span><%: string.Join(", ", Model.OcwThemeList.Where(w=>(ocw.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></span></strong>
                                <strong class="font-size-14 bar-vertical"><span><%: ocw.AssignNamePath %></span></strong>
                                <strong class="font-size-14 bar-vertical"><%: ocw.CreateDateTime %></strong>
                                <strong class="font-size-14 bar-vertical">조회(<%: ocw.UsingCount %>)</strong>
                                <a href="#"  onclick="viewOcw(<%: ocw.OcwNo%>
                                                            , <%: ocw.OcwType %>
                                                            , <%: ocw.OcwSourceType %>
                                                            , '<%: ocw.OcwType == 1 || (ocw.OcwType == 0 && ocw.OcwSourceType == 0) ? (ocw.OcwData ?? "") : "" %>'
                                                            , <%: ocw.OcwFileNo %>
                                                            , <%: ocw.OcwWidth %>
                                                            , <%: ocw.OcwHeight %>
                                                            , 'formPop');" 
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
                            <div class="mt-2">
                                <i class="bi bi-tags text-dark mr-2"></i>
                                <%: Html.Raw(string.Join("", (ocw.KWord ?? "").Split(',').Select(s => "<a href='javascript: void();' onclick='fnSetTag(this);' class='mr-1 badge badge-1-light'>" + s + "</a>"))) %>

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

    <!-- 페이징 -->
    <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>
    
</form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        function fnGoTab(catNo) {
            $("#UserCat").val(catNo);
            fnSubmit();
            fnPrevent();
        }




    </script>
</asp:Content>