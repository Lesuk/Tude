class AddCountersToQuiz < ActiveRecord::Migration
  def change
    add_column :survey_surveys, :views_count, :integer, default: 0, null: false
    add_column :survey_surveys, :participants_count, :integer, default: 0, null: false
    add_column :survey_surveys, :questions_count, :integer, default: 0, null: false
  end
end
