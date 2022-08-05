jQuery(document).ready(function () {
    // 2017-04-20 제쌍용 추가
    $.datepicker._gotoToday = function (id) {
        $(id).datepicker('setDate', new Date()).datepicker('hide').blur();
    };

    $('.datepicker').each(function () {
        $(this).attr({ 'maxlength': 10 });
        var isReadonly = $(this).prop('readonly'); //alert($(this).attr('id') + ' / ' + isReadonly);
        //$('.TabMenu ul li').removeClass('on');
        //$(this).addClass('on');
        if (isReadonly == false) {
            $(this).datepicker({
                beforeShow: function () {
                    setTimeout(function () {
                        $('.ui-datepicker').css('z-index', 99999999999999);
                    }, 0);
                },
                dateFormat: "yy-mm-dd",   /* 날짜 포맷 */
                prevText: '이전달',
                nextText: '다음달',
                showButtonPanel: true,    /* 버튼 패널 사용 */
                changeMonth: true,        /* 월 선택박스 사용 */
                changeYear: true,         /* 년 선택박스 사용 */
                showOtherMonths: true,    /* 이전/다음 달 일수 보이기 */
                selectOtherMonths: true,  /* 이전/다음 달 일 선택하기 */
                showOn: "button",
                buttonText: "날짜선택",
                buttonImage: "/Message/Common/Images/icon_calendar.png",
                buttonImageOnly: true,
                minDate: '-200y',
                closeText: '닫기',
                currentText: '오늘',
                showMonthAfterYear: true, /* 년과 달의 위치 바꾸기 */
                yearSuffix: '년',
                /* 한글화 */
                monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dayNames: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
                weekHeader: 'Wk',
                firstDay: 0,
                isRTL: false,
                duration: 200,
                showAnim: 'slideDown'
            });
        }
    });

});