jQuery(document).ready(function() {
  var item_position = $(".course-playlist__list .is-active").position().top;
  $(".course-playlist__list").scrollTop(item_position);
  // animate({scrollTop: item_position});
});
