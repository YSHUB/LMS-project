<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.ExamViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<h3 class="title04"><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %> 정보</h3>
	<div class="content">
		<div class="card card-style02">
			<div class="card-header">
				<div>
					<span class="badge <%:Model.ExamDetail.ProgramNo.Equals(1) ? "badge-regular" : "badge-irregular" %>"><%:Model.ExamDetail.ProgramName %></span>
					<span class="badge badge-1"><%:Model.ExamDetail.FinishGubunName %></span>
				</div>
				<a href="#" class="card-title01 text-dark"><%:Model.ExamDetail.SubjectName %></a>
			</div>
			<div class="card-body">
				<dl class="row dl-style02">
					<dt class="col-3 col-md-3 w-5rem text-dark"><i class="bi bi-dot"></i><%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? ConfigurationManager.AppSettings["TermText"].ToString() + "(기간)" : "회차" %> </dt>
					<dd class="col-3 col-md-3"><%:Model.ExamDetail.TermYear + "-" + Model.ExamDetail.TermQuarterName %></dd>
					<dt class="col-3 col-md-3 w-5rem text-dark <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><i class="bi bi-dot"></i>분반</dt>
					<dd class="col-3 col-md-3 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><%: Model.ExamDetail.ClassNo.ToString() %></dd>
				</dl>
				<dl class="row dl-style02">
					<dt class="col-3 col-md-3 w-5rem text-dark <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><i class="bi bi-dot"></i>학년</dt>
					<dd class="col-3 col-md-3 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><%:Model.ExamDetail.TargetGradeName %></dd>
					<dt class="col-3 col-md-3 w-5rem text-dark <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><i class="bi bi-dot"></i>학점</dt>
					<dd class="col-3 col-md-3 <%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "" : "d-none" %>"><%:Model.ExamDetail.Credit %></dd>
				</dl>
				<dl class="row dl-style02">
					<dt class="col-3 col-md-3 w-5rem text-dark"><i class="bi bi-dot"></i>수강인원</dt>
					<dd class="col-3 col-md-3"><%:Model.ExamDetail.TotalStudentCount %></dd>
					<dt class="col-3 col-md-3 w-5rem text-dark"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
					<dd class="col-3 col-md-3"><%:Model.ExamDetail.ProfessorName %></dd>
				</dl>
			</div><!-- card-body -->
		</div><!-- card -->

		<%-- 시험관리 리스트 --%>
		<% Html.RenderPartial("/Views/Shared/Exam/CandidatesListAdmin.ascx"); %>
	</div>

</asp:Content>