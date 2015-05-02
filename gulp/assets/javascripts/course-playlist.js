jQuery(document).ready(function() {
  var item = $(".course-playlist__list .is-active");
  if(item.length > 0){
    $(".course-playlist__list").scrollTop(item.position().top);
    // animate({scrollTop: item_position});
  }
});
