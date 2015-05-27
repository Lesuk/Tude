var cookies = require('../../../vendor/assets/javascripts/cookie-monster');

$('.js-view-type').on('click', function(){
  cookies.set($(this).data("objects") + '_view_type', $(this).data("type"));
});
