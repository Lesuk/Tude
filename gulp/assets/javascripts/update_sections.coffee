$ ->
  $(document).on 'change', '#article_course_id', (evt) ->
    $.ajax '/articles/update_sections',
      type: 'GET'
      dataType: 'script'
      data: {
        course_id: $("#article_course_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Sections selected")
