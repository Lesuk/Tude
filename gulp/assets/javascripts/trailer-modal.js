$(document).ready(function() {
  // js-modal-trailer
  require('magnific-popup');
  $('.js-modal-trailer').magnificPopup({
    type: 'iframe',

    iframe: {
       markup: '<div class="mfp-iframe-scaler">'+
                  '<div class="mfp-close"></div>'+
                  '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>'+
                  '<div class="mfp-trailer mfp-title">caption</div>'+
                '</div>'
    },
    callbacks: {
      markupParse: function(template, values, item) {
       values.title = item.el.attr('title');
      }
    }
  });

  if (window.location.search.indexOf('trailer=true') > -1) {
    $( ".js-modal-trailer" ).trigger( "click" );
  }
});
