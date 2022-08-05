<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="mt-4 alert bg-light rounded">
    <ul class="list-style03">
        <li class="text-primary">
            해당 주차의 1차시에 등록된 강의내용이 표시됩니다.​
        </li>
    </ul>
</div>

<div class="card">
    <div class="card-body py-0">
        <div class="table-responsive">
            <table class="table table-hover" cellspacing="0" summary="">
                <thead>
                    <tr>
                        <th scope="col">주차</th>
                        <th scope="col">강의내용</th>
                        <th scope="col">수업기간</th>
                        <th scope="col">콘텐츠</th>
                        <th scope="col">조회</th>
                        <th scope="col">의견</th>
                    </tr>
                </thead>
                <tbody>


                    <%
                        
                        foreach (var ocwWeek in Model.OcwCourseList)
                        {
                    %>
                    <tr>
                        <td><%: ocwWeek.Week %></td>
                        <td class="text-left">
                            <a href="/Ocw/WeekDetail/<%: ocwWeek.CourseNo%>?week=<%:ocwWeek.Week %>"><%: ocwWeek.Title%></a>
                        </td>
                        <td class="text-nowrap text-center"><%: ocwWeek.WeekStartDay %> ~ <%:ocwWeek.WeekEndDay %></td>
                        <td clss="text-center"><%:ocwWeek.CourseOcwCount.ToString("#,0") %></td>
                        <td class="text-center"><%:ocwWeek.ViewCount.ToString("#,0") %></td>
                        <td class="text-center"><%:ocwWeek.CourseOpCount.ToString("#,0") %></td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                        <td colspan="6" class="text-center <%: Model.OcwCourseList.Count > 0 ? "d-none" : "" %>">조회된 데이터가 없습니다.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
