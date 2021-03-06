module SurveysHelper
  def link_to_remove_field(name, f)
    f.hidden_field(:_destroy) +
    __link_to_function(raw(name), "removeField(this)", :id =>"remove-attach")
  end

  def new_survey
    new_quiz_path
  end

  def edit_survey(resource)
    edit_quiz_path(resource)
  end

  def survey_scope(resource)
    if action_name =~ /new|create/
      quizzes_path(resource)
    elsif action_name =~ /edit|update/
      quiz_path(resource)
    end
  end

  def new_attempt
    new_quiz_attempt_path
  end

  def attempt_scope(resource)
    if action_name =~ /new|create/
      quiz_attempts_path(resource)
    elsif action_name =~ /edit|update/
      attempt_path(resource)
    end
  end

  def link_to_add_field(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,:child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    __link_to_function(name, "addField(this, \"#{association}\", \"#{escape_javascript(fields)}\")",
    :id=>"add-attach",
    :class=>"btn btn-small btn-info")
  end

  def the_chosen_one?(answer, option)
    answer.option_id == option.id ? 'chosen' : nil
  end

  def option_checked?(answer, option)
    the_chosen_one?(answer, option) || option.correct ? 'checked' : nil
  end

  def set_option_type(answer, option)
    if option.correct
      '-type-success'
    elsif the_chosen_one?(answer, option)
      '-type-wrong'
    end
  end

  private

  def __link_to_function(name, on_click_event, opts={})
    link_to(name, '#', opts.merge(onclick: on_click_event))
  end
end
