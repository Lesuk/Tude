jQuery(document).ready(function($){

  function createCookie(name, value, days) {
    var expires;
    if (days) {
      var date = new Date();
      date.setTime(date.getTime()+(days*24*60*60*1000));
      expires = "; expires="+date.toGMTString();
    }
    else {
      expires = "";
    }
    document.cookie = name+"="+value+expires+"; path=/";
  }

  $('.reduce-sidebar').on('click', function(){
    var app = $('.app');
    var is_reduced = app.hasClass('sidebar-reduced');
    if (is_reduced){
      createCookie("sidebar_position", "opened", 90);
      app.removeClass('sidebar-reduced');
      $(this).removeClass('fa-angle-right').addClass('fa-angle-left');
    }
    else{
      createCookie("sidebar_position", "reduced", 90);
      app.addClass('sidebar-reduced');
      $(this).removeClass('fa-angle-left').addClass('fa-angle-right');
    }
  });
});