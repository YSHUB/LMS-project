<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Css" ContentPlaceHolderID="CssBlock" runat="server">
    <link href="/Common/css/sweetalert2.min.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<form action="/Common/OcwView/<%: Model.Ocw.OcwNo %>" method="post" id="mainForm">
		
        <%: Html.HiddenFor(m=>m.Ocw.OcwNo) %>
        <%: Html.HiddenFor(m=>m.Inning.InningNo) %>
		<%
			Int64 studyInningNo = Model.OcwByInning != null ? Convert.ToInt64(Model.OcwByInning["StudyInningNo"]) : 0;
		%>
        <%: Html.Hidden("h_studyInningNo", studyInningNo) %>
		<input type="hidden" name="ISPOST" value="Y" />
		<div id="ocwbox" style="width: 100%; height: 100%;">
	<%
		// 0 : 영상 CTKD001
		if (Model.Ocw.OcwType.Equals(0))
		{
			// 영상 - URL CTRB001
			if (Model.Ocw.OcwSourceType.Equals(0))
			{
				if (Model.Ocw.OcwData.Contains("youtube.com"))
				{
					string url = Model.Ocw.OcwData;

					string convertUrl = "";
					if (Model.AfterLogNo > 0)
					{
						//convertUrl = url + "?enablejsapi=1&version=3&playerapiid=ytplayer";
						convertUrl = url + (url.Contains("?") ? "&" : "?") + "enablejsapi=1&version=3&playerapiid=ytplayer";
					}
					else
					{
						if (url.Contains("?"))
						{
							convertUrl = url + "&start=" + Model.StudyTime;
						}
						else
						{
							convertUrl = url + "?start=" + Model.StudyTime;
						}
					}

					Model.Ocw.OcwData = convertUrl;
				}
	%>
	<iframe style="<%: "width:" + (Model.Ocw.OcwWidth + 50).ToString() + "px; " + "height: " + (Model.Ocw.OcwHeight + 70).ToString() + "px;" %>" src="<%: Model.Ocw.OcwData %>" frameborder="0" allowfullscreen></iframe>
	<%
		}
		// 영상 - 소스코드 CTRB002
		if (Model.Ocw.OcwSourceType.Equals(1))
		{
			if (Model.Ocw.OcwData.Contains("iframe") && Model.Ocw.OcwData.Contains("youtube.com") )
			{
				int startIndex = Model.Ocw.OcwData.IndexOf("src=") + 5;
				string url = Model.Ocw.OcwData.Substring(startIndex);
				int endIndex = url.IndexOf("\"");
				url = url.Substring(0, endIndex);

				string convertUrl = "";

				if (Model.AfterLogNo > 0)
				{
					convertUrl = url + "?enablejsapi=1&version=3&playerapiid=ytplayer";
				}
				else
				{
					if (url.Contains("?"))
					{
						convertUrl = url + "&enablejsapi=1&version=3&playerapiid=ytplayer&start=" + Model.StudyTime;
					}
					else
					{
						convertUrl = url + "?enablejsapi=1&version=3&playerapiid=ytplayer&start=" + Model.StudyTime;
					}
				}

				Model.Ocw.OcwData = Model.Ocw.OcwData.Replace(url, convertUrl);
			}
	%>
	<%: Html.Raw(Model.Ocw.OcwData) %>
	<%
			}
			// 영상 - MP4업로드 CTRB003
			if (Model.Ocw.OcwSourceType.Equals(3))
			{
	%>
	<video controls="controls" controlsList="nodownload" muted="muted">
		<%
			if (Model.AfterLogNo > 0) {
		%>
        <source src="/Files<%: Model.Ocw.OcwData %>" type="video/mp4" />
		<%
			} else {
		%>
        <source src="/Files<%: Model.Ocw.OcwData %>#t=<%:Model.StudyTime %>" type="video/mp4" />
		<%
			}
		%>
    </video>
	<%
			}
			// 영상 - HTML(ZIP)업로드 CTRB004
			if (Model.Ocw.OcwSourceType.Equals(4))
			{
	%>
	<iframe style="<%: "width:" + (Model.Ocw.OcwWidth + 20).ToString() + "px; " + "height: " + (Model.Ocw.OcwHeight + 20).ToString() + "px;" %>" src="/Files/OCW/OcwHtml/Ocw<%: Model.Ocw.OcwNo %><%: Model.Ocw.OcwData %>" frameborder="0" allowfullscreen></iframe>
	<%
			}
		}
	%>
		</div>
	</form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script src="/common/js/sweetalert2.min.js"></script>
    <script src="/common/js/promise.min.js"></script>
    <script>
		var _ajax = new AjaxHelper();
		var logTime = 10000; //10초에 한번 기록
        var contentsViewPage = 1;
        var objTimer, objSec;
		var contentTime = 0;
		<%="" %>
		<% 
			if (Request.ServerVariables["REMOTE_ADDR"] == "211.179.185.248" || Request.IsLocal){
		%>
		var DV_MidCheck = parseInt('5');
		<%
			} else {
		%>
		var DV_MidCheck = parseInt('<%: Model.MidCheckSecond %>');
		<%
			}
		%>
        var closePass = false;
        var afterlogno = parseInt('<%:Model.AfterLogNo%>');

		$(document).ready(function () {
			$("div.bg-primary.p-3").hide();
			<%
				if (Model.Ocw.OcwType.Equals(0) && Model.Ocw.OcwSourceType.Equals(3)) {
			%>
			$("video").attr("style", "width:" + (window.innerWidth).toString() + "px; height:" + (window.innerHeight.toString() - 6) + "px;");
			<%
				}
			%>

            var agent = navigator.userAgent.toLowerCase();
            if (agent.indexOf('msie') > -1) {
                var ieVersion = agent.match(/msie (\d+)/)[1];
                if (ieVersion < 10) {
                    alert("사용하시는 브라우저는 지원되지 않습니다.\nIE(인터넷 익스플로러) 10 이상 또는 chrome(크롬) 브라우저를 사용해주세요.");
                    self.close();
                }
			}

            if ('<%: Model.Ocw.OcwNo %>' == '0' || '<%: Model.Inning.InningNo > 0 %>' == '0') {
                alert("올바르지 않은 접근입니다.");
                closePass = true;
                self.close();
			}

            document.oncontextmenu = function () { return false; };
            $(document).on("keydown", function (e) {
                if (e.keyCode == 116 || e.keyCode == 123) {
					fnPrevent();
					return false;
                }
			});

            if ('<%: Model.IsLog ? 1 : 0 %>' == '1') {
                objTimer = setInterval(IncreaseTime, logTime);
                console.log('logstart');
                objSec = setInterval(IncreaseSecond, 1000);

                if (parseInt('<%: Model.MidCheckSecond %>') > 0) {
                    console.log('midcheckstart');
                }
            }
            else if (afterlogno > 0) {
                _intervalSecond = 0;
                objTimer = setInterval(IncreaseTime2, logTime);
                console.log('afterlogstart');
            }
            else {
                closePass = true;
                console.log('nostudent');
			}
			        
			//Youtube API 로드
			var tag = document.createElement('script');
			tag.src = "https://www.youtube.com/iframe_api";
			var firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        });

        function IncreaseTime() {
            goLog(false);
		}

        function IncreaseTime2() {
            goLog2(false);
		}

        var _intervalSecond = 1;
        function goLog(_close) {
            $.ajaxSetup({ cache: false });
			var params = "paramStudyInningNo=" + $("#h_studyInningNo").val() + "&paramLastPageNo=" + contentsViewPage + "&paramTime=" + (_intervalSecond).toString();

            $.ajax({
                type: "POST",
                url: "/Ocw/StudyLogUpdate",
                data: params,
                success: function (data) {
                    _intervalSecond = 1;
                    //console.log('logok:' + data);
                    if (parseInt(data) == 1) {
                        console.log('logfinished');
                        clearInterval(objTimer);
                        clearInterval(objSec);
                        closePass = true;
                    }
                },
                error: function (msg) {
                    alert(msg);
                    //console.log('logfail:' + msg);
                },
                complete: function () {
                    if (_close) {
                        closePass = true;
                        self.close();
                    }
                }
            });
		}

        function cblog() {
            //console.log('afterlog: ' + capResult.Code);
		}

        function goLog2(_close) {
            //capp("/Ocw/AfterLog", { LogNo: afterlogno, pno: contentsViewPage, stime: (logTime / 1000) }, "cblog", null, null, true);
        }

	    //필수 구현 함수, 자동 호출 함수, 플레이어 객체 구현 필요
		var player1;
        function onYouTubeIframeAPIReady() {
            if (document.getElementsByTagName("iframe")[0] != null) {
		        player1 = new YT.Player(document.getElementsByTagName("iframe")[0],{
					playerVars: {rel: 0},
					host: 'https://www.youtube.com',
			        events: {				
				        'onReady': onPlayerReady,	//플레이어 로드가 완료되면
				        'onStateChange': onPlayerStateChange	//플레이어 상태가 변경될 때마다 실행
			        }
                });
            }
	    }

        function onPlayerReady(event) {
            console.log('onPlayerReady 실행');
		}	
		
		var playerState = false;
        function onPlayerStateChange(event) {
            if (event.data == YT.PlayerState.PLAYING) {
                //재생
                playerState = true;
            } else if (event.data == YT.PlayerState.PAUSED) {
                //일시정지
                contentTime -= 1;
                _intervalSecond -= 1;
                playerState = false;
            }
        }
		
        var isMidOK = false;
        function IncreaseSecond() {
            _intervalSecond += 1;
            contentTime += 1;
            var video_01 = document.getElementsByTagName("video")[0];
			playerState = video_01 != null ? (video_01.paused ? false : true) : (playerState == false && player1.playerInfo.videoUrl != undefined ? false : true);
            if (!playerState) {
                contentTime -= 1;
                _intervalSecond -= 1;
			}

            if (DV_MidCheck > 0 && contentTime >= DV_MidCheck) {
                DV_MidCheck = 0;
                console.log('midstart');
				$("#ocwbox").hide();

                swal({
                    title: '[중간출석 확인]',
                    text: "※ [확인] 버튼을 클릭하지 않은 경우 약 <%:ConfigurationManager.AppSettings["MidCheckSecond"].AsInt()%>초 후 강의가 자동 종료됩니다. ",
                    type: 'warning',
                    showCancelButton: false,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '확인',
                    closeOnConfirm: false,
                    allowOutsideClick: false
                }).then(function (isConfirm) {
                    if (isConfirm) {
                        $.ajax({
                            type: 'POST',
                            url: "/Ocw/StudyMidCheck",
                            data: { "paramStudyInningNo": $("#h_studyInningNo").val() },
                            success: function (data) {
                                if (data != null) {
                                    console.log('midok');
                                    isMidOK = true;
                                    swal({
                                        title: '중간출석체크 완료',
                                        text: 'I will close in 2 seconds.',
                                        type: 'success',
                                        timer: 2000,
                                        showConfirmButton: false
                                    }).then(function () {
                                        $("#ocwbox").show();
                                    });
                                    $("#ocwbox").show();
                                }
                            },
                            //오류 발생 시 처리
                            error: function (e) {
                                alert('실행 중 오류가 발생되었습니다. 컨텐츠를 다시 실행해주세요.');
                                console.log('miderror');
                                closePass = true;
                                self.close();
                            }
                        });
                    }
				});

                setTimeout(function () {
                    if (!isMidOK) {
                        clearInterval(objTimer);
                        clearInterval(objSec);
                        goLog(true);
                    }
                }, <%:ConfigurationManager.AppSettings["MidCheckSecond"].AsInt()%>*1000);
            }
        }
        window.onbeforeunload = function () {
            if (!closePass) {
                console.log('unload1');
                var retmsg = confirmQuit();
                console.log('unload7');
                event.returnValue = retmsg;
                return retmsg;
            }
        }
        var confirmQuit = function () {
            var agent = navigator.userAgent.toLowerCase();
            var strmsg = "강의를 종료합니다.";
            if (!closePass) {
                console.log('unload2');
                strmsg = "강의를 종료하고 학습내용을 저장합니다 .";
                if (_intervalSecond > 0) {
                    console.log('unload3');
                    var params = "paramStudyInningNo=" + $("#h_studyInningNo").val() + "&paramLastPageNo=" + contentsViewPage + "&paramTime=" + _intervalSecond;
                    $.ajax({
                        type: "POST",
                        url: "/Ocw/StudyLogUpdate",
                        data: params,
                        success: function (data) {
                            _intervalSecond = 0;
                            console.log('unload4');
                        },
                        error: function (msg) {
                            console.log('unload4error');
                            if (agent.indexOf("chrome") == -1) {
                                alert(msg);
                            }
                        }
                    });
                }
                if (agent.indexOf("chrome") == -1) {
                    alert(strmsg);
                }
            }
            console.log('unload5');
            if (agent.indexOf("chrome") != -1) {
                // 브라우저가 Chrome인  경우
                if (!closePass) {
                    console.log('unload6');
                    return strmsg;
                }
            }
        }
    </script>
</asp:Content>
