jQuery(document).ready(function($){
  var cookies = require('../../../vendor/assets/javascripts/cookie-monster');

  $('.reduce-sidebar').on('click', function(){
    var app = $('.app');
    var is_reduced = app.hasClass('sidebar-reduced');
    if (is_reduced){
      cookies.set('sidebar_position', 'opened', 180);
      app.removeClass('sidebar-reduced');
      $(this).removeClass('fa-angle-right').addClass('fa-angle-left');
    }
    else{
      cookies.set('sidebar_position', 'reduced', 180);
      app.addClass('sidebar-reduced');
      $(this).removeClass('fa-angle-left').addClass('fa-angle-right');
    }
  });
});
