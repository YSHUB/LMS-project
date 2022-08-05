<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    
    <%-- 의견등록 form --%>
    <form method="post" id="saveOpForm">
        <input type="hidden" name="OpinionNo" id="OpinionNo" />
        <input type="hidden" name="ParentOpinionNo" id="ParentOpinionNo" />
        <input type="hidden" name="TopOpinionNo" id="TopOpinionNo" />
        <input type="hidden" name="OPLevel" id="OPLevel" />
        <input type="hidden" name="UserNo" id="UserNo" />
        <input type="hidden" name="OpinionText" id="OpinionText" />
        <input type="hidden" name="DeleteYesNo" id="DeleteYesNo" />
        <input type="hidden" name="CourseNo" id="CourseNo" value="<%:Model.OcwCourse.CourseNo %>" />
        <input type="hidden" name="Week" id="Week" value="<%:Model.OcwCourse.Week %>" />
        <input type="hidden" name="OpinionTotalCount" value="<%: Model.OcwOpinion.OpinionTotalCount%>" />
        <input type="hidden" name="PageNum" id="PageNum" value="<%: Model.PageNum %>" /> <!-- 의견 페이지개수 -->
    </form>

    <form action="/Ocw/WeekDetail/<%:ViewBag.Course.CourseNo%>" id="mainForm" method="post">
                
        <div class="card mt-3">
            <div class="card-body py-2">
                <ul class="list-inline-style03">
                    <li class="list-inline-item">
                        <strong class="pr-2">주차</strong>
                        <span><%:Model.OcwCourse.Week %> 주차</span>
                    </li>
                    <li class="list-inline-item bar-vertical"></li>
                    <li class="list-inline-item">
                        <strong class="pr-2">강의내용</strong>
                        <span><%:Model.OcwCourse.Title %></span>
                    </li>
                    <li class="list-inline-item bar-vertical"></li>
                    <li class="list-inline-item">
                        <strong class="pr-2">수업기간</strong>
                        <span><%:Model.OcwCourse.WeekStartDay %> ~ <%:Model.OcwCourse.WeekEndDay %></span>
                    </li>

                </ul>
            </div>
        </div>

        <!-- 학습OCW 리스트 -->
        <h4 class="title05 mt-3 d-none">학습 OCW<strong class="text-primary"></strong></h4>
        <div class="card card-style01">
            <div class="card-header"></div>

            <div class="card-body">
                <%
                    if (Model.OcwCourseList.Count < 1)
                    {
                %>
                        <div class="alert bg-light alert-light rounded text-center m-0"><i class="bi bi-info-circle-fill"></i>콘텐츠가 없습니다. <%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>님께 등록을 요청해주세요.</div>
                <%
                    }
                    else
                    {
                        foreach (var ocwCourse in Model.OcwCourseList)
                        {
                %>
                        <div class="card-item01">
                            <div class="row no-gutters align-items-md-stretch">
                                <div class="col-md-4 col-lg-3 mb-2 mb-md-0">

                                    <!-- icon type -->
                                    <div class="thumb-wrap icon">
                                        <div class="thumb">
											<%
												if (!(ocwCourse.ThumFileGroupNo > 0))
												{
											%>
                                            <i class="<%: ocwCourse.FileExtension %>"></i>
											<%
												}
												else
												{
											%>
											<img src="/Files<%:ocwCourse.FileName %>" alt="">
											<%
												}
											%>
                                        </div>
                                    </div>
                                </div>


                                <div class="col-md-8 col-lg-9 pl-md-4">
                                    <div class="text-secondary d-flex flex-wrap align-items-center">
                                        <%--<strong class="font-size-14 bar-vertical"><span><%: string.Join(", ", Model.OcwThemeList.Where(w=>(ocwCourseList.ThemeNos ?? "").Contains("," + w.ThemeNo.ToString() + ",")).Select(s => s.ThemeName)) %></span></strong>--%>
                                        <strong class="font-size-14 bar"><span><%: ocwCourse.AssignNamePath %></span></strong>
                                        <strong class="font-size-14 bar-vertical"><%: ocwCourse.CreateDateTime %></strong>
                                        <strong class="font-size-14 bar-vertical">조회(<%: ocwCourse.UsingCount %>)</strong>
                                        <a href="#" onclick="fnOcwView(<%: ocwCourse.OcwNo%>
                                                                    , <%: ocwCourse.OcwType %>
                                                                    , <%: ocwCourse.OcwSourceType %>
                                                                    , '<%: ocwCourse.OcwType == 1 || (ocwCourse.OcwType == 0 && ocwCourse.OcwSourceType == 0) ? (ocwCourse.OcwData ?? "") : "" %>'
                                                                    , <%: ocwCourse.OcwFileNo %>
                                                                    , <%: ocwCourse.OcwWidth %>
                                                                    , <%: ocwCourse.OcwHeight %>
                                                                    , 'frmpop');"
                                            title="강의 바로보기" class="font-size-20 text-point <%:ocwCourse.OcwType == 2 ? "d-none" : ""%>">
                                            <i class="bi bi-eye-fill"></i>
                                        </a>
                                    </div>
                                    <div class="my-1 text-truncate">
                                        <a href="/Ocw/Detail/<%: ocwCourse.OcwNo %>" class="text-dark">
                                            <strong class="font-size-22"><%: ocwCourse.OcwName %></strong>
                                        </a>
                                    </div>
                                    <div class="text-secondary text-truncate">
                                        <%: ocwCourse.DescText %>
                                    </div>
                                    <div class="mt-2">
                                        <i class="bi bi-tags text-dark mr-2"></i>
                                        <%: Html.Raw(string.Join("", (ocwCourse.KWord ?? "").Split(',').Select(s => "<a href='javascript: void();' onclick='fnSetTag(this);' class='mr-1 badge badge-1-light'>" + s + "</a>"))) %>
                                    </div>
                                </div>
                            </div>
                        </div>

                <%
                        }
                    }
                %>
            </div>

        </div>


        <!-- 학습 OCW 주차별 학습의견 -->
        <h4 class="title05 mt-4">학습의견<strong class="text-primary"></strong></h4>
        <div>

            <%
                if (Model.OcwOpinionList.Count < 1)
                {
            %>
                    <div class="alert bg-light alert-light rounded text-center mt-4"><i class="bi bi-info-circle-fill"></i>등록된 의견이 없습니다.</div>
            <%
                }
                else
                {
                    //댓글
                    foreach (var opinion in Model.OcwOpinionList.Where(w => w.OPLevel == 1))
                    {
            %>
                        <div class="card  mt-4">
            <%
                        
                        //내가 작성한 댓글
                        if (opinion.OpinionUserNo == ViewBag.User.UserNo && opinion.DeleteYesNo != "Y")
                        {
                            
            %>
                            <div class="card-header bg-light">
                                <div class="row align-items-center">
                                    <div class="col-md">
                                        <p class="card-title02"><strong class="badge badge-success mr-2"></strong><%:opinion.CreateUserName %>(<%:opinion.CreateUserIDsecu %>)</p>
                                    </div>
                                    <div class="col-md-auto text-right">
                                        <dl class="row dl-style01">
                                            <dt class="col-auto text-dark">작성일자</dt>
                                            <dd class="col-auto mb-0"><%:opinion.CreateDateTime %></dd>
                                            <dt class="col-auto text-dark sr-only">관리</dt>
                                            <dd class="col-auto mb-0">
                                                <a href="#" class="btn btn-sm btn-outline-danger" onclick="fnDelConfirm(this, <%: opinion.OpinionNo %>);">삭제</a>
                                                <a href="#" class="btn btn-sm btn-outline-warning" onclick="fnModiConfirm(this, <%: opinion.OpinionNo %>);">수정</a>
                                            </dd>
                                        </dl>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body bg-light">
                                <textarea class="form-control w-100"><%:opinion.OpinionText %></textarea>
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
                                            <p class="card-title02">                                               

                                                <%:opinion.CreateUserName %>(<%:opinion.CreateUserIDsecu %>)

                                            </p>
                                        </div>
                                        <div class="col-auto text-right">
                                            <dl class="row dl-style01">
                                                <dt class="col-auto text-dark">작성일자</dt>
                                                <dd class="col-auto mb-0"><%:opinion.CreateDateTime %></dd>
                                                <dd class="col-auto mb-0 <%: opinion.DeleteYesNo == "Y" ? "sr-only" : "" %>">
                                                    <a href="#" class="btn btn-sm btn-outline-primary"
                                                        onclick="fnReplyOp(this
                                                                         , <%: opinion.OpinionNo %>
                                                                         , <%: opinion.OPLevel %>
                                                                         , <%: opinion.ParentOpinionNo%>
                                                                         , <%: opinion.TopOpinionNo%>);">답글</a>
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

                            <!--답글 부분-->
                            <div class="replyOff d-none">
                                <div class="card-header border-top bg-light">
                                    <div class="row align-items-center">
                                        <div class="col-md">
                                            <p class="card-title02">
                                                <i class="bi bi-arrow-return-right font-size-20 mr-1"></i>답글등록

                                            </p>
                                        </div>
                                        <div class="col-md-auto text-right">
                                            <dl class="row dl-style01">
                                                <dt class="col-auto text-dark sr-only">관리</dt>
                                                <dd class="col-auto mb-0">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="fnSaveReply(this , <%: opinion.OpinionNo%> );">등록</button>
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
                                            <p class="card-title02">
                                                <i class="bi bi-arrow-return-right font-size-20 mr-1"></i>
                                                <strong class="badge badge-success mr-2"></strong><%:opinion2.CreateUserName %>(<%:opinion2.CreateUserIDsecu %>)
                                            </p>
                                        </div>
                                        <div class="col-md-auto text-right">
                                            <dl class="row dl-style01">
                                                <dt class="col-auto text-dark">작성일자</dt>
                                                <dd class="col-auto mb-0"><%:opinion2.CreateDateTime %></dd>
                                                <dt class="col-auto text-dark sr-only">관리</dt>
                                                <dd class="col-auto mb-0">
                                                    <a href="#" class="btn btn-sm btn-outline-danger" onclick="fnDelConfirm(this, <%: opinion2.OpinionNo %>);">삭제</a>
                                                    <a href="#" class="btn btn-sm btn-outline-warning" onclick="fnModiConfirm(this, <%: opinion2.OpinionNo %>);">수정</a>
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
                                            <p class="card-title02">
                                                <i class="bi bi-arrow-return-right font-size-20 mr-1"></i>                                                
                                                <%:opinion2.CreateUserName %>(<%:opinion2.CreateUserIDsecu %>)
                                            </p>
                                        </div>
                                        <div class="col-auto text-right">
                                            <dl class="row dl-style01">
                                                <dt class="col-auto text-dark">작성일자</dt>
                                                <dd class="col-auto mb-0"><%:opinion2.CreateDateTime %></dd>
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

            <div class="card mt-4">
                <div class="card-header">
                    <div class="row align-items-center">
                        <div class="col-md">
                            <p class="card-title02">새 의견 등록</p>
                        </div>
                        <div class="col-md-auto text-right">
                            <dl class="row dl-style01">
                                <dt class="col-auto text-dark sr-only">관리</dt>
                                <dd class="col-auto mb-0">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="fnSaveOpConfirm(0);">등록</button>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <textarea id="txtOpinion" class="form-control w-100"></textarea>
                </div>
            </div>
			<div class="text-right mt-2">			    
                <button type="button" class="btn btn-secondary" onclick="javascript:document.location.href='/Ocw/WeekList/<%:Model.OcwCourse.CourseNo %>';">목록</button>
            </div>
        </div>

    </form>

    <%-- ocwView관련 --%>
    <form id="frmpop">
        <input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
        <input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
    </form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">

        //의견 등록
        function fnSaveOpConfirm(gbn) {
            if ('<%:Model.CurrentTermYn%>' != "Y") {
                bootAlert("지난 <%:ConfigurationManager.AppSettings["TermText"].ToString() %>는 등록 및 수정/삭제가 불가합니다.");
                return;
            }

            //0 : 의견(댓글) 등록, 1 : 삭제 또는 수정, 3 : 대댓글 등록
            if (gbn == 0) {
                if (fnGetBytes($("#txtOpinion").val()) < 1 || fnGetBytes($("#txtOpinion").val(), true) > 300) {
                    bootAlert("1 ~ 300자를 등록하세요.");
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

                }
            }
            else {                
                ajaxHelper.CallAjaxPost("/Ocw/SaveOcwCourseOpinion", $("#saveOpForm").serializeArray(), "fnCbSave", gbn);
            }

            fnPrevent();
        }

        function fnSaveOpinion(params, gbn) {
            gbn = gbn || 0;
            ajaxHelper.CallAjaxPost("/Ocw/SaveOcwCourseOpinion", params, "fnCbSave", gbn);
        }


        function fnCbSave(gbn) {
            console.log(gbn);
            var ajaxResult = ajaxHelper.CallAjaxResult();

            if (ajaxResult > 0) {
                bootAlert((gbn == 0 || gbn == 3 ? "등록" : gbn == 1 && isDeleted == false ? "수정" : "삭제") + "되었습니다.", function () {
                    isDeleted = false;
                    window.location.reload();
                });
            } else {
                bootAlert("오류로 인해" + (gbn == 0 || gbn == 3 ? "등록" : gbn == 1 && isDeleted == false ? "수정" : "삭제") + "되지 못했습니다.", function () {
                    window.location.reload();
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
            //ajaxHelper.CallAjaxPost("/Ocw/SaveOcwCourseOpinion", $("#saveOpForm").serializeArray(), "fnCbSave", 3);
        }

    </script>
</asp:Content>
