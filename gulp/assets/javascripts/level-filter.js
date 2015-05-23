$(".filter-level__name").html(function(){
  return $(".filter-level__list .is-active").text();
});

// Click to reveal the nav
$('.filter-level').on('click', '.filter-level__name', function(){
  $(this).siblings('.filter-level__list').toggle();
  $(this).toggleClass('is-active');
});
