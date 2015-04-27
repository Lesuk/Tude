jQuery ->
  $("#articles").sortable
    axis: 'y'
    handle: '.handle'
    placeholder: "ui-state-highlight"
    cursor: "move"
    cursorAt: { left: 40 }
    distance: 10
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
