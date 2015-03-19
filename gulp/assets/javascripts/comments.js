;(function($) {

  // DOM ready
  $(function() {

    // Click to reveal the nav
    $('.comment__item').on('click', '.reply-to', function(){
      console.log('reply');
      var comment_to_id = $(this).data("reply");
      var subcomments_block = $("#comment_" + comment_to_id + " .comment__sub-comments");
      subcomments_block.removeClass('h-hidden');
      subcomments_block.children('ul').children('li:nth-child(1)').removeClass('h-hidden');
    });

    $('.js-cancel-reply').on('click', function(){
      var subcomments_block = $(this).parents('.comment__sub-comments');
      var subcomments_list = subcomments_block.children('ul');
      subcomments_list.find('textarea').val('').css('height', '50px');
      subcomments_list.children('li:nth-child(1)').addClass('h-hidden');
      if (subcomments_list.children().length === 1)
        subcomments_block.addClass('h-hidden');
    });

    $('.comments__sort-link').on('click', function(){
      $(this).siblings().removeClass('is-current');
      $(this).addClass('is-current');
    });

  });
})(jQuery);