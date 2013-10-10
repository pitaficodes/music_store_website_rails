

$(document).ready(function(){

			$("#countdown").countdown({
            
                        
				date: "25 December 2014 12:00:00",
				format: "on"
			},
			
			function() {
				// callback function
			});

             $(".timg a[rel^='prettyPhoto']").prettyPhoto({
						animation_speed: 'normal',
						autoplay_slideshow: true,
						slideshow: 3000
					});

             $(".work-img a[rel^='prettyPhoto']").prettyPhoto({
						animation_speed: 'normal',
						autoplay_slideshow: true,
						slideshow: 3000
					});
            
                    
                       // tooltip demo
    $('.social').tooltip({selector: "a[rel=tooltip]", placement:"top"});
    $('.social2').tooltip({selector: "a[rel=tooltip]", placement:"bottom"});
              
});