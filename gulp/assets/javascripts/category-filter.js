;(function($) {

  // DOM ready
  $(function() {

    $(".filter-cat__name-text").html(function(){
      return $(".filter-cat__list .is-active").text();
    });

    // Add a <span> to every .nav-item that has a <ul> inside
    $('.filter-cat__item').has('ul').prepend('<span class="js-click filter-cat__item-arrow fa fa-angle-down"></span>');

    // Click to reveal the nav
    $('.filter-cat').on('click', '.filter-cat__name', function(){
      $(this).siblings('.filter-cat__list').toggle();
      $(this).toggleClass('is-active');
    });

    // Dynamic binding to on 'click'
    $('.filter-cat__list').on('click', '.js-click', function(){

      // Toggle the nested nav
      $(this).siblings('.filter-cat__sub-list').toggle();
    });
  });
})(jQuery);
