jQuery(document).ready(function ($) {	
	$(function () {
		var mediaXL = window.matchMedia('(min-width: 1200px)');
		var mediaLG = window.matchMedia('(min-width: 992px)');
		var mediaMD = window.matchMedia('(min-width: 768px)');
		var mediaSM = window.matchMedia('(min-width: 576px)');
		
		initCommon();		// 공통
		initHeader();		// 헤더
		initFooter();		// 푸터
		initMain();			// 메인 페이지
		initSub();			// 서브 페이지

		/**
		 * 공통 초기화
		 */
		function initCommon() {
			// IE에서 JavaScript의 String 객체의 padStart() 메서드를 사용하기 위한 코드
			// https://github.com/uxitten/polyfill/blob/master/string.polyfill.js
			// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart
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

			// carousel 이전 버튼
			$('.carousel-box .prev-btn').on('click', function() {
				$(this).closest('.carousel-box').find('.owl-carousel').trigger('prev.owl.carousel');
			});

			// carousel 다음 버튼
			$('.carousel-box .next-btn').on('click', function() {
				$(this).closest('.carousel-box').find('.owl-carousel').trigger('next.owl.carousel');
			});

			// carousel 자동실행, 정지 버튼
			$('.carousel-btns .play-pause').on('click', function() {
				var $carousel = $(this).closest('.carousel-box').find('.owl-carousel');
				if ($(this).is('.pause')) {
					$carousel.trigger('stop.owl.autoplay');
					$(this)
						.removeClass('pause')
						.addClass('play');
					$(this).find('span').text('자동실행');
				} else {
					$carousel.trigger('play.owl.autoplay');
					$(this)
						.removeClass('play')
						.addClass('pause');
					$(this).find('span').text('정지');
				}
			});

			// if (mediaSM.matches) {
			// 	openPopup();	
			// }

			$(window).on('resize', function() {
				if (!mediaSM.matches) {
					closePopup();
				}
			});
/* 
			$('.popup-box .close-popup').on('click', function() {
				$(this).closest('.popup-box').fadeOut(500);
			}); */
			
			function openPopup() {
				$('.popup-box').each(function() {
					$(this).fadeIn(700);
				});
			}

			function closePopup() {
				$('.popup-box').each(function() {
					$(this).fadeOut(500);
				});
			}

			if( $('.login-box').length ) {
				$('body').addClass('login');
			}
			
		}

		/**
		 * 헤더 초기화
		 */
		function initHeader() {
			// top main Carousel
			/* var $owlTopMain = $('.top-main-carousel');
			if ($owlTopMain.length) {
				$owlTopMain.owlCarousel({
					autoplay: true,
					autoplayHoverPause: true,
					autoplayTimeout: 5000,
					dots: false,
					items: 1,
					loop: true
				});
			} */
			
			var duration = 300;

			// 햄버거 메뉴 클릭
			$('.nav-bg-fostrap').on('click', function() {
				if (!mediaXL.matches) {
					openMenu();
				}
			});

			// 햄버거 메뉴 모달 영역 클릭
			$('#mask').on('click', function() {				
				closeMenu();
			});

			$('.menubar-close').on('click', function() {
				closeMenu();
			});

			var $topSearchPop = $('.top-search-pop');
			$('.top-search-btn').on('click', function() {
				$topSearchPop.toggleClass('on');
				if($topSearchPop.is('.on')) {
					$(this).addClass('on');
				} else {
					$(this).removeClass('on');
				}
			});

			$(window).on('resize', function() {
				if (mediaXL.matches) {
					closeMenu();
				}
			});

			// 토글 버튼이 추가되지 않았다면
			if (!$('.top-menu').find('.toggle-btn').length) {
				// 하위 메뉴가 있을 경우 토글 버튼 추가 (1depth 및 2depth 메뉴로 제한)
				$('.menubar > li > [role="menuitem"][aria-haspopup="true"], .menubar .menubox-inner > [role="menu"] > li > [role="menuitem"][aria-haspopup="true"]').append('<button class="toggle-btn" type="button" aria-label="열기"></button>');
			}

			// 1 뎁스 메뉴 클릭
			var $firstMenuitems = $('.menubar > li > [role="menuitem"]');
			$firstMenuitems.children('.toggle-btn').on('click', function(event) {
				if (!mediaXL.matches) {
					event.preventDefault();
					var $currMenuItem = $(this).parent([role="menuitem"]);
					$firstMenuitems.not($currMenuItem).attr('aria-expanded', 'false');
					toggleMenuItemExpanded($currMenuItem);
				}
			});

			$firstMenuitems.on('focusin', function() {
				$firstMenuitems.next('.menubox').removeClass('focusin');
				if (mediaXL.matches) {
					$(this).next('.menubox').addClass('focusin');
				}
			});

			$firstMenuitems.on('mouseenter', function() {
				$('.menubox').removeClass('focusin');
			});

			$('.top-menu-right-link').on('focusin', function() {
				$firstMenuitems.next('.menubox').removeClass('focusin');
			});

			$firstMenuitems.on('touchstart', function(event) {
				if (mediaXL.matches) {
					if ($(this).attr('aria-haspopup') !== 'false') {
						event.preventDefault();
					}
					var $menubox = $(this).next('.menubox');
					if ($menubox.is('.focusin')) {
						$menubox.removeClass('focusin');
					} else {
						$firstMenuitems.next('.menubox').removeClass('focusin');
						$menubox.addClass('focusin');
					}
				}
			});

			$(document).on('touchstart', function(event) {
				if (!$(event.target).closest('.menubar').length) {
					$firstMenuitems.next('.menubox').removeClass('focusin');
				}
			});

			// 2 뎁스 메뉴 클릭
			var $secondMenuitems = $('.menubar .menubox > .menubox-inner > [role="menu"] > li > [role="menuitem"]');
			$secondMenuitems.children('.toggle-btn').on('click', function(event) {
				if (!mediaXL.matches) {
					event.preventDefault();
					var $currMenuItem = $(this).parent([role="menuitem"]);
					$secondMenuitems.not($currMenuItem).attr('aria-expanded', 'false');
					toggleMenuItemExpanded($currMenuItem);
				}
			});

			// window resize
			$(window).on('resize', function() {
				if (mediaXL.matches) {
					closeMenu();
					resetMenu();
				} else {
					$('.menubox').removeAttr('style');
				}
			});

			function openMenu() {
				$('#mask').fadeIn(duration);
				$('.menubar-box').addClass('on');
			}

			function closeMenu() {
				$('#mask').fadeOut(duration);
				$('.menubar-box').removeClass('on');
			}

			// menuitem 토글
			function toggleMenuItemExpanded($menuItem) {
				if ($menuItem.attr('aria-expanded') === 'true') {
					$menuItem.attr('aria-expanded', 'false');
				} else {						
					$menuItem.attr('aria-expanded', 'true');
				}
			}

			function resetMenu() {
				$('.menubar [role="menuitem"]').attr('aria-expanded', 'false');
			}
		}

		/**
		 * 푸터 초기화
		 */
		function initFooter() {
			var $goToTop = $('.go-to-top');
			$goToTop.click(function(event) {
				event.preventDefault();
				$("html, body").animate({
					scrollTop: 0
				}, 700);
			});

			$(window).on('scroll', function() {
				var posTop = $(window).scrollTop();	
				if (posTop > 150) {
					$goToTop.fadeIn(300);
				} else {
					$goToTop.fadeOut(300);
				}
			});
			// 챗봇 
			/* 
			function ChatUp() {
				$("#div_chatlayer").slideUp(500);
			}
			function ChatDown() {
				$("#div_chatlayer").slideDown(500);
			} */
		}

		/**
		 * 메인 페이지 초기화
		 */
		function initMain() {

			initFullpage();
			initMainVisual();
			initCurriculum();
			initNews();
			
			//fullpage
			function initFullpage() {
				$fullPage = $('#fullpage');
				if ($fullPage.length) {
					
					$fullPage.fullpage({			
						resize: false,
						lazyLoading: true,
				
						//Navigation
						//menu: '#header',
				
						//lockAnchors: false,
						anchors: ['intro', 'curriculum', 'video', 'news', 'links'],
						navigation: true,
						navigationPosition: 'right',
						navigationTooltips: ['한국로봇산업진흥원 LMS', '교육과정', '교육목표', '공지사항', '주요 서비스'],
						showActiveTooltip: false,
						
						//Scrolling
						//normalScrollElements: '.client',
						autoScrolling: false,
						scrollOverflow: false,
						//scrollBar: true,
						
						//Design
						verticalCentered: true,
						responsiveWidth: 1200,
				
						//events
						//afterResponsive: function (isResponsive) {										
						//}
					});
					fullpage_api.setScrollingSpeed(1000);
					changeHeaderPosition();
					$(window).on('scroll', changeHeaderPosition);
				}
			}

			//mv-carousel 
			function initMainVisual() {
				$owlMv = $('.mv-carousel');
				if ($owlMv.length) {
					$owlMv.owlCarousel({
						loop:true,
						items:1,
						margin:0,
						stagePadding:0,
						autoplay: true,
						autoplayHoverPause: true,
						autoplayTimeout: 5000,
						nav: false,
						dots: true,

						responsiveClass:true,
					});
					addPlayPauseBtn($owlMv);
					$('.mv-carousel .owl-nav').hide();
				};

				setVerticalImages();

				$(window).on('resize', function() {
					setVerticalImages();
				});
				
				function setVerticalImages() {
					var imageURL;
					var $images = $('.mv-carousel .item-img[data-mobile]');

					$images.each(function() {
						if (mediaMD.matches) {
							imageURL = $(this).attr('data-pc');
						} else {
							imageURL = $(this).attr('data-mobile');
						}
						
						$(this).css({
							backgroundImage: 'url(' + imageURL + ')'
						});
					});
				}
			}

			//curri carousel
			function initCurriculum() {
				$owlCurri = $('.curri-carousel');
				if ($owlCurri.length) {
					$owlCurri.owlCarousel({
						loop: false,
						margin: 30,
						stagePadding: 0,
						autoplay: true,
						autoplayHoverPause: true,
						autoplayTimeout: 5000,
						nav: false,
						dots: true,
	
						responsiveClass:true,
						responsive:{
							0:{
									items:1
							},
							768:{
									items:2
							},
							1024:{
									items:2,
									margin: 30,
									stagePadding:50
							},
							1300:{
									items:3
							}
						}
					});
					addPlayPauseBtn($owlCurri);
					$('.curri-carousel .owl-nav').hide();
				}
			}

			//news carousel
			function initNews() {
				$owlNews = $('.news-carousel');
				if ($owlNews.length) {
					$owlNews.owlCarousel({
						loop: false,
						margin:30,
						stagePadding:0,
						autoplay: true,
						autoplayHoverPause: true,
						autoplayTimeout: 5000,
						nav: false,
						dots: true,
	
						responsiveClass:true,
						responsive:{
							0:{
									items:1
							},
							768:{
									items:2
							},
							1024:{
									items:2,
									margin: 30,
									stagePadding:50
							},
							1300:{
									items:3
							}
						}
					});
					addPlayPauseBtn($owlNews);
					$('.news-carousel .owl-nav').hide();
				}
			}
		}

		/**
		 * 서브 페이지 초기화
		 */
		function initSub() {
			// 시설예약 갤러리 Carousel
			var $owlFacBox = $('.fac-carousel-box');
			var $owlFac = $('.fac-carousel');
			if ($owlFac.length) {
				/* 
				var totalPage = $owlFac.find('.item').length.toString().padStart(2, '0'); // 총 아이템 수					
				var $currPage = $owlFacBox.find('.carousel-btns .curr-page');
				$currPage.text('01');
				$owlFacBox.find('.carousel-btns .total-page').text(totalPage); 
				*/

				$owlFac.owlCarousel({
					autoplay: false,
					dots: false,
					nav: true,
					items: 1,
					loop: false,
					responsiveClass:true,
					responsive:{
							0:{
									items:1
							},
							768:{
									items:2
							},
							1024:{
									items:2
							},
							1400:{
									items:3
							}
					}
				});
			}			

			//마지막 아이템의 세로바를 없애기 위한 클래스 삽입
			if($('.card-header').length) {
				$( "dl[class*='dl-style']" ).last().addClass('last');
			}

			//제목너비만큼을 지정하기 위한 span 추가
			//$(".col-xl-9 h2.title02").first().append("<span></span>");

			//모바일에서 collapsed일때 header영역의 보더 삭제
			//$(".card-style01 .card-header::after").hide();
			//$(".btn[aria-expanded='false']").closest(".card-header").toggleClass('closed');

		}

		/**
		 * 공통 유틸
		 */
	 
		// Carousel에서 dots 없애기 
		function removeDots($carousel) {
			$carousel.find('.carousel-box .owl-dots').remove();
		}
		// 자동 실행 및 중지 버튼 추가
		function addPlayPauseBtn($carousel) {
			if(!$carousel.find('.play-pause-btn').length) {
				var $playPauseBtn = $('<button type="button" class="play-pause-btn pause" aria-label="정지"><i class="bi bi-pause-fill">PAUSE</i></button>');

				bindEventPlayPauseBtn($carousel, $playPauseBtn);

				if (!$carousel.data('owl.carousel').options.autoplay) { // autoplay 옵션이 false라면
					setPauseBtn($playPauseBtn, false);
				}
						
				$carousel.find('.owl-dots').wrap('<div class="owl-dots-wrapper"></div>');
				$carousel.find('.owl-dots-wrapper').append($playPauseBtn); 
			}
		}

		// 자동 실행 및 중지 버튼 이벤트 바인딩
		function bindEventPlayPauseBtn($carousel, $playPauseBtn) {
			$playPauseBtn.on('click', function() {
				if ($(this).is('.pause')) {
					$carousel.trigger('stop.owl.autoplay');
					setPauseBtn($playPauseBtn, false);
				} else {
					$carousel.trigger('play.owl.autoplay');
					setPauseBtn($playPauseBtn, true);
				}
			});
		}

		// 자동 실행 및 중지 버튼 세팅
		function setPauseBtn($playPauseBtn, pause) {
			if (pause) {
				$playPauseBtn.removeClass('play');
				$playPauseBtn.addClass('pause');
				$playPauseBtn.attr('aria-label', '정지');
				$playPauseBtn.children('i').text('PAUSE');
				$playPauseBtn.children('i').removeClass('bi-play-fill');
				$playPauseBtn.children('i').addClass('bi-pause-fill');
			} else {
				$playPauseBtn.removeClass('pause');
				$playPauseBtn.addClass('play');
				$playPauseBtn.attr('aria-label', '자동실행');
				$playPauseBtn.children('i').text('PLAY');
				$playPauseBtn.children('i').removeClass('bi-pause-fill');
				$playPauseBtn.children('i').addClass('bi-play-fill');
			}
		}

		////fullpage header position setting
		function changeHeaderPosition() {
			var $headerMain = $('#header .top-main');
			var posTop = $(window).scrollTop();
	
			if (posTop > 0) {
				$headerMain.addClass('fixed');
				$headerMain.removeClass('top');
			} else {
				$headerMain.removeClass('fixed');
				$headerMain.addClass('top');
			}
		}

	});
});