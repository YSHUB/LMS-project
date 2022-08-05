//calendar
var calendarEl = document.getElementById('calendar');
		
var calendar = new FullCalendar.Calendar(calendarEl, {
  initialView: 'dayGridMonth',
  contentHeight: 'auto',
  aspectRatio: false,
  
  slotMinTime: '09:00', // Day 캘린더에서 시작 시간
  slotMaxTime: '18:00', // Day 캘린더에서 종료 시간

  themeSystem: 'bootstrap',
  //locale: 'ko',

  hiddenDays: [ 0, 6 ],	//hide sun, sat
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

  events: [
    {
      title: '예약완료',
      start: '2022-02-01',
      classNames: ['fully-booked-event']
    },
    {
      groupId: 998,
      title: '고길동',
      start: '2022-02-07T09:00:00',
      end: '2022-02-07T11:00:00'
    },
    {
      groupId: 998,
      title: '이길동',
      start: '2022-02-07T14:00:00',
      end: '2022-02-07T15:00:00'
    },
    {
      groupId: 998,
      title: '정길동',
      start: '2022-02-07T15:00:00',
      end: '2022-02-07T16:00:00'
    },
    {
      //className: 'has-event',
      groupId: 999,
      title: 'Repeating Event',
      start: '2022-02-09T09:00:00'
    },
    {
      title: '하길동',
      start: '2022-02-11T10:00:00',
      end: '2022-02-11T12:00:00'
    },
    {
      title: '예약완료',
      start: '2022-02-14',
      classNames: ['fully-booked-event']
    },
    {
      title: 'Time Event',
      start: '2022-02-16T16:00:00',
      end: '2022-02-16T17:00:00'
    },
    {
      title: '예약완료',
      start: '2022-02-21',
      classNames: ['fully-booked-event']
    }
  ]

});

document.addEventListener('DOMContentLoaded', function() {
  calendar.render();

  //예약완료된 날짜에 대한 클래스 추가
  $( "#calendar .fully-booked-event" ).parents( ".fc-day" ).addClass( "fully-booked" );

  //클릭하여 예약을 지정할 날짜 표시
  var $dayEl = $( "#calendar .fc-day" );

  $dayEl.click(function() {

    $dayEl.not(this).removeClass('day-selected');
    $(this).toggleClass('day-selected');
    /* 
    if( $(this).hasClass("fully-booked") ===true ) {

      alert('예약이 완료되었습니다. 다른 날짜를 선택해 주세요.');

    } else {

      $(this).toggleClass('day-selected');
      
    } */

  });
 
});