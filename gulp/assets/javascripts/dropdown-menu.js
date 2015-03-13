$(function() {

  $('.js-dropdown').on('click', function(event){
    if ( $(this).hasClass('is-active') === false )
      $('.js-dropdown').removeClass('is-active');
    $(this).toggleClass('is-active');
    event.stopPropagation();
  });

  $(document).click(function() {
    // all dropdowns
    $('.js-dropdown').removeClass('is-active');
  });

});