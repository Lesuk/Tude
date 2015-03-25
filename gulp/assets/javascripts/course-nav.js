jQuery(document).ready(function() {
  jQuery('.course-nav button').click(function(){
    var currentPointer = jQuery(this).data('pointer');
    console.log(currentPointer);
    jQuery(this).parent().addClass('active').siblings().removeClass('active');

    switch (currentPointer) {
      case 'info':
        jQuery('*[data-box="info"]').show();
        jQuery('*[data-box="toc"]').hide();
        jQuery('*[data-box="reviews"]').hide();
        break;
      case 'toc':
        jQuery('*[data-box="info"]').hide();
        jQuery('*[data-box="toc"]').show();
        jQuery('*[data-box="reviews"]').hide();
        break;
      case 'reviews':
        jQuery('*[data-box="info"]').hide();
        jQuery('*[data-box="toc"]').hide();
        jQuery('*[data-box="reviews"]').show();
        break;
      default:
        return false;
    }
  });
});
