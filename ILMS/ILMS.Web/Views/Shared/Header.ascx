<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="top-main">
	<div class="container">
		<div class="layout between top-main-layout">
			<div class="ly-item">
				<h1 class="site-title">
					<a class="site-link" href="/Home/Index">
						<span class="site-logo"><%:ConfigurationManager.AppSettings["UnivName"].ToString() %></span>
						<span class="sub-site-title"><%:ConfigurationManager.AppSettings["OriginSystemName"].ToString() %></span>
					</a>
				</h1>
			</div>
			<div class="ly-item">
				<div id="top-menu" class="top-menu" tabindex="0">
					<div class="menubar-box">
						<div class="menubar-title-box">
							<h2 class="menubar-title">전체메뉴</h2> 
							<a class="menubar-close" href="javascript:void(0)" role="button">
								<i class="material-icons">close</i>
								<span class="sr-only">전체 메뉴 닫기</span>
							</a>
						</div>
						<ul class="menubar" role="menubar" aria-label="전체메뉴">
						<%
							if(ViewBag.MenuList == null)
							{
								Response.Redirect(ConfigurationManager.AppSettings["BaseUrl"].ToString() + "/Account/Index");
							}
							else
							{
								if(ViewBag.MenuList.Count > 0)
								{
									foreach (var item in ((ViewBag.MenuList as IList<ILMS.Design.Domain.Menu>).OrderBy(c => c.SortNo).ToList()))
									{
										if (item.MenuLv == 1)
										{
						%>
							<li>
								<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="true" aria-expanded="false">
									<%:item.MenuName.ToString() %>
								</a>
								<div class="menubox">
									<div class="menubox-inner">
										<ul role="menu" aria-label="<%:item.MenuName.ToString() %>">
						<%      
										}
										else if(item.MenuLv == 2)
										{
						%>
											<li>
												<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="false" aria-expanded="false">
													<%:item.MenuName.ToString() %>
												</a>
											</li>
						<%
										}

										if(item.LastMenuYN.ToString() == "Y" && item.MenuLv > 1)
										{
						%>
										</ul>
									</div>
								</div>
							</li>
						<%
										}
									}
								}
							
								if(ViewBag.LecMenuList.Count > 0)
								{
									foreach(var item in ((ViewBag.LecMenuList as IList<ILMS.Design.Domain.Menu>).OrderBy(c => c.SortNo).ToList()))
									{
										if (item.MenuLv == 1)
										{
						%>
							<li id="liLecMenu" class="d-block d-md-none">
								<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="true" aria-expanded="false">
									<%:item.MenuName.ToString() %>
								</a>
								<div class="menubox">
									<div class="menubox-inner">
										<ul role="menu" aria-label="<%:item.MenuName.ToString() %>">
						<%      
										}
										else if(item.MenuLv == 2)
										{
											if(item.LastMenuYN == "Y")
											{
						%>
											<li>
												<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" >
													<%:item.MenuName.ToString() %>
												</a>
											</li>
						<%
											}
											else
											{
						%>
											<li>
												<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="true" aria-expanded="false">
													<%:item.MenuName.ToString() %>
												</a>
												<ul role="menu" aria-label="<%:item.MenuName.ToString() %>">
						<%
											}
										}
										else if (item.MenuLv == 3)
										{
						%>
													<li>
														<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" >
															<%:item.MenuName.ToString() %>
														</a>
													</li>
						<%
											if (item.LastMenuYN == "Y") 
											{
						%>
												</ul>
											</li>
						<%				
											}
										}
									}
						%>
										</ul>
									</div>
								</div>
							</li>
						<%
								}
							
								if(ViewBag.AdmMenuList.Count > 0)
								{
									foreach(var item in ((ViewBag.AdmMenuList as IList<ILMS.Design.Domain.Menu>).OrderBy(c => c.SortNo).ToList()))
									{
										if (item.MenuLv == 1)
										{
						%>
											<li id="liAdmMenu" class="d-block d-md-none">
												<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="true" aria-expanded="false">
													<%:item.MenuName.ToString() %>
												</a>
												<div class="menubox">
													<div class="menubox-inner">
														<ul role="menu" aria-label="<%:item.MenuName.ToString() %>">
						<%      
										}
										else if(item.MenuLv == 2)
										{
											if(item.LastMenuYN == "Y")
											{
						%>
															<li>
																<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" >
																	<%:item.MenuName.ToString() %>
																</a>
															</li>
						<%
											}
											else
											{
						%>
															<li>
																<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" aria-haspopup="true" aria-expanded="false">
																	<%:item.MenuName.ToString() %>
																</a>
																<ul role="menu" aria-label="<%:item.MenuName.ToString() %>">
						<%
											}
										}
										else if (item.MenuLv == 3)
										{
						%>
																	<li>
																		<a role="menuitem" href="<%:item.MenuUrl.ToString() %>" target="<%:item.LinkTarget.ToString() %>" >
																			<%:item.MenuName.ToString() %>
																		</a>
																	</li>
						<%
										if (item.LastMenuYN == "Y") {
						%>
																</ul>
															</li>
						<%				
											}
										}
									}
						%>
														</ul>
													</div>
												</div>
											</li>
						<%
								}
							}
						%>	
						</ul>
					</div>
				</div>
			</div>
			<div class="ly-item">
			<%
				if ((ViewBag.baseCodes as IList<ILMS.Design.Domain.Code>).Where(c => c.ClassCode.Equals("SNSC")).ToList().Count > 0)
				{
			%>
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
							iconClass = "sns-icon-naverblog";
							iconName = "Naverblog";
						}
				%>
					<a href="<%:item.CodeName %>" target="_blank" class="<%:iconClass %>"><span class="sr-only"><%:iconName %></span></a>
				<%
					}
				%>
				</div>
			<%
				}
			%>

				<div class="bell <%: ViewBag.IsLogin ? "" : "d-none"%>">
					<a href="/Note/ReceiveList" class="memo-link">
						<span class="sr-only">받은 쪽지</span>
						<span class="count"><%: ViewBag.NoteReceiveCount > 99 ? "99+" :  ViewBag.NoteReceiveCount%></span>
					</a>
				</div>


		<%
			if (ViewBag.IsLogin)
			{
		%>
				<div class="dropdown">
					
					<button class="btn dropdown-toggle" type="button" id="profile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span class="sr-only">마이페이지</span>
					</button>
					<div class="dropdown-menu" aria-labelledby="family-site">
						<a class="dropdown-item d-none" href="/Note/ReceiveList">쪽지 <strong><%:ViewBag.NoteReceiveCount %></strong></a>
				<%
					if (ViewBag.IsAdmin && !ViewBag.IsAutoLogin)
					{
				%>
						<a class="dropdown-item" href="#" onclick="fnOpenPopup('/Message/<%:ConfigurationManager.AppSettings["MESSAGE_TYPE"].Equals("UNIV") ? "SMSWrite" : "Write" %>', 'Write', 1200, 900, 0, 0, 'auto');">메세지</a>
						<a class="dropdown-item" href="/System/MenuList">관리자</a>
				<%
					}
				%>
				<%
					if (ViewBag.IsAutoLogin)
					{
				%>
						<a class="dropdown-item" href="/Account/AutoLogout">사용자변경해제</a>
				<%
					}
				%>
						<a class="dropdown-item" href="/MyPage/MyInfo">회원정보 확인</a>
						<a class="dropdown-item d-none" href="#">비밀번호 변경</a>
						<div class="dropdown-divider"></div>
						<a class="dropdown-item" href="/Account/Logout">로그아웃</a>
					</div>
				</div>

		<%
			}
			else
			{
		%>
				<div class="dropdown">
					<button class="btn dropdown-toggle" type="button" id="loginProfile" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<span class="sr-only">로그인</span>
					</button>
					<div class="dropdown-menu" aria-labelledby="family-site">
						<a class="dropdown-item" href="/account/index">로그인</a>
					</div>
				</div>
		<%
			}
		%>				
			</div>
			<div class="ly-item">
				<!-- 햄버거 메뉴 버튼 -->
				<button class="nav-bg-fostrap" type="button" title="메뉴">
					<span class="navbar-fostrap">
						<span></span>
						<span></span>
						<span></span>
					</span>
				</button>
			</div>
		</div>
	</div>
</div>