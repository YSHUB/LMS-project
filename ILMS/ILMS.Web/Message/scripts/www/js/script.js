// JavaScript Document
jQuery(document).ready(function ($) {
	
	$(function () {

		var mediaMD = window.matchMedia('(min-width: 768px)');
		var mediaLG = window.matchMedia('(min-width: 992px)');

		initCommon(); // 공통		
		initMain(); 	// 메인

		/**
		 * 공통
		 */
		function initCommon() {
			if (!String.prototype.padStart) {
				String.prototype.padStart = function padStart(targetLength,padString) {
						targetLength = targetLength>>0; //truncate if number or convert non-number to 0;
						padString = String((typeof padString !== 'undefined' ? padString : ' '));
						if (this.length > targetLength) {
								return String(this);
						}
						else {
								targetLength = targetLength-this.length;
								if (targetLength > padString.length) {
										padString += padString.repeat(targetLength/padString.length); //append to original to ensure we are longer than needed
								}
								return padString.slice(0,targetLength) + String(this);
						}
				};
			}

			/* Carousel */
			$('.pause-btn').click(function () {
				$(this).closest('.carousel').carousel('pause');
				$(this).hide();
				$(this).next('.play-btn').show();
			});
			$('.play-btn').click(function () {
				$(this).closest('.carousel').carousel('cycle');
				$(this).hide();
				$(this).prev('.pause-btn').show();
			});

			$('.carousel-wrapper .prev-btn').on('click', function() {
				$(this).closest('.carousel-wrapper').find('.owl-carousel').trigger('prev.owl.carousel');
			});
	
			$('.carousel-wrapper .next-btn').on('click', function() {
				$(this).closest('.carousel-wrapper').find('.owl-carousel').trigger('next.owl.carousel');
			});

			/* 모달 */
			$('.nav-bg-fostrap[data-toggle="modal"] .navbar-fostrap').on('click', function() {
				$('#mask').removeClass('cover-bg');
			});			
		}
		
		/**
		 * 메인 페이지
		 */
		function initMain() {		
			// 메인 비주얼 carousel			
			var cTimer;	// carousel 타이머
			var cTimerDuration = 8000;
			var isPaused = false;
			var $circle = $('.cont-main .mv-carousel-wrapper .play-pause-box .circle'); // 원형 게이지

			var $owlMVBGWrapper = $('.mv-carousel-wrapper');
			var $owlMVBG = $('.mv-carousel');

			if ($owlMVBG.length) {
				var totalPageBG = $owlMVBG.find('.item').length.toString().padStart(2, '0'); // 총 아이템 수
				var $currPageBG = $owlMVBGWrapper.find('.carousel-btns .curr-page');
				$currPageBG.text('01');
				$owlMVBGWrapper.find('.carousel-btns .total-page').text(totalPageBG);

				$owlMVBG.owlCarousel({
					dots: true,
					items: 1,
					loop: true,
					mouseDrag: false,
					touchDrag: false,
					pullDrag: false,
					onInitialized: function () {
						resetTimer();
						startAni();
						$('.cont-main .mv-carousel .item-1').parent('.owl-item').css({
							'z-index': '1'
						});
					},
					onTranslate: function (event) {
						var currIndex = event.page.index + 1;
						$currPageBG.text(currIndex.toString().padStart(2, '0'));

						clearTimeout(cTimer);
						if (!isPaused) {
							startCircleGauge();
						}
					},
					onTranslated: function () {
						startAni();
					}
				});
			}

			$('.mv-carousel-wrapper .next-btn').on('click', function() {
				resetAni();
				if (!isPaused) {
					resetTimer();
				}
			});
			$('.mv-carousel-wrapper .prev-btn').on('click', function() {
				resetAni();
				if (!isPaused) {
					resetTimer();
				}
			});

			var $mvPlayPauseBtn = $('.cont-main .mv-carousel-wrapper .play-pause-btn');
			$mvPlayPauseBtn.on('click', function () {
				if ($(this).is('.pause')) { // pause 모양이라면 즉, play되고 있다면 pause
					stopTimer(); // 타이머 정지
					setPauseBtn($mvPlayPauseBtn, false); // 버튼 모양 토글
					isPaused = true; // 상태를 paused로 지정
				} else { // pause 되어 있다면 다시 play
					resetTimer(); // 타이머 다시 시작
					setPauseBtn($mvPlayPauseBtn, true); // 버튼 모양 토글
					isPaused = false; // 상태를 playing으로 지정
					$owlMVBG.trigger('next.owl.carousel'); // 다음 item으로 슬라이드
				}
			});

			function startAni() {
				cTimer = setTimeout(function() {
					if (!isPaused) {
						resetAni();
						$owlMVBG.trigger('next.owl.carousel');
					}
				}, cTimerDuration);

				var $aniImgs = $('.owl-item.active .deco-box img');
				var $aniText = $('.owl-item.active .text-box');
				var duration = 0;

				$aniImgs.css({
					'transition': '1s'
				});
				$aniText.css({
					'transition': '1s'
				});
				
				$aniImgs.each(function(index) {
					setTimeout(function() {
						$aniImgs.eq(index).addClass('on');
					}, duration);
					duration += 500;
				});
				setTimeout(function() {
					$aniText.addClass('on');
				}, duration);
			}

			function resetAni() {
				var $aniImgs = $('.owl-item .deco-box img');
				var $aniText = $('.owl-item .text-box');

				$aniImgs.css({
					'transition': '0s'
				});
				$aniText.css({
					'transition': '0s'
				});

				$aniImgs.removeClass('on');
				$aniText.removeClass('on');
			}

			function resetTimer() {
				clearTimeout(cTimer);
				startCircleGauge();
			}

			function stopTimer() {
				clearTimeout(cTimer);
				stopCircleGauge();
			}

			function startCircleGauge() {
				$circle.stop().css({ strokeDashoffset: 295 });
				$circle.stop().animate({ strokeDashoffset: 0 }, 8000, function() {
					window.requestAnimationFrame(startCircleGauge);
				});
			}

			function stopCircleGauge() {
				$circle.stop().css({ strokeDashoffset: 295 });
			}
		}

		// 자동 실행 및 중지 버튼 세팅
		function setPauseBtn($playPauseBtn, pause) {
			if (pause) {
				$playPauseBtn.removeClass('play');
				$playPauseBtn.addClass('pause');
				$playPauseBtn.attr('aria-label', '정지');
			} else {
				$playPauseBtn.removeClass('pause');
				$playPauseBtn.addClass('play');
				$playPauseBtn.attr('aria-label', '자동실행');
			}
		}
		
	});
});