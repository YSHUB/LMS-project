<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/LecInfo/GradeList/<%:Model.Course.CourseNo %>" id="mainForm" method="post">
		<input type="hidden" id="hdnListType" name="ListType" value="<%:Model.ListType %>">
		<input type="hidden" id="hdnDetailType" name="DetailType" value="<%:Model.DetailType %>">
		<input type="hidden" id="hdnCourseNo" name="Course.CourseNo" value="<%:Model.Course.CourseNo %>">
		<input type="hidden" id="hdnPassPoint" name="Course.PassPoint" value="<%:Model.Course.PassPoint %>">
		<div class="card mb-3">
			<div class="card-body">
				<div class="profile row">
					<div class="col-md-3">
					</div>
					<div class="col-md-9">
						<%-- 정보입력 --%>
						<ul class="row mb-0 mt-2">
							<li class="col-12 col-xl-4"><strong>총 수강생 : </strong><%:Model.GradeList.Count %>명</li>
							<li class="col-lg-6 col-xl-4"><strong>이수기준 : </strong><%:Model.Course.PassPoint %>점 이상</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<%
            if (Model.DetailType != null)
            {
        %>
        <% Html.RenderPartial(string.Format("./{0}Grade", Model.DetailType)); %>
        <%
            }
            else if (Model.ListType != null)
            {
        %>
        <% Html.RenderPartial(string.Format("./{0}Evaluation", Model.ListType)); %>
        <%
            }
        %>
	</form>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {

			var _ajax = new AjaxHelper();

			if ('<%: !(Convert.ToDateTime(Model.Course.TermStartDay) <= DateTime.Now && Convert.ToDateTime(Model.Course.TermEndDay) >= DateTime.Now) ? "Y" : "N" %>' == "Y") {
				bootAlert("성적처리 기간이 아닙니다.");
                $("#btn_AbsoluteEvaluation").hide();
                self.close();
			}

            $("table.datatable tr.data").on("click", function () {
                $("table.datatable tr.data").removeClass("selected");
                $(this).addClass("selected");
            });

			$("#btn_AbsoluteEvaluation").click(function () {
				bootConfirm("최종 성적 처리를 하시겠습니까?", function() {
                    document.forms["mainForm"].action = "/LecInfo/AbsoluteEvaluation"
                    document.forms["mainForm"].submit();
				});
			});

            $("#btn_AbsoluteEvaluationDelete").click(function () {
                bootConfirm("수료 처리를 초기화 하시겠습니까?", function() {
                    document.forms["mainForm"].action = "/LecInfo/AbsoluteEvaluation_Delete"
                    document.forms["mainForm"].submit();
				});
			});
		});

		function showList(gbn) {
            $("#hdnListType").val(gbn);
            $("#hdnDetailType").val("");
            window.document.forms["mainForm"].submit();
		}

        function showDetail(gbn, detail) {
            $("#hdnListType").val(gbn);
            $("#hdnDetailType").val(detail);
            window.document.forms["mainForm"].submit();
		}

        function moveScoreChange(detail) {
            if (detail == "Attendance")
                document.location = "/LecInfo/Attendance/" + $("#hdnCourseNo").val();
            if (detail == "MidtermExam")
                document.location = "/Exam/ListTeacher/" + $("#hdnCourseNo").val();
            else if (detail == "FinalExam")
                document.location = "/Exam/ListTeacher/" + $("#hdnCourseNo").val();
            else if (detail == "Quiz")
                document.location = "/Quiz/ListTeacher/" + $("#hdnCourseNo").val();
            else if (detail == "HomeWork")
                document.location = "/Homework/ListTeacher/" + $("#hdnCourseNo").val();
            self.close();
        }

	</script>
</asp:Content>
