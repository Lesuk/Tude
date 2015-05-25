var soulmate = require('../../../vendor/assets/javascripts/jquery.soulmate');
var render, select;

// Define the rendering and selecting behaviour for suggestions.
render = function(term, data, type){ return term; }

select = function(term, data, type){
  // populate our search form with the autocomplete result
  $('#main-search').val(term);

  // hide our autocomplete results
  $('ul#soulmate').hide();

  // then redirect to the result's link
  return window.location.href = data.url
}

$('#main-search').soulmate({
  url: '/autocomplete/search',
  types: ['articles', 'courses'],
  renderCallback : render,
  selectCallback : select,
  minQueryLength : 2,
  maxResults     : 5
})
