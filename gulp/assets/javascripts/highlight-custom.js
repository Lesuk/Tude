var highlight = require('../../../vendor/assets/javascripts/jquery.highlight');

var mainSearchInput = document.getElementById('main-search');

$('#soulmate').bind('contentchanged', function() {
  highlightTerms();
});

function highlightTerms(){
  $('.main-search .soulmate span').highlight(
      mainSearchInput.value.split(' '),
      { element: 'em', className: 'h' }
  );
}
