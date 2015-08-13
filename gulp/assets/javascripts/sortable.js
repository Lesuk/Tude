$('#sortable-articles').sortable({
  handle: '.handle'
});

$('#sortable-articles').sortable().bind('sortupdate', function(e, ui){
  articles_order = [];

  $('#sortable-articles li').each(function(i){
    articles_order.push({ id: $(this).data('id') });
  });

  // send updated order via ajax
  $.ajax({
    type: 'PUT',
    url: $(this).data('update-url'),
    data: {order: articles_order }
  });
});
