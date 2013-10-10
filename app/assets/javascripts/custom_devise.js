$(document).ready(function(){
    $('#sup').on('click', function (e) {
        e.preventDefault();
        $("#myModal").css("top", "15%");
    });
    $('.btnn').on('click', function (e) {
        e.preventDefault();
        if($('.login-div').length>0)
        {
            $("#myModal").css("top", "15%");
            $('.modal-body').css("max-height", "none");
            $('.loaderimg').show();
            $('.modal-body').load($(this).attr("href"), function() {
                $('.loaderimg').hide();
            });
        }
    });

});