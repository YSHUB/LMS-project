<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ILMS.Design.ViewModels.CourseViewModel>" %>

<div class="card mt-2" >
    <div class="card-header">
        <div class="form-inline">
            <div class="col-3 text-left">
                <button type="button" class="btn btn-outline-primary" onclick="showList('<%: Model.ListType %>');">◀ 뒤로</button>
            </div>
			<div class="col-6 text-center">
				※ 점수는 해당 페이지에서 수정이 가능합니다. 점수 수정 버튼을 누르면 성적처리를 종료하고 해당 페이지로 이동합니다.
			</div>
            <div class="col-3 text-right">
                <button type="button" class="btn btn-warning" onclick="moveScoreChange('<%: Model.DetailType %>');">점수 수정</button>
            </div>
        </div>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover">
                <tbody>
                    <tr>
                        <th rowspan="2" class="text-center">No
                        </th>
                        <%
						if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
						{	
						%>
                        <th rowspan="2" class="text-center">소속<br />
                        </th>
						<%
						}	
						%>
                        <th rowspan="2" class="text-center">학번<br />
                        </th>
                        <th rowspan="2" class="text-center">이름<br />
                        </th>
                        <th class="text-center" colspan="3">과제
                        </th>
                    </tr>
                    <tr>
                        <th class="text-center col-2">만점기준
                        </th>
                        <th class="text-center col-2">원점수
                        </th>
                        <th class="text-center col-2">환산점수
                        </th>
                    </tr>
                    <%
                        foreach (var item in Model.GradeList)
                        {
                    %>
                    <tr>
                        <td class="text-center">
                            <%:Model.GradeList.IndexOf(item) + 1 %>
                        </td>
                        <%
						if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
						{	
						%>
                        <td class="text-left">
                            <%: item.AssignName %>
                        </td>
						<%
						}
						%>
                        <td class="text-center">
                            <%: item.UserID %>
                        </td>
                        <td class="text-center">
                            <%: item.HangulName %>
                        </td>
                        <td class="text-center">
                            <%: item.HomeWorkPerfectScore.ToString("F2")%>
                        </td>
                        <td class="text-center">
                            <%: item.HomeWorkScore.ToString("F2")%>
                        </td>
                        <td class="text-center">
                            <%: item.HomeWork.ToString("F2")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('#CurrentMenuTitle').text("과제 점수 상세보기");
    });
</script>