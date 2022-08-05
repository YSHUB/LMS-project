<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="container">
	<div class="row">
		<div class="col-md-4">
			<h3><%:ConfigurationManager.AppSettings["UnivName"].ToString() %></h3>
			<ul class="list-01">
				<li>
					<a href="<%:ConfigurationManager.AppSettings["LocationUrl"].ToString() %>"><%:ConfigurationManager.AppSettings["UnivName"].ToString() %> 소개</a>
				</li>
				<li>
					<a href="<%:ConfigurationManager.AppSettings["PrivacyUrl"].ToString() %>" class="text-important font-weight-bold" target="_blank">개인정보 취급방침</a>
				</li>
			</ul>
		</div>
		<div class="col-md-4">
			<h3>교육과정</h3>
			<ul class="list-02">
				<%
					if(ViewBag.CategoryList != null)
					{
						foreach (var item in ViewBag.CategoryList)
						{
				%>
				<li>
					<a href="/Course/List/<%:item.MNo %>"><%:item.MName %></a>
				</li>
				<%
						}
					}
				%>
			</ul>
		</div>
		<div class="col-md-4">
			<h3><%:ConfigurationManager.AppSettings["EtcName"].ToString() %></h3>
			<ul class="list-03">
				<li>
					<strong><%:ConfigurationManager.AppSettings["EtcTelNo"].ToString() %></strong>
				</li>
				<li>
					<strong>운영시간</strong>
					<span><%:ConfigurationManager.AppSettings["EtcOperatingTime"].ToString() %></span>
				</li>
				<li>
					<strong>점심시간</strong>
					<span><%:ConfigurationManager.AppSettings["EtcBreakTime"].ToString() %></span>
				</li>
				<li>
					주말/공휴일 휴무
				</li>
			</ul>
		</div>
		<div class="col-md-12">
			<div class="row">
				<div class="col-xl">
					<address>
						<div class="row">
							<div class="col-md">
								<strong><%:ConfigurationManager.AppSettings["UnivInfoName"].Split('|')[0].ToString()%></strong>
							</div>
							<div class="col-md-auto">
								<span><%:ConfigurationManager.AppSettings["UnivAddress"].Split('|')[0].ToString() %></span>
								<span><%:ConfigurationManager.AppSettings["UnivTelNo"].Split('|')[0].ToString() %></span>
								<span><%:ConfigurationManager.AppSettings["UnivFaxNo"].Split('|')[0].ToString() %></span>
							</div>
						</div>
						<div class="row">
							<div class="col-md">
								<strong><%:ConfigurationManager.AppSettings["UnivInfoName"].Split('|')[1].ToString()%></strong>
							</div>
							<div class="col-md-auto">
								<span><%:ConfigurationManager.AppSettings["UnivAddress"].Split('|')[1].ToString() %></span>
								<span><%:ConfigurationManager.AppSettings["UnivTelNo"].Split('|')[1].ToString() %></span>
								<span><%:ConfigurationManager.AppSettings["UnivFaxNo"].Split('|')[1].ToString() %></span>
							</div>
						</div>
					</address>
				</div>
				<%
					if ((ViewBag.baseCodes as IList<ILMS.Design.Domain.Code>).Where(c => c.ClassCode.Equals("SNSC")).ToList().Count > 0)
					{
				%>
				<div class="col-md-auto">
					<div class="sns-link">
					<% 
						foreach (var item in (ViewBag.baseCodes as IList<ILMS.Design.Domain.Code>).Where(c => c.ClassCode.Equals("SNSC")).ToList())
						{
							string iconClass = "";
							string iconName = "";

							if (item.CodeValue.Equals("SNSC001"))
							{
								iconClass = "sns-icon-facebook";
								iconName = "Facebook";
							}
							else if (item.CodeValue.Equals("SNSC002"))
							{
								iconClass = "sns-icon-twitter";
								iconName = "Twitter";
							}
							else if (item.CodeValue.Equals("SNSC003"))
							{
								iconClass = "sns-icon-linkedin";
								iconName = "Linkedin";
							}
							else if (item.CodeValue.Equals("SNSC004"))
							{
								iconClass = "sns-icon-naver";
								iconName = "Naver";
							}
					%>
						<a href="<%:item.CodeName %>" target="_blank" class="<%:iconClass %>"><span class="sr-only"><%:iconName %></span></a>
					<%
						}
					%>
					</div>
				</div>
				<%
					}
				%>
				<div class="col-md-auto">
					<div class="dropdown">
						<button class="btn dropdown-toggle" type="button" id="family-site" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<%	if (!(ViewBag.FamilySiteList.Count > 0))
								{
							%>
									없음
							<%
								}
								else
								{
							%>
									관련사이트
							<%
								}
							%>

						</button>
							<%	if (ViewBag.FamilySiteList.Count > 0)
								{
							%>
									<div class="dropdown-menu" aria-labelledby="family-site">
							<%
									foreach (var item in (ViewBag.FamilySiteList))
									{
							%>
										<a class="dropdown-item" href="<%:item.SiteUrl %>"><%:item.SiteName %></a>
							<%
									}
							%>
									</div>
							<%
								}
							%>
					</div>
				</div>
			</div>
			<div class="copyright">
				<%:ConfigurationManager.AppSettings["CopyRight"].ToString() %>
			</div>
		</div>	
	</div>
</div>
