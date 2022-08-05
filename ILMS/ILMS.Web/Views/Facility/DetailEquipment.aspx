<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.FacilityViewModel>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">
	<link href="/common/fullcalendar-5.10.2/lib/main.css" rel="stylesheet" type="text/css">
	<link href="/site/resource/www/css/contents.css" rel="stylesheet">
	<div id="content">
		<div class="card card-style02">
			<div class="card-header form-inline">
				<div class="col-9 p-0">
					<div>
						<span class="badge badge-regular"><%:Model.Facility.FacilityTypeName %></span>
						<span class="badge badge-1"><%:Model.Facility.CategoryName %></span>
						<%
							if (Model.Facility.IsFree == "CHARGED")
							{
						%>
						<span class="badge badge-2">유료</span>
						<%
							}
						%>
					</div>
					<span class="card-title01 text-dark"><%:Model.Facility.FacilityName %></span>
				</div>
				<div class="col-3 text-right p-0">
					<input type="button" class="btn btn-secondary" value="<%:Model.isAdmin ? "예약현황 관리" : "나의 예약현황" %>" onclick="fnOpenReserve();">
				</div>
			</div>
			<div class="card-body">
				<%:Html.Raw(Server.UrlDecode(Model.Facility.FacilityText ?? "").Replace(System.Environment.NewLine, "<br />")) %>
			</div>
		</div>
		<%
			if(Model.FileList != null) {
		%>
		<div class="carousel-box fac-carousel-box">
			<div class="owl-carousel fac-carousel">
				<%
					foreach (var item in Model.FileList)
					{
				%>
				<div class="item">
					<a class="img-thumb">
						<img src="/Files<%:item.SaveFileName %>" class="item-img" alt="<%:item.OriginFileName %>">
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
		<p class="non-info">등록된 이미지가 없습니다.</p>
		<%
			}
		%>
		<div class="resv-calendar-box">
			<div class="row no-gutters">
				<div class="col-lg-8">
					<div class="form-row month-selector">
						<div class="form-group col-auto">
							<button type="button" title="이전 달" aria-pressed="false" class="btn btn-outline-light" onclick="fnSetCalendarDate('prev');">
								<i class="bi bi-chevron-left"></i>
							</button>
						</div>
						<div class="form-group col-auto">
							<label for="exampleFormControlSelect1" class="form-label sr-only">연도 선택</label>
							<select class="form-control" id="exampleFormControlSelect1">
								<option value="">2022년</option>
							</select>
						</div>
						<div class="form-group col-auto">
							<label for="exampleFormControlSelect2" class="form-label sr-only">월 선택</label>
							<select class="form-control" id="exampleFormControlSelect2">
								<option value="1">1월</option>
							</select>
						</div>
						<div class="form-group col-auto">
							<button type="button" title="다음 달" aria-pressed="false" class="btn btn-outline-light" onclick="fnSetCalendarDate('next');">
								<i class="bi bi-chevron-right"></i>
							</button>
						</div>
						<div class="form-group col-auto">
							<button type="button" title="이번 달" aria-pressed="false" class="btn btn-outline-light" onclick="fnSetCalendarDate('today');">
								이번 달
							</button>
						</div>
						<div class="col-auto text-right d-md-none">
							<button class="btn btn-light" type="button" data-toggle="collapse" data-target="#toggleCalendar" aria-expanded="false" aria-controls="toggleCalendar">
								<span class="sr-only">더 보기</span>
							</button>
						</div>
					</div>
					<div class="d-md-block collapse" id="toggleCalendar">
						<div id="calendar"></div>
					</div>
				</div>
				<div id="divNone" class="col-lg-4">
					<div class="message-box">
						<img src="/site/resource/www/images/icon-cal.png" alt="">
						<p class="text">예약일자를 선택해 주세요.</p>
					</div>
				</div>
				<div id="divDateSelect" class="col-lg-4 d-none">
					<div class="timetable">
						<h4 id="h4Date" class="tit-h4 text-center">2022년 08월 01일</h4>
						<input type="hidden" id="hdnDate" />
						<div class="table-responsive mt-3">
							<table class="table table-hover" summary="">
								<thead>
									<tr>
										<th scope="col">사용시간</th>
										<th scope="col">상태</th>
										<%
											if (Model.Facility.FacilityType == "FACILITY")
											{
										%>
										<th scope="col">인원</th>
										<%
											}
										%>
									</tr>
								</thead>
								<tbody id="tbResult">
								</tbody>
							</table>
						</div>
						<div class="border-top pt-3">
							<div class="text-right">
								<button type="button" id="btn신청" class="btn btn-primary">신청</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-12 text-right mt-0 p-0">
			<a class="btn btn-secondary" href="/Facility/List<%:Model.Facility.FacilityType.ToLower()%>?Category=<%:ViewBag.Category %>&SearchText=<%:ViewBag.SearchText%>&PageRowSize=<%:ViewBag.PageRowSize%>&PageNum=<%:ViewBag.PageNum%>">목록</a>
		</div>
	</div>
</asp:Content>

<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
	<!-- fullcalendar -->
	<script src="/common/fullcalendar-5.10.2/lib/main.js"></script>
	<script src="/common/fullcalendar-5.10.2/lib/locales/ko.js"></script>
	<script src="/common/fullcalendar-5.10.2/moment/moment.js"></script>

	<script src="/common/js/owl.carousel.min.js"></script>
	<script src="/site/resource/www/js/script.js"></script>

	<script type="text/javascript">
		var _ajax = new AjaxHelper();
		var _ajax2 = new AjaxHelper();
		var _ajax3 = new AjaxHelper();

		var calendarEl = document.getElementById('calendar');
		var calendar = new FullCalendar.Calendar(calendarEl, {
			initialView: 'dayGridMonth',
			contentHeight: 'auto',
			aspectRatio: false,

			slotMinTime: '09:00', // Day 캘린더에서 시작 시간
			slotMaxTime: '18:00', // Day 캘린더에서 종료 시간

			themeSystem: 'bootstrap',
			//locale: 'ko',

			hiddenDays: [0, 6],	//hide sun, sat
			expandRows: true, // 화면에 맞게 높이 재설정
			showNonCurrentDates: true,	//선택달 외의 날짜 보여주기
			navLinks: false, // can click day/week names to navigate views

			headerToolbar: {
				left: '',
				center: '',
				right: ''
				//left: 'today prev,next',
				//center: 'title',
				//right: 'title,dayGridMonth,timeGridWeek,timeGridDay'
			},
			views: {
				dayGridMonth: { // name of view
					titleFormat: { year: 'numeric', month: '2-digit' },
					// other view-specific options here
					dayHeaderFormat: {
						weekday: 'narrow'
					}
				}
			},
			dateClick: function (info) {
				fnSetReserveDate(info.dateStr);
			},
			events: [
				<%=""%>
				<%
					foreach (var dates in Model.FacilityReservationList)
					{
				%>
				{
					title: '예약완료',
					start: '<%:dates.ReservedDate%>',
					classNames: ['fully-booked-event']
				}<%:!dates.Equals(Model.FacilityList.Last()) ? "," : ""%>
				<%
					}
				%>
			]

		});

		$(document).ready(function () {
			fnAppendYear("exampleFormControlSelect1", "1");
			fnAppendMonth("exampleFormControlSelect2");

			calendar.render();
			fnSetCalendarEvents();

			$("#btn신청").click(function () {
				fnReserve();
			});

			$("#exampleFormControlSelect1").change(function () {
				var year = $("#exampleFormControlSelect1").val();
				var month = $("#exampleFormControlSelect2").val();

				calendar.gotoDate(year + '-' + month.padStart(2, '0') + '-01');
				fnSetCalendarEvents();
			});

			$("#exampleFormControlSelect2").change(function () {
				var year = $("#exampleFormControlSelect1").val();
				var month = $("#exampleFormControlSelect2").val();

				calendar.gotoDate(year + '-' + month.padStart(2, '0') + '-01');
				fnSetCalendarEvents();
			});
		});

		function fnSetCalendarEvents() {
			<%
				if (!Model.isAdmin)
				{
			%>
			$(".fc-day-past").addClass("fully-booked-event fully-booked");
			$("#calendar .fully-booked-event").parents(".fc-day").addClass("fully-booked");
			<%
				}
			%>
			$("#calendar .fc-day").click(function () {
				$("#calendar .fc-day").removeClass('day-selected');
				$(this).toggleClass('day-selected');
				/* 
				if( $(this).hasClass("fully-booked") ===true ) {
			
				  alert('예약이 완료되었습니다. 다른 날짜를 선택해 주세요.');
			
				} else {
			
				  $(this).toggleClass('day-selected');
				  
				} */

			});
		}

		function fnSetReserveDate(date) {
			$("#divNone").addClass("d-none");
			$("#divDateSelect").removeClass("d-none");

			var dateFormat = new Date(date);

			$("#hdnDate").val(date);
			$("#h4Date").text(dateFormat.getFullYear() + "년 " + (dateFormat.getMonth() + 1) + "월 " + dateFormat.getDate() + "일");

			fnGetReservedData(date);
		}

		function fnSetCalendarDate(date) {
			switch (date) {
				case 'prev':
					calendar.prev();
					break;
				case 'next':
					calendar.next();
					break;
				case 'today':
					calendar.today();
					break;
			}

			var dateFormat = calendar.getDate();
			var checkYear = false;

			for (var i = 0; i < $("#exampleFormControlSelect1").children().length; i++) {
				if ($("#exampleFormControlSelect1").children()[i].value == dateFormat.getFullYear()) {
					checkYear = true;
					break;
				}
			}

			if (!checkYear) {
				var today = new Date();
				var year = dateFormat.getFullYear() - today.getFullYear();

				fnAppendYear("exampleFormControlSelect1", Math.abs(year));
			}
			
			$("#exampleFormControlSelect1").val(dateFormat.getFullYear()).attr("selected", true);
			$("#exampleFormControlSelect2").val(dateFormat.getMonth() + 1).attr("selected", true);
			fnSetCalendarEvents();
		}

		function fnGetReservedData(date) {
			_ajax.CallAjaxPost("/Facility/GetReservedData", { facilityNo: <%:Model.Facility.FacilityNo%>, MaxUserCount: <%:Model.Facility.MaxUserCount%>, ReservedDate: date }, "cbGetResult");
		}

		function cbGetResult() {
			var result = _ajax.CallAjaxResult();

			if (result != null) {
				$("#tbResult").html(result);

				if ($("#hdnBanned").length > 0) {
					$("#btn신청").addClass("d-none");
				}
				<%
					if (Model.Facility.FacilityType == "FACILITY")
					{
				%>
				$("input[id*='customCheck']").click(function () {
					var txtCount = $("#userCount" + $(this)[0].id.replace("customCheck", ""))
					if ($(this).is(":checked")) {
						txtCount.removeAttr("disabled");
					}
					else {
						txtCount.val('');
						txtCount.attr("disabled", true);
					}
				});
				<%
					}
				%>
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		function fnReserve() {
			<%
				if (!Model.isAdmin)
				{
			%>
			if ('<%:DateTime.Now.ToString("yyyy-MM-dd")%>' == $("#hdnDate").val()) {
				bootAlert("당일에는 예약 및 예약취소를 할 수 없습니다.<br/> 관리자에게 문의해주세요.");
				return;
			}
			<%
				}
			%>

			var arrayTime = [];
			var arrayUser = [];
			var checkTime = "";

			for (var i = 0; i < $("#hdnTimeCount").val(); i++) {
				var chkBox = document.getElementById("customCheck" + i);
				var userCount = document.getElementById("userCount" + i);
				if (chkBox != null) {
					if (chkBox.checked == true) {
						arrayTime.push(i);
					<%
						if (Model.Facility.FacilityType == "FACILITY")
						{
					%>
						if (userCount.value > <%:Model.Facility.MaxUserCount%>) {
							bootAlert("최대 수용인원을 초과할 수 없습니다.");
							return;
						}
						else if (userCount.value == "") {
							bootAlert("신청 인원을 입력해야합니다.");
							userCount.focus();
							return;
						}
						else if (isNaN(userCount.value)) {
							bootAlert("잘못된 값이 입력되었습니다.");
							userCount.focus();
							return;
						}
						arrayUser.push(userCount.value);
					<%
						}
						else
						{
					%>
						arrayUser.push(0);
					<%
						}
					%>
						
					}
				}
			}

			if (arrayTime.length > 0 && arrayUser.length > 0) {
				if ((arrayTime.length + $(".bi-x-circle").length + $(".bi-x-square").length) > 4 && (arrayUser.length + $(".bi-x-circle").length + $(".bi-x-square").length) > 4) {
					bootAlert("<%:Model.Facility.FacilityType == "FACILITY" ? "시설은" : Model.Facility.FacilityType == "EQUIPMENT" ? "장비는" : "시설은"%> 하루에 2시간 이상 예약할 수 없습니다.");
				}
				else {
					arrayTime.forEach(element => checkTime += $("#hdnCheckTime" + element).val() + ", ");
					debugger;
					bootConfirm("<%:Model.Facility.FacilityName%>을(를) " + checkTime.substr(0, checkTime.length - 2) + "에 예약하시겠습니까?", function () {
						_ajax2.CallAjaxPost("/Facility/ReserveFacility", { facilityNo: <%:Model.Facility.FacilityNo%>, ReservedDate: $("#hdnDate").val(), TimeArray: arrayTime, UserCountArray: arrayUser }, "cbReserveResult");
					});
				}
			}
			else {
				bootAlert("예약하고자 하는 시간을 선택해야합니다.");
			}
		}

		function cbReserveResult() {
			var result = _ajax2.CallAjaxResult();

			if (result != null) {
				bootAlert("예약되었습니다.");
				fnGetReservedData($("#hdnDate").val());
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		function fnCancelReservation(time, rsvNo) {
			<%
				if (!Model.isAdmin)
				{
			%>
			if ('<%:DateTime.Now.ToString("yyyy-MM-dd")%>' == $("#hdnDate").val()) {
				bootAlert("당일에는 예약 및 예약취소를 할 수 없습니다.<br/> 관리자에게 문의해주세요.");
				return;
			}
			<%
				}
			%>

			bootConfirm("<%:Model.Facility.FacilityName%>의 " + $("#hdnDate").val() + "일 " + time + "시의 예약을 취소하시겠습니까?", function () {
				_ajax3.CallAjaxPost("/Facility/CancelReservation", { facilityNo: <%:Model.Facility.FacilityNo%>, ReservationNo: rsvNo }, "cbCacenlResult");
			});
		}

		function cbCacenlResult() {
			var result = _ajax3.CallAjaxResult();

			if (result != null) {
				bootAlert("취소되었습니다.");
				fnGetReservedData($("#hdnDate").val());
			}
			else {
				bootAlert("오류가 발생했습니다.");
			}
		}

		function fnOpenReserve() {
			fnOpenPopup('/Facility/ListReserve/<%:Model.Facility.FacilityNo%>', 'ContPop', 850, 800, 0, 0, 'auto');
		}

	</script>
</asp:Content>
