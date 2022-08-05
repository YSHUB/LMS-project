<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" MaintainScrollPositionOnPostback="true" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">
    <%: Html.Hidden("PageRowSize", (Model.PageRowSize ?? 0)) %> <!-- 추천리스트 페이지개수 -->

    <%-- 의견등록 form --%>
    <form action="/Ocw/SaveOcwOpinion" method="post" id="saveOpForm">
        <input type="hidden" name="OpinionNo" id="OpinionNo" />
        <input type="hidden" name="ParentOpinionNo" id="ParentOpinionNo" />
        <input type="hidden" name="TopOpinionNo" id="TopOpinionNo" />
        <input type="hidden" name="OcwNo" id="OcwNo" value="<%: Model.Ocw.OcwNo %>" />
        <input type="hidden" name="OPLevel" id="OPLevel" />
        <input type="hidden" name="UserNo" id="UserNo" />
        <input type="hidden" name="OpinionText" id="OpinionText" />
        <input type="hidden" name="DeleteYesNo" id="DeleteYesNo" />
        <input type="hidden" name="OpinionTotalCount" value="<%: Model.OcwOpinion.OpinionTotalCount%>" />
        <input type="hidden" name="PageNum" id="PageNum" value="<%: Model.PageNum %>" /> <!-- 의견 페이지개수 -->
        <input type="hidden" name="IsRefreshForm" id="IsRefreshForm" value="rel" />
    </form>

    <form id="moveAction" method="post">
        <input type="hidden" id="SearchText" name="SearchText" />
        <input type="hidden" id="AssignSel" name="AssignSel" />
        <input type="hidden" id="OcwThemeSel" name="OcwThemeSel" />
        <input type="hidden" id="OcwUserNo" name="UserNo" />
    </form>
    
    <!-- OcwView 관련-->
	<form id="frmpop">
		<input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
		<input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
	</form>

    <form action="/Ocw/Detail" id="mainForm" method="post">
        <div class="card card-style01">
            <div class="card-header">
                <div class="row no-gutters align-items-center">
                    <div class="col">
                        <a href="#" class="card-title01 text-dark"><%:Model.Ocw.OcwName %></a>

                    </div>
                    <div class="col-md-auto text-right">
                        <div class="icon-sns">
                            <a href="javascript:void(0);" role="button" id="twitter" onclick="fnSnsShare ($(this));" title="트위터 공유">
                                <i class="icon twitter"></i><span class="sr-only">트위터 공유</span>
                            </a>
                            <a href="javascript:void(0);" role="button" id="facebook" onclick="fnSnsShare ($(this));" title="페이스북 공유">
                                <i class="icon facebook"></i><span class="sr-only">페이스북 공유</span>
                            </a>
                            <a href="javascript:void(0);" role="button" id="kakaostory" onclick="fnSnsShare ($(this));" title="카카오스토리 공유">
                                <i class="icon kakaostory"></i><span class="sr-only">카카오스토리 공유</span>
                            </a>
                            <a href="javascript:void(0);" role="button" id="naverblog" onclick="fnSnsShare ($(this));" title="네이버블로그 공유">
                                <i class="icon naverblog"></i><span class="sr-only">네이버블로그 공유</span>
                            </a>
                            <a href="javascript:void(0);" role="button" id="link" onclick="fnSnsShare ($(this));" title="링크 공유">
                                <i class="icon share"></i><span class="sr-only">링크 공유</span>
                            </a>
                        </div>
                    </div>
                </div>

            </div>
            <div class="card-body" id="collapseExample2">
                <div class="row mt-2 align-items-end">
                    <div class="col-12">
                        <dl class="row dl-style02">
                            <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>등록자</dt>
                            <dd class="col-8 col-md">
								<span class="pr-2"><%:Model.Ocw.CreateUserName %></span>

                                <%
									if (ConfigurationManager.AppSettings["UnivCode"].ToString() != "KIRIA")
									{
				                %>
                                    <button type="button" class="btn btn-sm btn-primary d-block d-md-inline-block mb-1 mb-md-0" onclick="fnGoMember(<%:Model.Ocw.CreateUserNo %>);" title="등록 OCW"><i class="bi bi-person-lines-fill mr-2"></i>등록 OCW</button>
                                <%
							        }
                                %>

                                <%--<a class="btn btn-sm btn-point mb-1 mb-md-0" title="쪽지보내기" href="/Note/Write/<%:Model.Ocw.CreateUserNo %>" target="_blank" ><i class="bi bi-envelope-fill mr-2"></i>쪽지보내기</a>--%>
                                <a class="btn btn-sm btn-point mb-1 mb-md-0" title="쪽지보내기" onclick="fnGoNote(<%:Model.Ocw.CreateUserNo %>, '<%:Model.Ocw.CreateUserName %>');" ><i class="bi bi-envelope-fill mr-2 "></i>쪽지보내기</a>
                                <%--<a class="btn btn-sm btn-outline-success" title="쪽지보내기" data-toggle="modal" data-target="#divNoteSend" ><i class="bi bi-chat-dots"></i></a>--%>
                            </dd>
                        </dl>
                        <%
							if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
							{
				        %>
                            <dl class="row dl-style02">
                                <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>전공분류</dt>
                                <dd class="col-8 col-md"><a href='#' onclick="fnSearchAssign('<%:Model.Ocw.AssignNo %>');"><%: Model.Ocw.AssignNamePath %></a></dd>
                            </dl>
                        <%
							}
                        %>
						<dl class="row dl-style02">
							<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>테마분류</dt>
                            <dd class="col-8 col-md">
                                <%
                                    var isFirst = true;
                                    foreach (var themeGubun in Model.OcwThemeList.Where(w => (Model.Ocw.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")))
                                    {
                                %>

                                    <%: isFirst ? "" : ", " %>
                                        <a href="#" onclick="fnSearchTheme(<%:themeGubun.ThemeNo %>);"><%: themeGubun.ThemeName %></a>
                                
                                <%
                                        isFirst = false;
                                    }
                                %>
                            </dd>
						</dl>
						<div class="row">
							<div class="col-md-6">
								<dl class="row dl-style02">
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>작성일</dt>
									<dd class="col-8 col-md"><%: Model.Ocw.CreateDateTime %></dd>
								</dl>
							</div>
							<div class="col-md-6">
								<dl class="row dl-style02">
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>수정일</dt>
									<dd class="col-8 col-md"><%: Model.Ocw.UpdateDateTime %></dd>
								</dl>
							</div>
						</div>
                        <dl class="row dl-style02">
                            <dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>설명</dt>
                            <dd class="col-8 col-md"><%: Model.Ocw.DescText %>
                                <div class="mt-2 <%:string.IsNullOrWhiteSpace(Model.Ocw.KWord) ? "d-none" : "" %>">
                                    <i class="bi bi-tags text-dark mr-2"></i>
                                    <%: Html.Raw(string.Join(" ", (Model.Ocw.KWord ?? "").Split(',').Select(s=> "<a href='#' class='badge badge-1-light' onclick='javascript:fnSearchTag(this);'>" + (s == "" ? "-" : s) +"</a>"))) %>
                                </div>
                            </dd>
                        </dl>
						<div class="row">
							<div class="col-md-6">
								<dl class="row dl-style02">
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>조회수</dt>
                            <dd class="col-2 col-md"><%: Model.Ocw.UsingCount %></dd>
								</dl>
							</div>
							<div class="col-md-6">
								<dl class="row dl-style02">
									<dt class="col-4 col-md-auto w-7rem"><i class="bi bi-dot"></i>강좌 적용 수</dt>
                            <dd class="col-2 col-md"><%: Model.Ocw.CourseCount %></dd>
								</dl>
							</div>
						</div>
                    </div>
                    <div class="col-12">
                        <div class="text-right">
                             <a  href="javascript:void(0)"  onclick="fnOcwView(<%: Model.Ocw.OcwNo%>
                                                            , <%: Model.Ocw.OcwType %>
                                                            , <%: Model.Ocw.OcwSourceType %>
                                                            , '<%: Model.Ocw.OcwType == 1 || (Model.Ocw.OcwType == 0 && Model.Ocw.OcwSourceType == 0) ? (Model.Ocw.OcwData ?? "") : "" %>'
                                                            , <%: Model.Ocw.OcwFileNo %>
                                                            , <%: Model.Ocw.OcwWidth %>
                                                            , <%: Model.Ocw.OcwHeight %>
                                                            , 'frmpop');" 
                                    title="강의 바로보기" class="btn btn-lg btn-primary" <%:Model.Ocw.OcwType == 2 ? "d-none" : ""%>">콘텐츠 보기                                  
                             </a>
							<a class="btn btn-lg btn-secondary <%:ViewBag.User.UserType == "USRT007" ? "" : "d-none"%>" data-toggle="modal" data-target="#divModalCourse">강의자료 적용하기</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <div class="text-right">
                    <!-- 추천 버튼 -->
                    <%
                        if (Model.OcwLike.IsLiked == 0) // 추천 x
                        {
                    %>
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="fnOcwLike(<%: Model.Ocw.OcwNo %>);"><span class="badge badge-primary"><%:Model.OcwLike.LikeCount %></span> 추천 <i class="bi bi-hand-thumbs-up"></i></button>
                    <%                                
                        }
                        else // 추천
                        {
                    %>
                        <button type="button" class="btn btn-sm btn-primary" onclick="javascript:fnOcwLike(<%: Model.Ocw.OcwNo %>);"><span class="badge badge-primary"><%:Model.OcwLike.LikeCount %></span> 추천 <i class="bi bi-hand-thumbs-up-fill"></i></button>
                    <%                                
                        }
                    %>


                    <!-- 관심 버튼 -->
                    <%
                        if (Model.OcwPocket.IsPocketed == 1 || Model.Ocw.IsSelfOcw == 1) // 이미 관심등록 했거나 자신의 OCW인 경우
                        {
                    %>
                        <a class="btn btn-sm btn-success" onclick="javascript:bootAlert('이미 관심 OCW로 등록했거나 자신의 OCW일 경우 등록할 수 없습니다.'); return false;"><span class="badge badge-success"><%:Model.OcwPocket.PocketCount %></span> 관심 <i class="bi bi-suit-heart-fill"></i></a>
                                
                    <%
                        }
                        else
                        {
                    %>
                        <a class="btn btn-sm btn-outline-success" href="#" data-toggle="modal" data-target="#divModalPocket"><span class="badge badge-success"><%:Model.OcwPocket.PocketCount %></span> 관심 <i class="bi bi-suit-heart"></i></a>                           
                    <%
                        }
                    %>
                </div>
            </div>
        </div>


        <div class="tab-content" id="myTabContent">

            <!-- 탭리스트 -->
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="rel-tab" data-toggle="tab" href="#rel" role="tab" aria-controls="rel" aria-selected="false" <%--onclick="tapForm('connect')--%>">연계 컨텐츠 
                        <span class="badge badge-primary"><%: Model.PageTotalCount %></span></a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="opinion-tab" data-toggle="tab" href="#opinion" role="tab" aria-controls="opinion" aria-selected="true" <%--onclick="tapForm('opinion')"--%>>의견 
                        <span class="badge badge-primary"><%: Model.OcwOpinion.OpinionTotalCount %></span></a>
                </li>
                <li class="nav-item <%: Model.OcwCourseList.Count() > 0 ? "" : "d-none" %>" role="presentation">
                    <a class="nav-link" id="lecture-tab" data-toggle="tab" href="#lecture" role="tab" aria-controls="lecture" aria-selected="true" <%--onclick="tapForm('lecture')--%>">강의적용현황 
                        <span class="badge badge-primary"><%: Model.OcwCourseList.Count() %></span></a>
                </li>
            </ul>

            <!-- 연계 컨텐츠 -->
            <div class="tab-pane fade" id="rel" role="tabpanel" aria-labelledby="rel-tab">
                <h3 class="title04 mt-4">작성자 추천 리스트</h3>
                
                <%
                    if (Model.OcwList.Where(w => w.IsUserOcw == true).Count() == 0)
                    {
                %>
                    <div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i> 작성자 추천 항목이 없습니다.</div>			
                <%
                    }
                    else
                    {
				%>
					<div class="card card-style05">
						<div class="card-body">
				<%
                        foreach (var OcwRecomm in Model.OcwList.Where(w => w.IsUserOcw == true))
                        {
                %>
                            <div class="card-item01">
                                <div class="row no-gutters align-items-md-stretch">
                                    <div class="col-md-4 col-lg-3 mb-2 mb-md-0">

                                        <!-- icon type -->
                                        <div class="thumb-wrap icon">
                                            <div class="thumb">
                                                <i class="<%: OcwRecomm.FileExtension %>"></i>
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
                                            <strong class="font-size-14 bar-vertical"><%: string.Join(", ", Model.OcwThemeList.Where(w=>(OcwRecomm.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></strong>
                                            <strong class="font-size-14 bar-vertical"><%: OcwRecomm.UpdateDateTime %></strong>
                                            <strong class="font-size-14 bar-vertical">조회(<%: OcwRecomm.UsingCount.ToString("#,0") %>)</strong>
                                            <a href="#"  onclick="fnOcwView(<%: OcwRecomm.OcwNo%>
                                                                        , <%: OcwRecomm.OcwType %>
                                                                        , <%: OcwRecomm.OcwSourceType %>
                                                                        , '<%: OcwRecomm.OcwType == 1 || (OcwRecomm.OcwType == 0 && OcwRecomm.OcwSourceType == 0) ? (OcwRecomm.OcwData ?? "") : "" %>'
                                                                        , <%: OcwRecomm.OcwFileNo %>
                                                                        , <%: OcwRecomm.OcwWidth %>
                                                                        , <%: OcwRecomm.OcwHeight %>
                                                                        , 'frmpop');" 
                                                title="강의 바로보기" class="font-size-20 text-point <%:OcwRecomm.OcwType == 2 ? "d-none" : ""%>">
                                                <i class="bi bi-eye-fill"></i>
                                            </a>
                                        </div>
                                        <div class="my-1 text-truncate">
                                            <a href="/Ocw/Detail/<%: OcwRecomm.OcwNo %>" class="text-dark">
                                                <strong class="font-size-18"><%:OcwRecomm.OcwName %></strong>
                                            </a>
                                        </div>
                                        <div class="text-secondary text-truncate">
                                            <%:OcwRecomm.DescText %>
                                        </div>
                                        <div class="mt-2">
                                            <i class="bi bi-tags text-dark mr-2"></i>
                                            <span><%: Html.Raw(string.Join(" ", (OcwRecomm.KWord ?? "").Split(',').Select(s => "<a href='#' class='badge badge-1-light' onclick='javascript:fnSearchTag(this);'>" + s + "</a>"))) %></span>
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


                <!-- 기타 추천 -->
                <hr class="line-gap">
                <h3 class="title04 mt-4">기타 추천 리스트</h3>
                <%
                    if (Model.OcwList.Where(w => w.IsUserOcw == false).Count() == 0)
                    {
                %>
                    <div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i> 기타 추천 항목이 없습니다.</div>		
                <%
                    }
                    else
                    {
				%>
						<div class="card card-style05">
                            <div class="card-body">
				<%
                        foreach (var OcwRecomm in Model.OcwList.Where(w => w.IsUserOcw == false))
                        {
                %>
                                <div class="card-item01">
                                    <div class="row no-gutters align-items-md-stretch">
                                        <div class="col-md-4 col-lg-3 mb-2 mb-md-0">

                                            <!-- icon type -->
                                            <div class="thumb-wrap icon">
                                                <div class="thumb">
                                                    <i class="<%: OcwRecomm.FileExtension %>"></i>
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
                                                <strong class="font-size-14 bar-vertical"><%: string.Join(", ", Model.OcwThemeList.Where(w=>(OcwRecomm.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></strong>
                                                <strong class="font-size-14 bar-vertical"><%: OcwRecomm.UpdateDateTime %></strong>
                                                <strong class="font-size-14 bar-vertical">조회(<%: OcwRecomm.UsingCount.ToString("#,0") %>)</strong>
                                                
                                                <a href="#"  onclick="fnOcwView(<%: OcwRecomm.OcwNo%>
                                                                        , <%: OcwRecomm.OcwType %>
                                                                        , <%: OcwRecomm.OcwSourceType %>
                                                                        , '<%: OcwRecomm.OcwType == 1 || (OcwRecomm.OcwType == 0 && OcwRecomm.OcwSourceType == 0) ? (OcwRecomm.OcwData ?? "") : "" %>'
                                                                        , <%: OcwRecomm.OcwFileNo %>
                                                                        , <%: OcwRecomm.OcwWidth %>
                                                                        , <%: OcwRecomm.OcwHeight %>
                                                                        , 'frmpop');" 
                                                title="강의 바로보기" class="font-size-20 text-point <%:OcwRecomm.OcwType == 2 ? "d-none" : ""%>">
                                                <i class="bi bi-eye-fill"></i>
                                            </a>
                                                
                                            </div>
                                            <div class="my-1 text-truncate">
                                                <a href="/Ocw/Detail/<%: OcwRecomm.OcwNo %>" class="text-dark">
                                                    <strong class="font-size-18"><%:OcwRecomm.OcwName %></strong>
                                                </a>
                                            </div>
                                            <div class="text-secondary text-truncate">
                                                <%:OcwRecomm.DescText %>
                                            </div>
                                            <div class="mt-2">
                                                <i class="bi bi-tags text-dark mr-2"></i>
                                                <span><%: Html.Raw(string.Join(" ", (OcwRecomm.KWord ?? "").Split(',').Select(s => "<a href='#'class='badge badge-1-light' onclick='javascript:fnSearchTag(this);'>" + s + "</a>"))) %></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>                
                <%
                        }
                %>
							</div>
                        </div>
                        <!-- 페이징 -->
                        <%: Html.Pager((int)Model.PageNum, 5, (int)Model.PageRowSize, Model.PageTotalCount, Model.Dic)%>                        
                <%  
                    }
                %>


            </div>

            <!-- 의견 -->
            <div class="tab-pane fade" id="opinion" role="tabpanel" aria-labelledby="opinion-tab">

                <%
                    if (Model.OcwOpinionList.Count < 1)
                    {
                %>
                    <div class="alert bg-light alert-light rounded text-center mt-4"><i class="bi bi-info-circle-fill"></i> 아직 등록된 의견이 없습니다.</div>
                <%
                    }
                    else
                    {
                        //댓글
                        foreach (var opinion in Model.OcwOpinionList.Where(w => w.OPLevel == 1))
                        {
                %>
                            <div class="card mt-2">
                <%
                            //내가 작성한 댓글
                            if (opinion.OpinionUserNo == ViewBag.User.UserNo && opinion.DeleteYesNo != "Y")
                            {
                %>
							<div class="parent">
								<div class="card-header bg-light">
									<div class="row align-items-center">
										<div class="col-12 col-md">
											<dl class="row dl-style01">
												<dt class="col-auto sr-only">작성자</dt>
												<dd class="col-auto mb-0 text-primary font-weight-bold"><%:opinion.CreateUserName %>(<%:opinion.CreateUserIDsecu %>)</dd>
												<dt class="col-auto sr-only">작성일자</dt>
												<dd class="col-auto mb-0 text-dark"><%:opinion.CreateDateTime %></dd>
											</dl>
										</div>
										<div class="col-md-auto text-right">
											<dl class="row dl-style01">
												<dt class="col-auto text-dark sr-only">관리</dt>
												<dd class="col-auto mb-0">
													<div class="btn-group">
														<a href="#" class="btn btn-sm btn-danger" onclick="fnDelConfirm(this, <%: opinion.OpinionNo %>);">삭제</a>
														<a href="#" class="btn btn-sm btn-warning" onclick="fnModiConfirm(this, <%: opinion.OpinionNo %>);">수정</a>
													</div>
												</dd>
											</dl>
										</div>
									</div>
								</div>
								<div class="card-body bg-light">
									<textarea class="form-control w-100"><%:opinion.OpinionText %></textarea>
								</div>
							</div>
                <%
                            }
                            //다른 사람 댓글
                            else
                            {
                %>
                            <div class="parent">
                                <div class="card-header">
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md">
                                            <%
                                                if (opinion.OpinionUserNo == Model.Ocw.OcwUserNo)
                                                {
                                            %>
												<strong class="text-primary font-size-16">
													<span class="badge badge-primary mr-2">작성자 등록</span>
												</strong>
                                            <%
                                                }
                                            %>

											<dl class="row dl-style01">
												<dt class="col-auto sr-only">작성자</dt>
												<dd class="col-auto mb-0 text-primary font-weight-bold"><%:opinion.CreateUserName %>(<%:opinion.CreateUserIDsecu %>)</dd>
												<dt class="col-auto sr-only">작성일자</dt>
												<dd class="col-auto mb-0 text-dark"><%:opinion.CreateDateTime %></dd>
											</dl>
                                        </div>
                                        <div class="col-auto text-right">
                                            <dl class="row dl-style01">
                                                <dd class="col-auto mb-0 <%: opinion.DeleteYesNo == "Y" ? "sr-only" : "" %>">
                                                    <button type="button" class="btn btn-sm btn-point" onclick="fnReplyOp(this, <%: opinion.OpinionNo %>, <%: opinion.OPLevel %>, <%: opinion.ParentOpinionNo%>, <%: opinion.TopOpinionNo%>);">답글</button>
                                                </dd>
                                            </dl>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div><%: Html.Raw(Server.UrlDecode((opinion.DeleteYesNo == "Y" ? "-삭제된 글입니다-" : opinion.OpinionText).Replace(System.Environment.NewLine, "<br />"))) %></div>
                                    <!-- 삭제된 댓글의 경우 DB에서 안보이게 처리함  -->
                                </div>
                            </div>

                            <%-- 답글부분 --%>
                            <div class="replyOff d-none">
                                <div class="card-header bg-light">
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md">
                                            <strong class="text-primary font-size-14">
												<i class="bi bi-arrow-return-right font-size-16 mr-1"></i>답글 등록
                                            </strong>
                                        </div>
                                        <div class="col-md-auto text-right">
											<dl class="row dl-style01">
												<dt class="col-auto text-dark sr-only">관리</dt>
												<dd class="col-auto mb-0">
													<button type="button" class="btn btn-sm btn-primary" onclick="fnSaveReply(this, <%: opinion.OpinionNo%> );">등록</button>
												</dd>
											</dl>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body bg-light">
                                    <textarea id="txtOpinionRe" class="form-control w-100"></textarea>
                                </div>
                            </div>
                <%
                            }

                            //대댓글
                            foreach (var opinion2 in Model.OcwOpinionList.Where(w => w.TopOpinionNo == opinion.OpinionNo && w.OPLevel == 2))
                            {
                                //내가 작성한 대댓글
                                if (opinion2.OpinionUserNo == ViewBag.User.UserNo && opinion2.DeleteYesNo != "Y")
                                {
                %>
                                <div class="card-header border-top bg-light">
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md">
											<strong class="text-primary font-size-14">
												<i class="bi bi-arrow-return-right font-size-16 mr-1"></i>
											</strong>
											<dl class="row dl-style01">
												<dt class="col-auto sr-only">작성자</dt>
												<dd class="col-auto mb-0 text-primary font-weight-bold"><%:opinion2.CreateUserName %>(<%:opinion2.CreateUserIDsecu %>)</dd>
												<dt class="col-auto sr-only">작성일자</dt>
                                                <dd class="col-auto mb-0 text-dark"><%:opinion2.CreateDateTime %></dd>
											</dl>
                                        </div>
                                        <div class="col-md-auto text-right">
                                            <dl class="row dl-style01">
                                                <dt class="col-auto text-dark sr-only">관리</dt>
                                                <dd class="col-auto mb-0">
													<div class="btn-group">
														<a href="#" class="btn btn-sm btn-danger"  onclick="fnDelConfirm(this, <%: opinion2.OpinionNo %>);">삭제</a>
														<a href="#" class="btn btn-sm btn-warning" onclick="fnModiConfirm(this, <%: opinion2.OpinionNo %>);">수정</a>
													</div>
                                                </dd>
                                            </dl>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body bg-light">
                                    <textarea class="form-control w-100"><%:opinion2.OpinionText %></textarea>
                                </div>
                <%
                                }
                                //다른 사람 대댓글
                                else
                                {
                %>
                                <div class="card-header border-top">
                                    <div class="row align-items-center">
                                        <div class="col-12 col-md">
											<%
                                                if (opinion2.OpinionUserNo == Model.Ocw.OcwUserNo)
                                                {
                                            %>
												<strong class="text-primary font-size-14">
													<i class="bi bi-arrow-return-right font-size-16 mr-1"></i>
													<span class="badge badge-primary mr-2">작성자 등록</span>
												</strong>
                                            <%
                                                }
                                            %>
											
											<dl class="row dl-style01">
												<dt class="col-auto sr-only">작성자</dt>
												<dd class="col-auto mb-0 text-primary font-weight-bold"><%:opinion2.CreateUserName %>(<%:opinion2.CreateUserIDsecu %>)</dd>
												<dt class="col-auto sr-only">작성일자</dt>
												<dd class="col-auto mb-0 text-dark"><%:opinion2.CreateDateTime %></dd>
											</dl>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div><%: Html.Raw(Server.UrlDecode((opinion2.DeleteYesNo == "Y" ? "-삭제된 글입니다-" : opinion2.OpinionText).Replace(System.Environment.NewLine, "<br />"))) %></div>
                                    <!-- 삭제된 대댓글의 경우 DB에서 안보이게 처리함  -->
                                </div>
                <%
                                }
                            }
                %>
                            </div>
                <%
                        }
                    }
                %>

                <div class="card mt-2">
                    <div class="card-header">
                        <div class="row align-items-center">
                            <div class="col-12 col-md">
                                <p class="text-primary font-weight-bold">새 의견 등록</p>
                            </div>
                            <div class="col-md-auto text-right">
                                <dl class="row dl-style01">
                                    <dt class="col-auto text-dark sr-only">관리</dt>
                                    <dd class="col-auto mb-0">
                                        <button type="button" class="btn btn-sm btn-primary" onclick="fnSaveOpConfirm(0);">등록</button>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <textarea id="txtOpinion" class="form-control w-100"></textarea>
                    </div>
                </div>
            </div>

            <!-- 강의 적용현황 -->
            <div class="tab-pane fade" id="lecture" role="tabpanel" aria-labelledby="lecture-tab">
                <div class="card mt-4">
                    <div class="card-body py-0" data-spy="scroll" data-offset="0">
                        <div class="table-responsive">
                            <table class="table table-hover" cellspacing="0" summary="">
                                <thead>
                                    <tr>
                                        <th scope="col">학년도/<%:ConfigurationManager.AppSettings["TermText"].ToString() %></th>
                                        <th scope="col">강좌</th>
                                        <th scope="col">주차</th>
                                        <th scope="col">차시(순서)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    foreach(var ocwCourse in Model.OcwCourseList)
			                        {			                     
                                %>
                                    <tr>
                                        <td><%: ocwCourse.TermYear %> - <%: ocwCourse.TermQuarterName %></td>
                                        <td class="text-left"><%: ocwCourse.SubjectName %>(<%:ocwCourse.ClassNo %>)</td>
                                        <td class="text-center"><%: ocwCourse.Week %></td>
                                        <td class="text-center"><%: ocwCourse.SeqNo %></td>

                                    </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 쪽지 보내기 modal -->
            <div class="modal fade show" id="divNoteSend" tabindex="-1" aria-labelledby="divNoteContents" aria-modal="true" role="dialog">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title h4" id="divNoteContents">쪽지 발송</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="card d-md-block">
                                <div class="card-body">
                                    <div class="form-row">
                                        <div class="form-group col-12 col-md-12">
                                            <label for="Exam_Week" class="form-label">받는사람 <strong class="text-danger">*</strong></label>
                                            <div class="input-group">
                                                <input class="form-control" name="Exam.StartDay" id="" title="" readonly="" type="text" value="">

                                            </div>
                                        </div>
                                        <div class="form-group col-12">
                                            <label for="Exam_Week" class="form-label">제목 <strong class="text-danger">*</strong></label>
                                            <input class="form-control" name="Exam.StartDay" id="" title="">
                                        </div>
                                        <div class="form-group col-md-12">
                                            <label for="Exam_ExamContents" class="form-label">내용 <strong class="text-danger">*</strong></label>
                                            <textarea id="Exam_ExamContents" name="Exam.ExamContents" rows="5" class="form-control" title=""></textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="row align-items-center">
                                        <div class="col-6">
                                            <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                                        </div>
                                        <div class="col-6 text-right">
                                            <button type="button" class="btn btn-primary">발송</button>
                                            <button type="button" class="btn btn-outline-primary" data-dismiss="modal" title="닫기">닫기</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 관심 modal -->
            <div class="modal fade show" id="divModalPocket" tabindex="-1" aria-labelledby="divPocket" aria-modal="true" role="dialog">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title h4" id="divPocket">나의 OCW 저장</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="card d-md-block">
                                <div class="card-body">
                                    <div class="form-row">
                                        <div class="form-group col-12">
                                            <label for="CatCode" class="form-label">나의 폴더</label>
                                            <select id="CatCode" name="CatCode" class="form-control">                                                
                                                <%
                                                    string userCatcode = string.Empty;
                                                    foreach (var ocwUserCat in Model.OcwUserCatList)
                                                    {
                                                        userCatcode = ocwUserCat.CatCode.ToString();
                                                %>
                                                    <option value = "<%:userCatcode %>"><%: ocwUserCat.CatName%></option>
                                                <%
                                                    }
                                                %>
                                            </select>

                                        </div>

                                    </div>
                                </div>
                                <div class="card-footer">
                                    <div class="row align-items-center">
                                        <div class="col-6">
                                            <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 선택한 폴더에 OCW를 저장합니다.</p>
                                        </div>
                                        <div class="col-6 text-right">
                                            <button type="button" class="btn btn-primary" onclick="fnAddPocket(<%:Model.Ocw.OcwNo %>, $('#CatCode').val());">저장</button>
                                            <button type="button" class="btn btn-outline-primary" data-dismiss="modal" title="닫기">닫기</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 강의자료 적용 modal -->
            <div class="modal fade show" id="divModalCourse" tabindex="-1" aria-labelledby="divModalCourse" aria-modal="true" role="dialog">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title h4">강의 적용</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-light border-light d-none">
                                현재 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>에 배정받은 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 및 주차를 선택합니다. <br>( 강좌가 조회되지 않을 경우, 관리자에게 문의바랍니다. )
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <div class="form-row">
                                        <div class="form-group col-3">
                                            <label for="term" class="form-label"><%:ConfigurationManager.AppSettings["TermText"].ToString() %> <strong class="text-danger">*</strong></label>
                                            <select id="term" onchange="fnGetCourse();" class="form-control">
                                                <option value="termBlock"><%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요</option>
                                                <% 
                                                    foreach(var term in Model.TermList)
			                                        {
                                                %>
                                                     <option value ="<%: term.TermNo %>"><%: term.TermName%></option>
                                                <%                                                    
			                                        }    
                                                %>            
                                            </select>                                           
                                        </div>

                                        <div class="form-group col-4">
                                            <label for="course" class="form-label"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반 <strong class="text-danger">*</strong></label>
                                            <select id="course" onchange="fnGetWeek();" class="form-control">
                                                <option value="courseBlock"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>        
                                            </select>
                                        </div>

                                        <div class="form-group col-3">
                                            <label for="week" class="form-label">적용주차 <strong class="text-danger">*</strong></label>
                                            <select id="week" class="form-control">
                                                <option value="weekBlock">주차를 선택하세요</option>

                                            </select>
                                        </div>

                                        <div class="form-group col-2">
                                            <label for="impt"class="form-label">중요도 <strong class="text-danger">*</strong></label>
                                            <select id="impt" class="form-control">
                                            <%
                                                foreach(var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "IMPT"))
			                                    {
                                            %>
                                                 <option value ="<%: baseCode.CodeValue %>"><%: baseCode.CodeName%></option>
                                            <%
                                                }
                                            %>	

                                            </select>                                           
                                        </div>

                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-right">
                                <button type="button" class="btn btn-primary" onclick="fnAddCourse();">저장</button>
                                <button type="button" class="btn btn-secondary" data-dismiss="modal" title="닫기">닫기</button>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-right mt-2">			    
                
                <button type="button" class="btn btn-secondary" onclick="javascript:document.location.href='/Ocw/Index/0';">목록</button>
            </div>

        </div>



    </form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    <script type="text/javascript">

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        //페이지 로드시 새로고침
        $(document).on("pageload", function () {
            window.location.reload(true);
        });

        $(document).ready(function () {
            var tapIdx = "<%:Request.QueryString["tapIdx"]%>";
            if (tapIdx != "") {
                $('#' + tapIdx + "-tab").addClass("active");
                $("#" + tapIdx).addClass("show active");
            } else {
                $("#rel-tab").addClass("active");
                $("#rel").addClass("show active");
            }
        });


        //해당 페이지 새로고침
        function fnRefresh(tapIdx) {
            tapIdx = tapIdx || "";
            location.href = "/Ocw/Detail/<%:Model.Ocw.OcwNo %>?tapIdx=" + tapIdx;
        }

        // SNS공유
        function fnSnsShare(idx) {
            var id = idx.attr("id");
            if (id == "twitter") {
                window.open("https://twitter.com/home?status=" + location.origin + "/Ocw/Detail/<%: Model.Ocw.OcwNo%>", "", "width=500, height=500");
            }
            else if (id == "facebook") {
                window.open("https://www.facebook.com/sharer/sharer.php?u=" + location.origin + "/Ocw/Detail/<%: Model.Ocw.OcwNo %>&amp;src=sdkpreparse", "", "width=500, height=500");
            }
            else if (id == "kakaostory") {

                Kakao.init('<%=ConfigurationManager.AppSettings["kakaoApi"].ToString() %>');

				Kakao.Story.share({
					url: '<%=ConfigurationManager.AppSettings["BaseUrl"].ToString() %>/Ocw/Detail/<%: Model.Ocw.OcwNo %>'
					, text: '<%=ConfigurationManager.AppSettings["UnivName"].ToString() %> LMS'
				});

            }
            else if (id == "naverblog") {
                var url = encodeURI(encodeURIComponent("" + location.origin + "/Ocw/Detail/<%: Model.Ocw.OcwNo%>"));
                var title = encodeURI("<%=ConfigurationManager.AppSettings["UnivName"].ToString() %> LMS");
                window.open("http://share.naver.com/web/shareView.nhn?url=" + url + "&title=" + title, "", "width=500, height=500");
            }
            else if (id == "link") {
                var IE = (document.all) ? true : false;
                if (IE) {
                    window.clipboardData.setData("Text", "" + location.origin + "/Ocw/Detail/<%: Model.Ocw.OcwNo %>");
                }
                else {
                    temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", "" + location.origin + "/Ocw/Detail/<%: Model.Ocw.OcwNo %>");
                }
            }
        }


        // 추천하기
        function fnOcwLike(dNo) {
            ajaxHelper.CallAjaxPost("/Ocw/OcwLike", { ocwNo: dNo }, "fnCbLike");
        }

        function fnCbLike() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            switch (ajaxResult) {
                case 0:
                    bootAlert('오늘 하루 추천제한(10회) 수를 초과했습니다.');
                    break;
                default:
                    location.reload(true);
            }

        }

        //의견 등록
		function fnSaveOpConfirm(gbn) {

            //0 : 의견(댓글) 등록, 1 : 삭제 또는 수정, 3 : 대댓글 등록
            if (gbn == 0) {
                if (fnGetBytes($("#txtOpinion").val()) < 1 || fnGetBytes($("#txtOpinion").val(), true) > 300) {
                    bootAlert("1 ~ 300자를 등록하세요.");
					fnPrevent();
                }
				else {
					$("#OpinionNo").val(0);
					$("#ParentOpinionNo").val(0);
					$("#TopOpinionNo").val(0);
					$("#OPLevel").val(1);
					$("#OpinionText").val($("#txtOpinion").val());
					$("#DeleteYesNo").val("N");

					var params = $("#saveOpForm").serializeArray();

					bootConfirm("등록하시겠습니까?", fnSaveOpinion, params);

					//ajaxHelper.CallAjaxPost("/Ocw/SaveOcwOpinion", $("#saveForm").serializeArray(), "fnCbSave", gbn);

				}
            }
            else {
                ajaxHelper.CallAjaxPost("/Ocw/SaveOcwOpinion", $("#saveOpForm").serializeArray(), "fnCbSave", gbn);

            }

            fnPrevent();
        }

		function fnSaveOpinion(params, gbn) {
			gbn = gbn || 0;
			ajaxHelper.CallAjaxPost("/Ocw/SaveOcwOpinion", params, "fnCbSave", gbn);
		}

        function fnCbSave(gbn) {
            var ajaxResult = ajaxHelper.CallAjaxResult();

			if (ajaxResult > 0) {
				bootAlert((gbn == 0 || gbn == 3 ? "등록" : gbn == 1 && isDeleted == false ? "수정" : "삭제") + "되었습니다.", function () {
					isDeleted = false;

					$("#IsRefreshForm").val("opinion");
					fnRefresh($("#IsRefreshForm").val());
				});
			}
        }

        //의견 삭제
        var isDeleted = false;
		function fnDelConfirm(obj, opNo) {

			$("#DeleteYesNo").val("Y");
			$("#OpinionNo").val(opNo);

			bootConfirm("삭제하시겠습니까?", fnDelOpinion);

			fnPrevent();
        }

		function fnDelOpinion() {
			isDeleted = true;
			fnSaveOpConfirm(1);
        }


		//의견 수정
		function fnModiConfirm(obj, opNo) {
			if (fnGetBytes($(obj).parents().next().find("textarea").val()) < 1 || fnGetBytes($(obj).parents().next().find("textarea").val(), true) > 300) {
				bootAlert("1 ~ 300자를 등록하세요.");
			} else {
				$("#DeleteYesNo").val("N");
				$("#OpinionNo").val(opNo);
				$("#OpinionText").val($(obj).parents().next().find("textarea").val());

				bootConfirm("수정하시겠습니까?", fnModiOpinion);
			}

			fnPrevent();
		}

		function fnModiOpinion() {
			fnSaveOpConfirm(1);
		}

        //답글 layout
        function fnReplyOp(obj) {
            if ($(obj).parents('.parent').next().hasClass("replyOff")) {
                $(obj).parents('.parent').next().show();
                $(obj).parents('.parent').next().removeClass();
                $(obj).parents('.parent').next().addClass("replyOn");
            } else {
                $(obj).parents('.parent').next().hide();
                $(obj).parents('.parent').next().removeClass();
                $(obj).parents('.parent').next().addClass("replyOff");
            }

            fnPrevent();
        }

		//답글 등록
		function fnSaveReply(obj, parentOpinionNo) {
			if (fnGetBytes($(obj).parents().next().find("textarea").val()) < 1 || fnGetBytes($(obj).parents().next().find("textarea").val(), true) > 300) {
				bootAlert("1 ~ 300자를 등록하세요.");
			}
			else {
				$("#OpinionNo").val(0);
				$("#ParentOpinionNo").val(parentOpinionNo);
				$("#TopOpinionNo").val(parentOpinionNo);
				$("#OPLevel").val(2);
				$("#OpinionText").val($(obj).parents().next().find("textarea").val());
				$("#DeleteYesNo").val("N");

				bootConfirm("등록하시겠습니까", fnSaveReplyOp);

			}
		}

		function fnSaveReplyOp() {
			fnSaveOpConfirm(3);
		}

        //관심 OCW 저장
        function fnAddPocket(ocwNo, catCode) {
            ajaxHelper.CallAjaxPost("/Ocw/OcwPocket", { OcwNo: ocwNo, catCode: catCode }, "fnChPocekt");

            fnPrevent();
        }

        function fnChPocekt() {
            $("#divModalPocket").hide();

            if (confirm("관심콘테츠로 등록되었습니다. \n관심콘텐츠로 이동하시겠습니까?")) {
                location.href = "/Ocw/Like";
            }
            else {
                fnRefresh();
            }            
        }

        //교과목 바인딩
        function fnGetCourse() {
            var termNo = $("#term").val();
            if (termNo != "termBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetCourse", { TermNo: termNo }, "fnCbCourse");
            }
            else {
                $("#course").html();
                $("#week").html();

                var innerCourseBlock = "";
                var innerWeekBlock = "";

                innerCourseBlock = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>";

                $("#course").html(innerCourseBlock);
                $("#week").html(innerWeekBlock);

            }
        }

        function fnCbCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerCourseHtml = "";
            innerCourseHtml = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";

            $("#week").html();
            var innerWeekHtml = "";
            innerWeekHtml = "<option value=courseBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerCourseHtml += "<option value='" + ajaxResult[i].CourseNo + "'>" + ajaxResult[i].SubjectName + "";
            }

            $("#course").html(innerCourseHtml);
            $("#week").html(innerWeekHtml);

        }

        //주차 바인딩
        function fnGetWeek() {
            var courseNo = $("#course").val();
            if (courseNo != "courseBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetWeek", { CourseNo: courseNo }, "fnCbWeek");
            }
            else {
                $("#week").html();

                var innerWeekBlock = "";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>"
                $("#week").html(innerWeekBlock);
            }
        }

        function fnCbWeek() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerHtml = "";
            innerHtml = "<option value=weekBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerHtml += "<option value='" + ajaxResult[i].Week + "'>" + ajaxResult[i].Week + "";
            }

            $("#week").html(innerHtml);
        }

        //강좌 적용하기
        function fnAddCourse() {
            if ($("#term").val() == "termBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요.");
            }
            else if ($("#course").val() == "courseBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반을 선택하세요.");
            }
            else if ($("#week").val() == "weekBlock") {
                bootAlert("주차를 선택하세요.");
            }
            else {
                var objParam = {
                    CourseNo: parseInt($("#course").val()),
                    OcwNo: <%:Model.Ocw.OcwNo%>,
                    Impt: $("#impt").val() == "IMPT001" ? 1 : 0,
                    WeeK: parseInt($("#week").val())
                };

                ajaxHelper.CallAjaxPost("/Ocw/AddCourse", objParam, "fnCbAddCourse");
            }

        }

        function fnCbAddCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult < 0) {
                alert('이미 등록된 강의자료 입니다. 등록된 강의자료는 강의실에서 수정가능합니다.');
                fnPrevent();
            }
            else {
                if (confirm("강의실에 적용 완료되었습니다. 선택한 <%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>의 강의실로 이동하시겠습니까?")) {
                    fnShowInfoLayer("강의실로 이동중입니다. <br /> 잠시만 기다려 주세요.");

                    $("#divModalCourse").hide();

                    //강의실 이동 코드 추가 필요
                    location.reload(true);
                }
            }
        }

        //태그 검색
        function fnSearchTag(obj) {

            $("#SearchText").val($(obj).text());
            $("#moveAction").attr("action", "/Ocw/Index/0").submit();

            fnPrevent();
        }

        //전공 검색
        function fnSearchAssign(assignNo) {
            $("#AssignSel").val(assignNo);
            $("#moveAction").attr("action", "/Ocw/Index/0").submit();

            fnPrevent();
        }

        //테마 검색
        function fnSearchTheme(themeNo) {
            $("#OcwThemeSel").val(themeNo);
            $("#moveAction").attr("action", "/Ocw/Index/0").submit();

            fnPrevent();

        }

        //등록자 LMS 이동
        function fnGoMember(userNo) {
            $("#OcwUserNo").val(userNo);
            $("#moveAction").attr("action", "/Ocw/Member/0").submit();

            fnPrevent();

        }

        //등록자 쪽지쓰기 이동
        function fnGoNote(userNo, userNm) {
			var form = document.createElement("form");

			form.setAttribute("method", "post");
			form.setAttribute("target", "message");

            document.body.appendChild(form);

			var ocwUserNm = document.createElement("input");

			ocwUserNm.setAttribute("type", "text");
			ocwUserNm.setAttribute("name", "txtselectUser");
			ocwUserNm.setAttribute("value", userNm);

			var ocwUserNo = document.createElement("input");

			ocwUserNo.setAttribute("type", "hidden");
			ocwUserNo.setAttribute("name", "hdnUserNo");
            ocwUserNo.setAttribute("value", userNo);

            var gubun = document.createElement("input");

			gubun.setAttribute("type", "hidden");
			gubun.setAttribute("name", "hdnOcwGubun");
            gubun.setAttribute("value", "ocw");


			form.appendChild(ocwUserNm);
			form.appendChild(ocwUserNo);
            form.appendChild(gubun);

			form.setAttribute("action", "/Note/Write");

			form.submit();
		}

        <%-- 기타 추천 더보기 함수 주석(페이징으로 대신 함)
        function ViewMoreOcw() {

            var objParam = {
                FirstIndex: parseInt($("#PageRowSize").val()) + 1,
                LastIndex: parseInt($("#PageRowSize").val()) + 10,
                OcwNo: $("#OcwNo").val(),
                OcwUserNo: <%:Model.Ocw.OcwUserNo%>,
                KWord: '<%:Model.Ocw.KWord%>'

            };
            ajaxHelper.CallAjaxPost("/Ocw/MoreOcwOpinion", objParam, "cbMoreOcw");
        }

        function cbMoreOcw() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            console.log(ajaxResult);

        }
        --%>


	</script>

</asp:Content>
