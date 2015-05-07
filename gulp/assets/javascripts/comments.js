;(function($) {

  "use strict";
  // DOM ready
  $(function() {

    var commentOptions = {
      valueNames: [ 'timestamp', 'rating' ],
      listClass: 'comments__list'
    };

    var List = require ('list.js/dist/list.min');
    var commentList = new List('comments__box', commentOptions);
    if (commentList.listContainer){
      commentList.sort('rating', { order: "desc" });
    }

    // Click to reveal the nav
    $('.comment__item').on('click', '.js-reply-to', function(e){
      e.preventDefault();
      var comment_to_id = $(this).data("reply");
      var reply_to_id = $(this).data("rep-id");
      var subcomments_block = $("#comment_" + comment_to_id + " .comment__sub-comments");
      var replyTo = $(this).data("username");
      subcomments_block.removeClass('h-hidden');
      subcomments_block.children('ul').children('li:nth-child(1)').removeClass('h-hidden');
      if (replyTo){
        var textArea = $("#comment_to_" + comment_to_id);
        var hiddenField = $("#subparent_" + comment_to_id);
        textArea.val(function(i, val){
          return val + '@' + replyTo + ' ';
        });
        textArea.focus();
        hiddenField.val(function(i, val){
          return reply_to_id
        });
      }
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
