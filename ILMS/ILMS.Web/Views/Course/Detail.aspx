<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.CourseViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<div id="content">
		<div class="card card-style01 mt-4">
			<div class="card-header">
				<div class="row no-gutters align-items-center">
					<div class="col">
						<a href="#" class="card-title01 text-dark"><%:Model.Course.SubjectName %></a>
					</div>
					<div class="col-md-auto text-right">
						<div class="icon-sns">
							<a href="javascript:void(0);" role="button" onclick="snsShare('twitter');" title="트위터 공유">
								<i class="icon twitter"></i><span class="sr-only">트위터 공유</span>
							</a>
							<a href="javascript:void(0);" role="button" onclick="snsShare('facebook');" title="페이스북 공유">
								<i class="icon facebook"></i><span class="sr-only">페이스북 공유</span>
							</a>
							<a href="javascript:void(0);" role="button" onclick="snsShare('kakaostory');" title="카카오스토리 공유">
								<i class="icon kakaostory"></i><span class="sr-only">카카오스토리 공유</span>
							</a>
							<a href="javascript:void(0);" role="button" onclick="snsShare('naverblog');" title="네이버블로그 공유">
								<i class="icon naverblog"></i><span class="sr-only">네이버블로그 공유</span>
							</a>
							<a href="javascript:void(0);" role="button" onclick="snsShare('share');" title="링크 공유">
								<i class="icon share"></i><span class="sr-only">링크 공유</span>
							</a>
						</div>
					</div>

					<div class="col text-right d-md-none">
						<button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample1" aria-expanded="false" aria-controls="collapseExample1">
							<span class="sr-only">더 보기</span>
						</button>
					</div>
				</div>
			</div>

			<div class="card-body collapse d-md-block" id="collapseExample1">
				<div class="row align-items-end">
					<div class="col-md">
						<dl class="row dl-style02">
							<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>신청기간</dt>
							<dd class="col-sm pl-4"><%:Model.Course.RStart %> ~ <%:Model.Course.REnd %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>운영기간</dt>
							<dd class="col-sm pl-4"><%:Model.Course.LStart %> ~ <%:Model.Course.LEnd %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>분야</dt>
							<dd class="col-sm pl-4"><%:Model.Course.MName %></dd>
						</dl>
						<dl class="row dl-style02">
							<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %></dt>
							<dd class="col-sm pl-4"><%:Model.Course.HangulName %></dd>
						</dl>
					</div>
					<div class="col-md-auto mt-2 mt-md-0 text-right">
						<input type="hidden" id="hdnLecturer" value="<%:ViewBag.IsLecturer %>" />
						<%
							if(DateTime.ParseExact(Model.Course.RStart, "yyyy-MM-dd", null) < DateTime.Now && DateTime.ParseExact(Model.Course.REnd, "yyyy-MM-dd", null).AddDays(1) > DateTime.Now)
							{
						%>
						<button class="btn btn-lg btn-point w-100 w-md-auto <%:ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("N") && (ViewBag.IsLecturer || ViewBag.IsAdmin) ? "d-none" : "" %>" id="btnReqCourse" onclick="javascript:fnReqLecture();">수강신청하기</button>
						<%
							}
						%>
						<button class="btn btn-lg btn-point w-100 w-md-auto d-none" id="btnGoLectureRoom" onclick="javascript:fnGoLectureRoom(<%: Model.Course.CourseNo%>);">강의실이동</button>
						<input type="hidden" name="getProfessorMatched" id="getProfessorMatched" />
						<input type="hidden" name="isLogin" id="isLogin" value="<%:ViewBag.IsLogin ? 1:0 %>" />
					</div>
				</div>
			</div>
		</div>

		<div id="reqbox">
			<h3 class="title04 mt-4">과정소개</h3>
			<div class="mt-2">
				<p><%: Html.Raw( Model.Course.Introduce) %></p>
			</div>

			<h3 class="title04 mt-4"><%:ConfigurationManager.AppSettings["UnivYN"].Equals("Y") ? "평가기준" : "상세안내"%></h3>
			<div class="card mt-2">
				<div class="card-body py-0">
					<%
						if (ConfigurationManager.AppSettings["UnivYN"].Equals("Y"))
						{
					%>
					<div class="table-responsive">
						<table class="table" summary="">
							<thead>
								<tr>
									<th scope="col">평가항목</th>
									<%
										for (int i = 0; i < Model.EstimationItemBasis.Count; i++)
										{
									%>
									<th scope="col" class="text-nowrap"><%= Model.EstimationItemBasis[i].EstimationItemGubunName%></th>
									<%
										}
									%>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th scope="row">비율(%)</th>
									<%
										for (int i = 0; i < Model.EstimationItemBasis.Count; i++)
										{
									%>
									<td class="text-center">
										<div class="item" id="basisitemtext">
											<%= Model.EstimationItemBasis != null ? Model.EstimationItemBasis[i].RateScore.ToString() : "" %>
										</div>
									</td>
									<%
										}
									%>
								</tr>
							</tbody>
						</table>
					</div>
					<%
						}
						else
						{
					%>
					<div>
						<div class="card-body collapse d-md-block">
							<div class="row align-items-end">
								<div class="col-md">
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>강의형태</dt>
										<dd class="col-sm pl-4"><%:Model.Course.StudyTypeName %></dd>
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>교육비</dt>
										<dd class="col-sm pl-4"><%:Model.Course.CourseExpense.ToString("N0") %>원</dd>
									</dl>
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>교육시간</dt>
										<dd class="col-sm pl-4"><%:Model.Course.ClassTime != null ? Model.Course.ClassTime : "-" %></dd>
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>교육대상</dt>
										<dd class="col-sm pl-4"><%:Model.Course.TargetUser != null ? Model.Course.TargetUser : "-" %></dd>
									</dl>
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>수료증</dt>
										<dd class="col-sm pl-4"><%:Model.Course.Completion != null ? Model.Course.Completion : "-" %></dd>
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>기기지원</dt>
										<dd class="col-sm pl-4"><%:Model.Course.SupportDevice != null ? Model.Course.SupportDevice : "-" %></dd>
									</dl>
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>교재 및 참고자료</dt>
										<dd class="col-sm pl-4"><%:Model.Course.TextbookData != null ? Model.Course.TextbookData : "-" %></dd>
									</dl>
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>수료기준</dt>
										<dd class="col-sm pl-4">
											<%:"총점 " + Model.Course.PassPoint.ToString() + "점 이상 수료 (" %>
										<%
											for (int i = 0; i < Model.EstimationItemBasis.Count; i++)
											{
										%>
											<%:Model.EstimationItemBasis != null ? Model.EstimationItemBasis[i].EstimationItemGubunName + " " + Model.EstimationItemBasis[i].RateScore.ToString() + "%" : "설정되지 않음" %>
										<%
											}
										%>
											<%:")" %>
										</dd>
									</dl>
									<dl class="row dl-style02">
										<dt class="col-auto w-8rem"><i class="bi bi-dot"></i>학습목표</dt>
										<dd class="col-sm pl-4"><%:Model.Course.ClassTarget %></dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<%
						}
					%>
				</div>
			</div>

			<h3 class="title04 mt-4"><%:ConfigurationManager.AppSettings["CourseText"].ToString()%></h3>


			<%
				if (Model.Inning.Count > 0)
				{
			%>
				<div class="card mt-2">
					<div class="card-body py-0">
						<div class="table-responsive">
							<table class="table" summary="">
								<thead>
									<tr>
										<th scope="col">주차</th>
										<th scope="col">차시</th>
										<th scope="col">출석기간</th>
										<th scope="col">강의내용</th>
									</tr>
								</thead>
								<tbody>

									<%
										foreach (var item in Model.Inning)
										{
									%>

									<tr>
										<td><%:item.Week %></td>
										<td><%:item.InningSeqNo %></td>
										<td class="text-nowrap"><%:item.InningStartDay %> ~ <%:item.InningEndDay %></td>
										<td class="text-left">
										<%
											if (item.IsPreview == "Y")
											{ 
										%>
											<a href="javascript:void(0);" onclick="javascript:fnOcwView(<%:item.OcwNo %>, <%:item.OcwType %>, <%:item.OcwSourceType %>, '<%:item.OcwType == 1 ? (item.OcwData ?? "" ) : item.OcwSourceType == 0 ? item.OcwData : "" %>', <%:item.OcwFileGroupNo %>, <%:item.OcwWidth %>, <%:item.OcwHeight %>, 'frmpop', <%:item.InningNo %>);">
												<%:Html.Raw(item.Title)%>
											</a>
											<span class="text-danger">[맛보기]</span>
										<%
											}
											else
											{ 
										%> 
											<%:Html.Raw(item.Title) %>
										<%
											}
										%>
										</td>
									</tr>
									<%
										}
									%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			<%
				}
				else
				{
			%>
			<div class="alert bg-light alert-light rounded text-center mt-2"><i class="bi bi-info-circle-fill"></i> 등록된 학습이 없습니다.</div>

			<%
				}
			%>

			<div class="text-right">
				<a href="#" class="btn btn-secondary" onclick="fnGo()">목록</a>
			</div>
		</div>
	</div>
	<form id="frmpop">
        <input type="hidden" name="Ocw.OcwNo" id="OcwViewOcwNo">
        <input type="hidden" name="Inning.InningNo" id="OcwViewInningNo">
    </form>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<script type="text/javascript">
		var ajaxHelper = new AjaxHelper();

		$(document).ready(function () {
			ajaxHelper.CallAjaxPost("/Course/IsPossibleLecture/", { CourseNo: <%: Model.Course.CourseNo%> }, "fnIsPossibleLecuture");
			ajaxHelper.CallAjaxPost("/Course/getProfessorMatched/", { CourseNo: <%: Model.Course.CourseNo%> }, "fnProfessorMatched");
		});

		function fnIsPossibleLecuture() {
			var result = ajaxHelper.CallAjaxResult();
			var btnReqCourse = $('#btnReqCourse');
			var btnGoLectureRoom = $('#btnGoLectureRoom');

			if (result == -1) {

			} else if (result == -2) {
				btnGoLectureRoom.removeClass("d-none");
				btnReqCourse.addClass("d-none");
			}
		}

		function fnProfessorMatched() {
			var result = ajaxHelper.CallAjaxResult();
			$('#getProfessorMatched').val(result);
		}

        <%-- 수강신청하기 버튼 --%>
		function fnReqLecture() {
			var isLogin = document.getElementById('isLogin').value;

			if (isLogin == 0) {
				bootConfirm("로그인 후 수강신청이 가능합니다. 로그인 하시겠습니까?", fnGologin)
			}
			else if ($('#getProfessorMatched').val() != 0) {
				bootAlert('담당<%:ConfigurationManager.AppSettings["ProfIDText"].ToString() %>는 수강신청이 불가능합니다.');
			}
			else {
				bootConfirm("수강신청하시겠습니까?", fnReqCourse);
			}
		}

		function fnGologin(){
			location.href = "/Account/Index";
		}

		function fnReqCourse() {
			ajaxHelper.CallAjaxPost("/Course/ReqCourse/", { CourseNo: <%: Model.Course.CourseNo%> }, "fnCbReq");
		}

		function fnCbReq() {
			var result = ajaxHelper.CallAjaxResult();
			var btnReqCourse = $('#btnReqCourse');
			var btnGoLectureRoom = $('#btnGoLectureRoom');

			if (result > 0) {
				btnGoLectureRoom.removeClass("d-none");
				btnReqCourse.addClass("d-none");
				bootAlert("수강신청 완료 하였습니다.");
			}
			else if (result == -1) {
				bootAlert("로그인 후 신청해주세요.");
				location.href = "/Account/Index";
			}
			else if (result == -2) {
				btnGoLectureRoom.removeClass("d-none");
				btnReqCourse.addClass("d-none");
				bootAlert("수강신청 되었으나 등록된 강의가 없습니다.\n수강은 <%: ConfigurationManager.AppSettings["ProfIDText"].ToString() %>님이 강의를 등록하신 후 가능합니다.");
			}
			else if (result == -3) {
				bootAlert("신청기간이 아닙니다.");
			}
			else if (result == -4) {
				bootAlert("수강신청 중 문제가 발생하여 정상적으로 신청되지 않았습니다.\n강의실에서 수강취소 후 다시 시도해주세요.");
			}
		}

		function fnGoLectureRoom(courseNo) {
			location.href = "/LectureRoom/Index/" + courseNo;
		}

        <%-- SNS 버튼 --%>
		function snsShare(idx) {
			var idx2 = '<%: Model.Course.CourseNo %>';
			if (idx == "facebook") {
				window.open("https://www.facebook.com/sharer/sharer.php?u=" + location.origin + "/Course/Detail?CourseNo=" + idx2 + "&amp;src=sdkpreparse", "", "width=500, height=500");
			}
			else if (idx == "twitter") {
				window.open("https://twitter.com/home?status=" + location.origin + "/Course/Detail?CourseNo=" + idx2, "", "width=500, height=500");
			}
			else if (idx == "kakaostory") {
				Kakao.init('2dac7b12201daed560942cdd996cdbb2');
				Kakao.Story.share({
					url: location.origin + "/Course/Detail?CourseNo=" + idx2,
					text: '<%: ConfigurationManager.AppSettings["UnivName"].ToString() %> LMS'
				});
			}
			else if (idx == "naverblog") {
				var url = encodeURI(encodeURIComponent("" + location.origin + "/Course/Detail?CourseNo=" + idx2));
				var title = encodeURI("<%: ConfigurationManager.AppSettings["UnivName"].ToString() %> LMS");
				window.open("http://share.naver.com/web/shareView.nhn?url=" + url + "&title=" + title, "", "width=500, height=500");
			}
			else if (idx == "share") {
				var IE = (document.all) ? true : false;
				if (IE) {
					window.clipboardData.setData("Text", "" + location.origin + "/Course/Detail?CourseNo=" + idx2);
				} else {
					temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", "" + location.origin + "/Course/Detail?CourseNo=" + idx2);
				}
			}
			Prevent();
		}

		function fnGo() {

			var categoryNo = '<%: Model.CategoryNo == 0 ? "" : "/" + Model.CategoryNo %>';

			window.location = "/Course/List" + categoryNo + "?Year=" + '<%:Model.Year %>' + "&Month=" + '<%:Model.Month%>' + "&CategoryNo=" + '<%:Model.CategoryNo%>' + "&SearchText=" + decodeURIComponent('<%:Model.SearchText%>') + "&PageRowSize=" + <%:Model.PageRowSize%> + "&PageNum=" + <%:Model.PageNum%>;
		}

	</script>
</asp:Content>
