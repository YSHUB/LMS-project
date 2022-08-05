// JavaScript Document'

$(function() {

	const mcheck = 992;
	
$(document).ready(function () {
    navInit_Size();

    $(window).resize(function () {
        navInit_Size();
    });
});

function navInit_Size() {
    $('.navbar-nav li').removeClass('active')
    $('#top-menu').removeClass('visible');
    $('#mask').removeClass('cover-bg');
    $('#top-menu .navbar-nav li .depth2').removeAttr("style");
}

$('.navbar-fostrap').click(function () {
    $('#top-menu').toggleClass('visible');
    $('#mask').toggleClass('cover-bg');
});

$('.navbar-close').click(function () {
    //모바일
    if (window.innerWidth < mcheck) {
        $('#top-menu').removeClass('visible');
        $('#mask').removeClass('cover-bg');
        navInit_Size();
    }
    else {
    }
});

$('#mask').click(function () {
    navInit_Size();
});

$('#top-menu .navbar-nav li').on("click", function (evt) {
    evt.stopPropagation();
    if (window.innerWidth < mcheck) {
        $(this).addClass('active').siblings().removeClass();

        $(this).siblings().find('li').children('.dropdown-menu').removeClass();
        $('#top-menu .navbar-nav li .dropdown-menu').removeClass('show');
        $(this).children('.dropdown-menu').addClass('show').siblings().removeClass();

        if ($(this).children('.dropdown-menu').length == 0) {
            return true;
        }
        else {
            return false;
        }
    }
});

$('#top-menu .navbar-nav li a.dropdown').on("click", function (evt) {
    evt.stopPropagation();
    if (window.innerWidth < mcheck) {

        if ($(this).attr('href') === 'javascript:void(0);') {
            return false;
        }
    }
});

$('.snb-list > li:has(ul)').click(function (e) {
    if (e.target.parentElement != this) return;
    if ($(this).attr('class') == 'active') {
        $(this).removeClass('active');
    }
    else {
        $(this).addClass('active').siblings().removeClass('active');
    }
});
});