<%@ Page Language="C#" MasterPageFile="~/Views/Shared/LectureRoom.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server"></asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<form id="mainForm" method="post">
		<div class="content">

			<!--탭 리스트-->
			<div class="tab-content" id="myTabContent">
				<ul class="nav nav-tabs mt-4" role="tablist">
					<li class="nav-item" role="presentation">
						<a href="/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Progress" class="nav-link <%:Model.hdnPageMode.Equals("Progress") ? "active" : "" %>" id="receiveTab" role="tab">학습진도현황</a>
					</li>														
					<li class="nav-item" role="presentation">					
						<a href="/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Part" class="nav-link <%:Model.hdnPageMode.Equals("Part") ? "active" : "" %>" id="sendTab" role="tab">참여도현황</a>
					</li>														
					<li class="nav-item" role="presentation">					
						<a href="/LecInfo/StudentStatusList/<%:Model.CourseNo%>/Ocw" class="nav-link <%:Model.hdnPageMode.Equals("Ocw") ? "active" : "" %>" id="writeTab" role="tab">콘텐츠 활동 현황</a>
					</li>
				</ul>
			</div>
			<input type="hidden" name="hdnPageMode" value="<%:Model.hdnPageMode %>"/>
			<input type="hidden" id="exceltype" name="exceltype" value="" />
			

			<%
			if(Model.hdnPageMode.Equals("Progress"))
			{
			%>
				<!-- 학습진도현황 ascx 호출 -->
				<% Html.RenderPartial("./Lecture/LectureStudentList_Progress"); %>
				<!-- 학습진도현황 ascx 호출 -->
			<%
			}
			else if(Model.hdnPageMode.Equals("Part"))
			{
			%>
				<!-- 참여도현황 ascx 호출 -->
				<% Html.RenderPartial("./Lecture/LectureStudentList_Part"); %>
				<!-- 참여도현황 ascx 호출 -->
			<%
			}
			else
			{
			%>
				<!-- 컨텐츠 활동 ascx 호출 -->
				<% Html.RenderPartial("./Lecture/LectureStudentList_Ocw"); %>
				<!-- 참여도현황 ascx 호출 -->
			
			<%
			}
			%>
		</div>
	</form>

</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		 
		$(".btn_excelAttendance").click(function () {
			$("#mainForm").attr("action", "/LecInfo/GradeListEstimationExcel/<%: Model.CourseNo %>/" + $('#ddlSearchOption').val()).submit();
			//document.location.href = "/LecInfo/GradeListEstimationExcel/<%: Model.CourseNo %>/" + $('#ddlSearchOption').val();
			//fnPrevent();
		});

		$(".btn_excelProgress").click(function () {
			if (<%: Model.hdnPageMode.Equals("Progress") ? "true" : "false"%>) {
				$("#exceltype").val('Y');
			} else {
				$("#exceltype").val('N');
			}

			//$("#exceltype").val(strtype);
			document.location.href = "/LecInfo/CourseLectureProgressInfoExcel/<%: Model.CourseNo %>/" + $('#exceltype').val();
			fnPrevent();
			
		});


	</script>
</asp:Content>