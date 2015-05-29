var keyboardPagination = require('../../../vendor/assets/javascripts/jquery.keyboard-pagination');

$('.pagination').keyboardPagination(
{
  // num:        '.pagination-number',
  // numCurrent: '.pagination-current',
  prev:       '.pagination__item--prev',
  next:       '.pagination__item--next'
  // first:      '.pagination-first',
  // last:       '.pagination-last'
});
