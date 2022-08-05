$(function() {	
	var mediaMD = window.matchMedia('(min-width: 768px)');
	var mediaLG = window.matchMedia('(min-width: 992px)');

	initCommon();		// 공통
	initHeader();		// 헤더
	initFooter();		// 푸터
	initSide();			// 사이드
	initSub();			// 서브 페이지

	/**
	 * 공통
	 */
	function initCommon() {
		setScrollableTable();

		function setScrollableTable() {
			// 테이블 수평 스크롤 시 가이드 이미지 보여주기
			var duration = 500;
			var $scrollbox = $('.scrollbox');
			$('.scrollbox:not(:has(.msg-touch-help))').append('<div class="msg-touch-help"><img alt="touch slide" src="/_res/kibo/main/img/ico-table-scroll.png"></div>'); // .scrollbox 하위에 .msg-touch-help가 없을 경우 추가 

			var $msgTouchHelps = $('.scrollbox .msg-touch-help');
			if (!mediaMD.matches) {
				$msgTouchHelps.fadeIn(duration);
			}
			$scrollbox.on('scroll', function() {
				var $thisMSG = $(this).find('.msg-touch-help');
				if ($thisMSG.length) {
					$thisMSG.fadeOut(duration);
					$thisMSG.addClass('done');
				}
			});
			$(window).on('resize', function() {
				if (!mediaMD.matches) {
					$msgTouchHelps.not('.done').fadeIn(duration);
				} else {
					$msgTouchHelps.fadeOut(duration);
				}
			});
		}
	}

	/**
	 * 헤더
	 */	
	function initHeader() {
		setGBN(); // 페이지 로딩 시 GNB 세팅
		
		var $gnb = $('.gnb');
		var $gnbDim = $('.gnb-dim');
		var duration = 300;

		// GNB 팝업 버튼 클릭
		$('.top-main .sitemap-btn').on('click', function() {
			if (!mediaLG.matches) {
				openGNB();
			} else {
				location.href="/_site/kibo/main/sitemap.html";
			}
		});

		// GNB 팝업 닫기
		$('.gnb-close-btn').on('click', function() {
			closeGNB();
		});

		// GNB dim 영역 클릭
		$gnbDim.on('click', function() {
			closeGNB();
		});

		// GNB 열기
		function openGNB() {
			if (!mediaLG.matches) {
				$gnbDim.fadeIn(duration);
			}			
			$gnb.addClass('on');
		}

		// GNB 닫기
		function closeGNB() {
			$gnbDim.fadeOut(duration);
			$gnb.removeClass('on');
		}

		// .active인 메뉴 페이지 로딩 시 모두 펼치기
		if (!mediaLG.matches) {
			toggleMenuItemExpanded($('#gnb-list > li > [role="menuitem"].active'), true);
			toggleMenuItemExpanded($('#gnb-list .menubox > .menubox-inner > [role="menu"] > li > [role="menuitem"].active'), false);
		}

		// 1 depth menuitem 클릭
		var $firstMenuitems = $('#gnb-list > li > [role="menuitem"]');		
		$firstMenuitems.children('.toggle-btn').on('click', function(event) {			
			if (!mediaLG.matches) {
				event.preventDefault();
				var $currMenuItem = $(this).parent([role="menuitem"]);
				$firstMenuitems.not($currMenuItem).attr('aria-expanded', 'false');
				toggleMenuItemExpanded($currMenuItem, true);
			}
		});

		// 2 depth menuitem 클릭
		var $secondMenuitems = $('#gnb-list .menubox > .menubox-inner > [role="menu"] > li > [role="menuitem"]');
		$secondMenuitems.children('.toggle-btn').on('click', function(event) {
			if (!mediaLG.matches) {
				event.preventDefault();				
				var $currMenuItem = $(this).parent([role="menuitem"]);
				$secondMenuitems.not($currMenuItem).attr('aria-expanded', 'false');
				toggleMenuItemExpanded($currMenuItem);
			}
		});

		// menuitem 토글
		function toggleMenuItemExpanded($menuItem, isFirstDepth) {
			var $targetMenu;			
			if (isFirstDepth) {				
				$targetMenu = $menuItem.next('.menubox').find('[role="menu"]').first();
			} else {
				$targetMenu = $menuItem.next('[role="menu"]');
			}
			
			if ($menuItem.attr('aria-expanded') === 'true') {
				$targetMenu.slideUp(duration);				
				$menuItem.attr('aria-expanded', 'false');
			} else {
				if (isFirstDepth) {
					$('#gnb-list .menubox > .menubox-inner > [role="menu"]').not($targetMenu).slideUp(duration);
				} else {
					$('#gnb-list .menubox > .menubox-inner > [role="menu"] > li > [role="menu"]').not($targetMenu).slideUp(duration);
				}
				$targetMenu.slideDown(duration);
				$menuItem.attr('aria-expanded', 'true');
			}
		}

		// window resize
		$(window).on('resize', function() {
			if (mediaLG.matches) {
				closeGNB();
				resetGNB();
				$('.top-sub-search-pop').removeClass('on');
			} else {
				$('.menubox').removeAttr('style');
			}
		});

		function resetGNB() {
			$('#gnb-list [role="menuitem"]').attr('aria-expanded', 'false');
			$('#gnb-list [role="menu"]').slideUp(0, function() {
				$(this).removeAttr('style');
			});
		}

		$firstMenuitems.on('mouseenter', function() {
			var $li = $(this).parent('li');
			if ($(this).is('[aria-haspopup="true"]')) {
				var $menuBoxes = $('.menubox');
				if (mediaLG.matches) {
					$menuBoxes.stop();
					setGBN();
					var menuHeight = $li.find('.menubox-inner > [role="menu"]').attr('data-height');						
					$menuBoxes.animate({
						height: menuHeight
					}, duration);
					$('.menubox').removeClass('on');
					$li.find('.menubox').addClass('on');
				}
			} else {
				collapseMenubox();
			}
		});
		
		$firstMenuitems.on('focusin', function() {
			var $li = $(this).parent('li');
			if ($(this).is('[aria-haspopup="true"]')) {
				var $menuBoxes = $('.menubox');
				if (mediaLG.matches) {						
					$menuBoxes.stop();
					setGBN();
					var menuHeight = $li.find('.menubox-inner > [role="menu"]').attr('data-height');						
					$menuBoxes.animate({
						height: menuHeight
					}, duration);
					$('.menubox').removeClass('on');
					$li.find('.menubox').addClass('on');
				}
			} else {
				collapseMenubox();
			}
		});

		$('#gnb-list').on('mouseleave', function() {
			collapseMenubox();
		});

		$('.top-main .sitemap-btn').on('focusin', function() {
			if (mediaLG.matches) {
				collapseMenubox();
			}
		});

		function collapseMenubox() {
			var $menuBoxes = $('.menubox');			
			if (mediaLG.matches) {
				$menuBoxes.stop();
				$menuBoxes.animate({
					height: 0
				}, duration);
			}
		}

		function setGBN() {
			var $menuBoxes = $('.menubox');
			var $subMenus = $('#gnb-list .menubox-inner > [role="menu"]');
			if (!$menuBoxes.eq(0).find('.menubox-dummy').length) {
				$menuBoxes.prepend('<div class="menubox-dummy"><div class="menubox-dummy-1"></div><div class="menubox-dummy-2"></div></div>');
			}
			$subMenus.each(function() {
				var minHeight = 350;
				var height = $(this).outerHeight();
				height = height < minHeight ? minHeight : height;
				$(this).attr('data-height', height);
			});

			// 하위 메뉴가 있을 경우 토글 버튼 추가
			if (!$('#gnb-list').find('.toggle-btn').length) {
				// $('#gnb-list [role="menuitem"][aria-haspopup="true"]').append('<button class="toggle-btn" type="button" aria-label="열기"></button>');

				// 1depth 및 2depth 메뉴로 제한
				$('#gnb-list > li > [role="menuitem"][aria-haspopup="true"], #gnb-list .menubox-inner > [role="menu"] > li > [role="menuitem"][aria-haspopup="true"]').append('<button class="toggle-btn" type="button" aria-label="열기"></button>');
			}
		}

		var $topMain = $('.top-main');
		var $topSub = $('.top-sub');
		if ($topSub.length) {
			var topSubHeight = $topSub.outerHeight();
			$(window).on('scroll', function() {
				var posTop = $(window).scrollTop();
	
				if (posTop > topSubHeight) {
					if (!$topSub.next('.top-main-dummy').length) {
						$topSub.after('<div class="top-main-dummy"></div>');
					}
					$topMain.addClass('fixed');
				} else {
					$topSub.next('.top-main-dummy').remove();
					$topMain.removeClass('fixed');
				}
			});
		} else {			
			$topMain.addClass('fixed');
			var $mainContainer = $('.main-container');
			if ($mainContainer.length) {				
				if (!$topMain.prev('.top-main-dummy').length) {
					$topMain.before('<div class="top-main-dummy"></div>');
				}
			} else {
				$('#main').css({
					'margin-top': $topMain.outerHeight()
				});
			}
		}

		// 검색 버튼 클릭
		$('.top-sub-search-box .search-btn').on('click', function() {
			if (!mediaLG.matches) {
				$('.top-sub-search-pop').addClass('on');
			}
		});

		// 검색 팝업 닫기 버튼 클릭
		$('.top-sub-search-pop .close-search-pop').on('click', function() {
			$('.top-sub-search-pop').removeClass('on');
		});

		// test
		// $('#gnb-list > li:nth-child(2)').trigger('mouseenter');
	}


	/**
	 * 푸터
	 */
	function initFooter() {
		// 배너모음 Carousel 초기화
		var $owlBanner = $('.footer-banner-carousel');
		if ($owlBanner.length) {
			$owlBanner.owlCarousel({
				autoplay: true,
				autoplayTimeout: 5000,
				dots: false,
				items: 2,
				margin: 10,
				loop: true,
				responsive: {
					500: {
						items: 3,
						margin: 10
					},
					768: {
						items: 3,
						margin: 15
					},
					992: {
						items: 4,
						margin: 15
					},
					1200: {
						items: 5,
						margin: 15
					}
				}
			});

			var $prevBtn = $('#footer .prev-btn');
			var $nextBtn = $('#footer .next-btn');
			var $playPauseBtn = $('#footer .play-pause');

			// carousel 이전 버튼
			$prevBtn.on('click', function() {
				$owlBanner.trigger('prev.owl.carousel');
			});

			// carousel 다음 버튼
			$nextBtn.on('click', function() {
				$owlBanner.trigger('next.owl.carousel');
			});

			// carousel 자동실행, 정지 버튼			
			$playPauseBtn.on('click', function() {
				if ($(this).is('.pause')) {
					$owlBanner.trigger('stop.owl.autoplay');
					$(this)
						.removeClass('pause')
						.addClass('play')
						.find('span').text('자동실행');
				} else {					
					$owlBanner.trigger('play.owl.autoplay');
					$(this)
						.removeClass('play')
						.addClass('pause')
						.find('span').text('정지');
				}
			});
		}

		/* 챗봇 */
		setChatbot();

		function setChatbot() {
			if (jQuery.ui) {
				var $chat = $('.chatbot');
				if ($chat.length) {
					var $cbBtn = $('.chatbot .cb-btn');
					var $cbLink = $('.chatbot .cb-link');
					var $cbClose = $('.chatbot .cb-close-btn');
					var cbTimer;
					var timerDuration = 3000; // 메시지 떠 있는 타이머 지속시간
					var aniDuration = 300; // 애니메이션 지속시간
			
					$cbBtn.on('mouseenter focus', function() {
						if (cbTimer) {
							clearTimeout(cbTimer);
						}
						showCbMessage();
					});

					$cbLink.on('mouseenter', function() {
						if (cbTimer) {
							clearTimeout(cbTimer);
						}
					});
		
					$cbClose.on('click', function(event) {
						event.preventDefault();
						hideCbMessage();
					});
			
					if ($chat.is('.timer')) {
						showCbMessage();
						cbTimer = setTimeout(function() {
							hideCbMessage();
						}, timerDuration);
					}
		
					$(document).on('click', function(event) {
						if (!$(event.target).closest($chat).length) {
							hideCbMessage();
						}
					});
			
					function toggleCbMessage() {			
						$chat.toggleClass('on');
						$cbLink.toggle('slide', {
							direction: 'right'
						}, aniDuration);
					}
		
					function showCbMessage() {
						$chat.addClass('on');
						$cbLink.show('slide', {
							direction: 'right'
						}, aniDuration);
					}
		
					function hideCbMessage() {
						$chat.removeClass('on');
						$cbLink.hide('slide', {
							direction: 'right'
						}, aniDuration);
					}
				}
			}
		}

		/* Top 버튼 */
		var $goToTop = $('.go-to-top');
		$goToTop.on('click', function(event) {
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
	}

	/**
	 * 사이드
	 */
	function initSide() {
		var $side = $('#side');
		var $sideTitleBtn = $('.side-title-btn');
		var $sideMenu = $('.side-menu');

		if (mediaLG.matches) {
			setSideMenu(true);
			$sideTitleBtn.attr('tabindex', '-1');
		} else {
			$sideTitleBtn.removeAttr('tabindex');
		}

		$sideTitleBtn.on('click', function() {
			if (!mediaLG.matches) {
				$sideMenu.slideToggle(300);
				$side.toggleClass('on');
			}
		});

		// 3뎁스 메뉴 클릭
		var $menuItems = $('#side .side-menu-list > li > [role="menuitem"]');
		$menuItems.on('click', function() {
			var $subMenu = $(this).siblings('[role="menu"]');
			$menuItems.not($(this)).siblings('[role="menu"]').slideUp(300);
			$menuItems.not($(this)).attr('aria-expanded', 'false');
			if ($(this).attr('aria-expanded') === 'false') {
				$(this).attr('aria-expanded', 'true');
				$subMenu.slideDown(300);
			} else {
				$(this).attr('aria-expanded', 'false');
				$subMenu.slideUp(300);
			}
		});

		$(window).on('resize', function() {
			if (mediaLG.matches) {
				setSideMenu(true);
				$sideTitleBtn.attr('tabindex', '-1');
			} else {
				setSideMenu(false);
				$sideTitleBtn.removeAttr('tabindex');
			}
		});

		function setSideMenu(on) {
			if (on) {
				$sideMenu.show();
				$side.addClass('on');
			} else {
				$sideMenu.hide();
				$side.removeClass('on');
			}
		}
	}

	/**
	 * 서브 페이지 공통
	 */
	function initSub() {
		var duration = 200;

		$('.sub-visual .sv-img').addClass('on');

		if (mediaLG.matches) {
			setDropdownMenuHiehgt();
		}

		$('.breadcrumb .dropdown')
		.on('mouseenter', function() {
			var $dropdownMenu = $(this).children('.dropdown-menu');
			var height = $dropdownMenu.attr('data-height');
			$dropdownMenu.css({
				'visibility': 'visible'
			});
			$dropdownMenu.stop().animate({
				'height': height
			}, duration);
		})
		.on('mouseleave', function() {
			var $dropdownMenu = $(this).children('.dropdown-menu');
			$dropdownMenu.stop().animate({
				'height': 0
			}, duration);
		});		

		$(window).on('resize', function() {
			if (mediaLG.matches) {				
				setDropdownMenuHiehgt();
			}
		});

		var $svFooterBox = $('.sub-visual .sv-footer-box');
		var svFooterBoxOffsetTop = 242; // $svFooterBox.offset().top - 70 = 242;
		$(window).on('scroll', function() {
			if (mediaLG.matches) {				
				var posTop = $(window).scrollTop();
				if (posTop > svFooterBoxOffsetTop) {
					$svFooterBox.addClass('fixed');
				} else {
					$svFooterBox.removeClass('fixed');
				}
			}
		});

		function setDropdownMenuHiehgt() {
			var attr = $('.breadcrumb .dropdown-menu').eq(0).attr('data-height');
			if (typeof attr === typeof undefined) {
				$('.breadcrumb .dropdown-menu').each(function() {
					$(this).attr('data-height', $(this).outerHeight());
					$(this).css({
						'height': 0
					});
				});
			}
		}

		$('.breadcrumb .dropdown-menu a.active').wrapInner('<span></span>');

		if (typeof AOS != "undefined") {
			AOS.init({
				duration: 1000,
				once: true
			});
		}
	}

});
	