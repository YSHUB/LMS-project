<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.AccountViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<div class="b-table-box flex-col-3">
		<div class="b-row-box">

			<div class="b-row-item">
				<div class="b-title-box">
					<label for="id">아이디</label>
				</div>
				<div class="b-con-box"><%:Model.User.UserID %> </div>
			</div>

			<div class="b-row-item ">
				<div class="b-title-box">
					<label for="name">이름</label>
				</div>
				<div class="b-con-box"><%:Model.User.HangulName %> </div>
			</div>

			<div class="b-row-item">
				<div class="b-title-box">
					<label for="residentNo">생년월일</label>
				</div>
				<div class="b-con-box"><%:Model.User.ResidentNo %> </div>
			</div>

			<div class="b-row-item <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "merge-prev"%>">
				<div class="b-title-box">
					<label for="Email">이메일</label>
				</div>
				<div class="b-con-box"><%:Model.User.Email %> </div>
			</div>


			<div class="b-row-item <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "merge-2"%> ">
				<div class="b-title-box">
					<label for=""> <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "소속" : "구분"%></label>
				</div>
				<div class="b-con-box">
					<%
						if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
						{
					%>
						<%:Model.User.AssignName %>
					<%
						}
						else
						{
					%>
						<%:Model.User.GeneralUserCode %>
					<%
						}
					%>
					
				</div>
			</div>

			<div class="b-row-item <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none"%> ">
				<div class="b-title-box">학년 </div>
				<div class="b-con-box">
					<%:Model.User.GradeName %>
				</div>
			</div>

			<div class="b-row-item <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "" : "d-none"%> ">
				<div class="b-title-box">
					<label for="bb">학적</label>
				</div>
				<div class="b-con-box"><%:Model.User.HakjeokGubunName%></div>
			</div>

			<div class="b-row-item <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y") ? "merge-2" : "merge-3"%> ">
				<div class="b-title-box">
					<label for="address">주소</label>
				</div>
				<div class="b-con-box"><%:Model.User.HouseAddress1 + " " + Model.User.HouseAddress2%></div>
			</div>

		</div>
	</div>
	<div class="text-right <%:Model.User.IsGeneral == true ? "" : "d-none"%>">
		<a href="/MyPage/WriteInfo" class="btn btn-warning">수정</a>
	</div>

</asp:Content>
