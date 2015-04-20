"use strict";
$(function() {
  $(".youtube_video").each(function() {
    $(document).delegate('#'+this.id, 'click', function() {
      // Create an iFrame with autoplay set to true
      var params = "?autoplay=1&autohide=1";
      var iframe_url = "https://www.youtube.com/embed/" + this.id + params;

      // create iframe without sizing constraints
      var iframe = $('<iframe/>', {'frameborder': '0', 'src': iframe_url });

      // Replace the YouTube thumbnail with YouTube HTML5 Player
      $(this).html(iframe).addClass('loaded');

      // call fitVids on container
      $(this).fitVids();
    });
  });

  if (window.location.search.indexOf('autoplay=true') > -1) {
    $( ".youtube_video" ).trigger( "click" );
  }
});
