<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Main.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.HomePageViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form>
		<div id="dvPopLayer">
			<% 
				foreach (var item in Model.PopupList)
				{
			%>
			<textarea id="img_<%:item.PopupNo %>" style="display: none">/Files<%: item.SaveFileName %></textarea>
			<textarea id="PopupContents_PopupContents_<%:item.PopupNo %>" rows="15" cols="100" class="form-control" style="width: 400px; display: none"><%:Html.Raw(Server.UrlDecode(item.PopupContents))%></textarea>
			<%
				}
			%>
		</div>
		<div class="popup" id="popupLayer" style="display: block;"></div>
	</form>
    <div id="content" class="main-container">
        <div id="fullpage">
			<!-- section1 -->
            <section class="section bg-01" id="section1">
                <div id="main-visual">

                    <div class="mv-box">
                        <div class="carousel-box mv-carousel-box">
                            <div class="owl-carousel mv-carousel">
                                <div class="item">
                                    <div class="item-img" data-pc="/site/resource/www/images/main-visual-0101.jpg" data-mobile="/site/resource/www/images/main-visual-0101-m.jpg"></div>

                                    <div class="mv-text-box">
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-12">
                                                    <div class="mv-title-box">
                                                        <div class="mv-title">
                                                            <%=ConfigurationManager.AppSettings["UnivName"].ToString() %>
                                                        </div>
                                                        <div class="mv-tagline">
                                                            <small><%=ConfigurationManager.AppSettings["UnivNameEng"].ToString() %></small>
                                                            <strong>e-Learning System</strong>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="item-img" data-pc="/site/resource/www/images/main-visual-0102.jpg" data-mobile="/site/resource/www/images/main-visual-0102-m.jpg"></div>

                                    <div class="mv-text-box">
                                        <div class="container">
                                            <div class="mv-title-box">
                                                <div class="mv-title">
                                                    <%=ConfigurationManager.AppSettings["UnivName"].ToString() %>
                                                </div>
                                                <div class="mv-tagline">
                                                    <small><%=ConfigurationManager.AppSettings["UnivNameEng"].ToString() %></small>
                                                    <strong>e-Learning System</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </section>

            <!-- section2 -->
            <section class="section bg-02" id="section2">
                <div class="container">
                    <h2 class="title01">교육과정</h2>
                    <%
                        if(Model.CourseList.Count > 0)
                        {
                    %>
                        <div class="carousel-box curri-carousel-box">

                            <%-- class에 무조건 세개 고정인듯? --%>
                            <div class="owl-carousel curri-carousel">

                                <%
                                    foreach (var course in Model.CourseList)
                                    {
                                        int indexOf = Model.CourseList.IndexOf(course) + 1;
                                        string url = "/Site/resource/www/images/curriculum-bg0" + indexOf + ".jpg";
                                %>
                                        <div class="item">
                                            <a href="/Course/Detail/<%:course.CourseNo %>" class="item-link">
                                                <div class="item-header" style="background-image: url('<%:url %>');"></div>
                                                <div class="item-body">
                                                    <div class="item-title">
                                                        <h3 class="title"><%:course.SubjectName %></h3>
                                                        <ul>
                                                            <li><%:Html.Raw(Server.UrlDecode((course.Introduce ?? "").Replace(System.Environment.NewLine, "<br />"))) %></li>
                                                        </ul>

                                                    </div>
                                                    <div class="item-desc">
                                                        <h4 class="title">교육내용</h4>
                                                        <ul>
                                                            <%
                                                                foreach (var inning in Model.InningList.Where(w => w.CourseNo == course.CourseNo))
                                                                {
                                                            %>
                                                                    <li><%:inning.Title %></li>
                                                            <%
                                                                }
                                                            %>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                <%
                                    }


                                %>
                            </div>
                        </div>
                    <%
                        }
                        else
                        {
                    %>
						<div class="non-page board">
							<h3>조회된 교육과정이 없습니다.</h3>
						</div>
                    <%
                        }
                    %>
                                            
                </div>
            </section>

            <!-- section3 -->
            <section class="section bg-03" id="section3">
                <div class="container">
                    <div class="row align-items-lg-center">
                        <div class="col-lg-4 col-xl-3">
                            <h2 class="title01">교육목표</h2>
                            <div class="text">
                                빅데이터 활용 마이스터 로봇화 기술이 
								제조분야의 공정 시스템 고도화에 
								활용될 수 있도록 교육을 통한 
								빅데이터 활용 마이스터 로봇화 전문인력
								<small>(오퍼레이터 및 코디네이터)</small> 양성
                            </div>
                            <a href="/Sub/Vision" class="btn btn-outline-white">자세히 보기</a>
                        </div>
                        <div class="col-lg-8 col-xl-9 mt-5 mt-lg-0 ml-0">
                            <div class="video-box">
                                <iframe width="100%" height="100%" runat="server" id="ifr홍보영상" src="https://www.youtube.com/embed/8Z9NsTJU9iA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
							</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- section4 (공지사항)-->
            <section class="section bg-04" id="section4">
                <div class="container">
                    <h2 class="title01">공지사항</h2>
                    <%
                        if (Model.BoardList.Count > 0)
                        {
                    %>
                        <div class="carousel-box news-carousel-box">
                        <div class="owl-carousel news-carousel">

                            <%
                                foreach (var notice in Model.BoardList)
                                {

                            %>
                            <div class="item">
                                <a href="/Board/Detail/0/4/<%:notice.BoardNo %>" class="item-link" target="_blank">
                                    <div class="item-box">
                                        <span class="date"><%:notice.UpdateDateTime %></span>
                                        <h3 class="title text-truncate text-truncate--2"><%:notice.BoardTitle %></h3>
                                        <p class="text text-truncate text-truncate--4">
                                           <%-- <%:Regex.Replace(notice.BoardContents, "<[^>]*>", string.Empty) %>--%>
											<%--<%:Html.Raw(notice.BoardContents.Replace(System.Environment.NewLine, "<br />")) %>--%>
											<%:Html.Raw(notice.BoardContents.Replace(System.Environment.NewLine, "<br />").Replace("\n", "<br />").Replace("\r", "<br />")) %>
                                        </p>
                                        <span class="more">MORE</span>
                                    </div>
                                </a>
                            </div>
                            <%

                                }
                            %>
                        </div>
                    </div>

                    <%
                        }
                        else
                        {
                    %>
					    <div class="non-page board">
						    <h3>등록된 공지사항이 없습니다.</h3>
					    </div>                       

                    <%
                        }
                    %>
                </div>
            </section>

            <!-- section5 -->
            <section class="section bg-05" id="section5">
                <div id="footer">
                    <% Html.RenderPartial("./Footer"); %>
                </div>
				<div class="banners ci">
					<div class="container">
						<div class="row align-items-center justify-content-around text-center">
							<% 
								foreach (var quick in Model.QuickLinkList)
								{
							%>
								<div class="col">
									<a href="<%:quick.Url %>" target="_blank"><img class="img-fluid" src="/Files<%: quick.SaveFileName %>" style="width:145px; height:40px;"></a>

								</div>
							<%
								}

							%>
						</div>
					</div>
				</div>
            </section>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">

		$(document).ready(function () {

			device_check();

			$("#popupLayer").html(popupLayer);

			$('#main-visual-item .pause-btn').click(function () {
				$('#main-visual-item').carousel('pause');
				$('#main-visual-item .pause-btn').hide();
				$('#main-visual-item .play-btn').show();
			});
			$('#main-visual-item .play-btn').click(function () {
				$('#main-visual-item').carousel('cycle');
				$('#main-visual-item .play-btn').hide();
				$('#main-visual-item .pause-btn').show();
			});

			$('#rol-banner .pause-btn').click(function () {
				$('#rol-banner').carousel('pause');
				$('#rol-banner .pause-btn').hide();
				$('#rol-banner .play-btn').show();
			});
			$('#rol-banner .play-btn').click(function () {
				$('#rol-banner').carousel('cycle');
				$('#rol-banner .play-btn').hide();
				$('#rol-banner .pause-btn').show();
			});

		});



		var popupLayer = "";

		function closePopLayer(id) {
			$("#popup" + id).hide();
			if ($("#chkpopup" + id).is(":checked")) {
				setCookie("PopLayer" + id, "checked", 1);
			}
		}

		function device_check() {
			// 디바이스 종류 설정
			var pc_device = "win16|win32|win64|mac|macintel";

			// 접속한 디바이스 환경
			var this_device = navigator.platform;

			if (this_device) {
				console.log('PC');
			}
		}

		/*style = "topmargin: ' + t + 'px; leftmargin: ' + l + 'px; width: ' + w + 'px;"*/
		
		
		function openPopLayer(rowId, title, w, h, l, t) {
			if (getCookie("PopLayer" + rowId) == "") {
                var src = $("#PopupContents_PopupContents_" + rowId).val();
                var img = $("#img_" + rowId).val();
				popupLayer += '  <div class="popup-box" id="popup' + rowId + '" style ="top: ' + t + 'px; left: ' + l + 'px; transform: translate(-50%,-50%); width: ' + w + 'px;  height: '+h+'">';
                popupLayer += '    <div class="popup-header">' + title + '</div>';
                popupLayer += '    <!--테이블-->';
                popupLayer += '     <div class="popup-body">';
                popupLayer += '         <div class="layer-popup">';
				popupLayer += '             <div class="p-3 bg-light">';
 				popupLayer +=                   src;
				popupLayer += '                 <img src="' + img + '" alt="" class="img-fluid"  />';
                popupLayer += '              </div>';
				popupLayer += '         </div>';
				popupLayer += '    </div>';
				popupLayer += '    <div class="popup-footer">';
				popupLayer += '       <div class="row">';
				popupLayer += '           <div class="col-8">';
				popupLayer += '               <input id="chkpopup' + rowId + '" type="checkbox" value="" type="checkbox" />';
				popupLayer += '               <label for="chkpopup' + rowId + '">1일동안 열지 않음</label>';
				popupLayer += '           </div>';
                popupLayer += '           <div class="col-4 text-right">';
				popupLayer += '               <a class="close-popup" href="javascript:void(0);" onclick="javascript:closePopLayer(' + rowId + ');" role="button">닫기<i class="material-icons">clear</i></a>';
				popupLayer += '           </div>';
				popupLayer += '       </div>';
                popupLayer += '    </div>';
                popupLayer += '</div>';
                //popupLayer += '<div class="popup-mask"></div>';
			}
		}

		function getCookie(name) {
			var nameOfCookie = name + "=";
			var x = 0;

			while (x <= document.cookie.length) {
				var y = (x + nameOfCookie.length);
				if (document.cookie.substring(x, y) == nameOfCookie) {
					if ((endOfCookie = document.cookie.indexOf(";", y)) == -1)
						endOfCookie = document.cookie.length;
					return unescape(document.cookie.substring(y, endOfCookie));
				}
				x = document.cookie.indexOf("", x) + 1;
				if (x == 0) break;
			}
			return "";
		}

		function setCookie(name, value, expire) {
			var todayDate = new Date();
			todayDate.setDate(todayDate.getDate() + expire);
			todayDate.setHours(0, 0, 0, 0);

			document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";"
		}

        <% 
		foreach (var item in Model.PopupList)
		{
        %>
		    openPopLayer(<%:item.PopupNo %>, '<%:item.PopupTitle %>', <%:item.WidthSize %>, <%:item.HeightSize %>, <%:item.LeftMargin %>, <%:item.TopMargin %>);
        <%
		}
        %>

		$(document).ready(function () {
			botScroll();
			$(window).on("resize", function () {
				botScroll();
			});
			$(document).on("scroll", function () {
				botScroll();
			});
			var auto_cnt = 0;


			$("#btn_dot_0").click(function () {
				$("#btn_dot_0").addClass("on");
				$("#btn_dot_1").removeClass("on");
				$("#btn_dot_2").removeClass("on");
				bxBanner.goToSlide(0);
			});

			$("#btn_dot_1").click(function () {
				$("#btn_dot_0").removeClass("on");
				$("#btn_dot_1").addClass("on");
				$("#btn_dot_2").removeClass("on");
				bxBanner.goToSlide(1);
			});

			$("#btn_dot_2").click(function () {
				$("#btn_dot_0").removeClass("on");
				$("#btn_dot_1").removeClass("on");
				$("#btn_dot_2").addClass("on");
				bxBanner.goToSlide(2);
			});
		});

	</script>
</asp:Content>
