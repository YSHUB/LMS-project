<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>


    <div class="card">
        <div class="card-body py-0">
            <h4 class="title04 mt-4">지금 진행중인 학습 </h4>
            <div class="row">
                <%
                    if (Model.Inning.Where(w => w.InningProgress.Equals("Y")).Count() > 0)
                    {

                        foreach (var inning in Model.Inning.Where(w => w.InningProgress.Equals("Y")))
                        {
                            string classGbn = Model.GetCategoryClass(inning.InningGbn);
                            string inningName = Model.GetInningTypeName(inning.InningGbn);
                            MvcHtmlString inningStatusTag = Model.GetInningStatusTag(inning.InningGbn, inning.InningUserState, inning.InningProgress);
                            MvcHtmlString hrefTag = Model.GetHrefTag(inning.InningGbn, inning.CourseNo, inning.Title,
                                                                     inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                     , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);
                %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card card-style02">
                                <div class="card-header <%: classGbn %>">
                                    <div class="row">
                                        <div class="col">
                                            <strong class="font-size-18"><%:inningName %></strong>
                                        </div>
                                        <div class="col-auto text-right">
                                           <%: inningStatusTag %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <ul class="list-inline list-inline-style01 mb-1">
                                        <li class="list-inline-item <%:inning.Week > 0 ? "" : "d-none" %>"><%:inning.Week %> 주차</li>
                                        <li class="list-inline-item <%:inning.InningSeqNo > 0 ? "" : "d-none" %>"><%:inning.InningSeqNo %>차시 학습</li>
                                    </ul>

                                    <%:hrefTag %>

                                </div>
                                <div class="card-footer">
                                    <div>
                                        <i class="bi bi-calendar-range mr-1"></i><span class="font-size-14">
                                            <%:inning.InningStartDay %>(<%:inning.InningStartDayWeek %>) ~ <%:inning.InningEndDay %>(<%:inning.InningEndDayWeek %>)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-12">
                    <div class="alert bg-light alert-light rounded text-center mb-0"><i class="bi bi-info-circle-fill"></i> <span class="text-primary">지금 진행중인 학습</span>이 없습니다.</div>
                </div>

                <%
                    }
                %>
            </div>

            <hr class="line-gap">
            <h4 class="title04 mt-4">오늘 마감 학습</h4>

            <div class="row">
                <%
                    if (Model.Inning.Where(w => w.InningDeadline.Equals("Y")).Count() > 0)
                    {

                        foreach (var inning in Model.Inning.Where(w => w.InningDeadline.Equals("Y")))
                        {
                            string classGbn = Model.GetCategoryClass(inning.InningGbn);
                            string inningName = Model.GetInningTypeName(inning.InningGbn);
                            MvcHtmlString inningStatusTag = Model.GetInningStatusTag(inning.InningGbn, inning.InningUserState, inning.InningProgress);
                            MvcHtmlString hrefTag = Model.GetHrefTag(inning.InningGbn, inning.CourseNo, inning.Title,
                                                                     inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                     , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);
                %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card card-style02">
                                <div class="card-header <%: classGbn %>">
                                    <div class="row">
                                        <div class="col">
                                            <strong class="font-size-18"><%:inningName %></strong>
                                        </div>
                                        <div class="col-auto text-right">
                                            <%: inningStatusTag %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <ul class="list-inline list-inline-style01 mb-1">
                                        <li class="list-inline-item <%:inning.Week > 0 ? "" : "d-none" %>"><%:inning.Week %> 주차</li>
                                        <li class="list-inline-item <%:inning.InningSeqNo > 0 ? "" : "d-none" %>"><%:inning.InningSeqNo %>차시 학습</li>
                                    </ul>

                                    <%: hrefTag %>

                                </div>
                                <div class="card-footer">
                                    <div>
                                        <i class="bi bi-calendar-range mr-1"></i><span class="font-size-14">
                                            <%:inning.InningStartDay %>(<%:inning.InningStartDayWeek %>) ~ <%:inning.InningEndDay %>(<%:inning.InningEndDayWeek %>)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-12">
                    <div class="alert bg-light alert-light rounded text-center mb-0"><i class="bi bi-info-circle-fill"></i> <span class="text-primary">오늘 마감 학습</span>이 없습니다.</div>
                </div>

                <%
                    }
                %>
            </div>

            <hr class="line-gap">
            <h4 class="title04 mt-4">내일 마감 학습</h4>

            <div class="row">

                <%
                    if (Model.Inning.Where(w => w.InningTomorrowDeadline.Equals("Y")).Count() > 0)
                    {

                        foreach (var inning in Model.Inning.Where(w => w.InningTomorrowDeadline.Equals("Y")))
                        {
                            string classGbn = Model.GetCategoryClass(inning.InningGbn);
                            string inningName = Model.GetInningTypeName(inning.InningGbn);
                            MvcHtmlString inningStatusTag = Model.GetInningStatusTag(inning.InningGbn, inning.InningUserState, inning.InningProgress);
                            MvcHtmlString hrefTag = Model.GetHrefTag(inning.InningGbn, inning.CourseNo, inning.Title,
                                                                     inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                     , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);
                %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card card-style02">
                                <div class="card-header <%: classGbn %>">
                                    <div class="row">
                                        <div class="col">
                                            <strong class="font-size-18"><%:inningName %></strong>
                                        </div>
                                        <div class="col-auto text-right">
                                            <%: inningStatusTag %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <ul class="list-inline list-inline-style01 mb-1">
                                        <li class="list-inline-item <%:inning.Week > 0 ? "" : "d-none" %>"><%:inning.Week %> 주차</li>
                                        <li class="list-inline-item <%:inning.InningSeqNo > 0 ? "" : "d-none" %>"><%:inning.InningSeqNo %>차시 학습</li>
                                    </ul>

                                    <%:hrefTag %>

                                </div>
                                <div class="card-footer">
                                    <div>
                                        <i class="bi bi-calendar-range mr-1"></i><span class="font-size-14">
                                            <%:inning.InningStartDay %>(<%:inning.InningStartDayWeek %>) ~ <%:inning.InningEndDay %>(<%:inning.InningEndDayWeek %>)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-12">
                    <div class="alert bg-light alert-light rounded text-center mb-0"><i class="bi bi-info-circle-fill"></i> <span class="text-primary">내일 마감 학습</span>이 없습니다.</div>
                </div>

                <%
                    }
                %>


            </div>

            <hr class="line-gap">
            <h4 class="title04 mt-4">진행 예정 학습</h4>

            <div class="row">

                <%
                    if (Model.Inning.Where(w => w.InningBeforeStart.Equals("Y")).Count() > 0)
                    {

                        foreach (var inning in Model.Inning.Where(w => w.InningBeforeStart.Equals("Y")))
                        {
                            string classGbn = Model.GetCategoryClass(inning.InningGbn);
                            string inningName = Model.GetInningTypeName(inning.InningGbn);
                            MvcHtmlString inningStatusTag = Model.GetInningStatusTag(inning.InningGbn, inning.InningUserState, inning.InningProgress);
                            MvcHtmlString hrefTag = Model.GetHrefTag(inning.InningGbn, inning.CourseNo, inning.Title,
                                                                     inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                     , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);
                %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card card-style02">
                                <div class="card-header <%: classGbn %>">
                                    <div class="row">
                                        <div class="col">
                                            <strong class="font-size-18"><%:inningName %></strong>
                                        </div>
                                        <div class="col-auto text-right">
                                            <%: inningStatusTag %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <ul class="list-inline list-inline-style01 mb-1">
                                        <li class="list-inline-item <%:inning.Week > 0 ? "" : "d-none" %>"><%:inning.Week %> 주차</li>
                                        <li class="list-inline-item <%:inning.InningSeqNo > 0 ? "" : "d-none" %>"><%:inning.InningSeqNo %>차시 학습</li>
                                    </ul>

                                    <%:hrefTag %>

                                </div>
                                <div class="card-footer">
                                    <div>
                                        <i class="bi bi-calendar-range mr-1"></i><span class="font-size-14">
                                            <%:inning.InningStartDay %>(<%:inning.InningStartDayWeek %>) ~ <%:inning.InningEndDay %>(<%:inning.InningEndDayWeek %>)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-12">
                    <div class="alert bg-light alert-light rounded text-center mb-0"><i class="bi bi-info-circle-fill"></i> <span class="text-primary">진행 예정 학습</span>이 없습니다.</div>
                </div>

                <%
                    }
                %>


            </div>

            <hr class="line-gap">
            <h4 class="title04 mt-4">지난 학습</h4>

            <div class="row">

                <%
                    if (Model.Inning.Where(w => w.InningBeforeDeadline.Equals("Y")).Count() > 0)
                    {

                        foreach (var inning in Model.Inning.Where(w => w.InningBeforeDeadline.Equals("Y")))
                        {
                            string classGbn = Model.GetCategoryClass(inning.InningGbn);
                            string inningName = Model.GetInningTypeName(inning.InningGbn);
                            MvcHtmlString inningStatusTag = Model.GetInningStatusTag(inning.InningGbn, inning.InningUserState, inning.InningProgress);
                            MvcHtmlString hrefTag = Model.GetHrefTag(inning.InningGbn, inning.CourseNo, inning.Title,
                                                                     inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                     , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);
                %>
                        <div class="col-md-6 col-xl-4">
                            <div class="card card-style02">
                                <div class="card-header <%: classGbn %>">
                                    <div class="row">
                                        <div class="col">
                                            <strong class="font-size-18"><%:inningName %></strong>
                                        </div>
                                        <div class="col-auto text-right">
                                            <%:inningStatusTag %>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <ul class="list-inline list-inline-style01 mb-1">
                                        <li class="list-inline-item <%:inning.Week > 0 ? "" : "d-none" %>"><%:inning.Week %> 주차</li>
                                        <li class="list-inline-item <%:inning.InningSeqNo > 0 ? "" : "d-none" %>"><%:inning.InningSeqNo %>차시 학습</li>
                                    </ul>
                                    <%: hrefTag %>
                                </div>
                                <div class="card-footer">
                                    <div>
                                        <i class="bi bi-calendar-range mr-1"></i><span class="font-size-14">
                                            <%:inning.InningStartDay %>(<%:inning.InningStartDayWeek %>) ~ <%:inning.InningEndDay %>(<%:inning.InningEndDayWeek %>)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-12">
                    <div class="alert bg-light alert-light rounded text-center mb-0"><i class="bi bi-info-circle-fill"></i> <span class="text-primary">지난 학습</span>이 없습니다.</div>
                </div>

                <%
                    }
                %>

            </div>

            <hr class="line-gap">
        </div>
    </div>
