class AddCategoryIdToSurveySurvey < ActiveRecord::Migration
  def change
    add_column :survey_surveys, :category_id, :integer
    add_index :survey_surveys, :category_id
  end
end
