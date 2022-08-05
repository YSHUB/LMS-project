<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>

    <%
        var week1 = 0;
        var weekcount = Model.Inning.Count;
        foreach (var inning in Model.Inning)
        {
            MvcHtmlString hrefTagByInningLecture = Model.GetHrefTagByInningLecture(inning.LessonForm, inning.LectureType, inning.CourseNo, inning.ContentTitle
                                                                                , inning.OcwNo, inning.OcwType, inning.OcwSourceType, inning.OcwData, inning.OcwFileGroupNo
                                                                                , inning.OcwWidth, inning.OcwHeight, inning.InningNo, inning.ZoomURL, inning.InningEndDay);

            MvcHtmlString hrefTagByInningHomework = Model.GetHrefTagByInningHomework(inning.IsHomework, inning.CourseNo, inning.Week, inning.InningNo);
            MvcHtmlString hrefTagByInningQuiz = Model.GetHrefTagByInningQuiz(inning.IsQuiz, inning.CourseNo, inning.Week, inning.InningNo);
            week1 = inning.Week;
    %>               
            <div class="card">
			    <div class="card-header">
				    <div class="row">
					    <div class="col-12 col-md">
                            <span class="badge badge-danger"><%:inning.Week %>주</span>
                            <span class="badge badge-primary"><%:inning.InningSeqNo %>차시</span>
                                <%:Html.Raw((inning.Title ?? "").Replace("\r\n", "<br />").Replace("\n", "<br />"))%>
					    </div>
                        <div class="col-12 col-md-auto">
                            <i class="bi bi-calendar-range mr-1"></i> <span class="font-size-14"><%:inning.InningStartDay %> ~ <%:inning.InningEndDay %></span>
                        </div>
				    </div>
			    </div>
			    <div class="card-body">
				    <div class="row">
                        <div class="col-12 col-sm-4 mb-1">
                            <%:hrefTagByInningLecture %>
                        </div>
                        <div class="col-12 col-sm-8">
                            <div class="row">
                                <div class="col-12 col-sm-6 mb-1"><%:hrefTagByInningHomework %></div>
                                <div class="col-12 col-sm-6 mb-1"><%:hrefTagByInningQuiz %></div>
                            </div>
                        </div>
                                    
                    </div>
								
			    </div>
		    </div>                    
    
    <%
		}

		if (Model.Inning.Count.Equals(0))
		{
	%>
			<div class="alert bg-light alert-light rounded text-center mt-4"><i class="bi bi-info-circle-fill"></i> 등록된 강의가 없습니다.</div>
	<%
		}
    %>

