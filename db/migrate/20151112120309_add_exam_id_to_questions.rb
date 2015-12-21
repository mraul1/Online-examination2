class AddExamIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :exam_id, :integer
  end
end
