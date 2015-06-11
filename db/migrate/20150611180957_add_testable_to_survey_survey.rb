class AddTestableToSurveySurvey < ActiveRecord::Migration
  def change
    add_column :survey_surveys, :testable_type, :string
    add_column :survey_surveys, :testable_id, :integer
    add_index :survey_surveys, [:testable_id, :testable_type]
  end
end
