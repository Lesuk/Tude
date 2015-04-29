jQuery(document).ready(function() {
  'use strict';
  $('.flash-item').each(function(index){
    $(this).addClass('item-' + index);
    setTimeout(function () {
      $('.item-' + index).fadeOut( "400", function() {
        $(this).remove();
      });
    }, ( 5000 * (index + 1) ) );
  });

  $('.flash-item .fa-close').on('click', function(){
    $(this).parent().fadeOut( "fast", function() {
        $(this).remove();
      });
  });
});
