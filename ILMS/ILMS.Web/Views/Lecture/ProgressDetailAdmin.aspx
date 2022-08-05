<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 정보</h3>
	<form id="mainForm" method="post">
		<div class="content">
			<div class="card card-style02">
				<div class="card-header">
					<span class="card-title01 text-dark"><%:Model.Course.SubjectName%></span>	
				</div>
				<div class="card-body">
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>과정명</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.ProgramName%></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["TermText"].ToString() %></dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.TermYear%> - <%:Model.Course.TermName%></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>분반</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.ClassNo%></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>학년</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.TargetGradeName%></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>이수구분</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.FinishGubunName%></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>학점</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.Credit%></dd>
					</dl>
					<dl class="row dl-style02">
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>수강인원</dt>
						<dd class="col-9 col-md-3 pl-4"><%:Model.Course.StudentCount%></dd>
						<dt class="col-3 col-md-1 text-dark text-nowrap"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
						<dd class="col-9 col-md-7 pl-4"><%:Model.Course.ProfessorName%></dd>
					</dl>						
				</div>							
			</div>
			<!--탭 리스트-->
			<div class="tab-content" id="myTabContent">
				<ul class="nav nav-tabs mt-4" role="tablist">
					<li class="nav-item" role="presentation">
						<a href="/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Progress" class="nav-link <%:Model.hdnPageMode.Equals("Progress") ? "active" : "" %>" id="receiveTab" role="tab">학습진도현황</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Part" class="nav-link <%:Model.hdnPageMode.Equals("Part") ? "active" : "" %>" id="sendTab" role="tab">참여도현황</a>
					</li>
					<li class="nav-item" role="presentation">
						<a href="/Lecture/ProgressDetailAdmin?CourseNo=<%:Model.CourseNo%>&TermNo=<%:Model.TermNo%>&ProgramNo=<%:Model.ProgramNo%>&SearchText=<%:Model.SearchText%>&PageRowSize=<%:Model.PageRowSize%>&PageNum=<%:Model.PageNum%>&PageMode=Ocw" class="nav-link <%:Model.hdnPageMode.Equals("Ocw") ? "active" : "" %>" id="writeTab" role="tab">컨텐츠활동</a>
					</li>
				</ul>
			</div>
			<input type="hidden" name="hdnPageMode" value="<%:Model.hdnPageMode %>"/>

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
				<!-- 컨텐츠 활동 ascx 호출 -->
			<%
			}
			%>
		</div>
	</form>
</asp:Content>

