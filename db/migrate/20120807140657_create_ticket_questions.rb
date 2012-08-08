class CreateTicketQuestions < ActiveRecord::Migration
  def change
    create_table :ticket_questions do |t|
      t.references :ticket_question
      t.string     :question
      t.boolean    :leaf, default: true
      t.string     :state
      t.timestamps
    end
  end
end
