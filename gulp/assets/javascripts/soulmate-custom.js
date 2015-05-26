var soulmate = require('../../../vendor/assets/javascripts/jquery.soulmate');
var render, selectMain, selectSecondary;

// Define the rendering and selecting behaviour for suggestions.
render = function(term, data, type){
  return "<span>" + term + "</span><i class='fa fa-chevron-right soulmate__icon'></i>";
}

selectMain = function(term, data, type){
  // populate our search form with the autocomplete result
  $('#main-search').val(term);
  // hide our autocomplete results
  $('.main-search .soulmate').hide();
  // then redirect to the result's link
  return window.location.href = data.url
}

$('#main-search').soulmate({
  url: '/autocomplete/search',
  types: ['courses', 'articles'],
  renderCallback : render,
  selectCallback : selectMain,
  minQueryLength : 2,
  maxResults     : 4
})


selectSecondary = function(term, data, type){
  // populate our search form with the autocomplete result
  $('#secondary-search').val(term);
  // hide our autocomplete results
  $('.secondary-search .soulmate').hide();
  // then redirect to the result's link
  return window.location.href = data.url
}

$('#secondary-search').soulmate({
  url: '/autocomplete/search',
  types: ['courses', 'articles'],
  renderCallback : render,
  selectCallback : selectSecondary,
  minQueryLength : 2,
  maxResults     : 3
})
