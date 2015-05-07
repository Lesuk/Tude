jQuery(document).ready(function() {
  var reviewOptions = {
    valueNames: [ 'timestamp', 'rating' ],
    listClass: 'reviews__list'
  };

  var List = require ('list.js/dist/list.min');
  var reviewList = new List('reviews__box', reviewOptions);
  if (reviewList.listContainer){
    reviewList.sort('timestamp', { order: "desc" });
  }
});
