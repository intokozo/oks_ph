(function($) {

	"use strict";

	var fullHeight = function() {

		$('.js-fullheight').css('height', $(window).height());
		$(window).resize(function(){
			$('.js-fullheight').css('height', $(window).height());
		});

	};
	fullHeight();

	var carousel = function() {
		$('.featured-carousel').owlCarousel({
	    loop:true,
	    autoplay: false,
	    margin:20,
	    nav:true,
	    dots: true,
	    autoplayHoverPause: false,
	    items: 1,
	    navText : ["<img class='nav-button' alt='back' src='/img/chevron-back.svg'>","<img class='nav-button' alt='forward' src='/img/chevron-forward.svg'>"],
	    responsive:{
	      0:{
	        items:1
	      },
	      800:{
	        items:2
	      },
	      1000:{
	        items:3
	      }
	    }
		});

	};
	carousel();

})(jQuery);