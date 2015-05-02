jQuery(document).ready(function() {
  var reviewOptions = {
    valueNames: [ 'timestamp', 'rating' ],
    listClass: 'reviews__list'
  };

  var reviewList = new List('reviews__box', reviewOptions);
  if (reviewList.listContainer){
    reviewList.sort('timestamp', { order: "desc" });
  }
});
