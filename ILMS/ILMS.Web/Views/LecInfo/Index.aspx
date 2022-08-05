<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
    <div class="mt-4 alert bg-light rounded">
        <ul class="list-style03">
            <li class="text-warning">온라인강의 경우, 동영상 강의 버튼을 클릭하시면, 강의를 수강하실 수 있습니다.</li>
            <li class="text-primary">
                출석기간 내에 강의를 들으신 후 반드시 학습현황 메뉴에서 출석 여부를 확인하시기 바랍니다. 
                <button type="button" class="btn btn-outline-primary ml-1" data-toggle="modal" data-target="#divAttendanceNoticeModal">출결기준 안내</button>
            </li>
        </ul>
    </div>
    
    <%
        if (ViewBag.Course.IsProf == 1)
        {
    %>
        <% Html.RenderPartial("/Views/Shared/Lecture/LectureIndexProf.ascx");

    %>

    <%
        }
        else
        {
    %>
         <% Html.RenderPartial("/Views/Shared/Lecture/LectureIndexStud.ascx"); %>
    <%
        }


%>
    
    <!-- 출결기준 안내 모달-->
    <div class="modal fade show" id="divAttendanceNoticeModal" tabindex="-1" aria-labelledby="attendanceNoticeModal" aria-modal="true" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title h4" id="attendanceNoticeModal">안내</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="alert bg-light alert-light rounded mt-2">
						<p class="font-size-14 text-info font-weight-bold">
							<i class="bi bi-info-circle-fill"></i> 출결 기준 안내
						</p>
						<ul class="mb-3">
							<li class="font-size-14">
								출석기간에 학습완료를 했을 경우에만 출석이 인정됩니다.
							</li>
						</ul>
						<ul class="mb-3">
							<li class="font-size-14 text-danger">
								출석 : 출석기간에 학습완료
							</li>
							<li class="font-size-14 text-danger">
								결석 : 미수강, 미완료, 지각기간 이후에 학습완료
							</li>
							<%	if( Model.LatenessSetupDay > 0)
								{
							%>
									<li class="font-size-14 text-danger">
										지각 : 주차별 학습종료일 <%: Model.LatenessSetupDay %>일 이후 지각처리
									</li>
							<%
								}
							%>
						</ul>
						<ul>
							<%	if (ConfigurationManager.AppSettings["PeriodChkYN"].Equals("N"))
								{
							%>
									<li class="font-size-12">
										※ 출석기간 이후에도 강의보기를 할 수 있으나 출결상태값은 변경되지 않습니다.
									</li>
							<%
								}
							%>
						</ul>
					</div>
					<div class="col-12 text-right">
						<button type="button" class="btn btn-secondary" data-dismiss="modal" title="닫기">닫기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 출결기준 안내 모달-->

     <%-- ocwView관련 --%>
    <form id="frmpop">
        <input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo" />
        <input type="hidden" name="Inning.InningNo" id="OcwViewInningNo" />
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">

    <script type="text/javascript">

	</script>
</asp:Content>
